--!strict

export type SkillTarget = "Enemy" | "Self" | "Ally"
export type SkillEffect = "Damage"

export type SkillDefinition = {
    id: string,
    displayName: string,
    description: string,
    elementId: string,
    target: SkillTarget,
    effect: SkillEffect,
    cooldownSeconds: number,
    basePower: number,
}

return table.freeze({})
