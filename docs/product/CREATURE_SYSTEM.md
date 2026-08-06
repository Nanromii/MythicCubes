# Creature system

## Current implementation

`CreatureDataRegistry` load và validate definitions data-driven. Mỗi `CreatureDefinition` hiện có
`id`, `displayName`, `elementId`, `roleId`, `skillIds`, `baseStats` và `displayColor`. Source hiện có
bốn creature starter, bốn element, bốn role và một skill damage cho mỗi starter; owned creature theo
type có `instanceId`, `creatureId`, `level`, `experience`, `equippedSkillIds` nhưng persistence chưa có.

Server xác nhận starter và combat state. Client không được tự quyết định ownership, damage hoặc result.

## Target direction

Creature dạng khối, element/type, role, level và skill là product direction. Khắc hệ hiện trong source
dùng bảng effectiveness data-driven; các con số/element thứ năm, rarity, evolution, legendary,
capture difficulty và skill pool mở rộng phải có decision riêng trước implementation.

Starter creature và legendary roster ngoài bốn definition hiện tại là `TBD`. Không hard-code logic
riêng theo tên creature; thêm content qua definition/registry và validator.
