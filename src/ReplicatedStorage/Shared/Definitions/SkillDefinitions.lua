--!strict

local SkillTypes = require(script.Parent.Parent.Types.SkillTypes)

type SkillDefinition = SkillTypes.SkillDefinition

local definitions: { SkillDefinition } = {
    table.freeze({
        id = "briar_guard",
        displayName = "Briar Guard",
        description = "Raises a short-lived barrier of woven growth.",
        elementId = "verdant",
        target = "Self",
        cooldownSeconds = 8,
        basePower = 0,
    }),
    table.freeze({
        id = "cinder_dash",
        displayName = "Cinder Dash",
        description = "Surges forward with a concentrated burst of heat.",
        elementId = "ember",
        target = "Enemy",
        cooldownSeconds = 6,
        basePower = 24,
    }),
    table.freeze({
        id = "sheltering_current",
        displayName = "Sheltering Current",
        description = "Wraps an ally in a steady protective current.",
        elementId = "tide",
        target = "Ally",
        cooldownSeconds = 9,
        basePower = 0,
    }),
    table.freeze({
        id = "crosswind_snare",
        displayName = "Crosswind Snare",
        description = "Pins an opponent in converging currents of air.",
        elementId = "gale",
        target = "Enemy",
        cooldownSeconds = 7,
        basePower = 12,
    }),
}

return table.freeze(definitions)
