--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local OnboardingDefinitions = require(ReplicatedStorage.Shared.Config.OnboardingDefinitions)
local StarterDefinitions = require(ReplicatedStorage.Shared.Config.StarterDefinitions)
local OnboardingTypes = require(ReplicatedStorage.Shared.Types.OnboardingTypes)

type GateKind = OnboardingTypes.GateKind
type GateTouchHandler = (Player, GateKind, string?) -> ()

local ROOT_NAME = "Phase5World"
local VILLAGE_PLATFORM_SIZE = Vector3.new(180, 1, 180)
local INTERACTION_RANGE = 18
local CHARACTER_OFFSET = CFrame.new(0, 4, 0)

local VILLAGE_CENTER = Vector3.new(0, 0, -320)
local NORMAL_CENTER = Vector3.new(0, 0, -680)
local WORLD_CENTERS: { [string]: Vector3 } = {
    origin_plains = NORMAL_CENTER,
    ember_archipelago = Vector3.new(360, 0, -680),
    azure_tide = Vector3.new(-360, 0, -680),
    verdant_wilds = Vector3.new(360, 0, -1040),
    gale_skyway = Vector3.new(-360, 0, -1040),
}
local GATE_POSITIONS: { [string]: Vector3 } = {
    origin_plains = VILLAGE_CENTER + Vector3.new(0, 3, -64),
    ember_archipelago = VILLAGE_CENTER + Vector3.new(-54, 3, 24),
    azure_tide = VILLAGE_CENTER + Vector3.new(-28, 3, 58),
    verdant_wilds = VILLAGE_CENTER + Vector3.new(28, 3, 58),
    gale_skyway = VILLAGE_CENTER + Vector3.new(54, 3, 24),
}

local anchorsById: { [string]: BasePart } = {}
local locationSpawnsById: { [string]: BasePart } = {}
local villageSpawn: SpawnLocation? = nil
local gateTouchHandler: GateTouchHandler? = nil
local started = false

local VillageService = {}

local function createPart(
    parent: Instance,
    name: string,
    size: Vector3,
    position: Vector3,
    color: Color3,
    material: Enum.Material
): Part
    local part = Instance.new("Part")
    part.Name = name
    part.Anchored = true
    part.Size = size
    part.Position = position
    part.Color = color
    part.Material = material
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = parent
    return part
end

local function addBillboard(part: BasePart, text: string, color: Color3)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Label"
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 120
    billboard.Size = UDim2.fromOffset(280, 64)
    billboard.StudsOffset = Vector3.new(0, part.Size.Y / 2 + 2, 0)
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundColor3 = Color3.fromRGB(23, 30, 40)
    label.BackgroundTransparency = 0.15
    label.BorderSizePixel = 0
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = color
    label.TextScaled = true
    label.TextWrapped = true
    label.Parent = billboard

    local textConstraint = Instance.new("UITextSizeConstraint")
    textConstraint.MinTextSize = 12
    textConstraint.MaxTextSize = 22
    textConstraint.Parent = label
end

local function connectGateTouch(part: BasePart, gateKind: GateKind, worldId: string?)
    part.Touched:Connect(function(otherPart: BasePart)
        local handler = gateTouchHandler
        if handler == nil then
            return
        end
        local character = otherPart:FindFirstAncestorOfClass("Model")
        if character == nil then
            return
        end
        local player = Players:GetPlayerFromCharacter(character)
        if player == nil or player.Parent ~= Players then
            return
        end
        handler(player, gateKind, worldId)
    end)
end

local function createSpawn(parent: Instance, name: string, position: Vector3): SpawnLocation
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = name
    spawn.Anchored = true
    spawn.Neutral = true
    spawn.Duration = 0
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = position
    spawn.Color = Color3.fromRGB(238, 226, 178)
    spawn.Material = Enum.Material.SmoothPlastic
    spawn.Parent = parent
    return spawn
end

local function createVillage(root: Model)
    local village = Instance.new("Model")
    village.Name = "MachNguonVillage"
    village.Parent = root
    createPart(
        village,
        "VillagePlatform",
        VILLAGE_PLATFORM_SIZE,
        VILLAGE_CENTER,
        Color3.fromRGB(104, 152, 87),
        Enum.Material.Grass
    )
    local landmark = createPart(
        village,
        "SourceSpire",
        Vector3.new(12, 44, 12),
        VILLAGE_CENTER + Vector3.new(0, 22, 0),
        Color3.fromRGB(108, 184, 190),
        Enum.Material.Glass
    )
    addBillboard(landmark, "LÀNG MẠCH NGUỒN", Color3.fromRGB(245, 245, 230))

    villageSpawn = createSpawn(village, "VillageSpawn", VILLAGE_CENTER + Vector3.new(0, 1.5, 42))
    locationSpawnsById.village = villageSpawn :: SpawnLocation

    local selectionAnchor = createPart(
        village,
        "WorldChoiceAnchor",
        Vector3.new(14, 1, 14),
        VILLAGE_CENTER + Vector3.new(0, 1, 24),
        Color3.fromRGB(225, 205, 124),
        Enum.Material.Neon
    )
    selectionAnchor.CanCollide = false
    selectionAnchor.Transparency = 0.3
    anchorsById.world_choice = selectionAnchor
    addBillboard(
        selectionAnchor,
        "Chọn world nguyên tố đầu tiên",
        Color3.fromRGB(255, 247, 211)
    )

    for index, starter in StarterDefinitions.list do
        local x = (index - 3) * 14
        local pedestal = createPart(
            village,
            `StarterDisplay_{starter.id}`,
            Vector3.new(8, 2, 8),
            VILLAGE_CENTER + Vector3.new(x, 1.5, -24),
            Color3.fromRGB(70, 76, 86),
            Enum.Material.Slate
        )
        local blockout = createPart(
            village,
            `StarterBlockout_{starter.id}`,
            Vector3.new(5, 6, 5),
            pedestal.Position + Vector3.new(0, 4, 0),
            starter.displayColor,
            Enum.Material.SmoothPlastic
        )
        blockout.CanCollide = false
        addBillboard(blockout, starter.displayName, Color3.fromRGB(255, 255, 255))
    end

    for _, world in OnboardingDefinitions.worlds do
        local gatePosition = GATE_POSITIONS[world.id]
        assert(gatePosition ~= nil, `Missing Village gate position for {world.id}`)
        local gate = createPart(
            village,
            `Gate_{world.id}`,
            Vector3.new(12, 14, 4),
            gatePosition,
            world.displayColor,
            Enum.Material.Slate
        )
        gate:SetAttribute("WorldId", world.id)
        addBillboard(gate, world.displayName, Color3.fromRGB(255, 255, 255))
        anchorsById[`gate:{world.id}`] = gate
        connectGateTouch(gate, "world", world.id)
    end
end

local function createTutorialRoute(root: Model)
    local tutorial = Instance.new("Model")
    tutorial.Name = "OriginPlainsTutorial"
    tutorial.Parent = root
    createPart(
        tutorial,
        "TutorialPlatform",
        Vector3.new(120, 1, 160),
        NORMAL_CENTER,
        Color3.fromRGB(143, 174, 105),
        Enum.Material.Grass
    )
    local spawn =
        createSpawn(tutorial, "OriginPlainsSpawn", NORMAL_CENTER + Vector3.new(0, 1.5, -58))
    locationSpawnsById.origin_plains = spawn

    local movementMarker = createPart(
        tutorial,
        "MovementMarker",
        Vector3.new(10, 1, 10),
        NORMAL_CENTER + Vector3.new(0, 1, -28),
        Color3.fromRGB(238, 226, 178),
        Enum.Material.Neon
    )
    movementMarker.CanCollide = false
    addBillboard(movementMarker, "Di chuyển theo tuyến", Color3.fromRGB(255, 255, 255))

    local basicAttackMarker = createPart(
        tutorial,
        "BasicAttackMarker",
        Vector3.new(10, 1, 10),
        NORMAL_CENTER + Vector3.new(0, 1, -12),
        Color3.fromRGB(224, 184, 92),
        Enum.Material.Neon
    )
    basicAttackMarker.CanCollide = false
    anchorsById.basic_attack = basicAttackMarker
    addBillboard(basicAttackMarker, "Thực hành basic attack", Color3.fromRGB(255, 255, 255))

    local activeSkillMarker = createPart(
        tutorial,
        "ActiveSkillMarker",
        Vector3.new(10, 1, 10),
        NORMAL_CENTER + Vector3.new(0, 1, 4),
        Color3.fromRGB(108, 184, 190),
        Enum.Material.Neon
    )
    activeSkillMarker.CanCollide = false
    anchorsById.active_skill = activeSkillMarker
    addBillboard(activeSkillMarker, "Thực hành active skill", Color3.fromRGB(255, 255, 255))

    local tumblet = Instance.new("Model")
    tumblet.Name = "TutorialTumblet"
    tumblet.Parent = tutorial
    local tumbletBody = createPart(
        tumblet,
        "Body",
        Vector3.new(7, 6, 7),
        NORMAL_CENTER + Vector3.new(0, 4, 12),
        Color3.fromRGB(205, 188, 145),
        Enum.Material.SmoothPlastic
    )
    tumblet.PrimaryPart = tumbletBody
    addBillboard(tumbletBody, "Tumblet · Guaranteed capture", Color3.fromRGB(255, 255, 255))
    anchorsById.tumblet = tumbletBody

    local returnAnchor = createPart(
        tutorial,
        "TutorialReturn",
        Vector3.new(16, 10, 4),
        NORMAL_CENTER + Vector3.new(0, 5, 60),
        Color3.fromRGB(108, 184, 190),
        Enum.Material.Neon
    )
    anchorsById.normal_return = returnAnchor
    connectGateTouch(returnAnchor, "return", nil)
    addBillboard(returnAnchor, "Trở lại Làng Mạch Nguồn", Color3.fromRGB(255, 255, 255))
end

local function createElementalLandings(root: Model)
    for _, world in OnboardingDefinitions.elementalWorlds do
        local center = WORLD_CENTERS[world.id]
        assert(center ~= nil, `Missing elemental landing position for {world.id}`)
        local landing = Instance.new("Model")
        landing.Name = `Landing_{world.id}`
        landing.Parent = root
        createPart(
            landing,
            "Platform",
            Vector3.new(84, 1, 84),
            center,
            world.displayColor,
            Enum.Material.Slate
        )
        local spawn = createSpawn(landing, `Spawn_{world.id}`, center + Vector3.new(0, 1.5, 20))
        spawn.Color = world.displayColor
        locationSpawnsById[world.id] = spawn
        local marker = createPart(
            landing,
            "PreviewLandmark",
            Vector3.new(16, 28, 16),
            center + Vector3.new(0, 14, -14),
            world.displayColor,
            Enum.Material.Neon
        )
        addBillboard(marker, `{world.displayName}\nGreybox landing`, Color3.fromRGB(255, 255, 255))
        local returnAnchor = createPart(
            landing,
            "ReturnToVillage",
            Vector3.new(14, 10, 4),
            center + Vector3.new(0, 5, 34),
            Color3.fromRGB(108, 184, 190),
            Enum.Material.Neon
        )
        anchorsById[`return:{world.id}`] = returnAnchor
        connectGateTouch(returnAnchor, "return", nil)
        addBillboard(
            returnAnchor,
            "Trở lại Làng Mạch Nguồn",
            Color3.fromRGB(255, 255, 255)
        )
    end
end

local function configurePlayer(player: Player)
    local spawn = villageSpawn
    assert(spawn ~= nil, "Village spawn must exist before player configuration")
    player.RespawnLocation = spawn
    if player.Character ~= nil then
        task.defer(VillageService.movePlayerToLocation, player, "village")
    end
end

function VillageService.getAnchor(anchorId: string): BasePart?
    return anchorsById[anchorId]
end

function VillageService.setGateTouchHandler(handler: GateTouchHandler)
    assert(gateTouchHandler == nil, "Village gate touch handler was already configured")
    gateTouchHandler = handler
end

function VillageService.isInSafeZone(position: Vector3): boolean
    local halfSize = VILLAGE_PLATFORM_SIZE / 2
    return math.abs(position.X - VILLAGE_CENTER.X) <= halfSize.X
        and math.abs(position.Z - VILLAGE_CENTER.Z) <= halfSize.Z
end

function VillageService.getWorldGate(worldId: string): BasePart?
    return anchorsById[`gate:{worldId}`]
end

function VillageService.isPlayerNear(
    player: Player,
    anchor: BasePart,
    maximumDistance: number?
): boolean
    local character = player.Character
    local rootPart = if character == nil then nil else character:FindFirstChild("HumanoidRootPart")
    if rootPart == nil or not rootPart:IsA("BasePart") then
        return false
    end
    return (rootPart.Position - anchor.Position).Magnitude <= (maximumDistance or INTERACTION_RANGE)
end

function VillageService.movePlayerToLocation(player: Player, locationId: string): boolean
    local target = locationSpawnsById[locationId]
    local character = player.Character
    if target == nil or character == nil then
        return false
    end
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    if rootPart == nil or not rootPart:IsA("BasePart") then
        return false
    end
    character:PivotTo(target.CFrame * CHARACTER_OFFSET)
    return true
end

function VillageService.start()
    if started then
        return
    end
    started = true
    local existing = Workspace:FindFirstChild(ROOT_NAME)
    assert(existing == nil, `{ROOT_NAME} already exists before VillageService start`)
    local root = Instance.new("Model")
    root.Name = ROOT_NAME
    root:SetAttribute("AudioCue", "Village ambience asset pending licensed source")
    createVillage(root)
    createTutorialRoute(root)
    createElementalLandings(root)
    root.Parent = Workspace

    Players.PlayerAdded:Connect(configurePlayer)
    for _, player in Players:GetPlayers() do
        configurePlayer(player)
    end
end

return table.freeze(VillageService)
