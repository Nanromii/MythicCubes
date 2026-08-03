--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local WorldDataRegistry = require(ReplicatedStorage.Shared.Config.WorldDataRegistry)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)
local SpawnPoolSelector = require(ReplicatedStorage.Shared.Utils.SpawnPoolSelector)
local WildLifecycle = require(ReplicatedStorage.Shared.Utils.WildLifecycle)

type SpawnZoneDefinition = WorldTypes.SpawnZoneDefinition
type WildCreatureRecord = WorldTypes.WildCreatureRecord

type RespawnEntry = {
    dueAt: number,
    regionId: string,
    zoneId: string,
    position: Vector3,
}

local WILD_FOLDER_NAME = "WildCreatures"
local REGION_FOLDER_NAME = "Phase4Region"
local WILD_STATE_TEXT: { [string]: string } = table.freeze({
    Spawning = "Đang xuất hiện",
    Idle = "Đang nghỉ",
    Engaging = "Đang giao chiến",
    Returning = "Đang trở về",
    Defeated = "Đã bị hạ",
    Despawned = "Đã biến mất",
})
local random = Random.new()
local recordsById: { [string]: WildCreatureRecord } = {}
local modelsById: { [string]: Model } = {}
local respawnQueue: { RespawnEntry } = {}
local wildSequence = 0

local RegionalWildService = {}

local function getWildFolder(): Folder
    local existing = Workspace:FindFirstChild(WILD_FOLDER_NAME)
    if existing ~= nil then
        assert(existing:IsA("Folder"), `{WILD_FOLDER_NAME} must be a Folder`)
        return existing
    end
    local folder = Instance.new("Folder")
    folder.Name = WILD_FOLDER_NAME
    folder.Parent = Workspace
    return folder
end

local function createBlock(
    parent: Model,
    name: string,
    size: Vector3,
    offset: Vector3,
    color: Color3
): Part
    local part = Instance.new("Part")
    part.Name = name
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Size = size
    part.CFrame = CFrame.new(offset)
    part.Material = Enum.Material.SmoothPlastic
    part.Color = color
    part.Parent = parent
    return part
end

local function createModel(record: WildCreatureRecord): Model
    local definition = CreatureDataRegistry.getCreature(record.creatureId)
    assert(definition ~= nil, `Unknown wild creature: {record.creatureId}`)
    local model = Instance.new("Model")
    model.Name = record.id
    local root =
        createBlock(model, "Root", Vector3.new(2.6, 2, 2.4), Vector3.zero, definition.displayColor)
    createBlock(
        model,
        "Head",
        Vector3.new(1.8, 1.5, 1.8),
        Vector3.new(0, 1.45, -0.35),
        definition.displayColor
    )
    createBlock(
        model,
        "FootLeft",
        Vector3.new(0.65, 0.6, 0.8),
        Vector3.new(-0.65, -1.15, 0),
        definition.displayColor
    )
    createBlock(
        model,
        "FootRight",
        Vector3.new(0.65, 0.6, 0.8),
        Vector3.new(0.65, -1.15, 0),
        definition.displayColor
    )
    createBlock(
        model,
        "Crest",
        Vector3.new(0.65, 0.9, 0.65),
        Vector3.new(0, 2.35, 0),
        definition.displayColor
    )
    createBlock(
        model,
        "Tail",
        Vector3.new(0.7, 0.7, 1.2),
        Vector3.new(0, 0.15, 1.65),
        definition.displayColor
    )
    model.PrimaryPart = root
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Nameplate"
    billboard.Size = UDim2.fromOffset(170, 48)
    billboard.StudsOffset = Vector3.new(0, 2.8, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Parent = billboard
    model.Parent = getWildFolder()
    model:PivotTo(CFrame.new(record.position))
    return model
end

local function updatePresentation(record: WildCreatureRecord)
    local model = modelsById[record.id]
    if model == nil then
        return
    end
    model:PivotTo(CFrame.new(record.position))
    local root = model.PrimaryPart
    local nameplate = if root == nil then nil else root:FindFirstChild("Nameplate")
    local label = if nameplate == nil then nil else nameplate:FindFirstChild("Label")
    local definition = CreatureDataRegistry.getCreature(record.creatureId)
    if label ~= nil and label:IsA("TextLabel") and definition ~= nil then
        label.Text =
            `{definition.displayName}\n{record.currentHealth}/{record.maximumHealth} HP • {WILD_STATE_TEXT[record.state] or "Không xác định"}`
    end
end

local function chooseCreature(zone: SpawnZoneDefinition): string
    local creatureId = SpawnPoolSelector.select(zone.spawnPool, random:NextNumber())
    assert(creatureId ~= nil, `Validated spawn pool {zone.id} cannot be empty`)
    return creatureId
end

local function spawnOne(regionId: string, zone: SpawnZoneDefinition, position: Vector3)
    local creatureId = chooseCreature(zone)
    local definition = CreatureDataRegistry.getCreature(creatureId)
    assert(definition ~= nil, `Validated spawn pool references unknown creature: {creatureId}`)
    wildSequence += 1
    local record: WildCreatureRecord = {
        id = `wild-{wildSequence}`,
        creatureId = creatureId,
        regionId = regionId,
        zoneId = zone.id,
        spawnPosition = position,
        position = position,
        state = "Spawning",
        currentHealth = definition.baseStats.maxHealth,
        maximumHealth = definition.baseStats.maxHealth,
        attack = definition.baseStats.attack,
        defense = definition.baseStats.defense,
        encounterId = nil,
        targetUserId = nil,
    }
    recordsById[record.id] = record
    modelsById[record.id] = createModel(record)
    assert(WildLifecycle.transition(record, "Idle"))
    updatePresentation(record)
end

local function randomPosition(zone: SpawnZoneDefinition): Vector3
    return zone.center
        + Vector3.new(
            random:NextNumber(-zone.size.X / 2, zone.size.X / 2),
            0,
            random:NextNumber(-zone.size.Z / 2, zone.size.Z / 2)
        )
end

local function spawnInitialGroup(regionId: string, zone: SpawnZoneDefinition)
    local groupSize = random:NextInteger(zone.clusterMinimum, zone.clusterMaximum)
    local center = randomPosition(zone)
    for index = 1, groupSize do
        local angle = (index - 1) * math.pi * 2 / groupSize
        local radius = if groupSize == 1 then 0 else 3
        spawnOne(
            regionId,
            zone,
            center + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius)
        )
    end
end

local function createRegionPresentation()
    local existing = Workspace:FindFirstChild(REGION_FOLDER_NAME)
    if existing ~= nil then
        existing:Destroy()
    end
    local folder = Instance.new("Folder")
    folder.Name = REGION_FOLDER_NAME
    folder.Parent = Workspace
    for _, region in WorldDataRegistry.regions do
        local platform = Instance.new("Part")
        platform.Name = `{region.id}_Platform`
        platform.Anchored = true
        platform.Size = region.platformSize
        platform.Position = region.platformCenter
        platform.Material = Enum.Material.SmoothPlastic
        platform.Color = Color3.fromRGB(119, 170, 102)
        platform.TopSurface = Enum.SurfaceType.Smooth
        platform.Parent = folder
        for _, zone in region.spawnZones do
            local marker = Instance.new("Part")
            marker.Name = zone.id
            marker.Anchored = true
            marker.CanCollide = false
            marker.CanTouch = false
            marker.CanQuery = false
            marker.Transparency = 0.82
            marker.Size = Vector3.new(zone.size.X, 0.15, zone.size.Z)
            marker.Position = Vector3.new(zone.center.X, 0.58, zone.center.Z)
            marker.Material = Enum.Material.Neon
            marker.Color = if zone.clusterMinimum == 1
                then Color3.fromRGB(113, 207, 137)
                else Color3.fromRGB(104, 169, 224)
            marker.Parent = folder
        end
    end
end

local function scheduleRespawn(record: WildCreatureRecord)
    local zone = WorldDataRegistry.getSpawnZone(record.zoneId)
    assert(zone ~= nil, `Unknown zone for wild creature: {record.zoneId}`)
    table.insert(respawnQueue, {
        dueAt = os.clock() + zone.respawnSeconds,
        regionId = record.regionId,
        zoneId = record.zoneId,
        position = record.spawnPosition,
    })
end

local function despawn(record: WildCreatureRecord)
    if record.state == "Defeated" then
        assert(WildLifecycle.transition(record, "Despawned"))
    elseif record.state ~= "Despawned" then
        local transitioned = WildLifecycle.transition(record, "Despawned")
        assert(transitioned, `Cannot despawn wild creature from state {record.state}`)
    end
    local model = modelsById[record.id]
    if model ~= nil then
        model:Destroy()
        modelsById[record.id] = nil
    end
    scheduleRespawn(record)
end

function RegionalWildService.getAll(): { WildCreatureRecord }
    local records: { WildCreatureRecord } = {}
    for _, record in recordsById do
        if record.state ~= "Despawned" then
            table.insert(records, record)
        end
    end
    return records
end

function RegionalWildService.get(wildId: string): WildCreatureRecord?
    return recordsById[wildId]
end

function RegionalWildService.getZone(wildId: string): SpawnZoneDefinition?
    local record = recordsById[wildId]
    return if record == nil then nil else WorldDataRegistry.getSpawnZone(record.zoneId)
end

function RegionalWildService.beginEngagement(
    wildId: string,
    encounterId: string,
    userId: number,
    distance: number
): (boolean, string?)
    local record = recordsById[wildId]
    if record == nil then
        return false, "Wild creature not found"
    end
    local zone = WorldDataRegistry.getSpawnZone(record.zoneId)
    assert(zone ~= nil, `Unknown zone: {record.zoneId}`)
    local started, startError = WildLifecycle.beginEngagement(
        record,
        encounterId,
        userId,
        distance,
        math.max(zone.aggroRange, zone.engagementRange)
    )
    if started then
        updatePresentation(record)
    end
    return started, startError
end

function RegionalWildService.setPosition(wildId: string, position: Vector3)
    local record = recordsById[wildId]
    if record ~= nil and record.state ~= "Despawned" then
        record.position = position
        updatePresentation(record)
    end
end

function RegionalWildService.applyDamage(wildId: string, damage: number): boolean
    local record = recordsById[wildId]
    if record == nil or record.state ~= "Engaging" then
        return false
    end
    record.currentHealth = math.max(0, record.currentHealth - math.max(0, damage))
    updatePresentation(record)
    if record.currentHealth == 0 then
        assert(WildLifecycle.transition(record, "Defeated"))
        updatePresentation(record)
        despawn(record)
        return true
    end
    return false
end

function RegionalWildService.capture(wildId: string): boolean
    local record = recordsById[wildId]
    if record == nil or record.state ~= "Engaging" then
        return false
    end
    assert(WildLifecycle.transition(record, "Defeated"))
    updatePresentation(record)
    despawn(record)
    return true
end

function RegionalWildService.beginReturning(wildId: string): boolean
    local record = recordsById[wildId]
    if record == nil or record.state ~= "Engaging" then
        return false
    end
    assert(WildLifecycle.transition(record, "Returning"))
    updatePresentation(record)
    return true
end

function RegionalWildService.start()
    createRegionPresentation()
    for _, region in WorldDataRegistry.regions do
        for _, zone in region.spawnZones do
            for _ = 1, zone.maximumGroups do
                spawnInitialGroup(region.id, zone)
            end
        end
    end
    RunService.Heartbeat:Connect(function(deltaTime)
        for _, record in recordsById do
            if record.state == "Returning" then
                local zone = WorldDataRegistry.getSpawnZone(record.zoneId)
                assert(zone ~= nil, `Unknown returning zone: {record.zoneId}`)
                record.position = WildLifecycle.stepToward(
                    record.position,
                    record.spawnPosition,
                    zone.returnSpeed,
                    deltaTime
                )
                if (record.position - record.spawnPosition).Magnitude < 0.1 then
                    record.position = record.spawnPosition
                    record.currentHealth = record.maximumHealth
                    assert(WildLifecycle.transition(record, "Idle"))
                end
                updatePresentation(record)
            end
        end
        local currentTime = os.clock()
        for index = #respawnQueue, 1, -1 do
            local entry = respawnQueue[index]
            if currentTime >= entry.dueAt then
                local zone = WorldDataRegistry.getSpawnZone(entry.zoneId)
                assert(zone ~= nil, `Unknown respawn zone: {entry.zoneId}`)
                spawnOne(entry.regionId, zone, entry.position)
                table.remove(respawnQueue, index)
            end
        end
    end)
end

return table.freeze(RegionalWildService)
