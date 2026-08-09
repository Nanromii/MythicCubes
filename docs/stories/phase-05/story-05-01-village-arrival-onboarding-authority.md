# Story 05-01: Village arrival và onboarding authority

## Status

`Verification`

## Outcome

Player mới và player respawn xuất hiện tại public Làng Mạch Nguồn; server tạo đúng một session
onboarding state và client nhận snapshot/cue hiện tại mà không thể tự đặt progress.

## Authority

- Direct decisions ngày 2026-08-09 và `docs/plans/active/phase-05-village-onboarding.md`.
- `docs/phases/PHASE_ROADMAP.md` Phase 5.
- `docs/design/WORLD_EXPLORATION_PROGRESSION.md` onboarding/Làng.
- `docs/design/VISUAL_AUDIO_UI_DIRECTION.md` Village/UI/camera/audio/accessibility.
- `ARCHITECTURE.md` chỉ là current implementation evidence.

## Context

Current `HomeService` dùng `HomePlaceholder` làm public spawn và chưa có onboarding state machine.
Increment này tách public Village khỏi private Home tương lai và tạo authority dùng chung cho hai Story sau.

## In scope

- Pure onboarding state/transition schema và unit tests.
- `OnboardingService` session-only với snapshot, cleanup và server-internal transition API.
- Exact-shape snapshot request và server-published state update.
- Village greybox, public spawn, năm gate/landmark/signage, camera/ambience đại diện.
- Loading/failure/retry/invalid-state feedback shell và idempotent respawn binding.

## Out of scope

- Starter commit UI, tutorial encounter/capture, world selection commit, NPC logic, DataStore và full art kit.

## Gameplay decisions

- Làng Mạch Nguồn là public hub, không phải Nhà Riêng.
- Initial state là chờ chọn một trong năm starter; chỉ server chuyển state.
- Năm world/gate production names đã accepted; gate state gameplay được server snapshot.
- Session-only: rejoin bắt đầu session mới; respawn trong cùng session giữ state.

## Open questions

Không có decision chặn Story này. Numeric art/performance budgets giữ smoke-level theo Phase 5.

## Dependencies

Current Rojo mapping, `RemoteFactory`, five-world identifiers và Player lifecycle.

## Acceptance criteria

- [ ] Player spawn/respawn đúng Village spawn; `HomePlaceholder` không còn đóng vai public Home.
- [ ] Mỗi Player có một state độc lập; reset không reset progress, leaving cleanup session.
- [ ] Snapshot initial chỉ cho gate Thường ở trạng thái tutorial-eligible sau starter; elemental gates locked.
- [ ] Client không thể gửi step/completion flag hoặc mutate state qua snapshot remote.
- [ ] Illegal transition, duplicate/replay và wrong-state action fail closed không side effect.
- [ ] Village có landmark, signage, camera gameplay tự do, ambience và feedback shell tối thiểu.
- [ ] UI tôn trọng safe area, text scaling, contrast và non-color gate signal.

## Technical notes

Server owns `Player -> OnboardingSession`; client receives immutable snapshots. Internal transition events
are allowlisted and pure-tested. Snapshot remote accepts no payload. Story 05-04 bổ sung public gate
interaction bằng server `Touched` và permission fail-closed; Story này chỉ sở hữu state/read model nền.

## Security and exploit considerations

Validate exact type/shape/unknown fields, state, Player ownership, lifecycle and rate where a request
exists. Never accept userId, Player, tutorial step or completion from client. Cleanup PlayerRemoving and
avoid duplicate CharacterAdded/controller connections.

## Validation plan

- Static checks: StyLua, Selene, `git diff --check`.
- Build: default and Phase 5 test project.
- Automated: state initialization, legal/illegal transition, replay and per-user isolation.
- Studio functional tests: Play Solo spawn/reset/camera/UI/ambience/error-free Output.
- Multiplayer tests: two clients spawn/state/isolation/reset.
- Regression/exploit tests: malformed snapshot call, duplicate bind, post-respawn request.
- Playtest/game feel: landmark and gate status readable within first view/walk.

## Rollback

Remove new onboarding/Village modules and restore Bootstrap/Home mapping by targeted patch; do not alter
Phase 0–4 history or use broad Git reset.

## Completion evidence

Source/static/build evidence ngày 2026-08-09: targeted StyLua, Selene, default/Phase 5 Rojo build và
`git diff --check` pass. Automated, Play Solo, Server & Clients, reset/camera/UI pass theo xác nhận người
dùng ngày 2026-08-09; raw Output/Studio version không được cung cấp. Licensed ambience còn pending nên
Story giữ `Verification`, chưa `Done`.
