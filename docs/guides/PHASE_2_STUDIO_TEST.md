# Kiểm tra thủ công Phase 2 trong Roblox Studio

## Chuẩn bị test project

1. Tại project root, chạy `rojo build phase2-tests.project.json -o phase2-tests.rbxlx`.
2. Mở một place test riêng hoặc chạy `rojo serve phase2-tests.project.json --port 34874` rồi kết nối Rojo plugin tới port 34874.
3. Không publish test place và không thay thế place production bằng test project.

## Chạy validation suite

1. Bắt đầu Play Test với một server.
2. Xác nhận Output có dòng `[Phase2DataValidationTests] 11 tests passed`.
3. Xác nhận không có assertion, parse error hoặc warning từ `CreatureDataRegistry`.

Suite kiểm tra catalog hợp lệ, element hợp lệ/sai ID, skill target sai, skill ID trùng, `OwnedCreature` hợp lệ/sai level, catalog trùng ID, cross-reference role sai và lookup tồn tại/không tồn tại.

## Smoke test default project

1. Kết nối lại `default.project.json` và bắt đầu Play Test bình thường.
2. Xác nhận Home cùng UI chọn một starter vẫn hoạt động.
3. Xác nhận bốn starter giữ đúng tên/màu và chỉ một placeholder xuất hiện sau xác nhận.
4. Từ Server Command Bar, chạy:

```lua
local registry = require(game.ReplicatedStorage.Shared.Config.CreatureDataRegistry)
print(#registry.elements, #registry.roles, #registry.skills, #registry.creatures)
```

Kết quả mong đợi là `4 4 4 4`. Lookup ID không tồn tại phải trả `nil`; registry không chứa mutable player state.

## Ghi kết quả

Ghi ngày, phiên bản Studio, kết quả suite và Output thực tế vào `PROJECT_PROCESS.md`. Chỉ chuyển Phase 2 sang `DONE` khi test project và default-project smoke test đều đạt.

## Kết quả thực tế — 2026-08-02

- Server bootstrap: `[VoxelCreatures] Phase 1 server started`.
- Validation suite: `[Phase2DataValidationTests] 11 tests passed`.
- Client bootstrap: `[VoxelCreatures] Phase 1 client started`.
- Registry count: `4 4 4 4`.
- Kết luận: đạt acceptance criteria Phase 2; không có lỗi startup hoặc validation trong log được cung cấp.
