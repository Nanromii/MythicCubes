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
    return true, nil
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
    if record.encounterId ~= encounterId or record.targetUserId ~= targetUserId then
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
