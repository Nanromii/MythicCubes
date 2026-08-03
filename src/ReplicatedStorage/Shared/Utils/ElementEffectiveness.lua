--!strict

local CreatureDataRegistry = require(script.Parent.Parent.Config.CreatureDataRegistry)

local ElementEffectiveness = {}

function ElementEffectiveness.getMultiplier(
    attackingElementId: string,
    defendingElementId: string
): (number?, string?)
    local attackingElement = CreatureDataRegistry.getElement(attackingElementId)

    if attackingElement == nil then
        return nil, `Unknown attacking element: {attackingElementId}`
    end

    if CreatureDataRegistry.getElement(defendingElementId) == nil then
        return nil, `Unknown defending element: {defendingElementId}`
    end

    local multiplier = attackingElement.effectiveness[defendingElementId]

    if multiplier == nil then
        return nil, `Missing effectiveness from {attackingElementId} to {defendingElementId}`
    end

    return multiplier, nil
end

return table.freeze(ElementEffectiveness)
