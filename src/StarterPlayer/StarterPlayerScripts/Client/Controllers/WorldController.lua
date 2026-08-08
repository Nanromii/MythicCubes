--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local WorldDataRegistry = require(ReplicatedStorage.Shared.Config.WorldDataRegistry)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)

type CaptureResponse = WorldTypes.CaptureResponse
type CollectionSnapshot = WorldTypes.CollectionSnapshot
type EncounterSnapshot = WorldTypes.EncounterSnapshot
type UnknownTable = { [unknown]: unknown }

local REMOTE_WAIT_TIMEOUT_SECONDS = 10
local PANEL_COLOR = Color3.fromRGB(31, 38, 48)
local TEXT_COLOR = Color3.fromRGB(244, 246, 248)
local MUTED_COLOR = Color3.fromRGB(186, 196, 207)
local ACTION_COLOR = Color3.fromRGB(80, 167, 116)
local DISABLED_COLOR = Color3.fromRGB(88, 96, 106)

local WorldController = {}

local STATE_TEXT: { [string]: string } = table.freeze({
    Exploring = "đang khám phá",
    Spawning = "mục tiêu đang xuất hiện",
    Idle = "mục tiêu đang nghỉ",
    Engaging = "đang giao chiến",
    Returning = "mục tiêu đang trở về",
    Defeated = "mục tiêu đã bị hạ",
    Despawned = "mục tiêu đã biến mất",
})

local RESPONSE_MESSAGES: { [string]: string } = table.freeze({
    INVALID_REQUEST = "Yêu cầu bắt không hợp lệ.",
    RATE_LIMITED = "Bạn thao tác quá nhanh. Vui lòng chờ một chút.",
    DEVICE_NOT_FOUND = "Không tìm thấy thiết bị bắt.",
    DEVICE_EMPTY = "Bạn đã hết thiết bị bắt này.",
    ENCOUNTER_NOT_FOUND = "Cuộc giao chiến này không còn hiệu lực.",
    TARGET_NOT_FOUND = "Không tìm thấy sinh vật mục tiêu.",
    TARGET_INVALID = "Mục tiêu hoặc khoảng cách không hợp lệ.",
    TARGET_CAPTURE_LOCKED = "Sinh vật này đang được xử lý bởi một yêu cầu bắt khác.",
    TARGET_NOT_WEAKENED = "Hãy làm yếu sinh vật trước khi bắt.",
    REQUEST_ID_CONFLICT = "Mã yêu cầu bắt đã được dùng cho mục tiêu khác.",
    CAPTURE_SUCCEEDED = "Bắt thành công! Sinh vật đã vào bộ sưu tập.",
    CAPTURE_FAILED = "Bắt thất bại. Sinh vật vẫn đang giao chiến.",
})

local function waitForFunction(parent: Instance, name: string): RemoteFunction
    local remote = parent:WaitForChild(name, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remote ~= nil and remote:IsA("RemoteFunction"), `{name} must be a RemoteFunction`)
    return remote
end

local function waitForEvent(parent: Instance, name: string): RemoteEvent
    local remote = parent:WaitForChild(name, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remote ~= nil and remote:IsA("RemoteEvent"), `{name} must be a RemoteEvent`)
    return remote
end

local function addCorner(gui: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = gui
end

local function label(parent: Instance, name: string, position: UDim2, size: UDim2): TextLabel
    local item = Instance.new("TextLabel")
    item.Name = name
    item.BackgroundTransparency = 1
    item.Position = position
    item.Size = size
    item.Font = Enum.Font.Gotham
    item.TextColor3 = TEXT_COLOR
    item.TextSize = 14
    item.TextWrapped = true
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextYAlignment = Enum.TextYAlignment.Top
    item.Parent = parent
    return item
end

local function button(parent: Instance, name: string, position: UDim2): TextButton
    local item = Instance.new("TextButton")
    item.Name = name
    item.Position = position
    item.Size = UDim2.new(0.5, -20, 0, 46)
    item.AutoButtonColor = false
    item.BackgroundColor3 = ACTION_COLOR
    item.BorderSizePixel = 0
    item.Font = Enum.Font.GothamBold
    item.TextColor3 = TEXT_COLOR
    item.TextSize = 14
    item.Parent = parent
    addCorner(item, 8)
    return item
end

local function createInterface(playerGui: PlayerGui)
    local screen = Instance.new("ScreenGui")
    screen.Name = "Phase4WorldGui"
    screen.AutoLocalize = false
    screen.ResetOnSpawn = false
    screen.Parent = playerGui
    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.Position = UDim2.fromOffset(18, 18)
    panel.Size = UDim2.fromOffset(390, 650)
    panel.BackgroundColor3 = PANEL_COLOR
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.Parent = screen
    addCorner(panel, 14)
    local title = label(panel, "Title", UDim2.fromOffset(16, 14), UDim2.new(1, -32, 0, 28))
    title.Font = Enum.Font.GothamBold
    title.Text = "KHÁM PHÁ & THU PHỤC"
    title.TextSize = 20
    local state = label(panel, "State", UDim2.fromOffset(16, 50), UDim2.new(1, -32, 0, 24))
    local companion = label(panel, "Companion", UDim2.fromOffset(16, 78), UDim2.new(1, -32, 0, 24))
    local wild = label(panel, "Wild", UDim2.fromOffset(16, 106), UDim2.new(1, -32, 0, 78))
    local feedback = label(panel, "Feedback", UDim2.fromOffset(16, 190), UDim2.new(1, -32, 0, 44))
    feedback.TextColor3 = MUTED_COLOR
    local target = button(panel, "TargetSelector", UDim2.fromOffset(16, 240))
    target.Size = UDim2.new(1, -32, 0, 38)
    local trail = button(panel, "TrailCapsule", UDim2.fromOffset(16, 286))
    local prism = button(panel, "PrismSnare", UDim2.new(0.5, 4, 0, 286))
    local violet = button(panel, "VioletOrb", UDim2.fromOffset(16, 338))
    local crimson = button(panel, "CrimsonOrb", UDim2.new(0.5, 4, 0, 338))
    local collectionTitle =
        label(panel, "CollectionTitle", UDim2.fromOffset(16, 396), UDim2.new(1, -32, 0, 22))
    collectionTitle.Font = Enum.Font.GothamBold
    collectionTitle.Text = "BỘ SƯU TẬP THEO PHIÊN"
    local collection =
        label(panel, "Collection", UDim2.fromOffset(16, 424), UDim2.new(1, -32, 0, 112))
    collection.TextColor3 = MUTED_COLOR
    return state, companion, wild, feedback, target, trail, prism, violet, crimson, collection
end

local function readWorld(value: unknown): EncounterSnapshot?
    if typeof(value) ~= "table" then
        return nil
    end
    local snapshot = value :: UnknownTable
    if typeof(snapshot.state) ~= "string" then
        return nil
    end
    for _, field in { "encounterId", "wildId", "wildCreatureId", "companionCreatureId" } do
        if snapshot[field] ~= nil and typeof(snapshot[field]) ~= "string" then
            return nil
        end
    end
    for _, field in
        { "wildHealth", "wildMaximumHealth", "companionHealth", "companionMaximumHealth" }
    do
        if snapshot[field] ~= nil and typeof(snapshot[field]) ~= "number" then
            return nil
        end
    end
    if snapshot.wilds ~= nil and typeof(snapshot.wilds) ~= "table" then
        return nil
    end
    if snapshot.captureEligibleWildIds ~= nil and typeof(snapshot.captureEligibleWildIds) ~= "table" then
        return nil
    end
    return snapshot :: EncounterSnapshot
end

local function readCollection(value: unknown): CollectionSnapshot?
    if typeof(value) ~= "table" then
        return nil
    end
    local snapshot = value :: UnknownTable
    if
        typeof(snapshot.ownedCreatures) ~= "table"
        or typeof(snapshot.activeTeamInstanceIds) ~= "table"
        or typeof(snapshot.captureInventory) ~= "table"
    then
        return nil
    end
    return snapshot :: CollectionSnapshot
end

local function readCaptureResponse(value: unknown): CaptureResponse?
    if typeof(value) ~= "table" then
        return nil
    end
    local raw = value :: UnknownTable
    if
        typeof(raw.ok) ~= "boolean"
        or typeof(raw.code) ~= "string"
        or typeof(raw.message) ~= "string"
        or typeof(raw.captured) ~= "boolean"
    then
        return nil
    end
    local world = if raw.world == nil then nil else readWorld(raw.world)
    local collection = if raw.collection == nil then nil else readCollection(raw.collection)
    if (raw.world ~= nil and world == nil) or (raw.collection ~= nil and collection == nil) then
        return nil
    end
    if raw.chance ~= nil and typeof(raw.chance) ~= "number" then
        return nil
    end
    return {
        ok = raw.ok :: boolean,
        code = raw.code :: string,
        message = raw.message :: string,
        captured = raw.captured :: boolean,
        chance = raw.chance :: number?,
        world = world,
        collection = collection,
    }
end

local function invoke(remote: RemoteFunction, request: unknown?): (unknown, string?)
    local ok, result = pcall(function(): unknown
        if request == nil then
            return remote:InvokeServer()
        end
        return remote:InvokeServer(request)
    end)
    if not ok then
        return nil, "Không thể kết nối tới máy chủ."
    end
    return result, nil
end

function WorldController.start()
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    assert(playerGui:IsA("PlayerGui"), "PlayerGui must be a PlayerGui")
    local remotes = ReplicatedStorage:WaitForChild("Remotes", REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remotes ~= nil, "ReplicatedStorage.Remotes is missing")
    local getWorld = waitForFunction(remotes, RemoteNames.GET_WORLD_STATE)
    local getCollection = waitForFunction(remotes, RemoteNames.GET_COLLECTION)
    local useCapture = waitForFunction(remotes, RemoteNames.USE_CAPTURE_DEVICE)
    local worldUpdated = waitForEvent(remotes, RemoteNames.WORLD_UPDATED)
    local collectionUpdated = waitForEvent(remotes, RemoteNames.COLLECTION_UPDATED)
    local stateLabel,
        companionLabel,
        wildLabel,
        feedback,
        targetButton,
        trailButton,
        prismButton,
        violetButton,
        crimsonButton,
        collectionLabel =
        createInterface(playerGui)
    local currentWorld: EncounterSnapshot? = nil
    local currentCollection: CollectionSnapshot? = nil
    local requestSequence = 0
    local requestInFlight = false
    local selectedWildId: string? = nil

    local function setEnabled(item: TextButton, enabled: boolean)
        item.Active = enabled and not requestInFlight
        item.BackgroundColor3 = if enabled and not requestInFlight
            then ACTION_COLOR
            else DISABLED_COLOR
    end

    local function render()
        local world = currentWorld
        local collection = currentCollection
        stateLabel.Text = `Trạng thái: {if world == nil
            then STATE_TEXT.Exploring
            else STATE_TEXT[world.state] or "không xác định"}`
        if world ~= nil and world.companionCreatureId ~= nil then
            local definition = CreatureDataRegistry.getCreature(world.companionCreatureId)
            local displayName = if definition == nil
                then world.companionCreatureId
                else definition.displayName
            companionLabel.Text =
                `Đồng hành — {displayName}: {world.companionHealth or 0}/{world.companionMaximumHealth or 0} HP`
        else
            companionLabel.Text = "Đồng hành: đang chờ máy chủ"
        end
        local wilds = if world == nil or world.wilds == nil then {} else world.wilds
        local selectedWild = nil
        local selectedStillExists = false
        for _, wildSnapshot in wilds do
            if wildSnapshot.wildId == selectedWildId then
                selectedWild = wildSnapshot
                selectedStillExists = true
                break
            end
        end
        if not selectedStillExists then
            selectedWildId = if #wilds == 0 then nil else wilds[1].wildId
            selectedWild = wilds[1]
        end
        if #wilds > 0 then
            local names: { string } = {}
            for _, wildSnapshot in wilds do
                local definition = CreatureDataRegistry.getCreature(wildSnapshot.creatureId)
                local displayName = if definition == nil
                    then wildSnapshot.creatureId
                    else definition.displayName
                local marker = if wildSnapshot.wildId == selectedWildId then "▶ " else "  "
                local lockText = if wildSnapshot.isCaptureLocked then " • đang khóa bắt" else ""
                table.insert(
                    names,
                    `{marker}{displayName}: {wildSnapshot.health}/{wildSnapshot.maximumHealth} HP • {STATE_TEXT[wildSnapshot.state] or "không xác định"}{lockText}`
                )
            end
            local selectedDefinition = if selectedWild == nil
                then nil
                else CreatureDataRegistry.getCreature(selectedWild.creatureId)
            local selectedName = if selectedWild == nil or selectedDefinition == nil
                then if selectedWild == nil then "chưa có" else selectedWild.creatureId
                else selectedDefinition.displayName
            local selectedLockText = if selectedWild ~= nil and selectedWild.isCaptureLocked
                then " • đang khóa bắt"
                else ""
            wildLabel.Text = `Sinh vật tự nhiên ({#wilds}): {table.concat(names, "\n")}\nMục tiêu bắt hiện tại: {selectedName}{selectedLockText}`
        else
            wildLabel.Text = "Sinh vật tự nhiên: hãy đi tới Đồng Cỏ Khởi Nguyên"
        end
        local canCapture = world ~= nil
            and world.state == "Engaging"
            and selectedWild ~= nil
            and selectedWild.health < selectedWild.maximumHealth
            and not selectedWild.isCaptureLocked
        targetButton.Text = if selectedWild == nil
            then "Chưa có mục tiêu bắt"
            else "Đổi mục tiêu bắt"
        setEnabled(targetButton, #wilds > 1)
        local trailCount = if collection == nil
            then 0
            else collection.captureInventory.trail_capsule or 0
        local prismCount = if collection == nil
            then 0
            else collection.captureInventory.prism_snare or 0
        local violetCount = if collection == nil
            then 0
            else collection.captureInventory.violet_orb or 0
        local crimsonCount = if collection == nil
            then 0
            else collection.captureInventory.crimson_orb or 0
        local trailDefinition = WorldDataRegistry.getCaptureDevice("trail_capsule")
        local prismDefinition = WorldDataRegistry.getCaptureDevice("prism_snare")
        local violetDefinition = WorldDataRegistry.getCaptureDevice("violet_orb")
        local crimsonDefinition = WorldDataRegistry.getCaptureDevice("crimson_orb")
        trailButton.Text = `{if trailDefinition == nil
            then "Bóng xanh lá"
            else trailDefinition.displayName} ({trailCount})`
        prismButton.Text = `{if prismDefinition == nil
            then "Bóng xanh dương"
            else prismDefinition.displayName} ({prismCount})`
        violetButton.Text = `{if violetDefinition == nil
            then "Bóng tím"
            else violetDefinition.displayName} ({violetCount})`
        crimsonButton.Text = `{if crimsonDefinition == nil
            then "Bóng đỏ"
            else crimsonDefinition.displayName} ({crimsonCount})`
        trailButton:SetAttribute("Tooltip", if trailDefinition == nil then "Bóng xanh lá" else trailDefinition.displayName)
        prismButton:SetAttribute("Tooltip", if prismDefinition == nil then "Bóng xanh dương" else prismDefinition.displayName)
        violetButton:SetAttribute("Tooltip", if violetDefinition == nil then "Bóng tím" else violetDefinition.displayName)
        crimsonButton:SetAttribute("Tooltip", if crimsonDefinition == nil then "Bóng đỏ" else crimsonDefinition.displayName)
        crimsonButton:SetAttribute("IsSpecial", crimsonDefinition ~= nil and crimsonDefinition.isSpecial)
        setEnabled(trailButton, canCapture and trailCount > 0)
        setEnabled(prismButton, canCapture and prismCount > 0)
        setEnabled(violetButton, canCapture and violetCount > 0)
        setEnabled(crimsonButton, canCapture and crimsonCount > 0)
        if collection == nil then
            collectionLabel.Text = "Đang tải bộ sưu tập..."
        else
            local names: { string } = {}
            for _, owned in collection.ownedCreatures do
                local definition = CreatureDataRegistry.getCreature(owned.creatureId)
                table.insert(
                    names,
                    if definition == nil then owned.creatureId else definition.displayName
                )
            end
            collectionLabel.Text = if #names == 0
                then "Chưa có sinh vật."
                else `Sở hữu ({#names}): {table.concat(names, ", ")}\nĐội hình hiện tại: {#collection.activeTeamInstanceIds}/3`
        end
    end

    local function requestCapture(deviceId: string)
        local world = currentWorld
        if requestInFlight or world == nil or world.encounterId == nil or selectedWildId == nil then
            return
        end
        requestSequence += 1
        requestInFlight = true
        local deviceDefinition = WorldDataRegistry.getCaptureDevice(deviceId)
        local deviceName = if deviceDefinition == nil then deviceId else deviceDefinition.displayName
        feedback.Text = `{deviceName}: máy chủ đang xác nhận giao dịch bắt...`
        render()
        local raw, requestError = invoke(useCapture, {
            requestId = `capture-{player.UserId}-{requestSequence}`,
            encounterId = world.encounterId,
            wildId = selectedWildId,
            deviceId = deviceId,
        })
        requestInFlight = false
        local captureResponse = readCaptureResponse(raw)
        if captureResponse == nil then
            feedback.Text = requestError
                or "Máy chủ trả về kết quả bắt không hợp lệ."
            render()
            return
        end
        currentWorld = captureResponse.world or currentWorld
        currentCollection = captureResponse.collection or currentCollection
        local chanceText = if captureResponse.chance == nil
            then ""
            else ` (tỷ lệ máy chủ: {math.floor(captureResponse.chance * 100 + 0.5)}%)`
        feedback.Text =
            `{deviceName}: {RESPONSE_MESSAGES[captureResponse.code] or "Đã xử lý yêu cầu bắt."}{chanceText}`
        render()
    end

    trailButton.Activated:Connect(function()
        requestCapture("trail_capsule")
    end)
    prismButton.Activated:Connect(function()
        requestCapture("prism_snare")
    end)
    violetButton.Activated:Connect(function()
        requestCapture("violet_orb")
    end)
    crimsonButton.Activated:Connect(function()
        requestCapture("crimson_orb")
    end)
    targetButton.Activated:Connect(function()
        local world = currentWorld
        local wilds = if world == nil or world.wilds == nil then {} else world.wilds
        if #wilds <= 1 then
            return
        end
        local selectedIndex = 0
        for index, wildSnapshot in wilds do
            if wildSnapshot.wildId == selectedWildId then
                selectedIndex = index
                break
            end
        end
        selectedWildId = wilds[(selectedIndex % #wilds) + 1].wildId
        render()
    end)
    worldUpdated.OnClientEvent:Connect(function(value: unknown)
        local snapshot = readWorld(value)
        if snapshot ~= nil then
            currentWorld = snapshot
            render()
        end
    end)
    collectionUpdated.OnClientEvent:Connect(function(value: unknown)
        local snapshot = readCollection(value)
        if snapshot ~= nil then
            currentCollection = snapshot
            render()
        end
    end)
    local rawWorld, worldError = invoke(getWorld, nil)
    currentWorld = readWorld(rawWorld)
    local rawCollection, collectionError = invoke(getCollection, nil)
    currentCollection = readCollection(rawCollection)
    feedback.Text = worldError
        or collectionError
        or "Hãy khám phá vùng sáng phía trước để tìm sinh vật."
    render()
end

return table.freeze(WorldController)
