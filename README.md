# VoxelCreatures

> Game Roblox voxel/blocky nguyên bản; không sử dụng nội dung Pokémon hoặc IP bên thứ ba khi chưa có giấy phép.

## Trạng thái

Phase 4 — Open-world PvE, Capture and Collection (`IN_PROGRESS`). Source và test project đã được reconcile vào checkout; trạng thái chỉ chuyển `DONE` sau khi người dùng chạy và xác nhận toàn bộ Roblox Studio matrix trong [PHASE_4_STUDIO_TEST.md](docs/guides/PHASE_4_STUDIO_TEST.md).

Phase 0–3 là `DONE`; Phase 5 chưa bắt đầu.

## Mô tả

Game Roblox thu thập sinh vật với phong cách voxel/blocky, khám phá theo vùng, đội hình tối đa ba sinh vật và chiến đấu action RPG bán tự động.

## Công nghệ

- Roblox Studio và Luau strict.
- Rojo đồng bộ source và build place.
- Rokit quản lý Rojo, StyLua, Selene và Wally.
- Git quản lý source.

## Cấu trúc

- `src/`: source được Rojo ánh xạ vào Roblox DataModel.
- `tests/`: unit/integration tests và fixtures.
- `assets/`: asset tự tạo hoặc có license rõ ràng.
- `artifacts/json/`: Rojo project JSON dành riêng cho phase/test.
- `artifacts/rbxlx/`: place build phase/test/validation đã ignore khỏi Git.
- `docs/`: authority, workflow, product, phase, story, plan và test.
- `.agents/skills/`: skills Roblox-specific cho Codex.

## Lệnh thường dùng

```powershell
rojo build default.project.json -o default-current.rbxlx
rojo build artifacts/json/phase3-tests.project.json -o artifacts/rbxlx/phase3-tests.rbxlx
rojo build artifacts/json/phase4-tests.project.json -o artifacts/rbxlx/phase4-tests.rbxlx
rojo serve
stylua --check src tests
selene src
```

`default-current.rbxlx` là default place canonical duy nhất được giữ ở root. Project/output gắn với
phase, test hoặc validation phải nằm dưới `artifacts/`; xem [quy ước artifact](artifacts/README.md).
Mọi `*.rbxlx` đều là output local đã ignore. Roblox Studio functional/multiplayer test phải được chạy
riêng và ghi evidence theo story.

## Tài liệu nên đọc

Đọc [AGENTS.md](AGENTS.md), [CODEX.md](CODEX.md), [ARCHITECTURE.md](ARCHITECTURE.md),
[PROJECT_PROCESS.md](PROJECT_PROCESS.md), sau đó [docs/WORKFLOW.md](docs/WORKFLOW.md) và product/story
liên quan. Quy ước Git ở [GIT.md](GIT.md), tool ở [TOOL_SETUP.md](TOOL_SETUP.md).

Design direction tương lai nằm ở `docs/design/`; các phần chưa được chấp nhận/triển khai phải giữ
nhãn `DRAFT`, `TUNABLE` hoặc `TBD`.
