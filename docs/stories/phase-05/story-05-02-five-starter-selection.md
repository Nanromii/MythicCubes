# Story 05-02: Five-starter selection end-to-end

## Status

`Verification`

## Outcome

Tại Làng, player dùng mouse/keyboard, touch hoặc gamepad để xem và chọn đúng một trong năm starter;
server commit ownership một lần, chuyển onboarding state và client hiển thị companion/result xác nhận.

## Authority

Direct decisions ngày 2026-08-09; `docs/product/CREATURE_SYSTEM.md`;
`docs/design/WORLD_EXPLORATION_PROGRESSION.md`; `docs/design/VISUAL_AUDIO_UI_DIRECTION.md`;
Story 05-01 server onboarding authority.

## Context

Current selection đã validate `{starterId}` và commit session collection một lần nhưng UI/controller là
Phase 4 baseline, chưa tích hợp onboarding state, input abstraction, Village display và full lifecycle gate.

## In scope

- Five-starter parity từ registry và data-driven display.
- Input abstraction cho mouse/keyboard, touch và gamepad.
- Server selection commit liên kết atomic với onboarding transition.
- Năm silhouette/blockout, UI tokens/components và representative SFX/feedback.
- Loading, success, failure, retry, rate-limit và invalid-state presentation.

## Out of scope

Tumblet capture, world entry/choice, starter rebalance, production rig/animation set và persistence.

## Gameplay decisions

Player chọn đúng một trong Pebblit, Pyrel, Tiderook, Bramblet, Zephlet. Không starter mặc định và
starter không khóa world nguyên tố được chọn sau tutorial.

## Open questions

Không có decision chặn. Stat balance giữ current definitions, không được Story này thay đổi.

## Dependencies

Story 05-01; `StarterDefinitions`; Collection/Companion services; remote names/factory.

## Acceptance criteria

- [ ] UI hiển thị đúng năm starter, không duplicate/missing và không hard-code gameplay theo tên.
- [ ] Ba input families hoàn tất cùng một intent path và focus rõ ràng.
- [ ] Valid request commit đúng một starter/owned instance và state tiếp theo đúng một lần.
- [ ] Invalid ID, non-table, field thừa, spam, replay và wrong state bị từ chối không side effect.
- [ ] Client không thể cấp creature cho mình/player khác hoặc tự chuyển onboarding.
- [ ] Reset/respawn không duplicate UI/controller/display/grant; hai client tách biệt.
- [ ] Feedback dùng text/icon/state ngoài màu; model/SFX không quyết định outcome.

## Technical notes

Remote payload duy nhất `{ starterId: string }`; reject all extra/non-string fields. Server checks current
onboarding state before collection transaction. Only after collection success does internal transition
advance; replay returns canonical selected starter without second grant. Client renders server response/snapshot.

## Security and exploit considerations

Validate type, exact shape, starter registry membership, onboarding state, per-player ownership, rate and
replay. Request contains no userId/Player/instance. Review partial failure between collection and state;
transaction ordering must not leave duplicate ownership or stuck state.

## Validation plan

- Static checks: StyLua, Selene, `git diff --check`.
- Build: default and Phase 5 tests.
- Automated: validator, five IDs, unknown/extra fields, wrong state, replay, rate seam and isolation.
- Studio functional tests: selection with desktop/touch/gamepad, reset and feedback states.
- Multiplayer tests: simultaneous distinct choices and other-player spoof attempt.
- Regression/exploit tests: existing Phase 2/4 data/collection tests and remote abuse matrix.
- Playtest/game feel: all five choices readable and no visually implied strongest/default choice.

## Rollback

Targeted revert selection/onboarding integration and new presentation; preserve registry/history.

## Completion evidence

Source/static/build evidence ngày 2026-08-09: targeted StyLua, Selene, default/Phase 5 Rojo build và
`git diff --check` pass. Five-input/render behavior, reset và multiplayer pass theo xác nhận người dùng
ngày 2026-08-09; raw Output/Studio version không được cung cấp. Representative SFX còn pending nên Story
giữ `Verification`, chưa `Done`.
