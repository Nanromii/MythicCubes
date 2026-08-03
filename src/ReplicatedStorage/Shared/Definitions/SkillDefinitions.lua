--!strict

local SkillTypes = require(script.Parent.Parent.Types.SkillTypes)

type SkillDefinition = SkillTypes.SkillDefinition

local definitions: { SkillDefinition } = {
    table.freeze({
        id = "briar_guard",
        displayName = "Quét Gai",
        description = "Quét một lớp gai dày vào đối thủ.",
        elementId = "verdant",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 8,
        basePower = 18,
    }),
    table.freeze({
        id = "cinder_dash",
        displayName = "Lao Lửa",
        description = "Lao tới bằng một luồng nhiệt tập trung.",
        elementId = "ember",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 6,
        basePower = 24,
    }),
    table.freeze({
        id = "sheltering_current",
        displayName = "Dòng Nước Xoáy",
        description = "Dồn một dòng nước mạnh vào đối thủ.",
        elementId = "tide",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 9,
        basePower = 17,
    }),
    table.freeze({
        id = "crosswind_snare",
        displayName = "Gió Trói Buộc",
        description = "Khóa đối thủ giữa những luồng gió giao nhau.",
        elementId = "gale",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 7,
        basePower = 12,
    }),
}

return table.freeze(definitions)
