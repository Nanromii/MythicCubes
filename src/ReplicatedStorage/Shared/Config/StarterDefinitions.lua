--!strict

local StarterTypes = require(script.Parent.Parent.Types.StarterTypes)

type StarterDefinition = StarterTypes.StarterDefinition

local definitions: { StarterDefinition } = {
    table.freeze({
        id = "bramblet",
        displayName = "Bramblet",
        color = Color3.fromRGB(91, 154, 76),
    }),
    table.freeze({
        id = "pyrel",
        displayName = "Pyrel",
        color = Color3.fromRGB(224, 103, 67),
    }),
    table.freeze({
        id = "tiderook",
        displayName = "Tiderook",
        color = Color3.fromRGB(62, 137, 201),
    }),
    table.freeze({
        id = "zephlet",
        displayName = "Zephlet",
        color = Color3.fromRGB(190, 163, 219),
    }),
}

local definitionsById: { [string]: StarterDefinition } = {}

for _, definition in definitions do
    assert(definitionsById[definition.id] == nil, `Duplicate starter id: {definition.id}`)
    definitionsById[definition.id] = definition
end

local StarterDefinitions = {}

StarterDefinitions.list = table.freeze(definitions)

function StarterDefinitions.getById(starterId: string): StarterDefinition?
    return definitionsById[starterId]
end

return table.freeze(StarterDefinitions)
