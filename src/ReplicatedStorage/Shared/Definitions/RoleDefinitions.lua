--!strict

local RoleTypes = require(script.Parent.Parent.Types.RoleTypes)

type RoleDefinition = RoleTypes.RoleDefinition

local definitions: { RoleDefinition } = {
    table.freeze({
        id = "guardian",
        displayName = "Hộ vệ",
        description = "Chống chịu áp lực và bảo vệ đội hình.",
    }),
    table.freeze({
        id = "striker",
        displayName = "Công kích",
        description = "Gây sát thương trực tiếp bằng những đòn đánh quyết đoán.",
    }),
    table.freeze({
        id = "support",
        displayName = "Hỗ trợ",
        description = "Giúp đồng đội ổn định bằng các hiệu ứng phòng thủ.",
    }),
    table.freeze({
        id = "controller",
        displayName = "Khống chế",
        description = "Kiểm soát nhịp chiến đấu bằng cách hạn chế đối thủ.",
    }),
}

return table.freeze(definitions)
