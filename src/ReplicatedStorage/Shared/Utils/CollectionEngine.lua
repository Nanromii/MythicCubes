--!strict

local CreatureDataRegistry = require(script.Parent.Parent.Config.CreatureDataRegistry)
local WorldDataRegistry = require(script.Parent.Parent.Config.WorldDataRegistry)
local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)
local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type OwnedCreature = CreatureTypes.OwnedCreature
type CollectionSnapshot = WorldTypes.CollectionSnapshot

export type TransactionResult = {
    ok: boolean,
    code: string,
    captured: boolean,
    instanceId: string?,
}

export type SessionState = {
    ownerUserId: number,
    nextInstanceSequence: number,
    ownedCreatures: { OwnedCreature },
    activeTeamInstanceIds: { string },
    captureInventory: { [string]: number },
    processedCaptureRequests: { [string]: TransactionResult },
    processedCaptureFingerprints: { [string]: string },
}

local CollectionEngine = {}

local function cloneResult(result: TransactionResult): TransactionResult
    return {
        ok = result.ok,
        code = result.code,
        captured = result.captured,
        instanceId = result.instanceId,
    }
end

local function captureFingerprint(deviceId: string, creatureId: string, captured: boolean): string
    return `{deviceId}|{creatureId}|{tostring(captured)}`
end

local function createOwned(state: SessionState, creatureId: string): OwnedCreature
    state.nextInstanceSequence += 1
    local definition = CreatureDataRegistry.getCreature(creatureId)
    assert(definition ~= nil, `Unknown creature id: {creatureId}`)
    return {
        instanceId = `session-{state.ownerUserId}-{state.nextInstanceSequence}`,
        creatureId = creatureId,
        level = 1,
        experience = 0,
        equippedSkillIds = { definition.skillIds[1] },
    }
end

function CollectionEngine.createSession(ownerUserId: number): SessionState
    local inventory: { [string]: number } = {}
    for _, device in WorldDataRegistry.captureDevices do
        inventory[device.id] = device.startingQuantity
    end
    return {
        ownerUserId = ownerUserId,
        nextInstanceSequence = 0,
        ownedCreatures = {},
        activeTeamInstanceIds = {},
        captureInventory = inventory,
        processedCaptureRequests = {},
        processedCaptureFingerprints = {},
    }
end

function CollectionEngine.addStarter(state: SessionState, creatureId: string): (boolean, string?)
    if CreatureDataRegistry.getCreature(creatureId) == nil then
        return false, "UNKNOWN_CREATURE"
    end
    if #state.activeTeamInstanceIds > 0 then
        return false, "STARTER_ALREADY_ADDED"
    end
    local owned = createOwned(state, creatureId)
    table.insert(state.ownedCreatures, owned)
    table.insert(state.activeTeamInstanceIds, owned.instanceId)
    return true, nil
end

function CollectionEngine.completeCapture(
    state: SessionState,
    requesterUserId: number,
    requestId: string,
    deviceId: string,
    creatureId: string,
    captured: boolean
): (TransactionResult, boolean)
    local fingerprint = captureFingerprint(deviceId, creatureId, captured)
    local cachedFingerprint = state.processedCaptureFingerprints[requestId]
    if cachedFingerprint ~= nil and cachedFingerprint ~= fingerprint then
        return {
            ok = false,
            code = "REQUEST_ID_CONFLICT",
            captured = false,
            instanceId = nil,
        },
            false
    end
    local cached = state.processedCaptureRequests[requestId]
    if cached ~= nil then
        return cloneResult(cached), false
    end
    local result: TransactionResult
    if requesterUserId ~= state.ownerUserId then
        result = { ok = false, code = "NOT_COLLECTION_OWNER", captured = false, instanceId = nil }
    elseif WorldDataRegistry.getCaptureDevice(deviceId) == nil then
        result = { ok = false, code = "DEVICE_NOT_FOUND", captured = false, instanceId = nil }
    elseif CreatureDataRegistry.getCreature(creatureId) == nil then
        result = { ok = false, code = "CREATURE_NOT_FOUND", captured = false, instanceId = nil }
    elseif (state.captureInventory[deviceId] or 0) <= 0 then
        result = { ok = false, code = "DEVICE_EMPTY", captured = false, instanceId = nil }
    else
        state.captureInventory[deviceId] -= 1
        local instanceId: string? = nil
        if captured then
            local owned = createOwned(state, creatureId)
            table.insert(state.ownedCreatures, owned)
            instanceId = owned.instanceId
        end
        result = {
            ok = true,
            code = if captured then "CAPTURE_SUCCEEDED" else "CAPTURE_FAILED",
            captured = captured,
            instanceId = instanceId,
        }
    end
    state.processedCaptureRequests[requestId] = cloneResult(result)
    state.processedCaptureFingerprints[requestId] = fingerprint
    return result, true
end

function CollectionEngine.makeSnapshot(state: SessionState): CollectionSnapshot
    local ownedCreatures: { OwnedCreature } = {}
    for _, owned in state.ownedCreatures do
        table.insert(ownedCreatures, {
            instanceId = owned.instanceId,
            creatureId = owned.creatureId,
            level = owned.level,
            experience = owned.experience,
            equippedSkillIds = table.clone(owned.equippedSkillIds),
        })
    end
    return {
        ownedCreatures = ownedCreatures,
        activeTeamInstanceIds = table.clone(state.activeTeamInstanceIds),
        captureInventory = table.clone(state.captureInventory),
    }
end

return table.freeze(CollectionEngine)
