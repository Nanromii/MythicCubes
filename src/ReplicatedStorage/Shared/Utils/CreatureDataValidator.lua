--!strict

local MAX_ID_LENGTH = 64
local MAX_DISPLAY_NAME_LENGTH = 80
local MAX_DESCRIPTION_LENGTH = 240
local MAX_SKILLS_PER_CREATURE = 3
local MAX_LEVEL = 100
local MAX_STAT_VALUE = 100_000
local MAX_EXPERIENCE = 1_000_000_000_000

type UnknownTable = { [unknown]: unknown }
type Validator = (unknown) -> (boolean, string?)

local ELEMENT_FIELDS = table.freeze({
    id = true,
    displayName = true,
    color = true,
    effectiveness = true,
})
local ROLE_FIELDS = table.freeze({
    id = true,
    displayName = true,
    description = true,
})
local SKILL_FIELDS = table.freeze({
    id = true,
    displayName = true,
    description = true,
    elementId = true,
    target = true,
    effect = true,
    cooldownSeconds = true,
    basePower = true,
})
local CREATURE_FIELDS = table.freeze({
    id = true,
    displayName = true,
    elementId = true,
    roleId = true,
    skillIds = true,
    baseStats = true,
    displayColor = true,
})
local BASE_STATS_FIELDS = table.freeze({
    maxHealth = true,
    attack = true,
    defense = true,
    speed = true,
})
local OWNED_CREATURE_FIELDS = table.freeze({
    instanceId = true,
    creatureId = true,
    level = true,
    experience = true,
    equippedSkillIds = true,
})
local CATALOG_FIELDS = table.freeze({
    elements = true,
    roles = true,
    skills = true,
    creatures = true,
})
local SKILL_TARGETS = table.freeze({
    Enemy = true,
    Self = true,
    Ally = true,
})
local SKILL_EFFECTS = table.freeze({
    Damage = true,
})

local CreatureDataValidator = {}

local function validateExactFields(
    value: UnknownTable,
    allowedFields: { [string]: boolean },
    label: string
): (boolean, string?)
    for fieldName in value do
        if typeof(fieldName) ~= "string" or not allowedFields[fieldName] then
            return false, `{label} contains unknown field: {tostring(fieldName)}`
        end
    end

    return true, nil
end

local function validateIdentifier(value: unknown, label: string): (boolean, string?)
    if typeof(value) ~= "string" then
        return false, `{label} must be a string`
    end

    if #value == 0 or #value > MAX_ID_LENGTH then
        return false, `{label} length must be between 1 and {MAX_ID_LENGTH}`
    end

    if string.match(value, "^[a-z][a-z0-9_]*$") == nil then
        return false, `{label} must use lowercase snake_case`
    end

    return true, nil
end

local function validateText(
    value: unknown,
    label: string,
    maximumLength: number
): (boolean, string?)
    if typeof(value) ~= "string" then
        return false, `{label} must be a string`
    end

    if #value == 0 or #value > maximumLength then
        return false, `{label} length must be between 1 and {maximumLength}`
    end

    return true, nil
end

local function validateNumber(
    value: unknown,
    label: string,
    minimum: number,
    maximum: number,
    mustBeInteger: boolean
): (boolean, string?)
    if typeof(value) ~= "number" or value ~= value or math.abs(value) == math.huge then
        return false, `{label} must be a finite number`
    end

    if value < minimum or value > maximum then
        return false, `{label} must be between {minimum} and {maximum}`
    end

    if mustBeInteger and value % 1 ~= 0 then
        return false, `{label} must be an integer`
    end

    return true, nil
end

local function validateIdentifierArray(
    value: unknown,
    label: string,
    minimumCount: number,
    maximumCount: number
): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, `{label} must be an array`
    end

    local values = value :: UnknownTable
    local seenIndexes: { [number]: boolean } = {}
    local seenIds: { [string]: boolean } = {}
    local itemCount = 0

    for index, item in values do
        if typeof(index) ~= "number" or index % 1 ~= 0 or index < 1 then
            return false, `{label} must be a dense array`
        end

        local idIsValid, idError = validateIdentifier(item, `{label}[{index}]`)

        if not idIsValid then
            return false, idError
        end

        local itemId = item :: string

        if seenIds[itemId] then
            return false, `{label} contains duplicate id: {itemId}`
        end

        seenIndexes[index] = true
        seenIds[itemId] = true
        itemCount += 1
    end

    if itemCount < minimumCount or itemCount > maximumCount then
        return false, `{label} count must be between {minimumCount} and {maximumCount}`
    end

    for index = 1, itemCount do
        if not seenIndexes[index] then
            return false, `{label} must be a dense array`
        end
    end

    return true, nil
end

local function validateBaseStats(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "CreatureDefinition.baseStats must be a table"
    end

    local stats = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(stats, BASE_STATS_FIELDS, "CreatureDefinition.baseStats")

    if not fieldsAreValid then
        return false, fieldError
    end

    for _, fieldName in { "maxHealth", "attack", "defense", "speed" } do
        local numberIsValid, numberError = validateNumber(
            stats[fieldName],
            `CreatureDefinition.baseStats.{fieldName}`,
            1,
            MAX_STAT_VALUE,
            true
        )

        if not numberIsValid then
            return false, numberError
        end
    end

    return true, nil
end

function CreatureDataValidator.validateElementDefinition(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "ElementDefinition must be a table"
    end

    local definition = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(definition, ELEMENT_FIELDS, "ElementDefinition")

    if not fieldsAreValid then
        return false, fieldError
    end

    local idIsValid, idError = validateIdentifier(definition.id, "ElementDefinition.id")

    if not idIsValid then
        return false, idError
    end

    local nameIsValid, nameError = validateText(
        definition.displayName,
        "ElementDefinition.displayName",
        MAX_DISPLAY_NAME_LENGTH
    )

    if not nameIsValid then
        return false, nameError
    end

    if typeof(definition.color) ~= "Color3" then
        return false, "ElementDefinition.color must be a Color3"
    end

    if typeof(definition.effectiveness) ~= "table" then
        return false, "ElementDefinition.effectiveness must be a table"
    end

    for targetElementId, multiplier in definition.effectiveness :: UnknownTable do
        local targetIdIsValid, targetIdError =
            validateIdentifier(targetElementId, "ElementDefinition.effectiveness target id")

        if not targetIdIsValid then
            return false, targetIdError
        end

        local multiplierIsValid, multiplierError = validateNumber(
            multiplier,
            `ElementDefinition.effectiveness.{targetElementId}`,
            0.25,
            4,
            false
        )

        if not multiplierIsValid then
            return false, multiplierError
        end
    end

    return true, nil
end

function CreatureDataValidator.validateRoleDefinition(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "RoleDefinition must be a table"
    end

    local definition = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(definition, ROLE_FIELDS, "RoleDefinition")

    if not fieldsAreValid then
        return false, fieldError
    end

    local idIsValid, idError = validateIdentifier(definition.id, "RoleDefinition.id")

    if not idIsValid then
        return false, idError
    end

    local nameIsValid, nameError =
        validateText(definition.displayName, "RoleDefinition.displayName", MAX_DISPLAY_NAME_LENGTH)

    if not nameIsValid then
        return false, nameError
    end

    return validateText(
        definition.description,
        "RoleDefinition.description",
        MAX_DESCRIPTION_LENGTH
    )
end

function CreatureDataValidator.validateSkillDefinition(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "SkillDefinition must be a table"
    end

    local definition = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(definition, SKILL_FIELDS, "SkillDefinition")

    if not fieldsAreValid then
        return false, fieldError
    end

    for fieldName, fieldValue in
        {
            id = definition.id,
            elementId = definition.elementId,
        }
    do
        local idIsValid, idError = validateIdentifier(fieldValue, `SkillDefinition.{fieldName}`)

        if not idIsValid then
            return false, idError
        end
    end

    local nameIsValid, nameError =
        validateText(definition.displayName, "SkillDefinition.displayName", MAX_DISPLAY_NAME_LENGTH)

    if not nameIsValid then
        return false, nameError
    end

    local descriptionIsValid, descriptionError =
        validateText(definition.description, "SkillDefinition.description", MAX_DESCRIPTION_LENGTH)

    if not descriptionIsValid then
        return false, descriptionError
    end

    if typeof(definition.target) ~= "string" or not SKILL_TARGETS[definition.target] then
        return false, "SkillDefinition.target must be Enemy, Self, or Ally"
    end

    if typeof(definition.effect) ~= "string" or not SKILL_EFFECTS[definition.effect] then
        return false, "SkillDefinition.effect must be Damage"
    end

    local cooldownIsValid, cooldownError =
        validateNumber(definition.cooldownSeconds, "SkillDefinition.cooldownSeconds", 0, 300, false)

    if not cooldownIsValid then
        return false, cooldownError
    end

    return validateNumber(
        definition.basePower,
        "SkillDefinition.basePower",
        0,
        MAX_STAT_VALUE,
        true
    )
end

function CreatureDataValidator.validateCreatureDefinition(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "CreatureDefinition must be a table"
    end

    local definition = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(definition, CREATURE_FIELDS, "CreatureDefinition")

    if not fieldsAreValid then
        return false, fieldError
    end

    for fieldName, fieldValue in
        {
            id = definition.id,
            elementId = definition.elementId,
            roleId = definition.roleId,
        }
    do
        local idIsValid, idError = validateIdentifier(fieldValue, `CreatureDefinition.{fieldName}`)

        if not idIsValid then
            return false, idError
        end
    end

    local nameIsValid, nameError = validateText(
        definition.displayName,
        "CreatureDefinition.displayName",
        MAX_DISPLAY_NAME_LENGTH
    )

    if not nameIsValid then
        return false, nameError
    end

    local skillsAreValid, skillsError = validateIdentifierArray(
        definition.skillIds,
        "CreatureDefinition.skillIds",
        1,
        MAX_SKILLS_PER_CREATURE
    )

    if not skillsAreValid then
        return false, skillsError
    end

    local statsAreValid, statsError = validateBaseStats(definition.baseStats)

    if not statsAreValid then
        return false, statsError
    end

    if typeof(definition.displayColor) ~= "Color3" then
        return false, "CreatureDefinition.displayColor must be a Color3"
    end

    return true, nil
end

function CreatureDataValidator.validateOwnedCreature(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "OwnedCreature must be a table"
    end

    local ownedCreature = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(ownedCreature, OWNED_CREATURE_FIELDS, "OwnedCreature")

    if not fieldsAreValid then
        return false, fieldError
    end

    local instanceIdIsValid, instanceIdError =
        validateText(ownedCreature.instanceId, "OwnedCreature.instanceId", 128)

    if not instanceIdIsValid then
        return false, instanceIdError
    end

    local creatureIdIsValid, creatureIdError =
        validateIdentifier(ownedCreature.creatureId, "OwnedCreature.creatureId")

    if not creatureIdIsValid then
        return false, creatureIdError
    end

    local levelIsValid, levelError =
        validateNumber(ownedCreature.level, "OwnedCreature.level", 1, MAX_LEVEL, true)

    if not levelIsValid then
        return false, levelError
    end

    local experienceIsValid, experienceError = validateNumber(
        ownedCreature.experience,
        "OwnedCreature.experience",
        0,
        MAX_EXPERIENCE,
        true
    )

    if not experienceIsValid then
        return false, experienceError
    end

    local maximumEquippedSkills = if (ownedCreature.level :: number) >= 54
        then 3
        elseif (ownedCreature.level :: number) >= 18 then 2
        else 1

    return validateIdentifierArray(
        ownedCreature.equippedSkillIds,
        "OwnedCreature.equippedSkillIds",
        0,
        maximumEquippedSkills
    )
end

local function collectCatalog(
    value: unknown,
    label: string,
    validator: Validator
): ({ [string]: UnknownTable }?, string?)
    if typeof(value) ~= "table" then
        return nil, `{label} must be an array`
    end

    local definitions = value :: UnknownTable
    local definitionsById: { [string]: UnknownTable } = {}
    local seenIndexes: { [number]: boolean } = {}
    local definitionCount = 0

    for index, definitionValue in definitions do
        if typeof(index) ~= "number" or index % 1 ~= 0 or index < 1 then
            return nil, `{label} must be a dense array`
        end

        local definitionIsValid, definitionError = validator(definitionValue)

        if not definitionIsValid then
            return nil, `{label}[{index}]: {definitionError or "invalid definition"}`
        end

        local definition = definitionValue :: UnknownTable
        local definitionId = definition.id :: string

        if definitionsById[definitionId] ~= nil then
            return nil, `{label} contains duplicate id: {definitionId}`
        end

        definitionsById[definitionId] = definition
        seenIndexes[index] = true
        definitionCount += 1
    end

    if definitionCount == 0 then
        return nil, `{label} must contain at least one definition`
    end

    for index = 1, definitionCount do
        if not seenIndexes[index] then
            return nil, `{label} must be a dense array`
        end
    end

    return definitionsById, nil
end

function CreatureDataValidator.validateCatalog(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "Creature data catalog must be a table"
    end

    local catalog = value :: UnknownTable
    local fieldsAreValid, fieldError =
        validateExactFields(catalog, CATALOG_FIELDS, "Creature data catalog")

    if not fieldsAreValid then
        return false, fieldError
    end

    local elementsById, elementError = collectCatalog(
        catalog.elements,
        "elements",
        CreatureDataValidator.validateElementDefinition
    )

    if elementsById == nil then
        return false, elementError
    end

    local rolesById, roleError =
        collectCatalog(catalog.roles, "roles", CreatureDataValidator.validateRoleDefinition)

    if rolesById == nil then
        return false, roleError
    end

    local skillsById, skillError =
        collectCatalog(catalog.skills, "skills", CreatureDataValidator.validateSkillDefinition)

    if skillsById == nil then
        return false, skillError
    end

    local creaturesById, creatureError = collectCatalog(
        catalog.creatures,
        "creatures",
        CreatureDataValidator.validateCreatureDefinition
    )

    if creaturesById == nil then
        return false, creatureError
    end

    for skillId, skill in skillsById do
        local elementId = skill.elementId :: string

        if elementsById[elementId] == nil then
            return false, `Skill {skillId} references unknown element: {elementId}`
        end
    end

    for elementId, element in elementsById do
        local effectiveness = element.effectiveness :: UnknownTable

        for targetElementId in effectiveness do
            if elementsById[targetElementId :: string] == nil then
                return false,
                    `Element {elementId} effectiveness references unknown element: {targetElementId}`
            end
        end

        for targetElementId in elementsById do
            if effectiveness[targetElementId] == nil then
                return false,
                    `Element {elementId} effectiveness is missing target: {targetElementId}`
            end
        end
    end

    for creatureId, creature in creaturesById do
        local elementId = creature.elementId :: string
        local roleId = creature.roleId :: string

        if elementsById[elementId] == nil then
            return false, `Creature {creatureId} references unknown element: {elementId}`
        end

        if rolesById[roleId] == nil then
            return false, `Creature {creatureId} references unknown role: {roleId}`
        end

        for _, skillId in creature.skillIds :: { string } do
            local skill = skillsById[skillId]

            if skill == nil then
                return false, `Creature {creatureId} references unknown skill: {skillId}`
            end

            if skill.elementId ~= elementId then
                return false, `Creature {creatureId} skill {skillId} must use element: {elementId}`
            end
        end
    end

    return true, nil
end

return table.freeze(CreatureDataValidator)
