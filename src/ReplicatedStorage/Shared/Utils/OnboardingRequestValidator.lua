--!strict

local OnboardingTypes = require(script.Parent.Parent.Types.OnboardingTypes)

type ActionIntent = OnboardingTypes.ActionIntent
type ActionName = OnboardingTypes.ActionName

local ACTIONS_WITHOUT_WORLD: { [string]: boolean } = table.freeze({
    enter_normal_world = true,
    practice_basic_attack = true,
    practice_active_skill = true,
    capture_tumblet = true,
    return_to_village = true,
})
local ACTIONS_WITH_WORLD: { [string]: boolean } = table.freeze({
    select_elemental_world = true,
    travel_world = true,
})
local INVALID_REQUEST = "Request has an invalid onboarding action shape"

local OnboardingRequestValidator = {}

local function isValidRequestId(value: unknown): boolean
    if typeof(value) ~= "string" then
        return false
    end
    local requestId = value :: string
    return #requestId >= 1 and #requestId <= 64 and string.match(requestId, "^[%w_-]+$") ~= nil
end

function OnboardingRequestValidator.validate(request: unknown): (ActionIntent?, string?)
    if typeof(request) ~= "table" then
        return nil, INVALID_REQUEST
    end
    local requestTable = request :: { [unknown]: unknown }
    local requestId: unknown = nil
    local action: unknown = nil
    local worldId: unknown = nil
    for key, value in requestTable do
        if key == "requestId" then
            requestId = value
        elseif key == "action" then
            action = value
        elseif key == "worldId" then
            worldId = value
        else
            return nil, INVALID_REQUEST
        end
    end
    if not isValidRequestId(requestId) or typeof(action) ~= "string" then
        return nil, INVALID_REQUEST
    end
    local actionName = action :: string
    if ACTIONS_WITHOUT_WORLD[actionName] then
        if worldId ~= nil then
            return nil, INVALID_REQUEST
        end
    elseif ACTIONS_WITH_WORLD[actionName] then
        if typeof(worldId) ~= "string" then
            return nil, INVALID_REQUEST
        end
    else
        return nil, INVALID_REQUEST
    end
    return {
        requestId = requestId :: string,
        action = actionName :: ActionName,
        worldId = worldId :: string?,
    },
        nil
end

return table.freeze(OnboardingRequestValidator)
