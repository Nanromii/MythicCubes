--!strict

local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)

type CreatureDefinition = CreatureTypes.CreatureDefinition

local definitions: { CreatureDefinition } = {
    table.freeze({
        id = "pebblit",
        displayName = "Pebblit",
        elementId = "normal",
        roleId = "guardian",
        skillIds = table.freeze({ "steady_bump" }),
        baseStats = table.freeze({
            maxHealth = 105,
            attack = 15,
            defense = 16,
            speed = 12,
        }),
        displayColor = Color3.fromRGB(178, 168, 148),
    }),
    table.freeze({
        id = "tumblet",
        displayName = "Tumblet",
        elementId = "normal",
        roleId = "guardian",
        skillIds = table.freeze({ "steady_bump" }),
        baseStats = table.freeze({
            maxHealth = 100,
            attack = 16,
            defense = 14,
            speed = 16,
        }),
        displayColor = Color3.fromRGB(205, 188, 145),
    }),
    table.freeze({
        id = "bramblet",
        displayName = "Bramblet",
        elementId = "nature",
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
        elementId = "fire",
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
        elementId = "water",
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
        elementId = "wind",
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
