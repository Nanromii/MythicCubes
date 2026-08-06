--!strict

local WorldDefinitions = require(script.Parent.Parent.Definitions.WorldDefinitions)
local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)
local WorldDefinitionValidator = require(script.Parent.Parent.Utils.WorldDefinitionValidator)

type CaptureDeviceDefinition = WorldTypes.CaptureDeviceDefinition
type RegionDefinition = WorldTypes.RegionDefinition
type SpawnZoneDefinition = WorldTypes.SpawnZoneDefinition

local valid, validationError = WorldDefinitionValidator.validateCatalog(
    WorldDefinitions.regions,
    WorldDefinitions.captureDevices
)
assert(valid, `Invalid world definitions: {validationError or "unknown error"}`)

local regionsById: { [string]: RegionDefinition } = {}
local zonesById: { [string]: SpawnZoneDefinition } = {}
local devicesById: { [string]: CaptureDeviceDefinition } = {}

for _, region in WorldDefinitions.regions do
    regionsById[region.id] = region
    for _, zone in region.spawnZones do
        assert(zonesById[zone.id] == nil, `Duplicate global spawn zone id: {zone.id}`)
        zonesById[zone.id] = zone
    end
end

for _, device in WorldDefinitions.captureDevices do
    devicesById[device.id] = device
end

local WorldDataRegistry = {
    regions = WorldDefinitions.regions,
    captureDevices = WorldDefinitions.captureDevices,
}

function WorldDataRegistry.getRegion(regionId: string): RegionDefinition?
    return regionsById[regionId]
end

function WorldDataRegistry.getSpawnZone(zoneId: string): SpawnZoneDefinition?
    return zonesById[zoneId]
end

function WorldDataRegistry.getCaptureDevice(deviceId: string): CaptureDeviceDefinition?
    return devicesById[deviceId]
end

return table.freeze(WorldDataRegistry)
