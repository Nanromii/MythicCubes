# Voxel Creatures

> Tên sản phẩm và tên repository hiện là placeholder. Dự án là IP nguyên bản và không sử dụng nội dung thuộc Pokémon hoặc IP bên thứ ba khi chưa có giấy phép.

## Trạng thái

Phase 2 — Creature Data System (`IN_PROGRESS`). Home và single-starter selection đã có; typed creature data, registry và validation suite đã được triển khai, còn chờ test project trong Roblox Studio.

## Mô tả

Game Roblox thu thập sinh vật với phong cách voxel/blocky, khám phá theo vùng, đội hình tối đa ba sinh vật và chiến đấu action RPG bán tự động.

## Công nghệ

- Roblox Studio và Luau strict.
- Rojo để đồng bộ source và build place.
- Git, StyLua, Selene và Luau Language Server cho quy trình phát triển.

## Cấu trúc repository

- `src/`: source được Rojo ánh xạ vào Roblox DataModel.
- `assets/`: asset nguồn do đội ngũ tự tạo hoặc có giấy phép rõ ràng.
- `tests/`: unit test, integration test và fixture trong tương lai.
- `scripts/`: script build và validation trong tương lai.
- `docs/`: quyết định kiến trúc, sơ đồ và hướng dẫn.

## Yêu cầu môi trường

Cài Roblox Studio, Git, Rojo CLI, plugin Rojo, StyLua, Selene, Luau Language Server và editor phù hợp. Xem trạng thái cùng hướng dẫn chi tiết trong `TOOL_SETUP.md`.

## Lệnh thường dùng

```powershell
rojo build -o build.rbxlx
rojo serve
stylua src tests
selene src
```

`build.rbxlx` là output tạm và đã được ignore.

## Kết nối Roblox Studio

1. Mở terminal tại repository và chạy `rojo serve`.
2. Mở một place trong Roblox Studio.
3. Mở plugin Rojo và kết nối tới server local.
4. Xác nhận cây source xuất hiện đúng vị trí.
5. Chạy Play Test và kiểm tra Output cho log bootstrap server/client.

## Tài liệu nên đọc

Đọc `AGENTS.md`, `CODEX.md`, `GAME_DESIGN.md`, `ARCHITECTURE.md`, `CODING_STANDARDS.md` và `PROJECT_PROCESS.md` theo đúng thứ tự.

## Quy tắc branch

Feature và fix thông thường đi từ `master` rồi merge trở lại `master`; `prod` chỉ nhận release hoặc hotfix đã xác nhận. Không commit trực tiếp vào `prod` và không force push branch dùng chung. Xem `GIT_WORKFLOW.md`.
