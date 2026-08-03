--!strict

local CombatRequestRateLimiter = {}

function CombatRequestRateLimiter.isAllowed(
    lastRequestTime: number?,
    currentTime: number,
    minimumInterval: number
): boolean
    if lastRequestTime == nil then
        return true
    end

    return currentTime - lastRequestTime >= minimumInterval
end

return table.freeze(CombatRequestRateLimiter)
