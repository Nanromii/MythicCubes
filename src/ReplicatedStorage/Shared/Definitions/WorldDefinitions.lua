--!strict

local WorldTypes = require(script.Parent.Parent.Types.WorldTypes)

type CaptureDeviceDefinition = WorldTypes.CaptureDeviceDefinition
type RegionDefinition = WorldTypes.RegionDefinition

local regions: { RegionDefinition } = {
    table.freeze({
        id = "verdant_meadow",
        displayName = "Đồng Cỏ Khởi Nguyên",
        platformCenter = Vector3.new(0, 0, 92),
        platformSize = Vector3.new(100, 1, 104),
        spawnZones = table.freeze({
            table.freeze({
                id = "meadow_single",
                center = Vector3.new(-22, 2, 72),
                size = Vector3.new(24, 0, 24),
                maximumGroups = 1,
                clusterMinimum = 1,
                clusterMaximum = 1,
                respawnSeconds = 8,
                aggroRange = 16,
                engagementRange = 20,
                disengageRange = 28,
                leashRange = 42,
                attackRange = 6,
                moveSpeed = 10,
                returnSpeed = 14,
                attackIntervalSeconds = 2.5,
                spawnPool = table.freeze({
                    table.freeze({ creatureId = "pebblit", weight = 3 }),
                    table.freeze({ creatureId = "bramblet", weight = 1 }),
                }),
            }),
            table.freeze({
                id = "meadow_cluster",
                center = Vector3.new(22, 2, 108),
                size = Vector3.new(28, 0, 24),
                maximumGroups = 1,
                clusterMinimum = 2,
                clusterMaximum = 2,
                respawnSeconds = 10,
                aggroRange = 18,
                engagementRange = 22,
                disengageRange = 30,
                leashRange = 46,
                attackRange = 6,
                moveSpeed = 11,
                returnSpeed = 15,
                attackIntervalSeconds = 2.5,
                spawnPool = table.freeze({
                    table.freeze({ creatureId = "zephlet", weight = 2 }),
                    table.freeze({ creatureId = "tiderook", weight = 1 }),
                }),
            }),
        }),
    }),
}

local captureDevices: { CaptureDeviceDefinition } = {
    table.freeze({
        id = "trail_capsule",
        displayName = "Bóng xanh lá",
        tier = 1,
        isSpecial = false,
        baseChance = 0.2,
        missingHealthBonus = 0.6,
        maximumChance = 0.8,
        captureRange = 28,
        startingQuantity = 5,
    }),
    table.freeze({
        id = "prism_snare",
        displayName = "Bóng xanh dương",
        tier = 2,
        isSpecial = false,
        baseChance = 0.4,
        missingHealthBonus = 0.55,
        maximumChance = 0.95,
        captureRange = 32,
        startingQuantity = 2,
    }),
    table.freeze({
        id = "violet_orb",
        displayName = "Bóng tím",
        tier = 3,
        isSpecial = false,
        baseChance = 0.48,
        missingHealthBonus = 0.5,
        maximumChance = 0.98,
        captureRange = 36,
        startingQuantity = 1,
    }),
    table.freeze({
        id = "crimson_orb",
        displayName = "Bóng đỏ",
        tier = 4,
        isSpecial = true,
        baseChance = 0.9,
        missingHealthBonus = 0.1,
        maximumChance = 0.98,
        captureRange = 40,
        startingQuantity = 1,
    }),
}

return table.freeze({
    regions = table.freeze(regions),
    captureDevices = table.freeze(captureDevices),
})
