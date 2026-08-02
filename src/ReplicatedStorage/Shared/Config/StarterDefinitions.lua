--!strict

local CreatureDataRegistry = require(script.Parent.CreatureDataRegistry)
local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)

type CreatureDefinition = CreatureTypes.CreatureDefinition

local starterIds = table.freeze({
    "bramblet",
    "pyrel",
    "tiderook",
    "zephlet",
})

local definitions: { CreatureDefinition } = {}
local definitionsById: { [string]: CreatureDefinition } = {}

for _, starterId in starterIds do
    local definition = CreatureDataRegistry.getCreature(starterId)
    assert(definition ~= nil, `Unknown starter creature id: {starterId}`)
    table.insert(definitions, definition)
    definitionsById[starterId] = definition
end

local StarterDefinitions = {
    list = table.freeze(definitions),
}

function StarterDefinitions.getById(starterId: string): CreatureDefinition?
    return definitionsById[starterId]
end

return table.freeze(StarterDefinitions)
