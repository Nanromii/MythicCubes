--!strict

export type SkillTarget = "Enemy" | "Self" | "Ally"

export type SkillDefinition = {
    id: string,
    displayName: string,
    description: string,
    elementId: string,
    target: SkillTarget,
    cooldownSeconds: number,
    basePower: number,
}

return table.freeze({})
