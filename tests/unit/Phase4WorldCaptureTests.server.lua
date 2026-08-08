--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local WorldDataRegistry = require(ReplicatedStorage.Shared.Config.WorldDataRegistry)
local WorldTypes = require(ReplicatedStorage.Shared.Types.WorldTypes)
local CaptureCalculator = require(ReplicatedStorage.Shared.Utils.CaptureCalculator)
local CaptureRequestValidator = require(ReplicatedStorage.Shared.Utils.CaptureRequestValidator)
local CollectionEngine = require(ReplicatedStorage.Shared.Utils.CollectionEngine)
local SpawnPoolSelector = require(ReplicatedStorage.Shared.Utils.SpawnPoolSelector)
local WildLifecycle = require(ReplicatedStorage.Shared.Utils.WildLifecycle)
local WorldDefinitionValidator = require(ReplicatedStorage.Shared.Utils.WorldDefinitionValidator)
local StarterDefinitions = require(ReplicatedStorage.Shared.Config.StarterDefinitions)
local StarterSelectionValidator = require(ReplicatedStorage.Shared.Utils.StarterSelectionValidator)

type WildCreatureRecord = WorldTypes.WildCreatureRecord

local passedTestCount = 0

local function pass(condition: boolean, message: string)
    assert(condition, message)
    passedTestCount += 1
end

local region = WorldDataRegistry.regions[1]
local singleZone = region.spawnZones[1]
local clusterZone = region.spawnZones[2]
local validDefinitions, definitionError = WorldDefinitionValidator.validateCatalog(
    WorldDataRegistry.regions,
    WorldDataRegistry.captureDevices
)
pass(validDefinitions, definitionError or "Current Phase 4 definitions must be valid")
local expectedDevices = {
    { id = "trail_capsule", displayName = "Bóng xanh lá" },
    { id = "prism_snare", displayName = "Bóng xanh dương" },
    { id = "violet_orb", displayName = "Bóng tím" },
    { id = "crimson_orb", displayName = "Bóng đỏ" },
}
pass(#WorldDataRegistry.captureDevices == 4, "Phase 4 must expose exactly four capture devices")
for index, expectedDevice in expectedDevices do
    local device = WorldDataRegistry.captureDevices[index]
    pass(
        device ~= nil
            and device.id == expectedDevice.id
            and device.displayName == expectedDevice.displayName
            and (device :: any).tier == index,
        `Capture device {index} must preserve the ordered tier catalog`
    )
end
local specialDevice = WorldDataRegistry.getCaptureDevice("crimson_orb")
pass(
    specialDevice ~= nil and (specialDevice :: any).isSpecial == true,
    "The red capture device must be marked special"
)
pass(#StarterDefinitions.list == 5, "Starter selection must expose exactly five creatures")
local starterElements: { [string]: boolean } = {}
for _, starter in StarterDefinitions.list do
    starterElements[starter.elementId] = true
end
pass(
    StarterDefinitions.getById("pebblit") ~= nil
        and StarterDefinitions.getById("pebblit").elementId == "normal",
    "The fifth starter must be the existing normal-element creature"
)
local starterElementCount = 0
for _ in starterElements do
    starterElementCount += 1
end
pass(starterElementCount == 5, "Starter choices must represent five distinct elements")
local validStarterIntent = StarterSelectionValidator.validate({ starterId = "pebblit" })
pass(validStarterIntent == "pebblit", "The normal-element starter must be selectable")
local invalidStarterIntent = StarterSelectionValidator.validate({ starterId = "unknown_starter" })
pass(invalidStarterIntent == nil, "Unknown starter IDs must be rejected")
pass(
    singleZone.clusterMinimum == 1 and singleZone.clusterMaximum == 1,
    "The vertical slice must define an individual spawn"
)
pass(
    clusterZone.clusterMinimum >= 2 and clusterZone.clusterMaximum >= 2,
    "The vertical slice must define a cluster spawn"
)
pass(
    SpawnPoolSelector.select(singleZone.spawnPool, 0) == "pebblit"
        and SpawnPoolSelector.select(singleZone.spawnPool, 0.99) == "bramblet",
    "Weighted regional spawn selection must be deterministic for injected rolls"
)

local invalidZone = table.clone(singleZone)
invalidZone.leashRange = 10
local invalidZoneValid = WorldDefinitionValidator.validateSpawnZone(invalidZone)
pass(not invalidZoneValid, "A leash shorter than engagement range must be rejected")

local invalidDisengageZone = table.clone(singleZone)
invalidDisengageZone.disengageRange = 19
local invalidDisengageValid = WorldDefinitionValidator.validateSpawnZone(invalidDisengageZone)
pass(not invalidDisengageValid, "Owner disengage range cannot be shorter than engagement range")

local wild: WildCreatureRecord = {
    id = "wild-1",
    creatureId = "pebblit",
    regionId = region.id,
    zoneId = singleZone.id,
    spawnGroupId = "group-1",
    spawnPosition = Vector3.new(0, 2, 0),
    position = Vector3.new(0, 2, 0),
    state = "Spawning",
    currentHealth = 50,
    maximumHealth = 100,
    attack = 10,
    defense = 10,
    encounterId = nil,
    targetUserId = nil,
    targetUserIds = nil,
    captureLockUserId = nil,
    captureLockRequestId = nil,
}
local spawned = WildLifecycle.transition(wild, "Idle")
pass(spawned and wild.state == "Idle", "Spawning must transition to Idle")
local nearbyOwnerCanEngage =
    WildLifecycle.canStartEngagement(wild, Vector3.new(4, 2, 0), Vector3.new(2, 2, 0), 20, 28)
pass(nearbyOwnerCanEngage, "A nearby owner and companion may start an encounter")
local distantOwnerCanEngage =
    WildLifecycle.canStartEngagement(wild, Vector3.new(40, 2, 0), Vector3.new(2, 2, 0), 20, 28)
pass(
    not distantOwnerCanEngage,
    "A companion left in the region must not re-aggro while its owner is far away"
)
local engaged = WildLifecycle.beginEngagement(wild, "encounter-1", 11, 10, 20)
pass(engaged and wild.state == "Engaging", "Idle wild creature must engage an in-range target")
local targetValid = WildLifecycle.validateTarget(wild, "encounter-1", 11, 15, 20)
pass(targetValid, "Encounter target and server-observed range must validate")
local participantJoined = WildLifecycle.addParticipant(wild, "encounter-1", 22)
pass(participantJoined, "A second player may join an active shared wild encounter")
local secondParticipantValid = WildLifecycle.validateTarget(wild, "encounter-1", 22, 15, 20)
pass(secondParticipantValid, "A joined player may target the shared wild")
local participantRemoved = WildLifecycle.removeParticipant(wild, 22)
local removedParticipantValid = WildLifecycle.validateTarget(wild, "encounter-1", 22, 15, 20)
pass(
    participantRemoved and not removedParticipantValid,
    "A removed participant must lose target authority"
)
local wrongEncounterValid = WildLifecycle.validateTarget(wild, "encounter-other", 11, 15, 20)
pass(not wrongEncounterValid, "A target from another encounter must be rejected")
local outOfRangeValid = WildLifecycle.validateTarget(wild, "encounter-1", 11, 25, 20)
pass(not outOfRangeValid, "An out-of-range encounter target must be rejected")
pass(
    not WildLifecycle.shouldDisengage(wild, Vector3.new(20, 2, 0), Vector3.new(0, 2, 0), 28, 42),
    "An owner inside disengage range must keep the encounter active"
)
pass(
    WildLifecycle.shouldDisengage(wild, Vector3.new(29, 2, 0), Vector3.new(0, 2, 0), 28, 42),
    "An owner leaving the companion must end the encounter"
)
local firstCaptureLock = WildLifecycle.reserveCapture(wild, 11, "capture-lock-1")
local conflictingCaptureLock = WildLifecycle.reserveCapture(wild, 22, "capture-lock-2")
pass(
    firstCaptureLock and not conflictingCaptureLock,
    "The first valid capture request must lock a shared target"
)
WildLifecycle.releaseCapture(wild, 11, "capture-lock-1")
local lockAfterFailure = WildLifecycle.reserveCapture(wild, 22, "capture-lock-2")
pass(lockAfterFailure, "A failed capture must unlock the target for the next valid request")
WildLifecycle.releaseCapture(wild, 22, "capture-lock-2")
wild.position = Vector3.new(43, 2, 0)
pass(
    WildLifecycle.shouldDisengage(wild, Vector3.new(43, 2, 0), Vector3.new(43, 2, 0), 28, 42),
    "A wild creature leaving its spawn leash must return"
)
wild.position = wild.spawnPosition
local returning = WildLifecycle.transition(wild, "Returning")
local returned = WildLifecycle.transition(wild, "Idle")
pass(
    returning and returned and wild.state == "Idle",
    "Engaging must return safely through Returning"
)

local invalidTransition = WildLifecycle.transition(wild, "Defeated")
pass(not invalidTransition, "Idle cannot transition directly to Defeated")
assert(WildLifecycle.beginEngagement(wild, "encounter-2", 11, 5, 20))
local defeated = WildLifecycle.transition(wild, "Defeated")
local despawned = WildLifecycle.transition(wild, "Despawned")
pass(
    defeated and despawned and wild.state == "Despawned",
    "A defeated engagement must transition exactly once to Despawned"
)

local basicDevice = WorldDataRegistry.getCaptureDevice("trail_capsule")
assert(basicDevice ~= nil, "Trail capsule definition must exist")
local weakChance = CaptureCalculator.calculateChance(basicDevice, 10, 100)
local healthyChance = CaptureCalculator.calculateChance(basicDevice, 100, 100)
pass(weakChance > healthyChance, "Weakening a wild creature must improve capture probability")
pass(
    CaptureCalculator.isSuccessful(weakChance, 0)
        and not CaptureCalculator.isSuccessful(healthyChance, 0.99),
    "Injected capture rolls must cover success and failure"
)

local validIntent = CaptureRequestValidator.validate({
    requestId = "capture-1",
    encounterId = "encounter-1",
    wildId = "wild-1",
    deviceId = "trail_capsule",
})
pass(validIntent ~= nil, "A valid capture intent must pass shape validation")
local invalidIntent = CaptureRequestValidator.validate({
    requestId = "capture-2",
    encounterId = "encounter-1",
    wildId = "wild-1",
    deviceId = "trail_capsule",
    chance = 1,
})
pass(invalidIntent == nil, "Capture intents must reject client-provided chance and extra fields")

local firstSession = CollectionEngine.createSession(101)
local secondSession = CollectionEngine.createSession(202)
assert(CollectionEngine.addStarter(firstSession, "pyrel"))
assert(CollectionEngine.addStarter(secondSession, "bramblet"))
pass(
    firstSession.captureInventory.violet_orb == 1 and firstSession.captureInventory.crimson_orb == 1,
    "Each session must receive the new capture device inventory"
)
local firstQuantity = firstSession.captureInventory.trail_capsule
local failedResult = CollectionEngine.completeCapture(
    firstSession,
    101,
    "failed-capture",
    "trail_capsule",
    "pebblit",
    false
)
pass(
    failedResult.code == "CAPTURE_FAILED"
        and firstSession.captureInventory.trail_capsule == firstQuantity - 1
        and #firstSession.ownedCreatures == 1,
    "A valid failed capture must consume one device without granting ownership"
)

local beforeSuccessfulQuantity = firstSession.captureInventory.prism_snare
local successfulResult, firstExecution = CollectionEngine.completeCapture(
    firstSession,
    101,
    "successful-capture",
    "prism_snare",
    "pebblit",
    true
)
pass(
    successfulResult.captured
        and firstExecution
        and firstSession.captureInventory.prism_snare == beforeSuccessfulQuantity - 1
        and #firstSession.ownedCreatures == 2,
    "A successful capture must consume once and add one owned creature"
)

local ownedCountBeforeRetry = #firstSession.ownedCreatures
local quantityBeforeRetry = firstSession.captureInventory.prism_snare
local retryResult, retryExecuted = CollectionEngine.completeCapture(
    firstSession,
    101,
    "successful-capture",
    "prism_snare",
    "pebblit",
    true
)
pass(
    retryResult.captured
        and not retryExecuted
        and #firstSession.ownedCreatures == ownedCountBeforeRetry
        and firstSession.captureInventory.prism_snare == quantityBeforeRetry,
    "A duplicate request must return the cached result without duplicate consumption or ownership"
)
local conflictingRetryResult, conflictingRetryExecuted = CollectionEngine.completeCapture(
    firstSession,
    101,
    "successful-capture",
    "trail_capsule",
    "pebblit",
    false
)
pass(
    conflictingRetryResult.code == "REQUEST_ID_CONFLICT" and not conflictingRetryExecuted,
    "A duplicate request ID with a different capture intent must be rejected"
)

local wrongOwnerQuantity = firstSession.captureInventory.trail_capsule
local wrongOwnerResult = CollectionEngine.completeCapture(
    firstSession,
    202,
    "wrong-owner",
    "trail_capsule",
    "pebblit",
    true
)
pass(
    wrongOwnerResult.code == "NOT_COLLECTION_OWNER"
        and firstSession.captureInventory.trail_capsule == wrongOwnerQuantity,
    "Collection transactions must validate player ownership"
)
pass(
    #secondSession.ownedCreatures == 1
        and secondSession.captureInventory.trail_capsule == basicDevice.startingQuantity,
    "Session collection and inventory must remain isolated between players"
)
local unknownDeviceResult = CollectionEngine.completeCapture(
    firstSession,
    101,
    "unknown-device",
    "missing_device",
    "pebblit",
    true
)
pass(
    unknownDeviceResult.code == "DEVICE_NOT_FOUND",
    "Unknown capture device IDs must be rejected"
)
firstSession.captureInventory.violet_orb = 0
local emptyDeviceResult = CollectionEngine.completeCapture(
    firstSession,
    101,
    "empty-device",
    "violet_orb",
    "pebblit",
    true
)
pass(emptyDeviceResult.code == "DEVICE_EMPTY", "Empty capture device inventory must be rejected")

print(`[Phase4WorldCaptureTests] {passedTestCount} tests passed`)
