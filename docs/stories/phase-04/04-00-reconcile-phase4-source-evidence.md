# Story 04-00: Reconcile Phase 4 source và evidence

## Status

`Done`

## Outcome

Xác định chính xác Phase 4 đang ở branch/commit nào, phần nào thật sự có trong checkout và phase status
nào có thể giữ; không triển khai gameplay.

## Authority

`PROJECT_PROCESS.md`, `ARCHITECTURE.md`, `docs/design/OPEN_WORLD_COMBAT.md`, `docs/guides/` liên quan,
Git history/branch hiện tại và source tree hiện tại.

## Context

Branch `feature/open-world-capture` chứa source Phase 4 và đã được reconcile vào `master`. Discrepancy
giữa docs cũ và source đã được giải quyết; phần còn chờ là Roblox Studio acceptance.

## In scope

- Đối chiếu branch, commit, `git log`, tree source, Rojo mapping và test projects.
- Ghi evidence từng module/acceptance được tìm thấy hoặc không tìm thấy.
- Cập nhật phase status và tạo validation matrix/decision nếu cần.

## Out of scope

Viết mới gameplay, DataStore, UI gameplay hoặc mở rộng Phase 4; source hiện có chỉ được đối chiếu và
merge, không được coi là đã qua Studio acceptance.

## Gameplay decisions

Không có; story này chỉ làm rõ trạng thái repository.

## Open questions

- Phase 4 source hiện nằm ở `master` sau merge từ `feature/open-world-capture`.
- Acceptance canonical tiếp theo là `docs/guides/PHASE_4_STUDIO_TEST.md` với một và hai client.

## Acceptance criteria

- [x] Có bảng commit/branch/source evidence cho Phase 4.
- [x] Không đánh dấu module không tồn tại là implemented.
- [x] `PROJECT_PROCESS.md`, `ARCHITECTURE.md` và phase catalog không mâu thuẫn.
- [x] Có bước kế tiếp là Studio acceptance, không có source gameplay change mới trong task reconcile.

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

| Claim | Command/check | Kết quả |
| --- | --- | --- |
| Merge không còn conflict | `git ls-files -u` và conflict-marker scan | Pass; không còn unmerged path/marker |
| Tài liệu không có whitespace error | `git diff --cached --check` | Pass |
| Phase 4 source tồn tại | `git status`, `git log`, CodeGraph/source inspection | Pass; world/capture services, test project và guide có trong checkout |
| Studio acceptance | Play Solo, Server & Clients, raw Output | Chưa chạy |
