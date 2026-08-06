--!strict

local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type SpawnPoolEntry = WorldTypes.SpawnPoolEntry

local SpawnPoolSelector = {}

function SpawnPoolSelector.select(pool: { SpawnPoolEntry }, randomUnit: number): string?
    local totalWeight = 0
    for _, entry in pool do
        totalWeight += math.max(0, entry.weight)
    end
    if totalWeight <= 0 then
        return nil
    end
    local threshold = math.clamp(randomUnit, 0, 0.999999) * totalWeight
    local accumulated = 0
    for _, entry in pool do
        accumulated += math.max(0, entry.weight)
        if threshold < accumulated then
            return entry.creatureId
        end
    end
    return pool[#pool].creatureId
end

return table.freeze(SpawnPoolSelector)
