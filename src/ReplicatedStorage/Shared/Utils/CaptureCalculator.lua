--!strict

local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type CaptureDeviceDefinition = WorldTypes.CaptureDeviceDefinition

local CaptureCalculator = {}

function CaptureCalculator.calculateChance(
    device: CaptureDeviceDefinition,
    currentHealth: number,
    maximumHealth: number
): number
    local safeMaximum = math.max(1, maximumHealth)
    local healthRatio = math.clamp(currentHealth / safeMaximum, 0, 1)
    local missingHealthRatio = 1 - healthRatio
    return math.clamp(
        device.baseChance + missingHealthRatio * device.missingHealthBonus,
        0,
        device.maximumChance
    )
end

function CaptureCalculator.isSuccessful(chance: number, randomRoll: number): boolean
    return math.clamp(randomRoll, 0, 1) < math.clamp(chance, 0, 1)
end

return table.freeze(CaptureCalculator)
