--!strict

local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)

type CreatureDefinition = CreatureTypes.CreatureDefinition

local definitions: { CreatureDefinition } = {
    table.freeze({
        id = "bramblet",
        displayName = "Bramblet",
        elementId = "verdant",
        roleId = "guardian",
        skillIds = table.freeze({ "briar_guard" }),
        baseStats = table.freeze({
            maxHealth = 125,
            attack = 14,
            defense = 20,
            speed = 10,
        }),
        displayColor = Color3.fromRGB(91, 154, 76),
    }),
    table.freeze({
        id = "pyrel",
        displayName = "Pyrel",
        elementId = "ember",
        roleId = "striker",
        skillIds = table.freeze({ "cinder_dash" }),
        baseStats = table.freeze({
            maxHealth = 95,
            attack = 22,
            defense = 12,
            speed = 18,
        }),
        displayColor = Color3.fromRGB(224, 103, 67),
    }),
    table.freeze({
        id = "tiderook",
        displayName = "Tiderook",
        elementId = "tide",
        roleId = "support",
        skillIds = table.freeze({ "sheltering_current" }),
        baseStats = table.freeze({
            maxHealth = 110,
            attack = 13,
            defense = 17,
            speed = 13,
        }),
        displayColor = Color3.fromRGB(62, 137, 201),
    }),
    table.freeze({
        id = "zephlet",
        displayName = "Zephlet",
        elementId = "gale",
        roleId = "controller",
        skillIds = table.freeze({ "crosswind_snare" }),
        baseStats = table.freeze({
            maxHealth = 100,
            attack = 16,
            defense = 13,
            speed = 21,
        }),
        displayColor = Color3.fromRGB(190, 163, 219),
    }),
}

return table.freeze(definitions)
