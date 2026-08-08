# Story 04-02: Encounter chung, chọn mục tiêu bắt và HP expedition

## Status

`Done`

## Outcome

Combat Phase 4 không còn bị khóa vào một cặp 1v1. Nhiều player có thể cùng đánh một wild,
cụm wild có thể cùng tham gia encounter, player chọn đúng mục tiêu cần bắt, và companion không
tự hồi đầy máu chỉ vì combat kết thúc.

## Authority

`AGENTS.md`, `CODEX.md`, `ARCHITECTURE.md`, `PROJECT_PROCESS.md`, `docs/WORKFLOW.md`,
`docs/phases/PHASE_ROADMAP.md`, `docs/design/CAPTURE_SYSTEM.md`,
`docs/design/CREATURE_ELEMENT_SKILL_SYSTEM.md`, `docs/product/CREATURE_SYSTEM.md`,
`docs/guides/PHASE_4_STUDIO_TEST.md` và quyết định người dùng ngày 2026-08-07:
request bắt hợp lệ đến trước sẽ khóa target; nếu roll thất bại thì unlock target ngay.

## Context

Implementation hiện tại chỉ lưu một `wildId` trong encounter của mỗi player. Snapshot ngoài encounter
tính lại companion HP bằng max HP, tạo cảm giác companion tự hồi sau combat. Capture gửi một `wildId`
nhưng UI không có lựa chọn rõ khi encounter có nhiều wild.

## In scope

- Giữ HP companion theo session/expedition trong Phase 4, không reset khi encounter kết thúc.
- Claim toàn bộ wild hợp lệ trong cùng spawn group vào một encounter server-owned.
- Cho phép player khác join encounter đang có nếu còn trong range hợp lệ.
- Cho phép mỗi player chọn một wild hợp lệ trong encounter để ném bóng.
- Thêm capture lock server-side theo rule first-valid-request-wins; failure unlock ngay.
- Cập nhật snapshot/UI/test/Studio guide cho multi-wild, multi-player và capture contention.

## Out of scope

- Không đổi damage formula, elemental balance, capture formula, capture tier logic hoặc inventory rule.
- Không thêm DataStore, economy, item heal, regen theo thời gian, PvP, boss, rarity hoặc dependency mới.
- Không dựng UI Phase 12 đầy đủ như hold-drag-release, projectile 3D, camera/VFX/SFX.
- Không commit hoặc push.

## Gameplay decisions

- Một wild có thể có nhiều player participant trong cùng `encounterId`.
- Request capture hợp lệ đầu tiên tạo atomic lock trên đúng target wild trên server; không khóa cả encounter/cluster.
- Request capture khác vào target đang bị khóa bởi player/request khác bị từ chối, không roll và không tiêu bóng.
- Capture thất bại sau roll hợp lệ tiêu bóng rồi unlock target ngay để các request sau có thể thử lại.
- Capture thành công tiêu bóng, cấp creature đúng player thắng, despawn đúng target và loại target khỏi các encounter còn lại.
- Nếu wild chết trước khi được bắt và có item drop, user gây `last-hit final blow` nhận item; participation/contribution và capture success reward là credit riêng.
- Companion HP không tự hồi khi disengage, wild death hoặc capture; hồi máu safe zone production vẫn thuộc scope riêng nếu chưa có trigger trong Phase 4 runtime.

## Open questions

Không còn blocker cho vertical slice này. UI target selection hiện là lựa chọn danh sách tối thiểu, không phải presentation Phase 12.

## Acceptance criteria

- [x] Companion HP sau combat/disengage giữ nguyên giá trị đã mất, không reset về max khi quay lại Exploring.
- [x] Một spawn group có nhiều wild tạo encounter với nhiều target hợp lệ.
- [x] Player thứ hai có thể join encounter đang có và cùng gây damage lên cùng wild hợp lệ.
- [x] Wild trong encounter có thể cùng đánh companion của participant hợp lệ.
- [x] Capture UI cho phép chọn target cụ thể khi có nhiều wild.
- [x] Server từ chối target không thuộc encounter hoặc player không phải participant.
- [x] Server khóa target theo request hợp lệ đến trước; request cạnh tranh bị từ chối không side effect.
- [x] Capture failure unlock target ngay; capture success despawn đúng target và không duplicate ownership.
- [x] Retry cùng request ID/fingerprint trả cache; cùng request ID payload khác bị từ chối.

## Technical notes

Server tiếp tục là nguồn quyết định cho encounter membership, damage, target validity, capture lock,
inventory consume và capture result. Client chỉ render snapshot và gửi intent `{ requestId, encounterId,
wildId, deviceId }`.

## Security and exploit considerations

Không tin client về HP, target membership, position, chance, result, inventory hoặc ownership. Capture
phải validate exact payload, request fingerprint, rate limit, device, inventory, encounter membership,
range, target state và capture lock trước khi roll/consume.

## Validation plan

- Static checks: `git diff --check`, Selene, focused content audit.
- Build: `rojo build default.project.json`, `rojo build phase4-tests.project.json`.
- Studio functional tests: Play Solo HP persistence, multi-wild target list và capture target selection.
- Multiplayer tests: hai client join cùng encounter, cùng đánh một wild, capture contention first-valid locks.
- Regression/exploit tests: invalid target, wrong participant, unknown/empty device, duplicate request, request ID conflict, locked target.
- Playtest/game feel: xác nhận combat không còn cảm giác 1v1 cứng trong cụm wild.

## Completion evidence

- 2026-08-08: Phase 4 Studio acceptance đã được xác nhận hoàn tất; roadmap và guide đã được chốt sang `Done`.

- 2026-08-07 21:52:18 +07:00: `selene src tests` exit 0, 0 errors, 0 warnings, 0 parse errors.
- 2026-08-07 21:52:18 +07:00: `rojo build default.project.json -o build-validation.rbxlx` exit 0, build thành công.
- 2026-08-07 21:52:18 +07:00: `rojo build phase4-tests.project.json -o phase4-tests-validation.rbxlx` exit 0, build thành công.
- 2026-08-07 21:52:18 +07:00: `git diff --check` exit 0; chỉ có warning CRLF của Git.
- 2026-08-07 21:52:18 +07:00: `stylua --check src tests` exit 1 do baseline line-ending diff trên nhiều file, gồm file không thuộc thay đổi này; chưa dùng làm blocker.
- Roblox Studio Play Solo, Server & Clients, capture contention manual và Output audit cho story này: chưa chạy trong phiên này.
