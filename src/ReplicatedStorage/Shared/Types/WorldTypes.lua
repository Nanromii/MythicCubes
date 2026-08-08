--!strict

local CreatureTypes = require(script.Parent.CreatureTypes)

export type WildState = "Spawning" | "Idle" | "Engaging" | "Returning" | "Defeated" | "Despawned"

export type SpawnPoolEntry = {
    creatureId: string,
    weight: number,
}

export type SpawnZoneDefinition = {
    id: string,
    center: Vector3,
    size: Vector3,
    maximumGroups: number,
    clusterMinimum: number,
    clusterMaximum: number,
    respawnSeconds: number,
    aggroRange: number,
    engagementRange: number,
    disengageRange: number,
    leashRange: number,
    attackRange: number,
    moveSpeed: number,
    returnSpeed: number,
    attackIntervalSeconds: number,
    spawnPool: { SpawnPoolEntry },
}

export type RegionDefinition = {
    id: string,
    displayName: string,
    platformCenter: Vector3,
    platformSize: Vector3,
    spawnZones: { SpawnZoneDefinition },
}

export type CaptureDeviceDefinition = {
    id: string,
    displayName: string,
    tier: number,
    isSpecial: boolean,
    baseChance: number,
    missingHealthBonus: number,
    maximumChance: number,
    captureRange: number,
    startingQuantity: number,
}

export type WildCreatureRecord = {
    id: string,
    creatureId: string,
    regionId: string,
    zoneId: string,
    spawnGroupId: string,
    spawnPosition: Vector3,
    position: Vector3,
    state: WildState,
    currentHealth: number,
    maximumHealth: number,
    attack: number,
    defense: number,
    encounterId: string?,
    targetUserId: number?,
    targetUserIds: { [number]: boolean }?,
    captureLockUserId: number?,
    captureLockRequestId: string?,
}

export type EncounterWildSnapshot = {
    wildId: string,
    creatureId: string,
    health: number,
    maximumHealth: number,
    state: string,
    isCaptureLocked: boolean,
}

export type EncounterSnapshot = {
    encounterId: string?,
    state: string,
    wildId: string?,
    wildCreatureId: string?,
    wildHealth: number?,
    wildMaximumHealth: number?,
    wilds: { EncounterWildSnapshot },
    captureEligibleWildIds: { string },
    companionCreatureId: string?,
    companionHealth: number?,
    companionMaximumHealth: number?,
}

export type CollectionSnapshot = {
    ownedCreatures: { CreatureTypes.OwnedCreature },
    activeTeamInstanceIds: { string },
    captureInventory: { [string]: number },
}

export type CaptureIntent = {
    requestId: string,
    encounterId: string,
    wildId: string,
    deviceId: string,
}

export type CaptureResponse = {
    ok: boolean,
    code: string,
    message: string,
    captured: boolean,
    chance: number?,
    world: EncounterSnapshot?,
    collection: CollectionSnapshot?,
}

return table.freeze({})
