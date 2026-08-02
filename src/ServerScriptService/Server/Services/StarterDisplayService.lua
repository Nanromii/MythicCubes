--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local StarterDefinitions = require(ReplicatedStorage.Shared.Config.StarterDefinitions)

local COMPANION_FOLDER_NAME = "StarterCompanions"
local COMPANION_SIZE = Vector3.new(2.5, 2.5, 2.5)
local COMPANION_OFFSET = CFrame.new(3, 0, 1)

local StarterDisplayService = {}

local function getCompanionFolder(): Folder
    local existingFolder = Workspace:FindFirstChild(COMPANION_FOLDER_NAME)

    if existingFolder ~= nil then
        assert(existingFolder:IsA("Folder"), `{COMPANION_FOLDER_NAME} must be a Folder`)
        return existingFolder
    end

    local folder = Instance.new("Folder")
    folder.Name = COMPANION_FOLDER_NAME
    folder.Parent = Workspace
    return folder
end

local function addNameplate(part: BasePart, displayName: string)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Nameplate"
    billboard.Size = UDim2.fromOffset(140, 32)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.Text = displayName
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.35
    label.TextScaled = true
    label.Parent = billboard
end

local function createCompanion(playerFolder: Folder, rootPart: BasePart, starterId: string)
    local definition = StarterDefinitions.getById(starterId)
    assert(definition ~= nil, `Unknown validated starter id: {starterId}`)

    local companion = Instance.new("Part")
    companion.Name = definition.id
    companion.Anchored = false
    companion.CanCollide = false
    companion.CanQuery = false
    companion.CanTouch = false
    companion.CastShadow = true
    companion.Massless = true
    companion.Size = COMPANION_SIZE
    companion.Material = Enum.Material.SmoothPlastic
    companion.Color = definition.displayColor
    companion.CFrame = rootPart.CFrame * COMPANION_OFFSET
    companion.Parent = playerFolder

    addNameplate(companion, definition.displayName)

    local weld = Instance.new("WeldConstraint")
    weld.Name = "CharacterWeld"
    weld.Part0 = rootPart
    weld.Part1 = companion
    weld.Parent = companion
end

function StarterDisplayService.clearPlayer(player: Player)
    local playerFolder = getCompanionFolder():FindFirstChild(tostring(player.UserId))

    if playerFolder ~= nil then
        playerFolder:Destroy()
    end
end

function StarterDisplayService.showStarter(player: Player, starterId: string)
    StarterDisplayService.clearPlayer(player)

    local character = player.Character
    local rootPart = if character == nil then nil else character:WaitForChild("HumanoidRootPart", 5)

    if rootPart == nil or not rootPart:IsA("BasePart") then
        return
    end

    if player.Parent ~= Players then
        return
    end

    local playerFolder = Instance.new("Folder")
    playerFolder.Name = tostring(player.UserId)
    playerFolder.Parent = getCompanionFolder()

    createCompanion(playerFolder, rootPart, starterId)
end

return table.freeze(StarterDisplayService)
