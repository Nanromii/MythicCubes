--!strict

local SkillTypes = require(script.Parent.Parent.Types.SkillTypes)

type SkillDefinition = SkillTypes.SkillDefinition

local definitions: { SkillDefinition } = {
    table.freeze({
        id = "steady_bump",
        displayName = "Cú Húc Vững",
        description = "Một cú húc trực diện ổn định và dễ kiểm soát.",
        elementId = "normal",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 5,
        basePower = 16,
    }),
    table.freeze({
        id = "briar_guard",
        displayName = "Quét Gai",
        description = "Quét một lớp gai dày vào đối thủ.",
        elementId = "nature",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 8,
        basePower = 18,
    }),
    table.freeze({
        id = "cinder_dash",
        displayName = "Lao Lửa",
        description = "Lao tới bằng một luồng nhiệt tập trung.",
        elementId = "fire",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 6,
        basePower = 24,
    }),
    table.freeze({
        id = "sheltering_current",
        displayName = "Dòng Nước Xoáy",
        description = "Dồn một dòng nước mạnh vào đối thủ.",
        elementId = "water",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 9,
        basePower = 17,
    }),
    table.freeze({
        id = "crosswind_snare",
        displayName = "Gió Trói Buộc",
        description = "Khóa đối thủ giữa những luồng gió giao nhau.",
        elementId = "wind",
        target = "Enemy",
        effect = "Damage",
        cooldownSeconds = 7,
        basePower = 12,
    }),
}

return table.freeze(definitions)
