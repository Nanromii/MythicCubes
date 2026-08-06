--!strict

local ElementTypes = require(script.Parent.Parent.Types.ElementTypes)

type ElementDefinition = ElementTypes.ElementDefinition

local definitions: { ElementDefinition } = {
    table.freeze({
        id = "normal",
        displayName = "Thường",
        color = Color3.fromRGB(178, 168, 148),
        effectiveness = table.freeze({
            normal = 1,
            fire = 1,
            water = 1,
            nature = 1,
            wind = 1,
        }),
    }),
    table.freeze({
        id = "nature",
        displayName = "Tự nhiên",
        color = Color3.fromRGB(91, 154, 76),
        effectiveness = table.freeze({
            normal = 1,
            nature = 1,
            fire = 1,
            water = 1.5,
            wind = 0.75,
        }),
    }),
    table.freeze({
        id = "fire",
        displayName = "Lửa",
        color = Color3.fromRGB(224, 103, 67),
        effectiveness = table.freeze({
            normal = 1,
            nature = 1,
            fire = 1,
            water = 0.75,
            wind = 1.5,
        }),
    }),
    table.freeze({
        id = "water",
        displayName = "Nước",
        color = Color3.fromRGB(62, 137, 201),
        effectiveness = table.freeze({
            normal = 1,
            nature = 0.75,
            fire = 1.5,
            water = 1,
            wind = 1,
        }),
    }),
    table.freeze({
        id = "wind",
        displayName = "Gió",
        color = Color3.fromRGB(190, 163, 219),
        effectiveness = table.freeze({
            normal = 1,
            nature = 1.5,
            fire = 0.75,
            water = 1,
            wind = 1,
        }),
    }),
}

return table.freeze(definitions)
