--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local StarterTypes = require(ReplicatedStorage.Shared.Types.StarterTypes)
local StarterSelectionValidator = require(ReplicatedStorage.Shared.Utils.StarterSelectionValidator)
local CollectionService = require(script.Parent.CollectionService)
local CompanionService = require(script.Parent.CompanionService)
local OnboardingService = require(script.Parent.OnboardingService)

local MIN_REQUEST_INTERVAL_SECONDS = 0.5

type StarterResponse = StarterTypes.StarterResponse

local selectedStarterIdByPlayer: { [Player]: string } = {}
local lastRequestTimeByPlayer: { [Player]: number } = {}

local StarterSelectionService = {}

function StarterSelectionService.getSelectedStarterId(player: Player): string?
    return selectedStarterIdByPlayer[player]
end

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

    if not OnboardingService.canSelectStarter(player) then
        return createResponse(false, "WRONG_STATE", "Starter selection is not available", nil)
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

    local starterAdded, starterError = CollectionService.addStarter(player, validatedStarterId)

    if not starterAdded then
        return createResponse(
            false,
            "COLLECTION_REJECTED",
            starterError or "Starter could not be added to the session collection",
            nil
        )
    end

    local onboardingAdvanced, onboardingError =
        OnboardingService.recordStarterSelected(player, validatedStarterId)
    assert(
        onboardingAdvanced,
        `Starter collection commit must advance onboarding: {onboardingError or "unknown error"}`
    )

    selectedStarterIdByPlayer[player] = validatedStarterId
    task.defer(CompanionService.show, player, validatedStarterId)
    CollectionService.publish(player)

    return createResponse(true, "SELECTED", "Starter selected for this session", validatedStarterId)
end

local function registerPlayer(player: Player)
    player.CharacterAdded:Connect(function()
        local selectedStarterId = selectedStarterIdByPlayer[player]

        if selectedStarterId == nil then
            return
        end

        task.defer(CompanionService.show, player, selectedStarterId)
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
        CompanionService.clear(player)
    end)

    for _, player in Players:GetPlayers() do
        registerPlayer(player)
    end
end

return table.freeze(StarterSelectionService)
