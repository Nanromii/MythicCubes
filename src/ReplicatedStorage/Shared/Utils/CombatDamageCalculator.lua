--!strict

export type DamageInput = {
    attack: number,
    defense: number,
    basePower: number,
    elementMultiplier: number,
}

local MINIMUM_DAMAGE = 1
local MAXIMUM_DAMAGE = 1_000_000
local MAXIMUM_STAT = 100_000
local MINIMUM_MULTIPLIER = 0.25
local MAXIMUM_MULTIPLIER = 4
local DEFENSE_WEIGHT = 0.5

local CombatDamageCalculator = {}

local function finiteOrZero(value: number): number
    if value ~= value or math.abs(value) == math.huge then
        return 0
    end

    return value
end

function CombatDamageCalculator.calculateDamage(input: DamageInput): number
    local attack = math.clamp(finiteOrZero(input.attack), 0, MAXIMUM_STAT)
    local defense = math.clamp(finiteOrZero(input.defense), 0, MAXIMUM_STAT)
    local basePower = math.clamp(finiteOrZero(input.basePower), 0, MAXIMUM_STAT)
    local multiplier =
        math.clamp(finiteOrZero(input.elementMultiplier), MINIMUM_MULTIPLIER, MAXIMUM_MULTIPLIER)
    local rawDamage = math.max(attack + basePower - defense * DEFENSE_WEIGHT, MINIMUM_DAMAGE)
    local scaledDamage = math.floor(rawDamage * multiplier)

    return math.clamp(scaledDamage, MINIMUM_DAMAGE, MAXIMUM_DAMAGE)
end

return table.freeze(CombatDamageCalculator)
