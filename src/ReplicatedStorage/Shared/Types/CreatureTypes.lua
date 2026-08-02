--!strict

export type BaseStats = {
    maxHealth: number,
    attack: number,
    defense: number,
    speed: number,
}

export type CreatureDefinition = {
    id: string,
    displayName: string,
    elementId: string,
    roleId: string,
    skillIds: { string },
    baseStats: BaseStats,
    displayColor: Color3,
}

export type OwnedCreature = {
    instanceId: string,
    creatureId: string,
    level: number,
    experience: number,
    equippedSkillIds: { string },
}

return table.freeze({})
