code --install-extension JohnnyMorganz.luau-lsp
code --install-extension evaera.vscode-rojo
code --install-extension JohnnyMorganz.stylua
code --install-extension Kampfkarren.selene-vscode1233code --install-extension JohnnyMorganz.luau-lsp
code --install-extension evaera.vscode-rojo
code --install-extension JohnnyMorganz.stylua
code --install-extension Kampfkarren.selene-vscode1231212

# Quy trình và tiến độ dự án

## Tổng quan

| Phase | Tên                                | Trạng thái    | Mục tiêu                                                         |
| ----- | ----------------------------------- | --------------- | ------------------------------------------------------------------ |
| 0     | Project Foundation                  | `BLOCKED`     | Repository, Rojo, Git, tài liệu và toolchain tối thiểu        |
| 1     | Home and Starter Selection          | `NOT_STARTED` | Home và lựa chọn ba sinh vật khởi đầu có server xác nhận |
| 2     | Creature Data System                | `NOT_STARTED` | Mô hình dữ liệu sinh vật, hệ, vai trò và kỹ năng         |
| 3     | Combat Vertical Slice               | `NOT_STARTED` | Một vòng chiến đấu bán tự động hoàn chỉnh               |
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
- **Trạng thái:** `BLOCKED` — repository đã được tạo nhưng Rojo, StyLua và Selene thiếu, nên chưa thể xác minh build/format/lint.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** cài/pin tool theo `TOOL_SETUP.md`, chạy validation và test Studio; chỉ đổi sang `DONE` khi tất cả tiêu chí đạt.

## Phase 1 — Home and Starter Selection

- **Mục tiêu:** người chơi xuất hiện tại Home và chọn đội khởi đầu.
- **Scope:** một Home placeholder, UI chọn ba sinh vật, server validation lựa chọn và hiển thị sinh vật placeholder cạnh người chơi; chưa cần chiến đấu hoàn chỉnh.
- **Deliverables:** flow vào Home, starter definitions tối thiểu, request/response an toàn và presentation placeholder.
- **Acceptance criteria:** lựa chọn chỉ được chấp nhận một lần theo rule, server là nguồn sự thật, ba sinh vật hiển thị đúng và reconnect có hành vi đã định nghĩa.
- **Out of scope:** combat hoàn chỉnh, capture, progression và DataStore production.
- **Dependencies:** Phase 0 `DONE`; quyết định tạm thời về session state khi persistence chưa có.
- **Test thủ công:** vào Play Test, chọn starter hợp lệ/không hợp lệ, thử gửi request lặp và kiểm tra hai phía client/server.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** chỉ lập kế hoạch chi tiết sau khi Phase 0 hoàn tất.

## Phase 2 — Creature Data System

- **Mục tiêu:** tạo nền dữ liệu data-driven cho sinh vật và kỹ năng.
- **Scope:** `CreatureDefinition`, `OwnedCreature`, `ElementDefinition`, `RoleDefinition`, `SkillDefinition`, validation và dữ liệu mẫu tối thiểu.
- **Deliverables:** typed definitions, validator, registry nhỏ và test case hợp lệ/không hợp lệ.
- **Acceptance criteria:** definition sai bị từ chối rõ ràng, ID duy nhất, không hardcode data trong service và module shared không chứa player state.
- **Out of scope:** hàng trăm nội dung, combat/capture đầy đủ và balance production.
- **Dependencies:** Phase 0; yêu cầu starter từ Phase 1 được ghi nhận.
- **Test thủ công:** nạp registry trong Studio, kiểm tra log validation và thử các fixture sai có chủ đích.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** chốt schema tối thiểu và test strategy khi phase bắt đầu.

## Phase 3 — Combat Vertical Slice

- **Mục tiêu:** chứng minh một trận chiến bán tự động end-to-end.
- **Scope:** đội tối đa ba sinh vật, tự tìm mục tiêu, đánh thường, kỹ năng chủ động, cooldown, damage, khắc hệ và kết thúc trận.
- **Deliverables:** combat state server-authoritative, request kỹ năng, kết quả replicate và deterministic tests cho logic thuần.
- **Acceptance criteria:** client không quyết định damage; target/cooldown/state được validation; trận kết thúc nhất quán và test công thức ổn định.
- **Out of scope:** PvP, matchmaking, balance quy mô lớn và VFX hoàn chỉnh.
- **Dependencies:** Phase 2 và starter flow đủ dùng.
- **Test thủ công:** chơi encounter với nhiều đội hình, thử spam remote/target sai và kiểm tra kết thúc thắng-thua.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** thiết kế combat state machine sau khi Phase 2 ổn định.

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

- **Current Phase:** Phase 0 — Project Foundation (`BLOCKED`).
- **Current Task:** hoàn thiện foundation và xác minh toolchain/build.
- **Completed Work:** khởi tạo Git; tạo source tree, Rojo config, development config, bootstrap tối thiểu và tài liệu Phase 0; kiểm tra JSON/mapping, cấu trúc, whitespace, secret-like assignment và file build đều đạt.
- **Known Issues:** chưa có kết quả StyLua, Selene, Rojo build hoặc Play Test; trạng thái manual tool chưa được xác nhận.
- **Blockers:** `rojo`, `stylua` và `selene` không có trong PATH tại lần kiểm tra 2026-08-01.
- **Next Recommended Task:** cài/pin tool theo `TOOL_SETUP.md`, chạy validation, kết nối Studio và chỉ sau đó đánh dấu Phase 0 `DONE` để chuẩn bị kế hoạch Phase 1.

## Change History

| Ngày      | Phase | Thay đổi                                                                                      |
| ---------- | ----- | ----------------------------------------------------------------------------------------------- |
| 2026-08-01 | 0     | Khởi tạo repository foundation; ghi nhận toolchain còn thiếu và đặt Phase 0`BLOCKED`. |
