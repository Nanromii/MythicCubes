# Voxel Creatures

> Tên sản phẩm và tên repository hiện là placeholder. Dự án là IP nguyên bản và không sử dụng nội dung thuộc Pokémon hoặc IP bên thứ ba khi chưa có giấy phép.

## Trạng thái

Phase 3 — Combat Vertical Slice (`IN_PROGRESS`). Implementation, test project và terminal format/lint/build đã đạt; Phase 3 chưa thể chuyển `DONE` trước khi suite/runtime matrix được chạy và xác nhận thực tế trong Roblox Studio.

Phase 0, Phase 1 và Phase 2 là `DONE`. Phase 1 được đóng theo xác nhận rõ ràng của người dùng; repository không ghi thêm Studio version hoặc log chi tiết chưa được cung cấp.

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
- `docs/project/`: quy tắc agent, kiến trúc, quy trình, changelog và tài liệu vận hành dự án.
- `docs/design/`: quyết định thiết kế chuyên biệt.
- `docs/guides/`: hướng dẫn test và vận hành theo phase.

## Yêu cầu môi trường

Cài Roblox Studio, Git, Rojo CLI, plugin Rojo, StyLua, Selene, Luau Language Server và editor phù hợp. Xem trạng thái cùng hướng dẫn chi tiết trong [TOOL_SETUP.md](docs/project/TOOL_SETUP.md).

## Lệnh thường dùng

```powershell
rojo build -o build.rbxlx
rojo build phase3-tests.project.json -o phase3-tests.rbxlx
rojo serve
stylua src tests
selene src tests
```

`build.rbxlx` là output tạm và đã được ignore.

## Kết nối Roblox Studio

1. Mở terminal tại repository và chạy `rojo serve`.
2. Mở một place trong Roblox Studio.
3. Mở plugin Rojo và kết nối tới server local.
4. Xác nhận cây source xuất hiện đúng vị trí.
5. Chạy Play Test và kiểm tra Output cho log bootstrap server/client.

## Tài liệu nên đọc

Đọc [AGENTS.md](docs/project/AGENTS.md), [CODEX.md](docs/project/CODEX.md), [GAME_DESIGN.md](docs/project/GAME_DESIGN.md), [ARCHITECTURE.md](docs/project/ARCHITECTURE.md), [CODING_STANDARDS.md](docs/project/CODING_STANDARDS.md) và [PROJECT_PROCESS.md](docs/project/PROJECT_PROCESS.md) theo đúng thứ tự.

Thiết kế đích cho năm hệ, skill theo bậc, level/tiến hóa, roll skill, art direction và khoảng cách so với implementation hiện tại được tập trung tại [Hệ thống sinh vật, nguyên tố và kỹ năng](docs/design/CREATURE_ELEMENT_SKILL_SYSTEM.md).

## Quy tắc branch

Feature và fix thông thường đi từ `master` rồi merge trở lại `master`; `prod` chỉ nhận release hoặc hotfix đã xác nhận. Không commit trực tiếp vào `prod` và không force push branch dùng chung. Xem [GIT_WORKFLOW.md](docs/project/GIT_WORKFLOW.md).
