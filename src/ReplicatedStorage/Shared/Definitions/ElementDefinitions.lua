--!strict

local ElementTypes = require(script.Parent.Parent.Types.ElementTypes)

type ElementDefinition = ElementTypes.ElementDefinition

local definitions: { ElementDefinition } = {
    table.freeze({
        id = "verdant",
        displayName = "Verdant",
        color = Color3.fromRGB(91, 154, 76),
        effectiveness = table.freeze({
            verdant = 1,
            ember = 1,
            tide = 1.5,
            gale = 0.75,
        }),
    }),
    table.freeze({
        id = "ember",
        displayName = "Ember",
        color = Color3.fromRGB(224, 103, 67),
        effectiveness = table.freeze({
            verdant = 1,
            ember = 1,
            tide = 0.75,
            gale = 1.5,
        }),
    }),
    table.freeze({
        id = "tide",
        displayName = "Tide",
        color = Color3.fromRGB(62, 137, 201),
        effectiveness = table.freeze({
            verdant = 0.75,
            ember = 1.5,
            tide = 1,
            gale = 1,
        }),
    }),
    table.freeze({
        id = "gale",
        displayName = "Gale",
        color = Color3.fromRGB(190, 163, 219),
        effectiveness = table.freeze({
            verdant = 1.5,
            ember = 0.75,
            tide = 1,
            gale = 1,
        }),
    }),
}

return table.freeze(definitions)
