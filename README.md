# VoxelCreatures

> Game Roblox voxel/blocky nguyên bản; không sử dụng nội dung Pokémon hoặc IP bên thứ ba khi chưa có giấy phép.

## Trạng thái

Phase 0–3 được ghi `DONE (historical evidence)`. Phase 4 được tài liệu cũ ghi `IN_PROGRESS`, nhưng
checkout hiện tại chưa có đủ module world/capture/collection để xác minh; trạng thái canonical là
`AWAITING_SOURCE_VERIFICATION`. Xem [baseline](docs/retrospectives/current-project-baseline.md).

## Công nghệ

- Roblox Studio và Luau strict.
- Rojo đồng bộ source và build place.
- Rokit quản lý Rojo, StyLua, Selene và Wally.
- Git quản lý source.

## Cấu trúc

- `src/`: source được Rojo ánh xạ vào Roblox DataModel.
- `tests/`: unit/integration tests và fixtures.
- `assets/`: asset tự tạo hoặc có license rõ ràng.
- `docs/`: authority, workflow, product, phase, story, plan và test.
- `.agents/skills/`: skills Roblox-specific cho Codex.

## Lệnh thường dùng

```powershell
rojo build -o build.rbxlx
rojo serve
stylua --check src tests
selene src
```

`build.rbxlx` là output tạm và đã được ignore. Roblox Studio functional/multiplayer test phải được
chạy riêng và ghi evidence theo story.

## Tài liệu nên đọc

Đọc [AGENTS.md](AGENTS.md), [CODEX.md](CODEX.md), [ARCHITECTURE.md](ARCHITECTURE.md),
[PROJECT_PROCESS.md](PROJECT_PROCESS.md), sau đó [docs/WORKFLOW.md](docs/WORKFLOW.md) và product/story
liên quan. Quy ước Git ở [GIT.md](GIT.md), tool ở [TOOL_SETUP.md](TOOL_SETUP.md).

Design direction tương lai nằm ở `docs/design/`; các phần chưa được chấp nhận/triển khai phải giữ
nhãn `DRAFT`, `TUNABLE` hoặc `TBD`.
