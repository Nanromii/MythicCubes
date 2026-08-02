--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local StarterDefinitions = require(ReplicatedStorage.Shared.Config.StarterDefinitions)
local StarterTypes = require(ReplicatedStorage.Shared.Types.StarterTypes)

type ResponseView = StarterTypes.StarterResponse

local BACKGROUND_COLOR = Color3.fromRGB(31, 38, 48)
local PANEL_COLOR = Color3.fromRGB(46, 56, 69)
local TEXT_COLOR = Color3.fromRGB(244, 246, 248)
local MUTED_TEXT_COLOR = Color3.fromRGB(186, 196, 207)
local SELECTED_COLOR = Color3.fromRGB(238, 194, 86)
local CONFIRM_COLOR = Color3.fromRGB(80, 167, 116)
local DISABLED_COLOR = Color3.fromRGB(88, 96, 106)
local REMOTE_WAIT_TIMEOUT_SECONDS = 10

local StarterSelectionController = {}

local function waitForRemoteFunction(parent: Instance, remoteName: string): RemoteFunction
    local remote = parent:WaitForChild(remoteName, REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(
        remote ~= nil,
        `{remoteName} was not created after {REMOTE_WAIT_TIMEOUT_SECONDS} seconds; check server startup errors`
    )
    assert(remote:IsA("RemoteFunction"), `{remoteName} must be a RemoteFunction`)
    return remote
end

local function addCorner(instance: GuiObject, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = instance
end

local function readResponse(value: unknown): ResponseView?
    if typeof(value) ~= "table" then
        return nil
    end

    local response = value :: { [unknown]: unknown }

    if
        typeof(response.ok) ~= "boolean"
        or typeof(response.code) ~= "string"
        or typeof(response.message) ~= "string"
    then
        return nil
    end

    if response.starterId ~= nil and typeof(response.starterId) ~= "string" then
        return nil
    end

    return {
        ok = response.ok :: boolean,
        code = response.code :: string,
        message = response.message :: string,
        starterId = response.starterId :: string?,
    }
end

local function invokeRemote(remote: RemoteFunction, request: unknown?): (ResponseView?, string?)
    local callSucceeded, rawResponse = pcall(function(): unknown
        if request == nil then
            return remote:InvokeServer()
        end

        return remote:InvokeServer(request)
    end)

    if not callSucceeded then
        return nil, "Server request failed"
    end

    local response = readResponse(rawResponse)

    if response == nil then
        return nil, "Server returned an invalid response"
    end

    return response, nil
end

local function createInterface(playerGui: PlayerGui): (ScreenGui, Frame, TextLabel, TextButton)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StarterSelectionGui"
    screenGui.IgnoreGuiInset = false
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    local frame = Instance.new("Frame")
    frame.Name = "Panel"
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.Size = UDim2.fromOffset(520, 430)
    frame.BackgroundColor3 = BACKGROUND_COLOR
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    addCorner(frame, 16)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(320, 390)
    sizeConstraint.MaxSize = Vector2.new(520, 430)
    sizeConstraint.Parent = frame

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(24, 18)
    title.Size = UDim2.new(1, -48, 0, 36)
    title.Font = Enum.Font.GothamBold
    title.Text = "Choose your starter"
    title.TextColor3 = TEXT_COLOR
    title.TextSize = 26
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.BackgroundTransparency = 1
    subtitle.Position = UDim2.fromOffset(24, 56)
    subtitle.Size = UDim2.new(1, -48, 0, 26)
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Select one companion. This choice lasts for this session."
    subtitle.TextColor3 = MUTED_TEXT_COLOR
    subtitle.TextSize = 15
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = frame

    local optionsFrame = Instance.new("Frame")
    optionsFrame.Name = "Options"
    optionsFrame.BackgroundTransparency = 1
    optionsFrame.Position = UDim2.fromOffset(24, 96)
    optionsFrame.Size = UDim2.new(1, -48, 0, 200)
    optionsFrame.Parent = frame

    local grid = Instance.new("UIGridLayout")
    grid.CellPadding = UDim2.fromOffset(12, 12)
    grid.CellSize = UDim2.new(0.5, -6, 0, 94)
    grid.FillDirectionMaxCells = 2
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    grid.Parent = optionsFrame

    local status = Instance.new("TextLabel")
    status.Name = "Status"
    status.BackgroundTransparency = 1
    status.Position = UDim2.fromOffset(24, 312)
    status.Size = UDim2.new(1, -48, 0, 42)
    status.Font = Enum.Font.Gotham
    status.Text = "No starter selected"
    status.TextColor3 = MUTED_TEXT_COLOR
    status.TextSize = 15
    status.TextWrapped = true
    status.Parent = frame

    local confirmButton = Instance.new("TextButton")
    confirmButton.Name = "Confirm"
    confirmButton.AnchorPoint = Vector2.new(0.5, 1)
    confirmButton.Position = UDim2.new(0.5, 0, 1, -22)
    confirmButton.Size = UDim2.new(1, -48, 0, 48)
    confirmButton.AutoButtonColor = false
    confirmButton.BackgroundColor3 = DISABLED_COLOR
    confirmButton.BorderSizePixel = 0
    confirmButton.Font = Enum.Font.GothamBold
    confirmButton.Text = "Confirm starter"
    confirmButton.TextColor3 = TEXT_COLOR
    confirmButton.TextSize = 17
    confirmButton.Parent = frame
    addCorner(confirmButton, 10)

    return screenGui, optionsFrame, status, confirmButton
end

function StarterSelectionController.start()
    local localPlayer = Players.LocalPlayer
    local playerGuiInstance = localPlayer:WaitForChild("PlayerGui")
    assert(playerGuiInstance:IsA("PlayerGui"), "PlayerGui must be a PlayerGui")

    local remotesFolder = ReplicatedStorage:WaitForChild("Remotes", REMOTE_WAIT_TIMEOUT_SECONDS)
    assert(remotesFolder ~= nil, "ReplicatedStorage.Remotes is missing from the Rojo mapping")

    local getStarterInstance = waitForRemoteFunction(remotesFolder, RemoteNames.GET_STARTER)
    local selectStarterInstance = waitForRemoteFunction(remotesFolder, RemoteNames.SELECT_STARTER)

    local screenGui, optionsFrame, status, confirmButton = createInterface(playerGuiInstance)
    local selectedId: string? = nil
    local buttonsById: { [string]: TextButton } = {}
    local selectionLocked = false
    local requestInFlight = false

    local function updateInterface(message: string?)
        for starterId, button in buttonsById do
            button.BackgroundColor3 = if selectedId == starterId
                then SELECTED_COLOR
                else PANEL_COLOR
        end

        local hasSelection = selectedId ~= nil
        confirmButton.BackgroundColor3 = if hasSelection and not selectionLocked
            then CONFIRM_COLOR
            else DISABLED_COLOR
        confirmButton.Active = hasSelection and not selectionLocked and not requestInFlight

        if message ~= nil then
            status.Text = message
        elseif selectionLocked then
            status.Text = "Starter selected for this session."
        else
            status.Text = if selectedId == nil then "No starter selected" else "1 starter selected"
        end
    end

    local function setLockedStarter(starterId: string)
        selectedId = starterId
        selectionLocked = true
        updateInterface(nil)
        task.delay(2, function()
            screenGui.Enabled = false
        end)
    end

    for layoutOrder, definition in StarterDefinitions.list do
        local optionButton = Instance.new("TextButton")
        optionButton.Name = definition.id
        optionButton.LayoutOrder = layoutOrder
        optionButton.AutoButtonColor = false
        optionButton.BackgroundColor3 = PANEL_COLOR
        optionButton.BorderSizePixel = 0
        optionButton.Font = Enum.Font.GothamBold
        optionButton.Text = definition.displayName
        optionButton.TextColor3 = TEXT_COLOR
        optionButton.TextSize = 18
        optionButton.Parent = optionsFrame
        addCorner(optionButton, 10)
        buttonsById[definition.id] = optionButton

        local colorMarker = Instance.new("Frame")
        colorMarker.Name = "ColorMarker"
        colorMarker.AnchorPoint = Vector2.new(0, 0.5)
        colorMarker.Position = UDim2.new(0, 14, 0.5, 0)
        colorMarker.Size = UDim2.fromOffset(24, 48)
        colorMarker.BackgroundColor3 = definition.displayColor
        colorMarker.BorderSizePixel = 0
        colorMarker.Parent = optionButton
        addCorner(colorMarker, 6)

        optionButton.Activated:Connect(function()
            if selectionLocked or requestInFlight then
                return
            end

            selectedId = definition.id

            updateInterface(nil)
        end)
    end

    confirmButton.Activated:Connect(function()
        if selectionLocked or requestInFlight or selectedId == nil then
            return
        end

        requestInFlight = true
        updateInterface("Server is validating your starter...")

        local response, requestError = invokeRemote(selectStarterInstance, {
            starterId = selectedId,
        })

        requestInFlight = false

        if response == nil then
            updateInterface(requestError)
            return
        end

        if response.starterId ~= nil and (response.ok or response.code == "ALREADY_SELECTED") then
            setLockedStarter(response.starterId)
            return
        end

        updateInterface(response.message)
    end)

    updateInterface(nil)

    local currentStarterResponse, requestError = invokeRemote(getStarterInstance, nil)

    if currentStarterResponse == nil then
        updateInterface(requestError)
    elseif
        currentStarterResponse.code == "SELECTED" and currentStarterResponse.starterId ~= nil
    then
        setLockedStarter(currentStarterResponse.starterId)
    end
end

return table.freeze(StarterSelectionController)
