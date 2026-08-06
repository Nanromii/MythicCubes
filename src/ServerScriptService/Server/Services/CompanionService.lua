--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)

local FOLDER_NAME = "Companions"
local FOLLOW_SPEED = 18
local FOLLOW_OFFSET = Vector3.new(3.5, -1.5, 3.5)

type CompanionRecord = {
    creatureId: string,
    model: Model,
    position: Vector3,
    targetPosition: Vector3?,
}

local recordsByPlayer: { [Player]: CompanionRecord } = {}

local CompanionService = {}

local function getFolder(): Folder
    local existing = Workspace:FindFirstChild(FOLDER_NAME)
    if existing ~= nil then
        assert(existing:IsA("Folder"), `{FOLDER_NAME} must be a Folder`)
        return existing
    end
    local folder = Instance.new("Folder")
    folder.Name = FOLDER_NAME
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
    part.CanQuery = false
    part.CanTouch = false
    part.Size = size
    part.CFrame = CFrame.new(offset)
    part.Material = Enum.Material.SmoothPlastic
    part.Color = color
    part.Parent = parent
    return part
end

local function addNameplate(root: BasePart, displayName: string)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Nameplate"
    billboard.Size = UDim2.fromOffset(150, 34)
    billboard.StudsOffset = Vector3.new(0, 2.6, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = root
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.GothamBold
    label.Text = `{displayName} • Đồng hành`
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0.3
    label.TextScaled = true
    label.Parent = billboard
end

local function createModel(player: Player, creatureId: string, position: Vector3): Model
    local definition = CreatureDataRegistry.getCreature(creatureId)
    assert(definition ~= nil, `Unknown companion creature: {creatureId}`)
    local model = Instance.new("Model")
    model.Name = tostring(player.UserId)
    local root =
        createBlock(model, "Root", Vector3.new(2.4, 2, 2.6), Vector3.zero, definition.displayColor)
    createBlock(
        model,
        "Head",
        Vector3.new(1.8, 1.5, 1.8),
        Vector3.new(0, 1.5, -0.35),
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
        "EarLeft",
        Vector3.new(0.45, 0.75, 0.45),
        Vector3.new(-0.55, 2.45, -0.35),
        definition.displayColor
    )
    createBlock(
        model,
        "EarRight",
        Vector3.new(0.45, 0.75, 0.45),
        Vector3.new(0.55, 2.45, -0.35),
        definition.displayColor
    )
    model.PrimaryPart = root
    addNameplate(root, definition.displayName)
    model.Parent = getFolder()
    model:PivotTo(CFrame.new(position))
    return model
end

function CompanionService.clear(player: Player)
    local record = recordsByPlayer[player]
    if record ~= nil then
        record.model:Destroy()
        recordsByPlayer[player] = nil
    end
    local orphan = getFolder():FindFirstChild(tostring(player.UserId))
    if orphan ~= nil then
        orphan:Destroy()
    end
end

function CompanionService.show(player: Player, creatureId: string)
    CompanionService.clear(player)
    local character = player.Character
    local root = if character == nil then nil else character:WaitForChild("HumanoidRootPart", 5)
    if root == nil or not root:IsA("BasePart") or player.Parent ~= Players then
        return
    end
    local position = root.Position + FOLLOW_OFFSET
    recordsByPlayer[player] = {
        creatureId = creatureId,
        model = createModel(player, creatureId, position),
        position = position,
        targetPosition = nil,
    }
end

function CompanionService.getPosition(player: Player): Vector3?
    local record = recordsByPlayer[player]
    return if record == nil then nil else record.position
end

function CompanionService.setCombatTarget(player: Player, position: Vector3?)
    local record = recordsByPlayer[player]
    if record ~= nil then
        record.targetPosition = position
    end
end

function CompanionService.start()
    RunService.Heartbeat:Connect(function(deltaTime)
        for player, record in recordsByPlayer do
            local character = player.Character
            local root = if character == nil
                then nil
                else character:FindFirstChild("HumanoidRootPart")
            if root == nil or not root:IsA("BasePart") then
                continue
            end
            local target = record.targetPosition or (root.Position + FOLLOW_OFFSET)
            local offset = target - record.position
            if offset.Magnitude > 0.05 then
                local step = math.min(offset.Magnitude, FOLLOW_SPEED * deltaTime)
                record.position += offset.Unit * step
                record.model:PivotTo(CFrame.new(record.position))
            end
        end
    end)
    Players.PlayerRemoving:Connect(CompanionService.clear)
end

return table.freeze(CompanionService)
