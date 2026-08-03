--!strict

export type CombatStatus = "Preparing" | "Active" | "Finished"
export type CombatSide = "Player" | "Enemy"

export type CombatantState = {
    id: string,
    side: CombatSide,
    controllerUserId: number?,
    creatureId: string,
    elementId: string,
    currentHealth: number,
    maximumHealth: number,
    attack: number,
    defense: number,
    equippedSkillIds: { string },
    cooldownEndsAtBySkillId: { [string]: number },
    nextBasicAttackAt: number,
    alive: boolean,
}

export type CombatState = {
    id: string,
    ownerUserId: number,
    status: CombatStatus,
    combatants: { [string]: CombatantState },
    combatantOrder: { string },
    winnerSide: CombatSide?,
}

export type SkillIntent = {
    combatId: string,
    requestId: string,
    combatantId: string,
    skillId: string,
    targetId: string,
}

export type SkillCooldownSnapshot = {
    skillId: string,
    remainingSeconds: number,
}

export type CombatantSnapshot = {
    id: string,
    side: CombatSide,
    creatureId: string,
    currentHealth: number,
    maximumHealth: number,
    alive: boolean,
    equippedSkillIds: { string },
    skillCooldowns: { SkillCooldownSnapshot },
}

export type CombatSnapshot = {
    id: string,
    status: CombatStatus,
    winnerSide: CombatSide?,
    combatants: { CombatantSnapshot },
}

export type CombatActionResult = {
    ok: boolean,
    code: string,
    message: string,
    damage: number?,
    elementMultiplier: number?,
    finishedNow: boolean,
}

export type CombatResponse = {
    ok: boolean,
    code: string,
    message: string,
    snapshot: CombatSnapshot?,
}

return table.freeze({})
