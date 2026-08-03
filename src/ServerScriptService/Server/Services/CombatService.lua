--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local CreatureDataRegistry = require(ReplicatedStorage.Shared.Config.CreatureDataRegistry)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local CombatTypes = require(ReplicatedStorage.Shared.Types.CombatTypes)
local CombatEngine = require(ReplicatedStorage.Shared.Utils.CombatEngine)
local CombatRequestRateLimiter = require(ReplicatedStorage.Shared.Utils.CombatRequestRateLimiter)
local CombatRequestValidator = require(ReplicatedStorage.Shared.Utils.CombatRequestValidator)
local StarterSelectionService = require(script.Parent.StarterSelectionService)

type CombatResponse = CombatTypes.CombatResponse
type CombatSnapshot = CombatTypes.CombatSnapshot
type CombatState = CombatTypes.CombatState

local MINIMUM_SKILL_REQUEST_INTERVAL_SECONDS = 0.2
local MINIMUM_START_REQUEST_INTERVAL_SECONDS = 0.5

local activeCombatByPlayer: { [Player]: CombatState } = {}
local processedRequestIdsByPlayer: { [Player]: { [string]: boolean } } = {}
local lastSkillRequestTimeByPlayer: { [Player]: number } = {}
local lastStartRequestTimeByPlayer: { [Player]: number } = {}
local encounterSequence = 0

local CombatService = {}

local function response(
    ok: boolean,
    code: string,
    message: string,
    snapshot: CombatSnapshot?
): CombatResponse
    return {
        ok = ok,
        code = code,
        message = message,
        snapshot = snapshot,
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

local function getOrCreateRemoteEvent(parent: Folder, remoteName: string): RemoteEvent
    local existingRemote = parent:FindFirstChild(remoteName)

    if existingRemote ~= nil then
        assert(existingRemote:IsA("RemoteEvent"), `{remoteName} must be a RemoteEvent`)
        return existingRemote
    end

    local remote = Instance.new("RemoteEvent")
    remote.Name = remoteName
    remote.Parent = parent
    return remote
end

local function chooseEnemyCreatureId(playerCreatureId: string): string
    for _, definition in CreatureDataRegistry.creatures do
        if definition.id ~= playerCreatureId then
            return definition.id
        end
    end

    error("Combat requires at least two creature definitions")
end

local function getCombat(player: Player): CombatResponse
    local state = activeCombatByPlayer[player]

    if state == nil then
        return response(true, "NO_COMBAT", "Player has no combat encounter", nil)
    end

    return response(
        true,
        "COMBAT_FOUND",
        "Combat snapshot loaded",
        CombatEngine.makeSnapshot(state, os.clock())
    )
end

local function startCombat(player: Player, request: unknown): CombatResponse
    local requestIsValid, validationError = CombatRequestValidator.validateStartRequest(request)

    if not requestIsValid then
        return response(false, "INVALID_REQUEST", validationError or "Invalid start request", nil)
    end

    local currentTime = os.clock()
    local lastRequestTime = lastStartRequestTimeByPlayer[player]

    if
        not CombatRequestRateLimiter.isAllowed(
            lastRequestTime,
            currentTime,
            MINIMUM_START_REQUEST_INTERVAL_SECONDS
        )
    then
        return response(false, "RATE_LIMITED", "Please wait before starting another combat", nil)
    end

    lastStartRequestTimeByPlayer[player] = currentTime

    local existingState = activeCombatByPlayer[player]

    if existingState ~= nil and existingState.status ~= "Finished" then
        return response(
            false,
            "COMBAT_ALREADY_ACTIVE",
            "Player already has an active combat",
            CombatEngine.makeSnapshot(existingState, currentTime)
        )
    end

    local starterId = StarterSelectionService.getSelectedStarterId(player)

    if starterId == nil then
        return response(false, "STARTER_REQUIRED", "Select a starter before combat", nil)
    end

    encounterSequence += 1
    local combatId = `combat-{player.UserId}-{encounterSequence}`
    local state, creationError = CombatEngine.createCombat(
        combatId,
        player.UserId,
        starterId,
        chooseEnemyCreatureId(starterId),
        currentTime
    )

    if state == nil then
        return response(
            false,
            "COMBAT_CREATION_FAILED",
            creationError or "Combat creation failed",
            nil
        )
    end

    assert(CombatEngine.activate(state), "New combat must activate from Preparing")
    activeCombatByPlayer[player] = state
    processedRequestIdsByPlayer[player] = {}

    return response(
        true,
        "COMBAT_STARTED",
        "Combat encounter started",
        CombatEngine.makeSnapshot(state, currentTime)
    )
end

local function useSkill(player: Player, request: unknown): CombatResponse
    local intent, validationError = CombatRequestValidator.validateSkillIntent(request)

    if intent == nil then
        return response(false, "INVALID_REQUEST", validationError or "Invalid skill intent", nil)
    end

    local state = activeCombatByPlayer[player]

    if state == nil or intent.combatId ~= state.id then
        return response(false, "COMBAT_NOT_FOUND", "Player combat does not exist", nil)
    end

    if state.ownerUserId ~= player.UserId then
        return response(false, "NOT_COMBAT_OWNER", "Player does not own combat", nil)
    end

    local processedRequestIds = processedRequestIdsByPlayer[player]

    if processedRequestIds == nil then
        processedRequestIds = {}
        processedRequestIdsByPlayer[player] = processedRequestIds
    end

    if processedRequestIds[intent.requestId] then
        return response(false, "DUPLICATE_REQUEST", "Request was already processed", nil)
    end

    local currentTime = os.clock()

    if
        not CombatRequestRateLimiter.isAllowed(
            lastSkillRequestTimeByPlayer[player],
            currentTime,
            MINIMUM_SKILL_REQUEST_INTERVAL_SECONDS
        )
    then
        return response(false, "RATE_LIMITED", "Skill requests are arriving too quickly", nil)
    end

    lastSkillRequestTimeByPlayer[player] = currentTime
    processedRequestIds[intent.requestId] = true

    local action = CombatEngine.executeSkill(state, player.UserId, intent, currentTime)
    local snapshot = CombatEngine.makeSnapshot(state, currentTime)

    return response(action.ok, action.code, action.message, snapshot)
end

function CombatService.start()
    local remotesFolder = getOrCreateRemotesFolder()
    local getCombatRemote = getOrCreateRemoteFunction(remotesFolder, RemoteNames.GET_COMBAT)
    local startCombatRemote = getOrCreateRemoteFunction(remotesFolder, RemoteNames.START_COMBAT)
    local useSkillRemote = getOrCreateRemoteFunction(remotesFolder, RemoteNames.USE_COMBAT_SKILL)
    local combatUpdatedRemote = getOrCreateRemoteEvent(remotesFolder, RemoteNames.COMBAT_UPDATED)

    getCombatRemote.OnServerInvoke = getCombat
    startCombatRemote.OnServerInvoke = function(player: Player, request: unknown): CombatResponse
        local startResponse = startCombat(player, request)

        if startResponse.snapshot ~= nil then
            combatUpdatedRemote:FireClient(player, startResponse.snapshot)
        end

        return startResponse
    end
    useSkillRemote.OnServerInvoke = function(player: Player, request: unknown): CombatResponse
        local skillResponse = useSkill(player, request)

        if skillResponse.ok and skillResponse.snapshot ~= nil then
            combatUpdatedRemote:FireClient(player, skillResponse.snapshot)
        end

        return skillResponse
    end

    RunService.Heartbeat:Connect(function()
        local currentTime = os.clock()

        for player, state in activeCombatByPlayer do
            if state.status ~= "Active" then
                continue
            end

            local stateChanged = false

            for _, combatantId in state.combatantOrder do
                local combatant = state.combatants[combatantId]

                if combatant.alive and currentTime >= combatant.nextBasicAttackAt then
                    local action = CombatEngine.executeBasicAttack(state, combatantId, currentTime)
                    stateChanged = stateChanged or action.ok or action.finishedNow
                end

                if state.status == "Finished" then
                    break
                end
            end

            if stateChanged and player.Parent == Players then
                combatUpdatedRemote:FireClient(
                    player,
                    CombatEngine.makeSnapshot(state, currentTime)
                )
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        activeCombatByPlayer[player] = nil
        processedRequestIdsByPlayer[player] = nil
        lastSkillRequestTimeByPlayer[player] = nil
        lastStartRequestTimeByPlayer[player] = nil
    end)
end

return table.freeze(CombatService)
