# Current project baseline

## Ngày và phạm vi

Baseline được lập ngày 2026-08-06 từ checkout hiện tại, `default.project.json`, source/tests/docs và
`D:\VNPT\test.zip`. Đây là baseline tài liệu, không phải Studio acceptance mới.

## Cấu trúc hiện tại

- Root có `src/`, `tests/`, `assets/`, Rojo/Rokit config và docs README.
- Governance hiện được đưa về root; `docs/project` chỉ còn tài liệu historical.
- Design detail đang ở `docs/design`; test guides lịch sử ở `docs/guides`.
- `.codegraph/` tồn tại và đã được dùng để định vị call paths; không commit database orchestration từ ZIP.

## Source/runtime đang quan sát

`default.project.json` map project `VoxelCreatures`. Server bootstrap gọi Home, starter selection và
combat services. Shared registry hiện validate bốn creature (`bramblet`, `pyrel`, `tiderook`, `zephlet`),
bốn element (`verdant`, `ember`, `tide`, `gale`), role/skill definitions. Client bootstrap có starter
selection và combat controller. Tests unit/test projects cho Phase 2/3 có trong tree.

Không tìm thấy trong checkout hiện tại các module world/capture/collection/encounter được một số docs
cũ mô tả. Đây là documentation/source discrepancy cần xử lý ở story đầu tiên; không tự sửa code trong
baseline task.

## Phase

Phase 0–3 được ghi `DONE` bằng historical evidence trong docs. Phase 4 được docs ghi `IN_PROGRESS`,
nhưng source hiện tại chưa chứng minh vertical slice Phase 4; baseline đặt `AWAITING_SOURCE_VERIFICATION`.
Phase 5+ là `NOT_STARTED`.

## Tool và test đã biết

`rokit.toml` pin Rojo 7.7.0, StyLua 2.5.2, Selene 0.31.0, Wally 0.3.2. Studio guides có evidence
lịch sử nhưng không có Studio version/raw Output log đầy đủ trong checkout. Task này không chạy Roblox
Studio và không được tuyên bố gameplay đã retest.

## Technical debt và gaps

- Phase 4 docs/source/branch provenance chưa khớp.
- Legacy docs có nhiều roadmap/design detail; cần giữ ranh giới accepted vs DRAFT/TBD.
- Chưa có local story catalog/baseline completion report theo workflow mới.
- Chưa có automated Markdown link checker hoặc test runner riêng cho pure Luau; chỉ đề xuất khi cần.
- Không có authority decision log đáng kể ngoài `docs/decisions/.gitkeep`.

## ZIP comparison

| Từ `test.zip` | Áp dụng | Điều chỉnh cho Roblox | Loại bỏ |
| --- | --- | --- | --- |
| Work router và completion evidence | Có | Chuyển sang phase/story/Studio workflow, không Harness CLI | Không dùng database state |
| Bug diagnosis, TDD, review, walkthrough, grill | Có | Dùng cho Luau/server authority/Roblox Studio | Không copy wording phụ thuộc repo mẫu |
| Story/plan/decision/validation templates | Có | Thêm gameplay authority, exploit, multiplayer và Studio fields | Không dùng schema orchestration |
| `docs/WORKFLOW.md`, product/docs indexes | Có | Việt hóa và rút gọn cho cá nhân | Không tạo enterprise audit/maturity |
| `.git`, `__MACOSX`, `.DS_Store`, harness, SQLite, SQL schema, lock, binary | Không | Không áp dụng | Loại bỏ vì không thuộc project Roblox |

## Next recommended story

`Story 04-00: Reconcile Phase 4 source and evidence` — chỉ đọc branch/log/source/docs, xác định Phase 4
đang ở commit/branch nào, cập nhật authority/status và tạo validation matrix; không triển khai feature.
