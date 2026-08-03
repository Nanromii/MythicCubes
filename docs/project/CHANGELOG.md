# Changelog

Mọi thay đổi đáng chú ý của dự án được ghi theo cấu trúc đơn giản của Keep a Changelog.

## [Unreleased]

### Added

- Phase 4 open-world PvE vertical slice with server-owned regional individual/cluster spawns, wild lifecycle, companion follow, proximity combat and leash return.
- Two original data-driven capture devices, idempotent capture transactions, per-session inventory/collection/team ownership and Vietnamese gameplay UI.
- Validated world definitions, pure lifecycle/capture/collection utilities, a dedicated Phase 4 test project and Roblox Studio acceptance matrix.
- A fifth original Normal creature/skill pair for the five-element migration prerequisite.

- Initial Roblox project foundation.
- Rojo project structure.
- Project documentation.
- Development configuration.
- Runtime Home placeholder and spawn for Phase 1.
- Server-authoritative starter team selection with strict validation and session state.
- Starter selection UI and single-companion placeholder presentation.
- Roblox Studio manual test matrix for Phase 1.
- Typed creature, owned-creature, element, role and skill schemas.
- Four original definitions for each Phase 2 catalog.
- Strict catalog validation, immutable registry and a dedicated Phase 2 Studio test project.
- Server-authoritative combat state machine with scheduled basic attacks and active damage skills.
- Data-driven four-element effectiveness placeholder chart with cross-reference validation.
- Combat snapshot UI, rejection feedback and a dedicated Phase 3 Studio test project.
- Roblox Studio manual validation matrix for Phase 3 combat and multi-client isolation.

### Changed

- Migrated element IDs to `normal`, `fire`, `water`, `nature` and `wind`; limited equipped skills to three with level-based evolution-stage slots and same-element catalog validation.
- Replaced the default Phase 3 combat-test UI/runtime with Phase 4 world/capture presentation while preserving Phase 2 and Phase 3 regression suites.
- Marked Phase 4 `IN_PROGRESS` pending user-confirmed Roblox Studio validation.

- Recorded the user-confirmed passing Phase 3 Roblox Studio checklist and approval to integrate the combat test harness into `master`.
- Documented the approved open-world PvE direction, deferred arena PvP concept and user acceptance of Phase 3 as a completed combat test harness.
- Localized the current Home, starter selection, combat UI, element, role and skill display text to Vietnamese.
- Moved project-level Markdown into `docs/project/`, kept only `README.md` at repository root and updated internal documentation links.
- Updated design documentation to distinguish the approved creature, element, skill, progression and art targets from the current Phase 2–3 implementation and future phase work.
- Added `prod` as the production branch while retaining `master` for development/integration.
- Marked Phase 0 complete after pinned tool versions, formatting, lint and Rojo build were verified.
- Changed onboarding from selecting a three-creature team to selecting one of four starters.
- Documented a future original capture tutorial using a basic `Trail Capsule` and one of four opening routes.
- Verified the Phase 2 Studio suite with 11 passing tests and four entries in every registry catalog.
- Migrated all four starter skills to the explicitly supported `Damage` effect for the Phase 3 vertical slice; unsupported heal, shield and control effects remain unimplemented.

### Fixed

- End an open-world encounter when the owner retreats beyond the data-driven disengage range, allowing the companion to stop fighting and resume follow while the wild returns to spawn.
- Prevent a companion left inside a spawn zone from immediately acquiring another wild target while its owner is outside encounter range.
- Avoid a floating-point exact-boundary assertion in the Phase 3 rate-limit regression test.

- Delay `CombatGui` until the server confirms a starter, preventing starter/combat panels and pre-starter rate-limit feedback from appearing together.
- Replace the Home platform's 3D grass material with a flat surface so grass blades no longer obstruct the initial camera view.
- Resolve server/client bootstrap modules from sibling Rojo folders instead of invalid Script children.
- Give remote startup waits a bounded timeout with a server-startup diagnostic.
- Assign every player to the Home spawn, return respawned characters there and add a visible Home marker.
