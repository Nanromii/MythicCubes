--!strict

local OnboardingTypes = require(script.Parent.Parent.Types.OnboardingTypes)

type WorldDefinition = OnboardingTypes.WorldDefinition

local worlds: { WorldDefinition } = {
    table.freeze({
        id = "origin_plains",
        displayName = "Bình Nguyên Khởi Sinh",
        elementId = "normal",
        displayColor = Color3.fromRGB(178, 168, 148),
    }),
    table.freeze({
        id = "ember_archipelago",
        displayName = "Quần Đảo Hỏa Mạch",
        elementId = "fire",
        displayColor = Color3.fromRGB(224, 103, 67),
    }),
    table.freeze({
        id = "azure_tide",
        displayName = "Hải Vực Lam Triều",
        elementId = "water",
        displayColor = Color3.fromRGB(62, 137, 201),
    }),
    table.freeze({
        id = "verdant_wilds",
        displayName = "Đại Lâm Mầm Sống",
        elementId = "nature",
        displayColor = Color3.fromRGB(91, 154, 76),
    }),
    table.freeze({
        id = "gale_skyway",
        displayName = "Thiên Lộ Phong Vân",
        elementId = "wind",
        displayColor = Color3.fromRGB(190, 163, 219),
    }),
}

local worldsById: { [string]: WorldDefinition } = {}
local elementalWorlds: { WorldDefinition } = {}

for index, definition in worlds do
    worldsById[definition.id] = definition
    if index > 1 then
        table.insert(elementalWorlds, definition)
    end
end

local OnboardingDefinitions = {
    worlds = table.freeze(worlds),
    normalWorld = worlds[1],
    elementalWorlds = table.freeze(elementalWorlds),
}

function OnboardingDefinitions.getWorld(worldId: string): WorldDefinition?
    return worldsById[worldId]
end

function OnboardingDefinitions.isElementalWorld(worldId: string): boolean
    local definition = worldsById[worldId]
    return definition ~= nil and definition.elementId ~= "normal"
end

return table.freeze(OnboardingDefinitions)
