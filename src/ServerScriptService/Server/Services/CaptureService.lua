--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WorldDataRegistry = require(ReplicatedStorage.Shared.Config.WorldDataRegistry)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)
local CaptureCalculator = require(ReplicatedStorage.Shared.Utils.CaptureCalculator)
local CaptureRequestValidator = require(ReplicatedStorage.Shared.Utils.CaptureRequestValidator)
local CombatRequestRateLimiter = require(ReplicatedStorage.Shared.Utils.CombatRequestRateLimiter)
local CollectionService = require(script.Parent.CollectionService)
local EncounterService = require(script.Parent.EncounterService)
local RemoteFactory = require(script.Parent.Parent.Systems.RemoteFactory)

type CaptureResponse = WorldTypes.CaptureResponse

local MINIMUM_REQUEST_INTERVAL_SECONDS = 0.25
local processedResponsesByPlayer: { [Player]: { [string]: CaptureResponse } } = {}
local lastRequestTimeByPlayer: { [Player]: number } = {}

local CaptureService = {}

local function response(ok: boolean, code: string, message: string): CaptureResponse
    return {
        ok = ok,
        code = code,
        message = message,
        captured = false,
        chance = nil,
        world = nil,
        collection = nil,
    }
end

local function capture(player: Player, requestValue: unknown): CaptureResponse
    local intent, validationError = CaptureRequestValidator.validate(requestValue)
    if intent == nil then
        return response(false, "INVALID_REQUEST", validationError or "Invalid capture request")
    end
    local processed = processedResponsesByPlayer[player]
    if processed == nil then
        processed = {}
        processedResponsesByPlayer[player] = processed
    end
    local cached = processed[intent.requestId]
    if cached ~= nil then
        return cached
    end
    local currentTime = os.clock()
    if
        not CombatRequestRateLimiter.isAllowed(
            lastRequestTimeByPlayer[player],
            currentTime,
            MINIMUM_REQUEST_INTERVAL_SECONDS
        )
    then
        return response(false, "RATE_LIMITED", "Capture requests are arriving too quickly")
    end
    lastRequestTimeByPlayer[player] = currentTime
    local device = WorldDataRegistry.getCaptureDevice(intent.deviceId)
    if device == nil then
        return response(false, "DEVICE_NOT_FOUND", "Capture device does not exist")
    end
    local collectionBefore = CollectionService.getSnapshot(player)
    if (collectionBefore.captureInventory[intent.deviceId] or 0) <= 0 then
        local emptyResponse = response(false, "DEVICE_EMPTY", "Capture device inventory is empty")
        emptyResponse.collection = collectionBefore
        emptyResponse.world = EncounterService.getSnapshot(player)
        return emptyResponse
    end
    local wild, targetError = EncounterService.validateCaptureTarget(
        player,
        intent.encounterId,
        intent.wildId,
        device.captureRange
    )
    if wild == nil then
        local invalidTargetResponse =
            response(false, targetError or "TARGET_INVALID", "Capture target is invalid")
        invalidTargetResponse.collection = collectionBefore
        invalidTargetResponse.world = EncounterService.getSnapshot(player)
        return invalidTargetResponse
    end
    local chance = CaptureCalculator.calculateChance(device, wild.currentHealth, wild.maximumHealth)
    local captured = CaptureCalculator.isSuccessful(chance, math.random())
    local transaction, executed = CollectionService.completeCapture(
        player,
        intent.requestId,
        intent.deviceId,
        wild.creatureId,
        captured
    )
    if not transaction.ok then
        local transactionResponse =
            response(false, transaction.code, "Capture transaction was rejected")
        transactionResponse.collection = CollectionService.getSnapshot(player)
        transactionResponse.world = EncounterService.getSnapshot(player)
        return transactionResponse
    end
    assert(executed, "Uncached capture request must execute exactly once")
    if transaction.captured then
        assert(
            EncounterService.completeCapture(player, intent.encounterId, intent.wildId),
            "Validated capture target must complete atomically"
        )
    else
        EncounterService.publish(player)
    end
    CollectionService.publish(player)
    local captureResponse = response(true, transaction.code, "Capture transaction completed")
    captureResponse.captured = transaction.captured
    captureResponse.chance = chance
    captureResponse.collection = CollectionService.getSnapshot(player)
    captureResponse.world = EncounterService.getSnapshot(player)
    processed[intent.requestId] = captureResponse
    return captureResponse
end

function CaptureService.start()
    local useCaptureRemote = RemoteFactory.getFunction(RemoteNames.USE_CAPTURE_DEVICE)
    useCaptureRemote.OnServerInvoke = capture
    Players.PlayerRemoving:Connect(function(player)
        processedResponsesByPlayer[player] = nil
        lastRequestTimeByPlayer[player] = nil
    end)
end

return table.freeze(CaptureService)
