--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local CreatureDataValidator = require(ReplicatedStorage.Shared.Utils.CreatureDataValidator)

local passedTestCount = 0

local function expectValid(label: string, isValid: boolean, validationError: string?)
    assert(isValid, `{label} should be valid: {validationError or "unknown error"}`)
    passedTestCount += 1
end

local function expectInvalid(label: string, isValid: boolean, validationError: string?)
    assert(not isValid, `{label} should be invalid`)
    assert(validationError ~= nil and #validationError > 0, `{label} should return an error`)
    passedTestCount += 1
end

expectValid(
    "current catalog",
    CreatureDataValidator.validateCatalog({
        elements = CreatureDataRegistry.elements,
        roles = CreatureDataRegistry.roles,
        skills = CreatureDataRegistry.skills,
        creatures = CreatureDataRegistry.creatures,
    })
)

expectValid(
    "valid element",
    CreatureDataValidator.validateElementDefinition({
        id = "crystal",
        displayName = "Crystal",
        color = Color3.fromRGB(170, 220, 235),
    })
)

expectInvalid(
    "element with invalid id",
    CreatureDataValidator.validateElementDefinition({
        id = "Invalid ID",
        displayName = "Invalid",
        color = Color3.new(1, 1, 1),
    })
)

expectInvalid(
    "skill with invalid target",
    CreatureDataValidator.validateSkillDefinition({
        id = "invalid_target",
        displayName = "Invalid Target",
        description = "Fixture with an unsupported target.",
        elementId = "gale",
        target = "Everyone",
        cooldownSeconds = 1,
        basePower = 1,
    })
)

expectInvalid(
    "creature with duplicate skills",
    CreatureDataValidator.validateCreatureDefinition({
        id = "duplicate_skills",
        displayName = "Duplicate Skills",
        elementId = "gale",
        roleId = "controller",
        skillIds = { "crosswind_snare", "crosswind_snare" },
        baseStats = {
            maxHealth = 100,
            attack = 10,
            defense = 10,
            speed = 10,
        },
        displayColor = Color3.new(1, 1, 1),
    })
)

expectValid(
    "valid owned creature",
    CreatureDataValidator.validateOwnedCreature({
        instanceId = "session-creature-1",
        creatureId = "bramblet",
        level = 1,
        experience = 0,
        equippedSkillIds = { "briar_guard" },
    })
)

expectInvalid(
    "owned creature below minimum level",
    CreatureDataValidator.validateOwnedCreature({
        instanceId = "session-creature-2",
        creatureId = "bramblet",
        level = 0,
        experience = 0,
        equippedSkillIds = { "briar_guard" },
    })
)

local duplicateElements = table.clone(CreatureDataRegistry.elements)
table.insert(duplicateElements, CreatureDataRegistry.elements[1])

expectInvalid(
    "catalog with duplicate element id",
    CreatureDataValidator.validateCatalog({
        elements = duplicateElements,
        roles = CreatureDataRegistry.roles,
        skills = CreatureDataRegistry.skills,
        creatures = CreatureDataRegistry.creatures,
    })
)

local creatureWithUnknownRole = table.clone(CreatureDataRegistry.creatures[1])
creatureWithUnknownRole.roleId = "unknown_role"
local creaturesWithUnknownRole = table.clone(CreatureDataRegistry.creatures)
creaturesWithUnknownRole[1] = creatureWithUnknownRole

expectInvalid(
    "catalog with unknown role reference",
    CreatureDataValidator.validateCatalog({
        elements = CreatureDataRegistry.elements,
        roles = CreatureDataRegistry.roles,
        skills = CreatureDataRegistry.skills,
        creatures = creaturesWithUnknownRole,
    })
)

assert(CreatureDataRegistry.getCreature("bramblet") ~= nil, "Starter creature must be registered")
assert(
    CreatureDataRegistry.getCreature("unknown") == nil,
    "Unknown creature lookup must return nil"
)
passedTestCount += 2

print(`[Phase2DataValidationTests] {passedTestCount} tests passed`)
