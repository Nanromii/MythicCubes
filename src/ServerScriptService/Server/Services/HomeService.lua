--!strict

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local HOME_MODEL_NAME = "HomePlaceholder"
local PLATFORM_SIZE = Vector3.new(80, 1, 80)
local PLATFORM_POSITION = Vector3.new(0, 0, 0)
local SPAWN_POSITION = Vector3.new(0, 1.5, 0)
local CHARACTER_SPAWN_OFFSET = CFrame.new(0, 4, 0)

local HomeService = {}

local function createPlatform(parent: Instance)
    local platform = Instance.new("Part")
    platform.Name = "HomePlatform"
    platform.Anchored = true
    platform.Size = PLATFORM_SIZE
    platform.Position = PLATFORM_POSITION
    platform.Material = Enum.Material.SmoothPlastic
    platform.Color = Color3.fromRGB(104, 152, 87)
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = parent
end

local function createSpawn(parent: Instance): SpawnLocation
    local spawnLocation = Instance.new("SpawnLocation")
    spawnLocation.Name = "HomeSpawn"
    spawnLocation.Anchored = true
    spawnLocation.Size = Vector3.new(8, 1, 8)
    spawnLocation.Position = SPAWN_POSITION
    spawnLocation.Material = Enum.Material.SmoothPlastic
    spawnLocation.Color = Color3.fromRGB(238, 226, 178)
    spawnLocation.Neutral = true
    spawnLocation.Duration = 0
    spawnLocation.Parent = parent
    return spawnLocation
end

local function createHomeSign(parent: Instance)
    local sign = Instance.new("Part")
    sign.Name = "HomeSign"
    sign.Anchored = true
    sign.CanCollide = true
    sign.Size = Vector3.new(12, 6, 1)
    sign.Position = Vector3.new(0, 3.5, -12)
    sign.Material = Enum.Material.WoodPlanks
    sign.Color = Color3.fromRGB(105, 76, 51)
    sign.Parent = parent

    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Name = "Label"
    surfaceGui.Face = Enum.NormalId.Back
    surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surfaceGui.PixelsPerStud = 50
    surfaceGui.Parent = sign

    local label = Instance.new("TextLabel")
    label.Name = "Text"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.Text = "NHÀ"
    label.TextColor3 = Color3.fromRGB(248, 235, 190)
    label.TextScaled = true
    label.Parent = surfaceGui
end

local function getOrCreateHomeSpawn(): SpawnLocation
    local existingHome = Workspace:FindFirstChild(HOME_MODEL_NAME)

    if existingHome ~= nil then
        assert(existingHome:IsA("Model"), `{HOME_MODEL_NAME} must be a Model`)
        local existingSpawn = existingHome:FindFirstChild("HomeSpawn")
        assert(existingSpawn ~= nil and existingSpawn:IsA("SpawnLocation"), "HomeSpawn is missing")
        return existingSpawn
    end

    local home = Instance.new("Model")
    home.Name = HOME_MODEL_NAME
    createPlatform(home)
    local spawnLocation = createSpawn(home)
    createHomeSign(home)
    home.Parent = Workspace
    return spawnLocation
end

local function moveCharacterToHome(character: Model, spawnLocation: SpawnLocation)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)

    if rootPart == nil or not rootPart:IsA("BasePart") then
        return
    end

    character:PivotTo(spawnLocation.CFrame * CHARACTER_SPAWN_OFFSET)
end

local function configurePlayerHome(player: Player, spawnLocation: SpawnLocation)
    player.RespawnLocation = spawnLocation
    player.CharacterAdded:Connect(function(character)
        moveCharacterToHome(character, spawnLocation)
    end)

    if player.Character ~= nil then
        task.defer(moveCharacterToHome, player.Character, spawnLocation)
    end
end

function HomeService.start()
    local spawnLocation = getOrCreateHomeSpawn()

    Players.PlayerAdded:Connect(function(player)
        configurePlayerHome(player, spawnLocation)
    end)

    for _, player in Players:GetPlayers() do
        configurePlayerHome(player, spawnLocation)
    end
end

return table.freeze(HomeService)
