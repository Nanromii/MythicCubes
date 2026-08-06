--!strict

local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type CaptureIntent = WorldTypes.CaptureIntent
type UnknownTable = { [unknown]: unknown }

local FIELDS = table.freeze({
    requestId = true,
    encounterId = true,
    wildId = true,
    deviceId = true,
})

local CaptureRequestValidator = {}

local function validId(value: unknown): boolean
    return typeof(value) == "string" and #value > 0 and #value <= 128
end

function CaptureRequestValidator.validate(value: unknown): (CaptureIntent?, string?)
    if typeof(value) ~= "table" then
        return nil, "Capture request must be a table"
    end
    local request = value :: UnknownTable
    local count = 0
    for field in request do
        if typeof(field) ~= "string" or not FIELDS[field] then
            return nil, `Capture request contains unknown field: {tostring(field)}`
        end
        count += 1
    end
    if count ~= 4 then
        return nil, "Capture request must contain exactly four fields"
    end
    for _, field in { "requestId", "encounterId", "wildId", "deviceId" } do
        if not validId(request[field]) then
            return nil, `Capture request {field} must be a non-empty string`
        end
    end
    return {
        requestId = request.requestId :: string,
        encounterId = request.encounterId :: string,
        wildId = request.wildId :: string,
        deviceId = request.deviceId :: string,
    },
        nil
end

return table.freeze(CaptureRequestValidator)
