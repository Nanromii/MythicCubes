--!strict

local ElementTypes = require(script.Parent.Parent.Types.ElementTypes)

type ElementDefinition = ElementTypes.ElementDefinition

local definitions: { ElementDefinition } = {
    table.freeze({
        id = "verdant",
        displayName = "Verdant",
        color = Color3.fromRGB(91, 154, 76),
    }),
    table.freeze({
        id = "ember",
        displayName = "Ember",
        color = Color3.fromRGB(224, 103, 67),
    }),
    table.freeze({
        id = "tide",
        displayName = "Tide",
        color = Color3.fromRGB(62, 137, 201),
    }),
    table.freeze({
        id = "gale",
        displayName = "Gale",
        color = Color3.fromRGB(190, 163, 219),
    }),
}

return table.freeze(definitions)
