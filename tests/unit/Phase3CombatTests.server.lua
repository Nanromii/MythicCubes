--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local CombatTypes = require(ReplicatedStorage.Shared.Types.CombatTypes)
local CombatDamageCalculator = require(ReplicatedStorage.Shared.Utils.CombatDamageCalculator)
local CombatEngine = require(ReplicatedStorage.Shared.Utils.CombatEngine)
local CombatRequestRateLimiter = require(ReplicatedStorage.Shared.Utils.CombatRequestRateLimiter)
local CombatRequestValidator = require(ReplicatedStorage.Shared.Utils.CombatRequestValidator)
local CreatureDataValidator = require(ReplicatedStorage.Shared.Utils.CreatureDataValidator)
local ElementEffectiveness = require(ReplicatedStorage.Shared.Utils.ElementEffectiveness)

type CombatState = CombatTypes.CombatState
type SkillIntent = CombatTypes.SkillIntent

local passedTestCount = 0

local function pass(condition: boolean, message: string)
    assert(condition, message)
    passedTestCount += 1
end

local function createActiveCombat(combatId: string, ownerUserId: number): CombatState
    local state, creationError =
        CombatEngine.createCombat(combatId, ownerUserId, "pyrel", "bramblet", 0)
    assert(state ~= nil, creationError or "Combat creation failed")
    assert(CombatEngine.activate(state), "Combat should activate")
    return state
end

local function makeIntent(state: CombatState, requestId: string): SkillIntent
    return {
        combatId = state.id,
        requestId = requestId,
        combatantId = state.combatantOrder[1],
        skillId = "cinder_dash",
        targetId = state.combatantOrder[2],
    }
end

pass(CombatDamageCalculator.calculateDamage({
    attack = 20,
    defense = 10,
    basePower = 10,
    elementMultiplier = 1,
}) == 25, "Normal damage should use the deterministic formula")

pass(CombatDamageCalculator.calculateDamage({
    attack = 0,
    defense = 100_000,
    basePower = 0,
    elementMultiplier = 0.25,
}) == 1, "Damage should never fall below one")

local effectiveMultiplier = ElementEffectiveness.getMultiplier("water", "fire")
pass(effectiveMultiplier == 1.5, "Water should be effective against Fire in the placeholder chart")

local resistedMultiplier = ElementEffectiveness.getMultiplier("water", "nature")
pass(resistedMultiplier == 0.75, "Water should be resisted by Nature in the placeholder chart")

local neutralMultiplier = ElementEffectiveness.getMultiplier("normal", "wind")
pass(neutralMultiplier == 1, "Normal should be neutral against Wind")

local invalidElements = table.clone(CreatureDataRegistry.elements)
local invalidElement = table.clone(invalidElements[1])
local invalidEffectiveness = table.clone(invalidElement.effectiveness)
invalidEffectiveness.unknown_element = 1
invalidElement.effectiveness = invalidEffectiveness
invalidElements[1] = invalidElement
local chartIsValid = CreatureDataValidator.validateCatalog({
    elements = invalidElements,
    roles = CreatureDataRegistry.roles,
    skills = CreatureDataRegistry.skills,
    creatures = CreatureDataRegistry.creatures,
})
pass(not chartIsValid, "Element effectiveness must reject unknown element references")

local missingCombatantState = createActiveCombat("missing-combatant", 1)
local missingCombatantIntent = makeIntent(missingCombatantState, "request-1")
missingCombatantIntent.combatantId = "missing"
local missingCombatantResult =
    CombatEngine.executeSkill(missingCombatantState, 1, missingCombatantIntent, 10)
pass(missingCombatantResult.code == "COMBATANT_NOT_FOUND", "Unknown combatants must be rejected")

local missingTargetState = createActiveCombat("missing-target", 2)
local missingTargetIntent = makeIntent(missingTargetState, "request-2")
missingTargetIntent.targetId = "missing"
local missingTargetResult =
    CombatEngine.executeSkill(missingTargetState, 2, missingTargetIntent, 10)
pass(missingTargetResult.code == "TARGET_NOT_FOUND", "Unknown targets must be rejected")

local defeatedTargetState = createActiveCombat("defeated-target", 3)
local defeatedTarget = defeatedTargetState.combatants[defeatedTargetState.combatantOrder[2]]
defeatedTarget.currentHealth = 0
defeatedTarget.alive = false
local defeatedTargetResult = CombatEngine.executeSkill(
    defeatedTargetState,
    3,
    makeIntent(defeatedTargetState, "request-3"),
    10
)
pass(defeatedTargetResult.code == "TARGET_DEFEATED", "Defeated targets must be rejected")

local unequippedSkillState = createActiveCombat("unequipped-skill", 4)
local unequippedSkillIntent = makeIntent(unequippedSkillState, "request-4")
unequippedSkillIntent.skillId = "crosswind_snare"
local unequippedSkillResult =
    CombatEngine.executeSkill(unequippedSkillState, 4, unequippedSkillIntent, 10)
pass(unequippedSkillResult.code == "SKILL_NOT_EQUIPPED", "Unequipped skills must be rejected")

local cooldownState = createActiveCombat("cooldown", 5)
local cooldownIntent = makeIntent(cooldownState, "request-5")
local firstSkillResult = CombatEngine.executeSkill(cooldownState, 5, cooldownIntent, 10)
assert(firstSkillResult.ok, "First skill use should succeed")
cooldownIntent.requestId = "request-6"
local cooldownResult = CombatEngine.executeSkill(cooldownState, 5, cooldownIntent, 10.5)
pass(cooldownResult.code == "SKILL_ON_COOLDOWN", "Skill cooldown must be server-enforced")

local wrongTypeIntent = CombatRequestValidator.validateSkillIntent("not-a-table")
pass(wrongTypeIntent == nil, "Wrong skill intent types must be rejected")

local extraFieldIntent = CombatRequestValidator.validateSkillIntent({
    combatId = "combat",
    requestId = "request",
    combatantId = "combatant",
    skillId = "skill",
    targetId = "target",
    damage = 999,
})
pass(extraFieldIntent == nil, "Unknown skill intent fields must be rejected")

pass(
    CombatRequestRateLimiter.isAllowed(10, 10.1, 0.2) == false
        and CombatRequestRateLimiter.isAllowed(10, 10.21, 0.2) == true,
    "Skill request spam must be rate-limited"
)

local finishState = createActiveCombat("finish-once", 6)
local finishTarget = finishState.combatants[finishState.combatantOrder[2]]
finishTarget.currentHealth = 1
local finishingResult =
    CombatEngine.executeBasicAttack(finishState, finishState.combatantOrder[1], 10)
pass(
    finishingResult.finishedNow and finishState.status == "Finished",
    "Combat must finish when one side has no living combatants"
)

local postFinishResult =
    CombatEngine.executeBasicAttack(finishState, finishState.combatantOrder[1], 20)
pass(
    not postFinishResult.finishedNow and postFinishResult.code == "COMBAT_NOT_ACTIVE",
    "Finished combat must not finish twice or continue basic attacks"
)

local firstPlayerState = createActiveCombat("isolation-a", 7)
local secondPlayerState = createActiveCombat("isolation-b", 8)
local secondPlayerHealthBefore =
    secondPlayerState.combatants[secondPlayerState.combatantOrder[2]].currentHealth
local isolatedAction =
    CombatEngine.executeSkill(firstPlayerState, 7, makeIntent(firstPlayerState, "request-7"), 10)
assert(isolatedAction.ok, "Isolation fixture action should succeed")
pass(
    secondPlayerState.combatants[secondPlayerState.combatantOrder[2]].currentHealth
        == secondPlayerHealthBefore,
    "Combat state must not leak between players"
)

print(`[Phase3CombatTests] {passedTestCount} tests passed`)
