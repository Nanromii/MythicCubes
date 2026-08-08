--!strict

local CreatureDataRegistry = require(script.Parent.CreatureDataRegistry)
local CreatureTypes = require(script.Parent.Parent.Types.CreatureTypes)

type CreatureDefinition = CreatureTypes.CreatureDefinition

local starterIds = table.freeze({
    "bramblet",
    "pyrel",
    "tiderook",
    "zephlet",
    "pebblit",
})

local definitions: { CreatureDefinition } = {}
local definitionsById: { [string]: CreatureDefinition } = {}
local elementIds: { [string]: boolean } = {}
local elementCount = 0

for _, starterId in starterIds do
    local definition = CreatureDataRegistry.getCreature(starterId)
    assert(definition ~= nil, `Unknown starter creature id: {starterId}`)
    assert(definitionsById[starterId] == nil, `Duplicate starter creature id: {starterId}`)
    assert(
        not elementIds[definition.elementId],
        `Starter choices must use distinct elements: {definition.elementId}`
    )
    table.insert(definitions, definition)
    definitionsById[starterId] = definition
    elementIds[definition.elementId] = true
    elementCount += 1
end

assert(elementCount == 5, "Phase 4 requires exactly five starter creatures")

local StarterDefinitions = {
    list = table.freeze(definitions),
}

function StarterDefinitions.getById(starterId: string): CreatureDefinition?
    return definitionsById[starterId]
end

return table.freeze(StarterDefinitions)
