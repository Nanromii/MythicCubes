--!strict

local CreatureDataRegistry = require(script.Parent.Parent.Config.CreatureDataRegistry)
local CombatTypes = require(script.Parent.Parent.Types.CombatTypes)
local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)
local CombatDamageCalculator = require(script.Parent.CombatDamageCalculator)
local ElementEffectiveness = require(script.Parent.ElementEffectiveness)

type CombatActionResult = CombatTypes.CombatActionResult
type CombatSide = CombatTypes.CombatSide
type CombatSnapshot = CombatTypes.CombatSnapshot
type CombatState = CombatTypes.CombatState
type CombatantSnapshot = CombatTypes.CombatantSnapshot
type CombatantState = CombatTypes.CombatantState
type SkillCooldownSnapshot = CombatTypes.SkillCooldownSnapshot
type CreatureDefinition = CreatureTypes.CreatureDefinition
type SkillIntent = CombatTypes.SkillIntent

local BASIC_ATTACK_INTERVAL_SECONDS = 2.5
local BASIC_ATTACK_POWER = 6

local CombatEngine = {}

local function result(
    ok: boolean,
    code: string,
    message: string,
    damage: number?,
    elementMultiplier: number?,
    finishedNow: boolean
): CombatActionResult
    return {
        ok = ok,
        code = code,
        message = message,
        damage = damage,
        elementMultiplier = elementMultiplier,
        finishedNow = finishedNow,
    }
end

local function createCombatant(
    combatId: string,
    suffix: string,
    side: CombatSide,
    controllerUserId: number?,
    definition: CreatureDefinition,
    currentTime: number
): CombatantState
    return {
        id = `{combatId}:{suffix}`,
        side = side,
        controllerUserId = controllerUserId,
        creatureId = definition.id,
        elementId = definition.elementId,
        currentHealth = definition.baseStats.maxHealth,
        maximumHealth = definition.baseStats.maxHealth,
        attack = definition.baseStats.attack,
        defense = definition.baseStats.defense,
        equippedSkillIds = table.clone(definition.skillIds),
        cooldownEndsAtBySkillId = {},
        nextBasicAttackAt = currentTime + BASIC_ATTACK_INTERVAL_SECONDS,
        alive = true,
    }
end

local function sideHasLivingCombatant(state: CombatState, side: CombatSide): boolean
    for _, combatantId in state.combatantOrder do
        local combatant = state.combatants[combatantId]

        if combatant.side == side and combatant.alive then
            return true
        end
    end

    return false
end

local function finishIfNeeded(state: CombatState): boolean
    if state.status ~= "Active" then
        return false
    end

    local playerAlive = sideHasLivingCombatant(state, "Player")
    local enemyAlive = sideHasLivingCombatant(state, "Enemy")

    if playerAlive and enemyAlive then
        return false
    end

    state.status = "Finished"
    state.winnerSide = if playerAlive then "Player" elseif enemyAlive then "Enemy" else nil
    return true
end

local function findTarget(state: CombatState, attacker: CombatantState): CombatantState?
    for _, combatantId in state.combatantOrder do
        local candidate = state.combatants[combatantId]

        if candidate.side ~= attacker.side and candidate.alive then
            return candidate
        end
    end

    return nil
end

local function hasEquippedSkill(combatant: CombatantState, skillId: string): boolean
    for _, equippedSkillId in combatant.equippedSkillIds do
        if equippedSkillId == skillId then
            return true
        end
    end

    return false
end

local function applyDamage(target: CombatantState, damage: number)
    target.currentHealth = math.max(0, target.currentHealth - damage)

    if target.currentHealth == 0 then
        target.alive = false
    end
end

local function dealDamage(
    state: CombatState,
    attacker: CombatantState,
    target: CombatantState,
    basePower: number
): CombatActionResult
    local multiplier, multiplierError =
        ElementEffectiveness.getMultiplier(attacker.elementId, target.elementId)

    if multiplier == nil then
        return result(
            false,
            "INVALID_ELEMENT",
            multiplierError or "Invalid element",
            nil,
            nil,
            false
        )
    end

    local damage = CombatDamageCalculator.calculateDamage({
        attack = attacker.attack,
        defense = target.defense,
        basePower = basePower,
        elementMultiplier = multiplier,
    })

    applyDamage(target, damage)
    local finishedNow = finishIfNeeded(state)

    return result(
        true,
        "DAMAGE_APPLIED",
        "Server applied combat damage",
        damage,
        multiplier,
        finishedNow
    )
end

function CombatEngine.createCombat(
    combatId: string,
    ownerUserId: number,
    playerCreatureId: string,
    enemyCreatureId: string,
    currentTime: number
): (CombatState?, string?)
    local playerDefinition = CreatureDataRegistry.getCreature(playerCreatureId)

    if playerDefinition == nil then
        return nil, `Unknown player creature: {playerCreatureId}`
    end

    local enemyDefinition = CreatureDataRegistry.getCreature(enemyCreatureId)

    if enemyDefinition == nil then
        return nil, `Unknown enemy creature: {enemyCreatureId}`
    end

    local playerCombatant =
        createCombatant(combatId, "player-1", "Player", ownerUserId, playerDefinition, currentTime)
    local enemyCombatant =
        createCombatant(combatId, "enemy-1", "Enemy", nil, enemyDefinition, currentTime)

    return {
        id = combatId,
        ownerUserId = ownerUserId,
        status = "Preparing",
        combatants = {
            [playerCombatant.id] = playerCombatant,
            [enemyCombatant.id] = enemyCombatant,
        },
        combatantOrder = { playerCombatant.id, enemyCombatant.id },
        winnerSide = nil,
    },
        nil
end

function CombatEngine.activate(state: CombatState): boolean
    if state.status ~= "Preparing" then
        return false
    end

    state.status = "Active"
    return true
end

function CombatEngine.executeBasicAttack(
    state: CombatState,
    combatantId: string,
    currentTime: number
): CombatActionResult
    if state.status ~= "Active" then
        return result(false, "COMBAT_NOT_ACTIVE", "Combat is not active", nil, nil, false)
    end

    local attacker = state.combatants[combatantId]

    if attacker == nil then
        return result(false, "COMBATANT_NOT_FOUND", "Combatant does not exist", nil, nil, false)
    end

    if not attacker.alive then
        return result(false, "COMBATANT_DEFEATED", "Combatant is defeated", nil, nil, false)
    end

    if currentTime < attacker.nextBasicAttackAt then
        return result(false, "BASIC_NOT_READY", "Basic attack is not ready", nil, nil, false)
    end

    local target = findTarget(state, attacker)

    if target == nil then
        local finishedNow = finishIfNeeded(state)
        return result(false, "TARGET_NOT_FOUND", "No living enemy target", nil, nil, finishedNow)
    end

    attacker.nextBasicAttackAt = currentTime + BASIC_ATTACK_INTERVAL_SECONDS
    return dealDamage(state, attacker, target, BASIC_ATTACK_POWER)
end

function CombatEngine.executeSkill(
    state: CombatState,
    controllerUserId: number,
    intent: SkillIntent,
    currentTime: number
): CombatActionResult
    if intent.combatId ~= state.id then
        return result(false, "COMBAT_NOT_FOUND", "Combat does not exist", nil, nil, false)
    end

    if state.status ~= "Active" then
        return result(false, "COMBAT_NOT_ACTIVE", "Combat is not active", nil, nil, false)
    end

    local combatant = state.combatants[intent.combatantId]

    if combatant == nil then
        return result(false, "COMBATANT_NOT_FOUND", "Combatant does not exist", nil, nil, false)
    end

    if combatant.controllerUserId ~= controllerUserId then
        return result(
            false,
            "NOT_COMBATANT_OWNER",
            "Player does not control combatant",
            nil,
            nil,
            false
        )
    end

    if not combatant.alive then
        return result(false, "COMBATANT_DEFEATED", "Combatant is defeated", nil, nil, false)
    end

    local skill = CreatureDataRegistry.getSkill(intent.skillId)

    if skill == nil then
        return result(false, "SKILL_NOT_FOUND", "Skill does not exist", nil, nil, false)
    end

    if not hasEquippedSkill(combatant, intent.skillId) then
        return result(false, "SKILL_NOT_EQUIPPED", "Skill is not equipped", nil, nil, false)
    end

    local cooldownEndsAt = combatant.cooldownEndsAtBySkillId[intent.skillId] or 0

    if currentTime < cooldownEndsAt then
        return result(false, "SKILL_ON_COOLDOWN", "Skill is still on cooldown", nil, nil, false)
    end

    local target = state.combatants[intent.targetId]

    if target == nil then
        return result(false, "TARGET_NOT_FOUND", "Target does not exist", nil, nil, false)
    end

    if not target.alive then
        return result(false, "TARGET_DEFEATED", "Target is already defeated", nil, nil, false)
    end

    if skill.target ~= "Enemy" or skill.effect ~= "Damage" then
        return result(
            false,
            "UNSUPPORTED_SKILL_EFFECT",
            "Skill effect is not implemented by this vertical slice",
            nil,
            nil,
            false
        )
    end

    if target.side == combatant.side then
        return result(false, "INVALID_TARGET", "Skill requires an enemy target", nil, nil, false)
    end

    combatant.cooldownEndsAtBySkillId[intent.skillId] = currentTime + skill.cooldownSeconds
    return dealDamage(state, combatant, target, skill.basePower)
end

function CombatEngine.makeSnapshot(state: CombatState, currentTime: number): CombatSnapshot
    local combatantSnapshots: { CombatantSnapshot } = {}

    for _, combatantId in state.combatantOrder do
        local combatant = state.combatants[combatantId]
        local cooldowns: { SkillCooldownSnapshot } = {}

        for _, skillId in combatant.equippedSkillIds do
            local cooldownEndsAt = combatant.cooldownEndsAtBySkillId[skillId] or 0
            table.insert(cooldowns, {
                skillId = skillId,
                remainingSeconds = math.max(0, cooldownEndsAt - currentTime),
            })
        end

        table.insert(combatantSnapshots, {
            id = combatant.id,
            side = combatant.side,
            creatureId = combatant.creatureId,
            currentHealth = combatant.currentHealth,
            maximumHealth = combatant.maximumHealth,
            alive = combatant.alive,
            equippedSkillIds = table.clone(combatant.equippedSkillIds),
            skillCooldowns = cooldowns,
        })
    end

    return {
        id = state.id,
        status = state.status,
        winnerSide = state.winnerSide,
        combatants = combatantSnapshots,
    }
end

return table.freeze(CombatEngine)
