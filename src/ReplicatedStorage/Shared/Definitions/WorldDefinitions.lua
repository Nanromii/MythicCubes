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
        displayName = "Nang Dấu Đường",
        baseChance = 0.2,
        missingHealthBonus = 0.6,
        maximumChance = 0.8,
        captureRange = 28,
        startingQuantity = 5,
    }),
    table.freeze({
        id = "prism_snare",
        displayName = "Bẫy Lăng Kính",
        baseChance = 0.4,
        missingHealthBonus = 0.55,
        maximumChance = 0.95,
        captureRange = 32,
        startingQuantity = 2,
    }),
}

return table.freeze({
    regions = table.freeze(regions),
    captureDevices = table.freeze(captureDevices),
})
