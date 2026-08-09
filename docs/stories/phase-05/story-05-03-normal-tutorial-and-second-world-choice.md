# Story 05-03: Tutorial Thường và lựa chọn world thứ hai

## Status

`Verification`

## Outcome

Player có starter đi tuyến tutorial chung tại Bình Nguyên Khởi Sinh, guaranteed-capture Tumblet, quay
lại Làng và tự mở một trong bốn world nguyên tố; kết thúc session onboarding với đúng hai creature và
đúng hai world accessible.

## Authority

Direct decisions ngày 2026-08-09; `docs/product/CREATURE_SYSTEM.md`;
`docs/design/WORLD_EXPLORATION_PROGRESSION.md`; `docs/design/VISUAL_AUDIO_UI_DIRECTION.md`;
Stories 05-01 và 05-02.

## Context

Phase 4 có encounter/capture session slice nhưng chưa có tutorial identity, guaranteed-capture rule,
return gate hay world-access choice. Increment tái dùng trust boundary hiện có mà không kéo manual
throw/contact, persistence hoặc full world content vào Phase 5.

## In scope

- Data-driven Tumblet definition/blockout và Normal tutorial spawn identity.
- Tutorial route/interaction shell giới thiệu movement và current basic attack/skill/capture feedback.
- Server-only guaranteed capture eligibility cho đúng player/encounter/wild/state.
- Return-to-Village transition và preview/chọn một trong bốn elemental world.
- Selected elemental gate + representative landing shell accessible; ba gate khác locked.
- Success/failure/retry/invalid state, navigation/camera/SFX/ambience and integration lifecycle.

## Out of scope

Manual capture/contact rewrite, full elemental world content, XP/level/reward item, NPC economy,
DataStore, unlock world thứ ba đến thứ năm và production asset upload.

## Gameplay decisions

- Tumblet là fixed Normal non-starter tutorial creature; capture hợp lệ đầu tiên được server bảo đảm.
- Reward chỉ là starter, Tumblet và first elemental world access.
- Elemental world choice độc lập starter và commit đúng một lần trong session.
- Rejoin resets session; respawn retains state.

## Open questions

Unlock rule cho ba world còn lại là `TBD` future dependency, không được implementation Story này dùng.

## Dependencies

Stories 05-01/05-02; Collection/Capture/Encounter/RegionalWild services; world/creature registries;
Village gate anchors and onboarding snapshots.

## Acceptance criteria

- [ ] Chỉ player có starter/đúng state và character chạm normal gate mới vào tutorial route.
- [ ] Tutorial target là Tumblet và guarantee chỉ áp dụng đúng server-owned tutorial encounter/wild.
- [ ] Capture commit tiêu đúng device theo current rule, thêm đúng một Tumblet và advance state một lần.
- [ ] Invalid payload/ID, extra field, wrong target/state/range, spam và replay không grant/advance.
- [ ] Sau return, player tự chọn đúng một trong bốn elemental world; choice không phụ thuộc starter.
- [ ] Kết thúc có đúng hai owned creature và access Normal + chosen elemental world, không access ba gate khác.
- [ ] Reset/respawn không duplicate target/controller/UI/display/grant; hai client hoàn toàn tách biệt.
- [ ] Loading/success/failure/retry, camera/readability, input/accessibility và representative audio pass smoke.
- [ ] Không xuất hiện XP/item reward phụ, economy, persistence hay content ngoài Phase 5.

## Technical notes

Client chỉ gửi intent cho practice/capture và UI fallback; Story 05-04 chuyển gate travel sang server
physical touch. Server đo proximity khi phù hợp, kiểm tra state/world whitelist và sở hữu transition.
Capture guarantee là server predicate gắn với tutorial
wild identity plus player participation/state, never a client boolean. Collection request fingerprint
and one-way transition enforce idempotency. Gate access is a server snapshot and server-controlled move.

## Security and exploit considerations

Validate exact type/shape/extra fields, state, player ownership/participant, target identity, range,
world allowlist, rate and replay. Other-player Tumblet/anchor/world request fails closed. Audit capture
lock, inventory consumption, partial failure, PlayerRemoving cleanup and stale respawn connections.

## Validation plan

- Static checks: StyLua, Selene, `git diff --check`, links/artifact paths.
- Build: default and Phase 5 test project.
- Automated: Tumblet schema, transition, guarantee predicate, capture/grant replay, world choice whitelist/isolation.
- Studio functional tests: Play Solo end-to-end, reset/retry, touch/gamepad, camera/UI/audio/accessibility.
- Multiplayer tests: Server & Clients two-player target/state/grant/gate isolation.
- Regression/exploit tests: malformed/unknown/extra/spam/replay/wrong-state/out-of-range/post-respawn.
- Playtest/game feel: 3–5 minute target, route/gates readable and world choice understandable.

## Rollback

Disable tutorial/elemental gate integration and remove Tumblet/Phase 5 content by targeted patch while
preserving Phase 0–4 definitions/history and unrelated user changes.

## Completion evidence

Source/static/build evidence ngày 2026-08-09: targeted StyLua, Selene, default/Phase 5 Rojo build và
`git diff --check` pass. Luau runtime, end-to-end, two-client exploit matrix, camera/touch và
accessibility pass theo xác nhận người dùng ngày 2026-08-09; raw Output/Studio version không được cung cấp.
Representative audio còn pending nên Story giữ `Verification`, chưa `Done`.
