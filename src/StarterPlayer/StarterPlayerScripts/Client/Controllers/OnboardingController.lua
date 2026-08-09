--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OnboardingDefinitions = require(ReplicatedStorage.Shared.Config.OnboardingDefinitions)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local OnboardingTypes = require(ReplicatedStorage.Shared.Types.OnboardingTypes)

type Snapshot = OnboardingTypes.Snapshot
type CompletionCallback = () -> ()

local REMOTE_WAIT_TIMEOUT_SECONDS = 10
local PANEL_COLOR = Color3.fromRGB(25, 32, 43)
local BUTTON_COLOR = Color3.fromRGB(52, 122, 139)
local TEXT_COLOR = Color3.fromRGB(246, 247, 241)
local MUTED_TEXT_COLOR = Color3.fromRGB(190, 200, 211)

local OnboardingController = {}

local function addCorner(instance: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function waitForRemote(parent: Instance, name: string, className: string): Instance
    local remote = parent:WaitForChild(name, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remote ~= nil, `{name} was not created after {REMOTE_WAIT_TIMEOUT_SECONDS} seconds`)
    assert(remote.ClassName == className, `{name} must be a {className}`)
    return remote
end

local function readStringList(value: unknown): { string }?
    if typeof(value) ~= "table" then
        return nil
    end
    local result: { string } = {}
    for _, item in value :: { unknown } do
        if typeof(item) ~= "string" then
            return nil
        end
        table.insert(result, item :: string)
    end
    return result
end

local function readSnapshot(value: unknown): Snapshot?
    if typeof(value) ~= "table" then
        return nil
    end
    local raw = value :: { [unknown]: unknown }
    if typeof(raw.state) ~= "string" or typeof(raw.locationId) ~= "string" then
        return nil
    end
    if raw.starterId ~= nil and typeof(raw.starterId) ~= "string" then
        return nil
    end
    if raw.selectedElementalWorldId ~= nil and typeof(raw.selectedElementalWorldId) ~= "string" then
        return nil
    end
    local accessibleWorldIds = readStringList(raw.accessibleWorldIds)
    if accessibleWorldIds == nil then
        return nil
    end
    return {
        state = raw.state :: OnboardingTypes.StateName,
        starterId = raw.starterId :: string?,
        selectedElementalWorldId = raw.selectedElementalWorldId :: string?,
        locationId = raw.locationId :: string,
        accessibleWorldIds = accessibleWorldIds,
    }
end

local function createInterface(
    playerGui: PlayerGui
): (ScreenGui, TextLabel, TextLabel, ScrollingFrame)
    local old = playerGui:FindFirstChild("OnboardingGui")
    if old ~= nil then
        old:Destroy()
    end
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "OnboardingGui"
    screenGui.AutoLocalize = false
    screenGui.IgnoreGuiInset = false
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local panel = Instance.new("Frame")
    panel.Name = "Panel"
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.Position = UDim2.new(1, -20, 0, 20)
    panel.Size = UDim2.new(0.32, 0, 0, 360)
    panel.BackgroundColor3 = PANEL_COLOR
    panel.BackgroundTransparency = 0.08
    panel.BorderSizePixel = 0
    panel.Parent = screenGui
    addCorner(panel, 14)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(280, 320)
    sizeConstraint.MaxSize = Vector2.new(430, 390)
    sizeConstraint.Parent = panel

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(18, 14)
    title.Size = UDim2.new(1, -36, 0, 34)
    title.Font = Enum.Font.GothamBold
    title.Text = "Hướng dẫn đầu tiên"
    title.TextColor3 = TEXT_COLOR
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = panel

    local instruction = Instance.new("TextLabel")
    instruction.Name = "Instruction"
    instruction.BackgroundTransparency = 1
    instruction.Position = UDim2.fromOffset(18, 52)
    instruction.Size = UDim2.new(1, -36, 0, 68)
    instruction.Font = Enum.Font.Gotham
    instruction.TextColor3 = TEXT_COLOR
    instruction.TextSize = 16
    instruction.TextWrapped = true
    instruction.TextXAlignment = Enum.TextXAlignment.Left
    instruction.TextYAlignment = Enum.TextYAlignment.Top
    instruction.Parent = panel

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.BackgroundTransparency = 1
    status.Position = UDim2.fromOffset(18, 122)
    status.Size = UDim2.new(1, -36, 0, 44)
    status.Font = Enum.Font.Gotham
    status.Text = "Đang tải trạng thái từ server..."
    status.TextColor3 = MUTED_TEXT_COLOR
    status.TextSize = 14
    status.TextWrapped = true
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextYAlignment = Enum.TextYAlignment.Top
    status.Parent = panel

    local actions = Instance.new("ScrollingFrame")
    actions.Name = "Actions"
    actions.BackgroundTransparency = 1
    actions.BorderSizePixel = 0
    actions.AutomaticCanvasSize = Enum.AutomaticSize.Y
    actions.CanvasSize = UDim2.fromOffset(0, 0)
    actions.ScrollBarThickness = 6
    actions.Position = UDim2.fromOffset(18, 170)
    actions.Size = UDim2.new(1, -36, 1, -186)
    actions.Parent = panel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = actions

    return screenGui, instruction, status, actions
end

local function createActionButton(parent: Instance, text: string, layoutOrder: number): TextButton
    local button = Instance.new("TextButton")
    button.Name = `Action_{layoutOrder}`
    button.LayoutOrder = layoutOrder
    button.AutoButtonColor = true
    button.BackgroundColor3 = BUTTON_COLOR
    button.BorderSizePixel = 0
    button.Size = UDim2.new(1, 0, 0, 40)
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = TEXT_COLOR
    button.TextSize = 15
    button.Selectable = true
    button.Parent = parent
    addCorner(button, 9)
    return button
end

function OnboardingController.start(onCompleted: CompletionCallback)
    local localPlayer = Players.LocalPlayer
    local playerGui = localPlayer:WaitForChild("PlayerGui") :: PlayerGui
    local remotes = ReplicatedStorage:WaitForChild("Remotes", REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remotes ~= nil, "ReplicatedStorage.Remotes is missing")
    local getOnboarding =
        waitForRemote(remotes, RemoteNames.GET_ONBOARDING, "RemoteFunction") :: RemoteFunction
    local requestAction = waitForRemote(
        remotes,
        RemoteNames.REQUEST_ONBOARDING_ACTION,
        "RemoteFunction"
    ) :: RemoteFunction
    local onboardingUpdated =
        waitForRemote(remotes, RemoteNames.ONBOARDING_UPDATED, "RemoteEvent") :: RemoteEvent
    local _screenGui, instruction, status, actions = createInterface(playerGui)
    local requestSequence = 0
    local requestInFlight = false
    local completionReported = false
    local currentSnapshot: Snapshot? = nil

    local camera = workspace.CurrentCamera
    if camera ~= nil then
        camera.CameraType = Enum.CameraType.Custom
    end

    local function clearActions()
        for _, child in actions:GetChildren() do
            if child:IsA("GuiButton") then
                child:Destroy()
            end
        end
    end

    local render: (Snapshot, string?) -> ()
    local loadSnapshot: () -> ()

    local function sendAction(actionName: string, worldId: string?)
        if requestInFlight then
            return
        end
        requestInFlight = true
        requestSequence += 1
        status.Text = "Máy chủ đang xác nhận..."
        local payload: { [string]: unknown } = {
            requestId = `phase5-{localPlayer.UserId}-{requestSequence}`,
            action = actionName,
        }
        if worldId ~= nil then
            payload.worldId = worldId
        end
        local ok, rawResponse = pcall(function(): unknown
            return requestAction:InvokeServer(payload)
        end)
        requestInFlight = false
        if not ok or typeof(rawResponse) ~= "table" then
            status.Text = "Không thể kết nối tới máy chủ. Hãy thử lại."
            return
        end
        local response = rawResponse :: { [unknown]: unknown }
        local snapshot = readSnapshot(response.snapshot)
        if
            typeof(response.ok) ~= "boolean"
            or typeof(response.code) ~= "string"
            or typeof(response.message) ~= "string"
            or snapshot == nil
        then
            status.Text = "Máy chủ trả về dữ liệu không hợp lệ."
            return
        end
        render(snapshot, response.message :: string)
    end

    local function bindAction(text: string, actionName: string, worldId: string?, order: number)
        local button = createActionButton(actions, text, order)
        button.Activated:Connect(function()
            sendAction(actionName, worldId)
        end)
    end

    render = function(snapshot: Snapshot, message: string?)
        currentSnapshot = snapshot
        clearActions()
        status.Text = message or "Trạng thái đã được server xác nhận."
        if snapshot.state == "AWAITING_STARTER" then
            instruction.Text = "Đến khu trưng bày và chọn 1 trong 5 thú đồng hành."
        elseif snapshot.state == "NORMAL_WORLD_READY" then
            instruction.Text =
                "Chạm cổng Bình Nguyên Khởi Sinh để bắt đầu tutorial."
            bindAction("Vào Bình Nguyên Khởi Sinh", "enter_normal_world", nil, 1)
        elseif snapshot.state == "NORMAL_TUTORIAL" then
            instruction.Text = "Đi theo tuyến và đến gần marker basic attack."
            bindAction("Thực hành basic attack", "practice_basic_attack", nil, 1)
        elseif snapshot.state == "BASIC_ATTACK_PRACTICED" then
            instruction.Text = "Đến gần marker active skill để tiếp tục."
            bindAction("Thực hành active skill", "practice_active_skill", nil, 1)
        elseif snapshot.state == "ACTIVE_SKILL_PRACTICED" then
            instruction.Text = "Đến gần Tumblet để thực hành guaranteed capture."
            bindAction("Capture Tumblet", "capture_tumblet", nil, 1)
        elseif snapshot.state == "TUMBLET_CAPTURED" then
            instruction.Text =
                "Chạm cổng cuối tuyến để trở lại Làng Mạch Nguồn."
            bindAction("Trở lại Làng", "return_to_village", nil, 1)
        elseif snapshot.state == "WORLD_CHOICE_READY" then
            instruction.Text =
                "Chạm cổng nguyên tố của world bạn muốn khám phá trước."
            for index, world in OnboardingDefinitions.elementalWorlds do
                bindAction(world.displayName, "select_elemental_world", world.id, index)
            end
        elseif snapshot.state == "COMPLETE" then
            if not completionReported then
                completionReported = true
                task.defer(onCompleted)
            end
            if snapshot.locationId ~= "village" then
                instruction.Text =
                    "Onboarding hoàn tất. Chạm cổng trở về để quay lại Làng."
                bindAction("Trở lại Làng", "return_to_village", nil, 1)
            else
                instruction.Text =
                    "Onboarding hoàn tất. Chạm cổng của một trong hai world đã mở."
                local order = 0
                for _, worldId in snapshot.accessibleWorldIds do
                    local world = OnboardingDefinitions.getWorld(worldId)
                    if world ~= nil then
                        order += 1
                        bindAction(world.displayName, "travel_world", world.id, order)
                    end
                end
            end
        else
            instruction.Text = "Trạng thái onboarding không được hỗ trợ."
            status.Text = "Hãy báo lỗi và kiểm tra Server Output."
        end
    end

    onboardingUpdated.OnClientEvent:Connect(function(rawSnapshot: unknown)
        local snapshot = readSnapshot(rawSnapshot)
        if snapshot ~= nil then
            render(snapshot, nil)
        else
            status.Text = "Snapshot onboarding không hợp lệ."
        end
    end)

    loadSnapshot = function()
        clearActions()
        instruction.Text = "Đang tải trạng thái onboarding từ server."
        status.Text = "Vui lòng chờ..."
        local ok, rawSnapshot = pcall(function(): unknown
            return getOnboarding:InvokeServer()
        end)
        local snapshot = if ok then readSnapshot(rawSnapshot) else nil
        if snapshot == nil then
            instruction.Text = "Không tải được onboarding."
            status.Text = "Kiểm tra kết nối rồi thử lại."
            local retryButton = createActionButton(actions, "Thử tải lại", 1)
            retryButton.Activated:Connect(loadSnapshot)
        else
            render(snapshot, nil)
        end
    end

    loadSnapshot()

    return function(): Snapshot?
        return currentSnapshot
    end
end

return table.freeze(OnboardingController)
