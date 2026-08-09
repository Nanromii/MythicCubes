# Creature system

## Current implementation

`CreatureDataRegistry` load và validate definitions data-driven. Mỗi `CreatureDefinition` hiện có
`id`, `displayName`, `elementId`, `roleId`, `skillIds`, `baseStats` và `displayColor`. Source hiện có
 năm creature starter cùng Tumblet non-starter, năm element, bốn role và skill damage data-driven; owned creature theo
type có `instanceId`, `creatureId`, `level`, `experience`, `equippedSkillIds` nhưng persistence chưa có.

Server xác nhận starter và combat state. Client không được tự quyết định ownership, damage hoặc result.

## Target direction

Creature dạng khối, element/type, role, level và skill là product direction. Khắc hệ hiện trong source
dùng bảng effectiveness data-driven; các con số/element thứ năm, rarity, evolution, legendary,
capture difficulty và skill pool mở rộng phải có decision riêng trước implementation.

Starter roster hiện có đúng năm definition đại diện cho năm element; legendary roster vẫn là `TBD`.
Không hard-code logic riêng theo tên creature; thêm content qua definition/registry và validator.

## Quyết định onboarding Phase 5

Người dùng chấp nhận ngày 2026-08-09 rằng starter vẫn là lựa chọn một trong năm creature canonical.
Tutorial tại Bình Nguyên Khởi Sinh guaranteed-capture một creature thứ hai cố định tên **Tumblet**:

- `id`: `tumblet`;
- hệ Thường, stat profile cân bằng và dùng `guardian` hiện có làm `roleId` trong Phase 5;
- không thuộc `StarterDefinitions`;
- dùng skill Thường hiện có nếu schema tương thích;
- dùng blockout nguyên bản và definition data-driven, không có service logic riêng theo tên;
- capture chỉ được bảo đảm khi server xác nhận đúng tutorial encounter và onboarding state.

Tumblet là accepted product rule cho onboarding nhưng chưa phải current implementation cho tới khi có
source và evidence Phase 5. Không thêm XP, tiền hoặc item reward riêng cho tutorial.
