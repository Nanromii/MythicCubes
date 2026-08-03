--!strict

local CreatureDataRegistry = require(script.Parent.Parent.Config.CreatureDataRegistry)

type UnknownTable = { [unknown]: unknown }

local REGION_FIELDS = table.freeze({
    id = true,
    displayName = true,
    platformCenter = true,
    platformSize = true,
    spawnZones = true,
})
local ZONE_FIELDS = table.freeze({
    id = true,
    center = true,
    size = true,
    maximumGroups = true,
    clusterMinimum = true,
    clusterMaximum = true,
    respawnSeconds = true,
    aggroRange = true,
    engagementRange = true,
    leashRange = true,
    attackRange = true,
    moveSpeed = true,
    returnSpeed = true,
    attackIntervalSeconds = true,
    spawnPool = true,
})
local POOL_FIELDS = table.freeze({ creatureId = true, weight = true })
local DEVICE_FIELDS = table.freeze({
    id = true,
    displayName = true,
    baseChance = true,
    missingHealthBonus = true,
    maximumChance = true,
    captureRange = true,
    startingQuantity = true,
})

local WorldDefinitionValidator = {}

local function exactFields(
    value: UnknownTable,
    allowed: { [string]: boolean },
    label: string
): (boolean, string?)
    for field in value do
        if typeof(field) ~= "string" or not allowed[field] then
            return false, `{label} contains unknown field: {tostring(field)}`
        end
    end
    return true, nil
end

local function identifier(value: unknown, label: string): (boolean, string?)
    if typeof(value) ~= "string" or #value < 1 or #value > 64 then
        return false, `{label} must be a non-empty string up to 64 characters`
    end
    if string.match(value, "^[a-z][a-z0-9_]*$") == nil then
        return false, `{label} must use lowercase snake_case`
    end
    return true, nil
end

local function finiteNumber(
    value: unknown,
    minimum: number,
    maximum: number,
    label: string
): (boolean, string?)
    if typeof(value) ~= "number" or value ~= value or math.abs(value) == math.huge then
        return false, `{label} must be a finite number`
    end
    if value < minimum or value > maximum then
        return false, `{label} must be between {minimum} and {maximum}`
    end
    return true, nil
end

local function positiveVector(value: unknown, label: string): (boolean, string?)
    if typeof(value) ~= "Vector3" then
        return false, `{label} must be a Vector3`
    end
    local vector = value :: Vector3
    if vector.X <= 0 or vector.Z <= 0 or vector.Y < 0 then
        return false, `{label} must have positive X/Z and non-negative Y`
    end
    return true, nil
end

function WorldDefinitionValidator.validateSpawnZone(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "Spawn zone must be a table"
    end
    local zone = value :: UnknownTable
    local fieldsValid, fieldError = exactFields(zone, ZONE_FIELDS, "Spawn zone")
    if not fieldsValid then
        return false, fieldError
    end
    local idValid, idError = identifier(zone.id, "Spawn zone id")
    if not idValid then
        return false, idError
    end
    if typeof(zone.center) ~= "Vector3" then
        return false, "Spawn zone center must be a Vector3"
    end
    local sizeValid, sizeError = positiveVector(zone.size, "Spawn zone size")
    if not sizeValid then
        return false, sizeError
    end
    for _, field in { "maximumGroups", "clusterMinimum", "clusterMaximum" } do
        local valid, numberError = finiteNumber(zone[field], 1, 20, `Spawn zone {field}`)
        if not valid or (zone[field] :: number) % 1 ~= 0 then
            return false, numberError or `Spawn zone {field} must be an integer`
        end
    end
    if (zone.clusterMinimum :: number) > (zone.clusterMaximum :: number) then
        return false, "Spawn zone clusterMinimum cannot exceed clusterMaximum"
    end
    for _, field in
        {
            "respawnSeconds",
            "aggroRange",
            "engagementRange",
            "leashRange",
            "attackRange",
            "moveSpeed",
            "returnSpeed",
            "attackIntervalSeconds",
        }
    do
        local valid, numberError = finiteNumber(zone[field], 0.1, 600, `Spawn zone {field}`)
        if not valid then
            return false, numberError
        end
    end
    if (zone.attackRange :: number) > (zone.engagementRange :: number) then
        return false, "Spawn zone attackRange cannot exceed engagementRange"
    end
    if (zone.engagementRange :: number) > (zone.leashRange :: number) then
        return false, "Spawn zone engagementRange cannot exceed leashRange"
    end
    if typeof(zone.spawnPool) ~= "table" then
        return false, "Spawn zone spawnPool must be an array"
    end
    local poolCount = 0
    for index, entryValue in zone.spawnPool :: UnknownTable do
        if typeof(index) ~= "number" or index % 1 ~= 0 or typeof(entryValue) ~= "table" then
            return false, "Spawn zone spawnPool must be a dense array of tables"
        end
        local entry = entryValue :: UnknownTable
        local entryFieldsValid, entryError = exactFields(entry, POOL_FIELDS, "Spawn pool entry")
        if not entryFieldsValid then
            return false, entryError
        end
        local creatureIdValid, creatureIdError =
            identifier(entry.creatureId, "Spawn pool creatureId")
        if not creatureIdValid then
            return false, creatureIdError
        end
        if CreatureDataRegistry.getCreature(entry.creatureId :: string) == nil then
            return false, `Spawn pool references unknown creature: {entry.creatureId}`
        end
        local weightValid, weightError =
            finiteNumber(entry.weight, 0.01, 1_000, "Spawn pool weight")
        if not weightValid then
            return false, weightError
        end
        poolCount += 1
    end
    if poolCount == 0 then
        return false, "Spawn zone spawnPool cannot be empty"
    end
    return true, nil
end

function WorldDefinitionValidator.validateRegion(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "Region must be a table"
    end
    local region = value :: UnknownTable
    local fieldsValid, fieldError = exactFields(region, REGION_FIELDS, "Region")
    if not fieldsValid then
        return false, fieldError
    end
    local idValid, idError = identifier(region.id, "Region id")
    if not idValid then
        return false, idError
    end
    if typeof(region.displayName) ~= "string" or #region.displayName == 0 then
        return false, "Region displayName must be a non-empty string"
    end
    if typeof(region.platformCenter) ~= "Vector3" then
        return false, "Region platformCenter must be a Vector3"
    end
    local sizeValid, sizeError = positiveVector(region.platformSize, "Region platformSize")
    if not sizeValid then
        return false, sizeError
    end
    if typeof(region.spawnZones) ~= "table" then
        return false, "Region spawnZones must be an array"
    end
    local zoneIds: { [string]: boolean } = {}
    local zoneCount = 0
    for _, zoneValue in region.spawnZones :: UnknownTable do
        local zoneValid, zoneError = WorldDefinitionValidator.validateSpawnZone(zoneValue)
        if not zoneValid then
            return false, zoneError
        end
        local zoneId = (zoneValue :: UnknownTable).id :: string
        if zoneIds[zoneId] then
            return false, `Region contains duplicate spawn zone: {zoneId}`
        end
        zoneIds[zoneId] = true
        zoneCount += 1
    end
    if zoneCount == 0 then
        return false, "Region must contain at least one spawn zone"
    end
    return true, nil
end

function WorldDefinitionValidator.validateCaptureDevice(value: unknown): (boolean, string?)
    if typeof(value) ~= "table" then
        return false, "Capture device must be a table"
    end
    local device = value :: UnknownTable
    local fieldsValid, fieldError = exactFields(device, DEVICE_FIELDS, "Capture device")
    if not fieldsValid then
        return false, fieldError
    end
    local idValid, idError = identifier(device.id, "Capture device id")
    if not idValid then
        return false, idError
    end
    if typeof(device.displayName) ~= "string" or #device.displayName == 0 then
        return false, "Capture device displayName must be a non-empty string"
    end
    for _, field in { "baseChance", "missingHealthBonus", "maximumChance" } do
        local valid, numberError = finiteNumber(device[field], 0, 1, `Capture device {field}`)
        if not valid then
            return false, numberError
        end
    end
    if (device.baseChance :: number) > (device.maximumChance :: number) then
        return false, "Capture device baseChance cannot exceed maximumChance"
    end
    local rangeValid, rangeError =
        finiteNumber(device.captureRange, 1, 200, "Capture device captureRange")
    if not rangeValid then
        return false, rangeError
    end
    local quantityValid, quantityError =
        finiteNumber(device.startingQuantity, 0, 100, "Capture device startingQuantity")
    if not quantityValid or (device.startingQuantity :: number) % 1 ~= 0 then
        return false, quantityError or "Capture device startingQuantity must be an integer"
    end
    return true, nil
end

function WorldDefinitionValidator.validateCatalog(
    regions: unknown,
    devices: unknown
): (boolean, string?)
    if typeof(regions) ~= "table" or typeof(devices) ~= "table" then
        return false, "World definitions must use region and device arrays"
    end
    local regionIds: { [string]: boolean } = {}
    local deviceIds: { [string]: boolean } = {}
    local regionCount = 0
    for _, regionValue in regions :: UnknownTable do
        local valid, validationError = WorldDefinitionValidator.validateRegion(regionValue)
        if not valid then
            return false, validationError
        end
        local id = (regionValue :: UnknownTable).id :: string
        if regionIds[id] then
            return false, `Duplicate region id: {id}`
        end
        regionIds[id] = true
        regionCount += 1
    end
    local deviceCount = 0
    for _, deviceValue in devices :: UnknownTable do
        local valid, validationError = WorldDefinitionValidator.validateCaptureDevice(deviceValue)
        if not valid then
            return false, validationError
        end
        local id = (deviceValue :: UnknownTable).id :: string
        if deviceIds[id] then
            return false, `Duplicate capture device id: {id}`
        end
        deviceIds[id] = true
        deviceCount += 1
    end
    if regionCount == 0 or deviceCount ~= 2 then
        return false, "Phase 4 requires at least one region and exactly two capture devices"
    end
    return true, nil
end

return table.freeze(WorldDefinitionValidator)
