--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local OnboardingDefinitions = require(ReplicatedStorage.Shared.Config.OnboardingDefinitions)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local OnboardingTypes = require(ReplicatedStorage.Shared.Types.OnboardingTypes)
local CombatRequestRateLimiter = require(ReplicatedStorage.Shared.Utils.CombatRequestRateLimiter)
local OnboardingEngine = require(ReplicatedStorage.Shared.Utils.OnboardingEngine)
local OnboardingRequestValidator =
    require(ReplicatedStorage.Shared.Utils.OnboardingRequestValidator)
local CollectionService = require(script.Parent.CollectionService)
local VillageService = require(script.Parent.VillageService)
local RemoteFactory = require(script.Parent.Parent.Systems.RemoteFactory)

type SessionState = OnboardingTypes.SessionState
type Snapshot = OnboardingTypes.Snapshot
type ActionIntent = OnboardingTypes.ActionIntent
type ActionResponse = OnboardingTypes.ActionResponse
type GateKind = OnboardingTypes.GateKind

type CachedResponse = {
    fingerprint: string,
    response: ActionResponse,
}

local MINIMUM_REQUEST_INTERVAL_SECONDS = 0.35
local GATE_TOUCH_DEBOUNCE_SECONDS = 0.75
local MAXIMUM_CACHED_REQUESTS_PER_PLAYER = 128
local TUTORIAL_DEVICE_ID = "trail_capsule"
local sessionsByPlayer: { [Player]: SessionState } = {}
local processedResponsesByPlayer: { [Player]: { [string]: CachedResponse } } = {}
local processedRequestOrderByPlayer: { [Player]: { string } } = {}
local lastRequestTimeByPlayer: { [Player]: number } = {}
local lastGateTouchTimeByPlayer: { [Player]: number } = {}
local gateTouchSequenceByPlayer: { [Player]: number } = {}
local onboardingUpdatedRemote: RemoteEvent? = nil

local OnboardingService = {}

local function getOrCreateSession(player: Player): SessionState
    local state = sessionsByPlayer[player]
    if state == nil then
        state = OnboardingEngine.createSession(player.UserId)
        sessionsByPlayer[player] = state
    end
    return state
end

local function makeResponse(
    player: Player,
    ok: boolean,
    code: string,
    message: string
): ActionResponse
    return {
        ok = ok,
        code = code,
        message = message,
        snapshot = OnboardingEngine.makeSnapshot(getOrCreateSession(player)),
    }
end

local function publish(player: Player)
    if onboardingUpdatedRemote ~= nil and player.Parent == Players then
        onboardingUpdatedRemote:FireClient(
            player,
            OnboardingEngine.makeSnapshot(getOrCreateSession(player))
        )
    end
end

local function intentFingerprint(intent: ActionIntent): string
    return `{intent.action}|{intent.worldId or ""}`
end

local function cacheResponse(
    player: Player,
    requestId: string,
    fingerprint: string,
    actionResponse: ActionResponse
)
    local processed = processedResponsesByPlayer[player]
    assert(processed ~= nil, "Processed response map must exist before caching")
    local order = processedRequestOrderByPlayer[player]
    if order == nil then
        order = {}
        processedRequestOrderByPlayer[player] = order
    end
    processed[requestId] = {
        fingerprint = fingerprint,
        response = actionResponse,
    }
    table.insert(order, requestId)
    if #order > MAXIMUM_CACHED_REQUESTS_PER_PLAYER then
        local expiredRequestId = table.remove(order, 1)
        processed[expiredRequestId] = nil
    end
end

local function getRequiredAnchor(player: Player, intent: ActionIntent): BasePart?
    if intent.action == "enter_normal_world" then
        return VillageService.getWorldGate(OnboardingDefinitions.normalWorld.id)
    elseif intent.action == "practice_basic_attack" then
        return VillageService.getAnchor("basic_attack")
    elseif intent.action == "practice_active_skill" then
        return VillageService.getAnchor("active_skill")
    elseif intent.action == "capture_tumblet" then
        return VillageService.getAnchor("tumblet")
    elseif intent.action == "return_to_village" then
        local state = getOrCreateSession(player)
        if state.state == "COMPLETE" then
            if state.locationId == OnboardingDefinitions.normalWorld.id then
                return VillageService.getAnchor("normal_return")
            end
            return VillageService.getAnchor(`return:{state.locationId}`)
        end
        return VillageService.getAnchor("normal_return")
    elseif intent.action == "select_elemental_world" or intent.action == "travel_world" then
        if intent.worldId == nil then
            return nil
        end
        return VillageService.getWorldGate(intent.worldId)
    end
    return nil
end

local function applyAction(player: Player, intent: ActionIntent): ActionResponse
    local state = getOrCreateSession(player)
    local anchor = getRequiredAnchor(player, intent)
    if anchor == nil or not VillageService.isPlayerNear(player, anchor) then
        return makeResponse(
            player,
            false,
            "OUT_OF_RANGE",
            "Hãy đến đúng điểm tương tác."
        )
    end

    if intent.action == "enter_normal_world" then
        local transitioned, transitionError =
            OnboardingEngine.transition(state, "ENTER_NORMAL_WORLD", nil)
        if not transitioned then
            return makeResponse(
                player,
                false,
                transitionError or "WRONG_STATE",
                "Chưa thể vào tuyến hướng dẫn."
            )
        end
        VillageService.movePlayerToLocation(player, OnboardingDefinitions.normalWorld.id)
        publish(player)
        return makeResponse(
            player,
            true,
            "NORMAL_TUTORIAL_STARTED",
            "Đã vào Bình Nguyên Khởi Sinh."
        )
    end

    if intent.action == "capture_tumblet" then
        if state.state ~= "ACTIVE_SKILL_PRACTICED" then
            return makeResponse(
                player,
                false,
                "WRONG_STATE",
                "Tumblet chưa thể được capture ở trạng thái này."
            )
        end
        local transaction, _executed = CollectionService.completeCapture(
            player,
            `onboarding-{intent.requestId}`,
            TUTORIAL_DEVICE_ID,
            "tumblet",
            true
        )
        if not transaction.ok or not transaction.captured then
            return makeResponse(
                player,
                false,
                transaction.code,
                "Không thể hoàn tất tutorial capture."
            )
        end
        local transitioned = OnboardingEngine.transition(state, "CAPTURE_TUMBLET", nil)
        assert(transitioned, "Validated tutorial capture must advance the onboarding state")
        CollectionService.publish(player)
        publish(player)
        return makeResponse(player, true, "TUMBLET_CAPTURED", "Đã capture Tumblet.")
    end

    if intent.action == "practice_basic_attack" then
        local transitioned, transitionError =
            OnboardingEngine.transition(state, "PRACTICE_BASIC_ATTACK", nil)
        if not transitioned then
            return makeResponse(
                player,
                false,
                transitionError or "WRONG_STATE",
                "Chưa thể thực hành basic attack."
            )
        end
        publish(player)
        return makeResponse(
            player,
            true,
            "BASIC_ATTACK_PRACTICED",
            "Basic attack đã được server xác nhận."
        )
    end

    if intent.action == "practice_active_skill" then
        local transitioned, transitionError =
            OnboardingEngine.transition(state, "PRACTICE_ACTIVE_SKILL", nil)
        if not transitioned then
            return makeResponse(
                player,
                false,
                transitionError or "WRONG_STATE",
                "Chưa thể thực hành active skill."
            )
        end
        publish(player)
        return makeResponse(
            player,
            true,
            "ACTIVE_SKILL_PRACTICED",
            "Active skill đã được server xác nhận."
        )
    end

    if intent.action == "return_to_village" then
        if state.state == "COMPLETE" then
            if not OnboardingEngine.setLocation(state, "village") then
                return makeResponse(player, false, "WRONG_STATE", "Chưa thể trở lại Làng.")
            end
            VillageService.movePlayerToLocation(player, "village")
            publish(player)
            return makeResponse(
                player,
                true,
                "VILLAGE_RETURNED",
                "Đã trở lại Làng Mạch Nguồn."
            )
        end
        local transitioned, transitionError =
            OnboardingEngine.transition(state, "RETURN_TO_VILLAGE", nil)
        if not transitioned then
            return makeResponse(
                player,
                false,
                transitionError or "WRONG_STATE",
                "Chưa thể trở lại Làng."
            )
        end
        VillageService.movePlayerToLocation(player, "village")
        publish(player)
        return makeResponse(
            player,
            true,
            "WORLD_CHOICE_READY",
            "Hãy chọn world nguyên tố đầu tiên."
        )
    end

    if intent.action == "select_elemental_world" then
        local transitioned, transitionError =
            OnboardingEngine.transition(state, "SELECT_ELEMENTAL_WORLD", intent.worldId)
        if not transitioned then
            return makeResponse(
                player,
                false,
                transitionError or "WRONG_STATE",
                "World này chưa thể được mở."
            )
        end
        assert(intent.worldId ~= nil, "Validated world selection must include a world ID")
        VillageService.movePlayerToLocation(player, intent.worldId)
        publish(player)
        return makeResponse(
            player,
            true,
            "ONBOARDING_COMPLETE",
            "Đã mở world nguyên tố đầu tiên."
        )
    end

    if intent.action == "travel_world" then
        if state.state ~= "COMPLETE" or intent.worldId == nil then
            return makeResponse(player, false, "WRONG_STATE", "Chưa thể đi qua cổng này.")
        end
        if not OnboardingEngine.setLocation(state, intent.worldId) then
            return makeResponse(player, false, "WORLD_LOCKED", "World này vẫn đang khóa.")
        end
        VillageService.movePlayerToLocation(player, intent.worldId)
        publish(player)
        return makeResponse(player, true, "WORLD_TRAVELLED", "Đã đi qua cổng world.")
    end

    return makeResponse(
        player,
        false,
        "UNKNOWN_ACTION",
        "Hành động onboarding không tồn tại."
    )
end

local function requestAction(player: Player, request: unknown): ActionResponse
    local intent, validationError = OnboardingRequestValidator.validate(request)
    if intent == nil then
        return makeResponse(
            player,
            false,
            "INVALID_REQUEST",
            validationError or "Request không hợp lệ."
        )
    end
    local processed = processedResponsesByPlayer[player]
    if processed == nil then
        processed = {}
        processedResponsesByPlayer[player] = processed
    end
    local fingerprint = intentFingerprint(intent)
    local cached = processed[intent.requestId]
    if cached ~= nil then
        if cached.fingerprint ~= fingerprint then
            return makeResponse(
                player,
                false,
                "REQUEST_ID_CONFLICT",
                "Request ID đã được dùng cho intent khác."
            )
        end
        return makeResponse(
            player,
            cached.response.ok,
            cached.response.code,
            cached.response.message
        )
    end
    local currentTime = os.clock()
    if
        not CombatRequestRateLimiter.isAllowed(
            lastRequestTimeByPlayer[player],
            currentTime,
            MINIMUM_REQUEST_INTERVAL_SECONDS
        )
    then
        return makeResponse(player, false, "RATE_LIMITED", "Hãy chờ trước khi thử lại.")
    end
    lastRequestTimeByPlayer[player] = currentTime
    local actionResponse = applyAction(player, intent)
    cacheResponse(player, intent.requestId, fingerprint, actionResponse)
    return actionResponse
end

local function handleGateTouch(player: Player, gateKind: GateKind, worldId: string?)
    local state = getOrCreateSession(player)
    local gateAction = OnboardingEngine.resolveGateAction(state, gateKind, worldId)
    if gateAction == nil then
        return
    end
    local currentTime = os.clock()
    if
        not CombatRequestRateLimiter.isAllowed(
            lastGateTouchTimeByPlayer[player],
            currentTime,
            GATE_TOUCH_DEBOUNCE_SECONDS
        )
    then
        return
    end
    lastGateTouchTimeByPlayer[player] = currentTime
    local sequence = (gateTouchSequenceByPlayer[player] or 0) + 1
    gateTouchSequenceByPlayer[player] = sequence
    applyAction(player, {
        requestId = `gate-touch-{player.UserId}-{sequence}`,
        action = gateAction.action,
        worldId = gateAction.worldId,
    })
end

local function registerPlayer(player: Player)
    getOrCreateSession(player)
    player.CharacterAdded:Connect(function()
        task.defer(function()
            local state = getOrCreateSession(player)
            VillageService.movePlayerToLocation(player, state.locationId)
            publish(player)
        end)
    end)
    if player.Character ~= nil then
        task.defer(function()
            VillageService.movePlayerToLocation(player, getOrCreateSession(player).locationId)
            publish(player)
        end)
    end
end

function OnboardingService.getSnapshot(player: Player): Snapshot
    return OnboardingEngine.makeSnapshot(getOrCreateSession(player))
end

function OnboardingService.canSelectStarter(player: Player): boolean
    return getOrCreateSession(player).state == "AWAITING_STARTER"
end

function OnboardingService.isComplete(player: Player): boolean
    return getOrCreateSession(player).state == "COMPLETE"
end

function OnboardingService.recordStarterSelected(
    player: Player,
    starterId: string
): (boolean, string?)
    local transitioned, transitionError =
        OnboardingEngine.transition(getOrCreateSession(player), "STARTER_SELECTED", starterId)
    if transitioned then
        publish(player)
    end
    return transitioned, transitionError
end

function OnboardingService.start()
    local getOnboardingRemote = RemoteFactory.getFunction(RemoteNames.GET_ONBOARDING)
    local requestActionRemote = RemoteFactory.getFunction(RemoteNames.REQUEST_ONBOARDING_ACTION)
    onboardingUpdatedRemote = RemoteFactory.getEvent(RemoteNames.ONBOARDING_UPDATED)
    getOnboardingRemote.OnServerInvoke = function(player: Player, request: unknown): Snapshot?
        if request ~= nil then
            return nil
        end
        return OnboardingService.getSnapshot(player)
    end
    requestActionRemote.OnServerInvoke = requestAction
    VillageService.setGateTouchHandler(handleGateTouch)

    Players.PlayerAdded:Connect(registerPlayer)
    Players.PlayerRemoving:Connect(function(player)
        sessionsByPlayer[player] = nil
        processedResponsesByPlayer[player] = nil
        processedRequestOrderByPlayer[player] = nil
        lastRequestTimeByPlayer[player] = nil
        lastGateTouchTimeByPlayer[player] = nil
        gateTouchSequenceByPlayer[player] = nil
    end)
    for _, player in Players:GetPlayers() do
        registerPlayer(player)
    end
end

return table.freeze(OnboardingService)
