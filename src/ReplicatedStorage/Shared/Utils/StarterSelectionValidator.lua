--!strict

local StarterDefinitions = require(script.Parent.Parent.Config.StarterDefinitions)

local INVALID_REQUEST = "Request must contain only a starterId string"

local StarterSelectionValidator = {}

function StarterSelectionValidator.validate(request: unknown): (string?, string?)
    if typeof(request) ~= "table" then
        return nil, INVALID_REQUEST
    end

    local requestTable = request :: { [unknown]: unknown }
    local starterIdValue: unknown = nil

    for key, value in requestTable do
        if key ~= "starterId" then
            return nil, INVALID_REQUEST
        end

        starterIdValue = value
    end

    if typeof(starterIdValue) ~= "string" then
        return nil, INVALID_REQUEST
    end

    local starterId = starterIdValue :: string

    if StarterDefinitions.getById(starterId) == nil then
        return nil, `Unknown starter id: {starterId}`
    end

    return starterId, nil
end

return table.freeze(StarterSelectionValidator)
