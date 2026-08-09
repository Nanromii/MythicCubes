# Story 04-01: Chuẩn hóa capture device và năm starter

## Status

`Done (historical; user-confirmed Studio)`

## Outcome

Người chơi nhìn thấy đúng bốn loại bóng bắt thú theo thứ tự cấp độ tăng dần và màn hình
chọn thú ban đầu có đúng năm lựa chọn thuộc năm hệ `fire`, `water`, `wind`, `nature`,
`normal`.

## Authority

`ARCHITECTURE.md`, `PROJECT_PROCESS.md`, `docs/WORKFLOW.md`, `docs/phases/PHASE_ROADMAP.md`,
`docs/design/CAPTURE_SYSTEM.md`, `docs/design/CREATURE_ELEMENT_SKILL_SYSTEM.md`,
`docs/product/CREATURE_SYSTEM.md`, `docs/guides/PHASE_4_STUDIO_TEST.md` và quyết định người dùng
ngày 2026-08-07 cho phép dùng definition hệ Thường hiện có làm starter thứ năm.

## Context

Vertical slice hiện có hai capture device và bốn starter. Definition `pebblit` đã tồn tại với
element `normal`, stats, role, skill và presentation color; quyết định được chấp nhận là đưa
definition này vào starter list, giữ nguyên internal ID `pebblit` và display name `Pebblit`.

## In scope

- Mở rộng capture device catalog thành đúng bốn entry, giữ ổn định `trail_capsule` và
  `prism_snare`.
- Dùng display name tiếng Việt: `Bóng xanh lá`, `Bóng xanh dương`, `Bóng tím`, `Bóng đỏ`.
- Đánh dấu `Bóng đỏ` là device đặc biệt trong definition/registry và duy trì thứ tự cấp độ.
- Cập nhật validator, inventory snapshot/fixture, capture UI, feedback/result text, test và
  Phase 4 Studio guide.
- Thêm `pebblit` vào `StarterDefinitions` để có đúng năm starter, không đổi definition gameplay.
- Giữ server quyết định selection, inventory transaction và capture result.

## Out of scope

- Đổi internal ID hiện có, capture formula, chance/tier balance ngoài dữ liệu cần để phân biệt
  bốn entry, inventory transaction, DataStore, monetization, combat, artwork pipeline hoặc
  starter ngoài `pebblit`.
- Tạo UI flow mới ngoài việc cập nhật danh sách capture device và starter hiện có.

## Gameplay decisions

- `trail_capsule` giữ ID và trở thành `Bóng xanh lá`.
- `prism_snare` giữ ID và trở thành `Bóng xanh dương`.
- Hai ID mới dùng cho `Bóng tím` và `Bóng đỏ`; `Bóng đỏ` có cờ `isSpecial = true`.
- `pebblit` là starter hệ Thường thứ năm; giữ nguyên stats, role, skill và display color.
- Công thức capture vẫn dùng các field chance hiện có; không thêm client-provided chance/result.

## Open questions

Không còn quyết định gameplay bắt buộc trước implementation. Tên hai capture device mới là
implementation identifier, không phải product-facing display name.

## Acceptance criteria

- [x] Registry có đúng bốn capture device theo thứ tự: Bóng xanh lá, Bóng xanh dương, Bóng tím,
  Bóng đỏ.
- [x] Không còn display name capture cũ trong source, UI, inventory, result, fixture hoặc guide
  liên quan.
- [x] Bóng đỏ có cờ đặc biệt và không tạo duplicate ID.
- [x] Starter registry có đúng năm ID, mỗi ID thuộc một element khác nhau: `bramblet`, `pyrel`,
  `tiderook`, `zephlet`, `pebblit`.
- [x] Starter request sai shape hoặc ID không hợp lệ bị server từ chối; capture request sai shape,
  device không tồn tại, inventory hết, target/range/ownership/state/rate-limit sai tiếp tục bị
  server từ chối.
- [x] Client chỉ gửi `starterId` hoặc capture intent; server quyết định ownership và capture result.
- [x] Behavior của bốn starter cũ, capture formula và transaction idempotency không đổi.

## Technical notes

`WorldDefinitions` là nguồn definition; `WorldDataRegistry` và `WorldDefinitionValidator` là
registry/validation boundary. `CaptureService` kiểm tra request, device, inventory, encounter,
range và gọi `CollectionService` cho transaction. `StarterSelectionService` dùng
`StarterSelectionValidator`, thêm starter vào collection và tạo companion. Client chỉ render
snapshot/response server đã xác nhận.

## Security and exploit considerations

Không tin device ID, starter ID, chance, ownership, position, target hay result do client gửi.
Giữ exact-field validation, ownership isolation, server-observed target/range, rate-limit và
request idempotency. Không log raw payload hoặc thêm remote surface.

## Validation plan

- Static checks: `git diff --check`, StyLua, Selene và kiểm tra không còn display name cũ.
- Build: `rojo build default.project.json -o default-current.rbxlx` và
  `rojo build artifacts/json/phase4-tests.project.json -o artifacts/rbxlx/phase4-tests.rbxlx`.
- Studio functional tests: danh sách năm starter và bốn tên bóng trong UI/inventory/result.
- Multiplayer tests: hai client có starter, inventory và collection riêng.
- Regression/exploit tests: invalid payload, unknown device, empty inventory, invalid starter ID,
  extra client fields, duplicate capture request, wrong owner, out-of-range và rate-limit.
- Playtest/game feel: không mở rộng ngoài content/list update; ghi rõ nếu chưa chạy Studio.

## Completion evidence

| Claim | Manual check | Kết quả |
| --- | --- | --- |
| Studio functional test cho starter/capture device | Người dùng xác nhận đã chạy trong Roblox Studio; ngày/giờ chi tiết, version và raw Output chưa cung cấp | Pass theo xác nhận người dùng |
| Giới hạn evidence | Codex không có Studio session để chạy lại | Chưa kiểm chứng độc lập |
