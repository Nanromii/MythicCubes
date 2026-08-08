--!strict

local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type WildCreatureRecord = WorldTypes.WildCreatureRecord
type WildState = WorldTypes.WildState

local ALLOWED_TRANSITIONS: { [WildState]: { [WildState]: boolean } } = {
    Spawning = { Idle = true },
    Idle = { Engaging = true, Despawned = true },
    Engaging = { Returning = true, Defeated = true },
    Returning = { Idle = true, Despawned = true },
    Defeated = { Despawned = true },
    Despawned = {},
}

local WildLifecycle = {}

function WildLifecycle.canStartEngagement(
    record: WildCreatureRecord,
    playerPosition: Vector3,
    companionPosition: Vector3,
    maximumTriggerRange: number,
    ownerRange: number
): (boolean, string?)
    if record.state ~= "Idle" then
        return false, "Wild creature is not idle"
    end
    if (record.position - companionPosition).Magnitude > maximumTriggerRange then
        return false, "Companion is outside engagement range"
    end
    if
        (playerPosition - companionPosition).Magnitude > ownerRange
        or (playerPosition - record.position).Magnitude > ownerRange
    then
        return false, "Owner is outside encounter range"
    end
    return true, nil
end

function WildLifecycle.transition(
    record: WildCreatureRecord,
    nextState: WildState
): (boolean, string?)
    if record.state == nextState then
        return false, `Wild creature is already {nextState}`
    end
    if not ALLOWED_TRANSITIONS[record.state][nextState] then
        return false, `Invalid wild transition: {record.state} -> {nextState}`
    end
    record.state = nextState
    if nextState ~= "Engaging" then
        record.encounterId = nil
        record.targetUserId = nil
        record.targetUserIds = nil
        record.captureLockUserId = nil
        record.captureLockRequestId = nil
    end
    return true, nil
end

function WildLifecycle.beginEngagement(
    record: WildCreatureRecord,
    encounterId: string,
    targetUserId: number,
    distance: number,
    maximumRange: number
): (boolean, string?)
    if record.state ~= "Idle" then
        return false, "Wild creature is not idle"
    end
    if distance > maximumRange then
        return false, "Target is outside engagement range"
    end
    local transitioned, transitionError = WildLifecycle.transition(record, "Engaging")
    if not transitioned then
        return false, transitionError
    end
    record.encounterId = encounterId
    record.targetUserId = targetUserId
    record.targetUserIds = {
        [targetUserId] = true,
    }
    return true, nil
end

function WildLifecycle.addParticipant(
    record: WildCreatureRecord,
    encounterId: string,
    targetUserId: number
): (boolean, string?)
    if record.state ~= "Engaging" or record.encounterId ~= encounterId then
        return false, "Wild creature does not belong to this encounter"
    end
    local targetUserIds = record.targetUserIds
    if targetUserIds == nil then
        targetUserIds = {}
        if record.targetUserId ~= nil then
            targetUserIds[record.targetUserId] = true
        end
        record.targetUserIds = targetUserIds
    end
    targetUserIds[targetUserId] = true
    return true, nil
end

function WildLifecycle.removeParticipant(record: WildCreatureRecord, targetUserId: number): boolean
    local targetUserIds = record.targetUserIds
    if targetUserIds == nil then
        if record.targetUserId ~= targetUserId then
            return false
        end
        record.targetUserId = nil
        return true
    end
    if not targetUserIds[targetUserId] then
        return false
    end
    targetUserIds[targetUserId] = nil
    if record.targetUserId == targetUserId then
        record.targetUserId = nil
        for userId in targetUserIds do
            record.targetUserId = userId
            break
        end
    end
    return true
end

function WildLifecycle.hasParticipant(record: WildCreatureRecord, targetUserId: number): boolean
    local targetUserIds = record.targetUserIds
    if targetUserIds ~= nil then
        return targetUserIds[targetUserId] == true
    end
    return record.targetUserId == targetUserId
end

function WildLifecycle.hasParticipants(record: WildCreatureRecord): boolean
    local targetUserIds = record.targetUserIds
    if targetUserIds ~= nil then
        for _, enabled in targetUserIds do
            if enabled then
                return true
            end
        end
        return false
    end
    return record.targetUserId ~= nil
end

function WildLifecycle.reserveCapture(
    record: WildCreatureRecord,
    targetUserId: number,
    requestId: string
): (boolean, string?)
    if record.captureLockRequestId ~= nil then
        if record.captureLockUserId == targetUserId and record.captureLockRequestId == requestId then
            return true, nil
        end
        return false, "TARGET_CAPTURE_LOCKED"
    end
    record.captureLockUserId = targetUserId
    record.captureLockRequestId = requestId
    return true, nil
end

function WildLifecycle.releaseCapture(record: WildCreatureRecord, targetUserId: number, requestId: string)
    if record.captureLockUserId == targetUserId and record.captureLockRequestId == requestId then
        record.captureLockUserId = nil
        record.captureLockRequestId = nil
    end
end

function WildLifecycle.validateTarget(
    record: WildCreatureRecord,
    encounterId: string,
    targetUserId: number,
    distance: number,
    maximumRange: number
): (boolean, string?)
    if record.state ~= "Engaging" or record.currentHealth <= 0 then
        return false, "Wild creature is not alive in an engagement"
    end
    if record.encounterId ~= encounterId or not WildLifecycle.hasParticipant(record, targetUserId) then
        return false, "Wild creature does not belong to this encounter"
    end
    if distance > maximumRange then
        return false, "Target is outside server-observed range"
    end
    return true, nil
end

function WildLifecycle.shouldDisengage(
    record: WildCreatureRecord,
    playerPosition: Vector3,
    companionPosition: Vector3,
    disengageRange: number,
    leashRange: number
): boolean
    local ownerLeftCompanion = (playerPosition - companionPosition).Magnitude > disengageRange
    local ownerLeftWild = (playerPosition - record.position).Magnitude > disengageRange
    local wildExceededLeash = (record.position - record.spawnPosition).Magnitude > leashRange
    return ownerLeftCompanion or ownerLeftWild or wildExceededLeash
end

function WildLifecycle.stepToward(
    current: Vector3,
    target: Vector3,
    speed: number,
    deltaTime: number
): Vector3
    local offset = target - current
    local distance = offset.Magnitude
    if distance == 0 then
        return current
    end
    local step = math.min(distance, math.max(0, speed * deltaTime))
    return current + offset.Unit * step
end

return table.freeze(WildLifecycle)
