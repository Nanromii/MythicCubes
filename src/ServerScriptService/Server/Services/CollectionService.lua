--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)
local CollectionEngine = require(ReplicatedStorage.Shared.Utils.CollectionEngine)
local RemoteFactory = require(script.Parent.Parent.Systems.RemoteFactory)

type CollectionSnapshot = WorldTypes.CollectionSnapshot
type SessionState = CollectionEngine.SessionState
type TransactionResult = CollectionEngine.TransactionResult

local sessionsByPlayer: { [Player]: SessionState } = {}
local collectionUpdatedRemote: RemoteEvent? = nil

local CollectionService = {}

local function getOrCreateSession(player: Player): SessionState
    local state = sessionsByPlayer[player]
    if state == nil then
        state = CollectionEngine.createSession(player.UserId)
        sessionsByPlayer[player] = state
    end
    return state
end

function CollectionService.getSnapshot(player: Player): CollectionSnapshot
    return CollectionEngine.makeSnapshot(getOrCreateSession(player))
end

function CollectionService.addStarter(player: Player, creatureId: string): (boolean, string?)
    return CollectionEngine.addStarter(getOrCreateSession(player), creatureId)
end

function CollectionService.completeCapture(
    player: Player,
    requestId: string,
    deviceId: string,
    creatureId: string,
    captured: boolean
): (TransactionResult, boolean)
    return CollectionEngine.completeCapture(
        getOrCreateSession(player),
        player.UserId,
        requestId,
        deviceId,
        creatureId,
        captured
    )
end

function CollectionService.publish(player: Player)
    if collectionUpdatedRemote ~= nil and player.Parent == Players then
        collectionUpdatedRemote:FireClient(player, CollectionService.getSnapshot(player))
    end
end

function CollectionService.start()
    local getCollectionRemote = RemoteFactory.getFunction(RemoteNames.GET_COLLECTION)
    collectionUpdatedRemote = RemoteFactory.getEvent(RemoteNames.COLLECTION_UPDATED)
    getCollectionRemote.OnServerInvoke = function(player: Player): CollectionSnapshot
        return CollectionService.getSnapshot(player)
    end
    Players.PlayerAdded:Connect(function(player)
        getOrCreateSession(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        sessionsByPlayer[player] = nil
    end)
    for _, player in Players:GetPlayers() do
        getOrCreateSession(player)
    end
end

return table.freeze(CollectionService)
