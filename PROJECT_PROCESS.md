# Quy trình và tiến độ dự án

## Tổng quan

| Phase | Tên                                | Trạng thái    | Mục tiêu                                                         |
| ----- | ----------------------------------- | --------------- | ------------------------------------------------------------------ |
| 0     | Project Foundation                  | `DONE`        | Repository, Rojo, Git, tài liệu và toolchain tối thiểu        |
| 1     | Home and Starter Selection          | `IN_PROGRESS` | Home và lựa chọn một trong bốn starter có server xác nhận |
| 2     | Creature Data System                | `DONE`        | Mô hình dữ liệu sinh vật, hệ, vai trò và kỹ năng         |
| 3     | Combat Vertical Slice               | `IN_PROGRESS` | Một vòng chiến đấu bán tự động hoàn chỉnh               |
| 4     | Capture and Collection              | `NOT_STARTED` | Bắt sinh vật, collection và quản lý đội hình               |
| 5     | Progression, Boss and Region Unlock | `NOT_STARTED` | Cấp độ, boss, phần thưởng và mở vùng                      |
| 6     | Persistent Data                     | `NOT_STARTED` | Lưu profile an toàn và migration                                |
| 7     | UI, Mobile and Polish               | `NOT_STARTED` | UX hoàn chỉnh, mobile và tối ưu                               |
| 8     | Content Expansion                   | `NOT_STARTED` | Mở rộng vùng, sinh vật, kỹ năng và thế giới               |

Trạng thái hợp lệ: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `DONE`.

## Phase 0 — Project Foundation

- **Mục tiêu:** tạo nền tảng repository nhất quán để các phase sau phát triển an toàn.
- **Scope:** cấu trúc repository, Git, Rojo mapping, tài liệu, formatter, linter, tool checklist, hai bootstrap tối thiểu và build thử.
- **Deliverables:** `default.project.json`, source tree, bootstrap server/client, cấu hình development và toàn bộ tài liệu root.
- **Acceptance criteria:** cấu trúc/tài liệu đầy đủ; JSON Rojo hợp lệ; source strict và không có gameplay; StyLua/Selene sạch; `rojo build` thành công nếu tool có sẵn; diff chỉ thuộc Phase 0.
- **Out of scope:** mọi gameplay, asset nội dung, package bên thứ ba, publish và branch production.
- **Dependencies:** Git, Rojo CLI, StyLua, Selene; kiểm tra Studio/plugin cần thao tác thủ công.
- **Test thủ công:** kết nối `rojo serve`, xác nhận mapping và hai bootstrap, Play Test rồi đọc Output.
- **Trạng thái:** `DONE` — Rojo 7.7.0, StyLua 2.5.2 và Selene 0.31.0 đã được pin/cài; format check, lint và Rojo build đều trả exit code 0 ngày 2026-08-01.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** giữ validation foundation trong mọi phase; dùng binary pin trực tiếp nếu shim Rokit của terminal hiện tại chưa resolve được đường dẫn.

## Phase 1 — Home and Starter Selection

- **Mục tiêu:** người chơi xuất hiện tại Home và chọn một starter đầu tiên.
- **Scope:** một Home placeholder, UI chọn đúng một trong bốn starter, server validation lựa chọn và hiển thị một sinh vật placeholder cạnh người chơi; chưa cần chiến đấu hoặc capture hoàn chỉnh.
- **Deliverables:** flow vào Home, bốn starter definitions tối thiểu, request/response an toàn và presentation placeholder cho lựa chọn duy nhất.
- **Acceptance criteria:** chỉ một starter được chấp nhận một lần theo rule, server là nguồn sự thật, sinh vật đã chọn hiển thị đúng và reconnect có hành vi đã định nghĩa.
- **Out of scope:** combat hoàn chỉnh, capture, progression và DataStore production.
- **Dependencies:** Phase 0 `DONE`; quyết định tạm thời về session state khi persistence chưa có.
- **Test thủ công:** vào Play Test, chọn starter hợp lệ/không hợp lệ, thử gửi request lặp và kiểm tra hai phía client/server.
- **Trạng thái:** `IN_PROGRESS` — implementation và validation tự động đã hoàn tất; chưa chạy Play Test trong Roblox Studio nên chưa đủ bằng chứng để chuyển sang `DONE`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** chạy toàn bộ matrix trong `docs/guides/PHASE_1_STUDIO_TEST.md`, ghi kết quả thực tế và chỉ sau đó chuyển Phase 1 sang `DONE`.

## Phase 2 — Creature Data System

- **Mục tiêu:** tạo nền dữ liệu data-driven cho sinh vật và kỹ năng.
- **Scope:** `CreatureDefinition`, `OwnedCreature`, `ElementDefinition`, `RoleDefinition`, `SkillDefinition`, validation và dữ liệu mẫu tối thiểu.
- **Deliverables:** typed definitions, validator, registry nhỏ và test case hợp lệ/không hợp lệ.
- **Acceptance criteria:** definition sai bị từ chối rõ ràng, ID duy nhất, không hardcode data trong service và module shared không chứa player state.
- **Out of scope:** hàng trăm nội dung, combat/capture đầy đủ và balance production.
- **Dependencies:** Phase 0; yêu cầu starter từ Phase 1 được ghi nhận.
- **Test thủ công:** nạp registry trong Studio, kiểm tra log validation và thử các fixture sai có chủ đích.
- **Trạng thái:** `DONE` — typed schema, bốn catalog definition, validator, registry và test project đã được triển khai; Studio suite đạt 11/11 test và registry trả đúng `4 4 4 4` ngày 2026-08-02.
- **Cập nhật gần nhất:** 2026-08-02.
- **Bước tiếp theo:** không mở rộng schema ngoài nhu cầu thật; chuẩn bị thiết kế combat state machine khi Phase 3 được bắt đầu.

## Phase 3 — Combat Vertical Slice

- **Mục tiêu:** chứng minh một trận chiến bán tự động end-to-end.
- **Scope:** đội tối đa ba sinh vật, tự tìm mục tiêu, đánh thường, kỹ năng chủ động, cooldown, damage, khắc hệ và kết thúc trận.
- **Deliverables:** combat state server-authoritative, request kỹ năng, kết quả replicate và deterministic tests cho logic thuần.
- **Acceptance criteria:** client không quyết định damage; target/cooldown/state được validation; trận kết thúc nhất quán và test công thức ổn định.
- **Out of scope:** PvP, matchmaking, balance quy mô lớn và VFX hoàn chỉnh.
- **Dependencies:** Phase 2 và starter flow đủ dùng.
- **Test thủ công:** chơi encounter với nhiều đội hình, thử spam remote/target sai và kiểm tra kết thúc thắng-thua.
- **Trạng thái:** `IN_PROGRESS` — implementation server-authoritative, client placeholder, chart data-driven và test project đã được thêm; StyLua format/check, Selene và cả ba Rojo build trả exit code 0 ngày 2026-08-03. Chưa có kết quả suite/runtime Roblox Studio nên chưa đủ bằng chứng chuyển `DONE`.
- **Cập nhật gần nhất:** 2026-08-03.
- **Bước tiếp theo:** chạy `phase3-tests.project.json` và toàn bộ matrix trong `docs/guides/PHASE_3_STUDIO_TEST.md`, ghi actual result rồi mới xem xét chuyển `DONE`.

## Phase 4 — Capture and Collection

- **Mục tiêu:** cho phép bắt và quản lý sinh vật sở hữu.
- **Scope:** làm yếu mục tiêu, hai thiết bị bắt, server quyết định kết quả, collection, đội hình và kho sinh vật.
- **Deliverables:** capture request an toàn, inventory consumption, owned creature record và UI/flow quản lý cơ bản.
- **Acceptance criteria:** ownership/inventory/encounter/range được kiểm tra; kết quả chỉ quyết định ở server; không nhân đôi vật phẩm hoặc sinh vật.
- **Out of scope:** trading, marketplace, collection hàng trăm sinh vật.
- **Dependencies:** Phase 2 và Phase 3.
- **Test thủ công:** bắt thành công/thất bại, inventory thiếu, ngoài khoảng cách, request lặp và collection đầy.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** chốt capture state và transaction boundary khi phase bắt đầu.

## Phase 5 — Progression, Boss and Region Unlock

- **Mục tiêu:** tạo vòng tiến triển từ chiến đấu đến vùng mới.
- **Scope:** kinh nghiệm, cấp độ, tăng chỉ số, boss vùng, phần thưởng và mở khóa vùng tiếp theo.
- **Deliverables:** progression rules data-driven, boss encounter, reward grant idempotent và region gate.
- **Acceptance criteria:** server tính thưởng/cấp; boss reward không nhận lặp; region chỉ mở khi prerequisite đúng.
- **Out of scope:** endgame, battle pass, live event và nhiều thế giới.
- **Dependencies:** Phase 3, Phase 4 và region definitions tối thiểu.
- **Test thủ công:** thắng/thua boss, reconnect/retry reward, vào vùng khóa và kiểm tra boundary cấp độ.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** xác định MVP progression curve khi vertical slice combat/capture được kiểm chứng.

## Phase 6 — Persistent Data

- **Mục tiêu:** lưu PlayerProfile an toàn qua session.
- **Scope:** DataStore, retry, session protection, save lifecycle, migration và xử lý lỗi lưu.
- **Deliverables:** profile schema có version, load/save service, migration, shutdown path và observability an toàn.
- **Acceptance criteria:** không ghi đè session đang hoạt động, retry có giới hạn, migration có test và lỗi lưu không làm mất state im lặng.
- **Out of scope:** analytics warehouse, cross-experience economy và backup ngoài Roblox.
- **Dependencies:** schema sở hữu/progression từ Phase 2–5 và môi trường test DataStore.
- **Test thủ công:** first join, rejoin, simulated failure, bind-to-close, schema cũ và concurrent session.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** threat model dữ liệu và migration plan trước implementation.

## Phase 7 — UI, Mobile and Polish

- **Mục tiêu:** đưa vertical slice tới trải nghiệm dễ hiểu trên desktop/mobile.
- **Scope:** UI hoàn chỉnh, mobile controls, camera, VFX, SFX, tutorial, combat feedback và optimization.
- **Deliverables:** responsive screens, input abstraction, feedback audio/visual nguyên bản, onboarding và performance budget.
- **Acceptance criteria:** core loop dùng được trên thiết bị mục tiêu; UI không che safe area; hiệu năng đạt budget; asset có nguồn/license rõ ràng.
- **Out of scope:** content expansion quy mô lớn và tính năng social mới.
- **Dependencies:** core loop Phase 1–6 ổn định.
- **Test thủ công:** device emulator, touch/gamepad/keyboard, network throttling, memory/performance và accessibility cơ bản.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** lập UX flow và device matrix khi core systems ổn định.

## Phase 8 — Content Expansion

- **Mục tiêu:** mở rộng chiều sâu sau khi kiến trúc và core loop đã chứng minh.
- **Scope:** thêm vùng, sinh vật, kỹ năng, sinh vật hiếm, boss đặc biệt và thế giới khác.
- **Deliverables:** content packs được validation, pipeline authoring và regression suite cho dữ liệu.
- **Acceptance criteria:** nội dung mới không cần sửa core service không liên quan; validation/build/test giữ ổn định; IP và license được review.
- **Out of scope:** feature không có product decision hoặc không phù hợp core loop.
- **Dependencies:** Phase 1–7 hoàn tất và có số liệu/feedback đủ tin cậy.
- **Test thủ công:** smoke test từng content pack, progression route, balance pass và asset/license audit.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** chưa lập lịch; không bắt đầu trước khi vertical slice được đánh giá.

## Trạng thái hiện tại

- **Current Phase:** Phase 3 — Combat Vertical Slice (`IN_PROGRESS`).
- **Current Task:** triển khai và xác minh combat vertical slice trên `feature/combat-vertical-slice`; không merge `master` trước khi runtime Studio đạt.
- **Completed Work:** Phase 2 đã merge vào `master`. Phase 3 hiện có typed combat state/snapshot, deterministic damage và element chart, combat engine, server lifecycle/basic attack/remote validation, client snapshot UI và suite 17 case để chạy trong Studio.
- **Known Issues:** single-starter selection chưa có kết quả regression chi tiết trong test log được ghi lại; shim Rokit trong PATH của terminal Codex vẫn báo lỗi đường dẫn nhưng binary pin chạy đúng.
- **Blockers:** remote HEAD GitHub vẫn cần chuyển từ `master` sang `prod` bằng Settings hoặc API client đã xác thực.
- **Next Recommended Task:** ghi nhận single-starter regression nếu cần, sau đó lập kế hoạch Phase 3 trước khi viết combat code.

## Change History

| Ngày      | Phase | Thay đổi                                                                                      |
| ---------- | ----- | ----------------------------------------------------------------------------------------------- |
| 2026-08-01 | 0     | Khởi tạo repository foundation; ghi nhận toolchain còn thiếu và đặt Phase 0`BLOCKED`. |
| 2026-08-01 | 0     | Xác minh Rojo 7.7.0, StyLua 2.5.2, Selene 0.31.0 cùng build/format/lint; chuyển Phase 0 sang `DONE`. |
| 2026-08-01 | 1     | Triển khai Home, starter team selection server-authoritative và placeholder presentation; giữ `IN_PROGRESS` chờ Studio Play Test. |
| 2026-08-02 | 1     | Sửa bootstrap dùng sai Rojo sibling path; thêm remote timeout, Home marker và `RespawnLocation`; chờ Studio regression test. |
| 2026-08-02 | 1     | Đổi onboarding sang chọn một trong bốn starter; ghi nhận hướng tutorial capture nguyên bản cho phase sau. |
| 2026-08-02 | 2     | Thêm typed creature data, definitions, validator, registry và test project; giữ `IN_PROGRESS` chờ Studio suite. |
| 2026-08-02 | 2     | Studio validation đạt 11/11 test, registry trả `4 4 4 4`; chuyển Phase 2 sang `DONE`. |
| 2026-08-03 | 3     | Bắt đầu combat vertical slice trên feature branch; thêm server-authoritative encounter, damage skill, snapshot UI và test project; giữ `IN_PROGRESS` chờ Studio runtime. |
