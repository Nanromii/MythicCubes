--!strict

local CombatTypes = require(script.Parent.Parent.Types.CombatTypes)

type SkillIntent = CombatTypes.SkillIntent
type UnknownTable = { [unknown]: unknown }

local MAXIMUM_ID_LENGTH = 128
local SKILL_INTENT_FIELDS = table.freeze({
    combatId = true,
    requestId = true,
    combatantId = true,
    skillId = true,
    targetId = true,
})

local CombatRequestValidator = {}

local function isValidId(value: unknown): boolean
    return typeof(value) == "string" and #value > 0 and #value <= MAXIMUM_ID_LENGTH
end

function CombatRequestValidator.validateStartRequest(request: unknown): (boolean, string?)
    if typeof(request) ~= "table" then
        return false, "Start request must be an empty table"
    end

    for _ in request :: UnknownTable do
        return false, "Start request must not contain fields"
    end

    return true, nil
end

function CombatRequestValidator.validateSkillIntent(request: unknown): (SkillIntent?, string?)
    if typeof(request) ~= "table" then
        return nil, "Skill intent must be a table"
    end

    local requestTable = request :: UnknownTable
    local fieldCount = 0

    for fieldName in requestTable do
        if typeof(fieldName) ~= "string" or not SKILL_INTENT_FIELDS[fieldName] then
            return nil, `Skill intent contains unknown field: {tostring(fieldName)}`
        end

        fieldCount += 1
    end

    if fieldCount ~= 5 then
        return nil, "Skill intent must contain exactly five fields"
    end

    for _, fieldName in { "combatId", "requestId", "combatantId", "skillId", "targetId" } do
        if not isValidId(requestTable[fieldName]) then
            return nil, `Skill intent {fieldName} must be a non-empty string`
        end
    end

    return {
        combatId = requestTable.combatId :: string,
        requestId = requestTable.requestId :: string,
        combatantId = requestTable.combatantId :: string,
        skillId = requestTable.skillId :: string,
        targetId = requestTable.targetId :: string,
    },
        nil
end

return table.freeze(CombatRequestValidator)
