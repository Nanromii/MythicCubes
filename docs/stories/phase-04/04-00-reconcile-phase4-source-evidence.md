# Story 04-00: Reconcile Phase 4 source và evidence

## Status

`Ready`

## Outcome

Xác định chính xác Phase 4 đang ở branch/commit nào, phần nào thật sự có trong checkout và phase status
nào có thể giữ; không triển khai gameplay.

## Authority

`PROJECT_PROCESS.md`, `ARCHITECTURE.md`, `docs/design/OPEN_WORLD_COMBAT.md`, `docs/guides/` liên quan,
Git history/branch hiện tại và source tree hiện tại.

## Context

Một số docs cũ mô tả Phase 4 world/capture/collection nhưng source checkout hiện tại chỉ thấy module
Home/starter/combat harness. Cần giải quyết discrepancy trước story implementation tiếp theo.

## In scope

- Đối chiếu branch, commit, `git log`, tree source, Rojo mapping và test projects.
- Ghi evidence từng module/acceptance được tìm thấy hoặc không tìm thấy.
- Cập nhật phase status và tạo validation matrix/decision nếu cần.

## Out of scope

Combat, capture, region, creature/skill mới, DataStore, UI gameplay, source migration hoặc đổi branch.

## Gameplay decisions

Không có; story này chỉ làm rõ trạng thái repository.

## Open questions

- Phase 4 implementation có nằm ở branch/commit khác không?
- Nếu không, Phase 4 cần được mở lại từ story nào và acceptance nào là canonical?

## Acceptance criteria

- [ ] Có bảng commit/branch/source evidence cho Phase 4.
- [ ] Không đánh dấu module không tồn tại là implemented.
- [ ] `PROJECT_PROCESS.md`, `ARCHITECTURE.md` và baseline không mâu thuẫn.
- [ ] Có đề xuất story kế tiếp, không có source gameplay change.

## Technical notes

Dùng CodeGraph nếu index còn current; xác nhận mọi kết quả bằng file hiện tại. Rojo mapping là
`default.project.json`.

## Security and exploit considerations

Không có runtime change; không có remote/security surface mới.

## Validation plan

- Static: Markdown link/reference audit, `git diff --check`.
- Build: tùy chọn chạy `rojo build -o build.rbxlx` để chứng minh docs không sửa mapping.
- Studio: không cần cho story docs-only; ghi rõ `Not applicable`.

## Completion evidence

Điền command, timestamp, exit code và phần source/Studio chưa kiểm tra trước khi đổi thành `Done`.
