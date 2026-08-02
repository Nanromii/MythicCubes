--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local StarterSelectionValidator = require(ReplicatedStorage.Shared.Utils.StarterSelectionValidator)
local StarterDisplayService = require(script.Parent.StarterDisplayService)

local MIN_REQUEST_INTERVAL_SECONDS = 0.5

type StarterResponse = {
    ok: boolean,
    code: string,
    message: string,
    starterId: string?,
}

local selectedStarterIdByPlayer: { [Player]: string } = {}
local lastRequestTimeByPlayer: { [Player]: number } = {}

local StarterSelectionService = {}

local function createResponse(
    ok: boolean,
    code: string,
    message: string,
    starterId: string?
): StarterResponse
    return {
        ok = ok,
        code = code,
        message = message,
        starterId = starterId,
    }
end

local function getOrCreateRemotesFolder(): Folder
    local existingFolder = ReplicatedStorage:FindFirstChild("Remotes")

    if existingFolder ~= nil then
        assert(existingFolder:IsA("Folder"), "ReplicatedStorage.Remotes must be a Folder")
        return existingFolder
    end

    local folder = Instance.new("Folder")
    folder.Name = "Remotes"
    folder.Parent = ReplicatedStorage
    return folder
end

local function getOrCreateRemoteFunction(parent: Folder, remoteName: string): RemoteFunction
    local existingRemote = parent:FindFirstChild(remoteName)

    if existingRemote ~= nil then
        assert(existingRemote:IsA("RemoteFunction"), `{remoteName} must be a RemoteFunction`)
        return existingRemote
    end

    local remote = Instance.new("RemoteFunction")
    remote.Name = remoteName
    remote.Parent = parent
    return remote
end

local function getStarter(player: Player): StarterResponse
    local selectedStarterId = selectedStarterIdByPlayer[player]

    if selectedStarterId == nil then
        return createResponse(true, "NOT_SELECTED", "No starter selected this session", nil)
    end

    return createResponse(true, "SELECTED", "Starter already selected", selectedStarterId)
end

local function selectStarter(player: Player, request: unknown): StarterResponse
    local selectedStarterId = selectedStarterIdByPlayer[player]

    if selectedStarterId ~= nil then
        return createResponse(
            false,
            "ALREADY_SELECTED",
            "A starter can only be selected once per session",
            selectedStarterId
        )
    end

    local currentTime = os.clock()
    local lastRequestTime = lastRequestTimeByPlayer[player]

    if lastRequestTime ~= nil and currentTime - lastRequestTime < MIN_REQUEST_INTERVAL_SECONDS then
        return createResponse(false, "RATE_LIMITED", "Please wait before trying again", nil)
    end

    lastRequestTimeByPlayer[player] = currentTime

    local validatedStarterId, validationError = StarterSelectionValidator.validate(request)

    if validatedStarterId == nil then
        return createResponse(
            false,
            "INVALID_SELECTION",
            validationError or "Invalid starter selection",
            nil
        )
    end

    selectedStarterIdByPlayer[player] = validatedStarterId
    StarterDisplayService.showStarter(player, validatedStarterId)

    return createResponse(true, "SELECTED", "Starter selected for this session", validatedStarterId)
end

local function registerPlayer(player: Player)
    player.CharacterAdded:Connect(function()
        local selectedStarterId = selectedStarterIdByPlayer[player]

        if selectedStarterId == nil then
            return
        end

        task.defer(StarterDisplayService.showStarter, player, selectedStarterId)
    end)
end

function StarterSelectionService.start()
    local remotesFolder = getOrCreateRemotesFolder()
    local getStarterRemote = getOrCreateRemoteFunction(remotesFolder, RemoteNames.GET_STARTER)
    local selectStarterRemote = getOrCreateRemoteFunction(remotesFolder, RemoteNames.SELECT_STARTER)

    getStarterRemote.OnServerInvoke = getStarter
    selectStarterRemote.OnServerInvoke = selectStarter

    Players.PlayerAdded:Connect(registerPlayer)
    Players.PlayerRemoving:Connect(function(player)
        selectedStarterIdByPlayer[player] = nil
        lastRequestTimeByPlayer[player] = nil
        StarterDisplayService.clearPlayer(player)
    end)

    for _, player in Players:GetPlayers() do
        registerPlayer(player)
    end
end

return table.freeze(StarterSelectionService)
