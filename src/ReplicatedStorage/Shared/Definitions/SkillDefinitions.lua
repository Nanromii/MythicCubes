--!strict

local SkillTypes = require(script.Parent.Parent.Types.SkillTypes)

type SkillDefinition = SkillTypes.SkillDefinition

local definitions: { SkillDefinition } = {
    table.freeze({
        id = "briar_guard",
        displayName = "Briar Guard",
        description = "Strikes an opponent with a dense sweep of woven growth.",
        elementId = "verdant",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 8,
        basePower = 18,
    }),
    table.freeze({
        id = "cinder_dash",
        displayName = "Cinder Dash",
        description = "Surges forward with a concentrated burst of heat.",
        elementId = "ember",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 6,
        basePower = 24,
    }),
    table.freeze({
        id = "sheltering_current",
        displayName = "Sheltering Current",
        description = "Drives a concentrated current into an opponent.",
        elementId = "tide",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 9,
        basePower = 17,
    }),
    table.freeze({
        id = "crosswind_snare",
        displayName = "Crosswind Snare",
        description = "Pins an opponent in converging currents of air.",
        elementId = "gale",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 7,
        basePower = 12,
    }),
}

return table.freeze(definitions)
