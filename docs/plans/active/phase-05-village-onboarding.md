# Plan: Phase 5 — Làng và onboarding năm starter

## Outcome

Player mới xuất hiện tại Làng Mạch Nguồn, chọn một trong năm starter, hoàn tất tuyến tutorial chung ở
Bình Nguyên Khởi Sinh, guaranteed-capture Tumblet, quay lại Làng và tự mở một trong bốn world nguyên tố.
Kết thúc flow, player có đúng hai creature và quyền truy cập đúng hai world trong session.

## Route và authority

- Task type sau decision gate: `multi-session-initiative`.
- Direct decisions ngày 2026-08-09: flow hai world, world thứ hai do player chọn, production world names,
  Tumblet là guaranteed-capture creature và không có reward phụ.
- Canonical authority: `docs/phases/PHASE_ROADMAP.md` Phase 5,
  `docs/design/WORLD_EXPLORATION_PROGRESSION.md`, `docs/product/CREATURE_SYSTEM.md`,
  `docs/design/VISUAL_AUDIO_UI_DIRECTION.md`, `ARCHITECTURE.md`.
- Phase 0–4 là historical baseline và không được viết lại.

## Baseline

- Worktree sạch trên `master` khi bắt đầu ngày 2026-08-09.
- `HomeService` hiện tạo `HomePlaceholder` public và đưa mọi respawn về đó.
- `StarterSelectionService` giữ selection session-only, validate exact starter payload, rate-limit và
  commit collection một lần; client khởi động `WorldController` ngay sau selection.
- Registry hiện có đúng năm starter/năm element, chưa có Tumblet.
- Chưa có onboarding state machine, Village production shell, world gate authority hoặc Phase 5 tests.
- Phase 4 có session collection, encounter/capture và world slice có thể mở rộng nhưng không tự trở
  thành product rule Phase 5.

## In scope

- Story 05-01: public Village arrival và canonical onboarding authority.
- Story 05-02: five-starter selection end-to-end cùng UI/input/presentation.
- Story 05-03: tuyến tutorial Thường, guaranteed Tumblet capture, return và lựa chọn world nguyên tố.
- Pure/unit tests, integration seams, static/build validation và Studio test matrix.
- Session-only lifecycle, reset/respawn safety và two-client isolation.

## Out of scope

- DataStore/account persistence; NPC economy/quest/shop/crafting; Nhà Riêng; full world content kit.
- Manual throw/contact migration, XP/level/evolution, expedition energy, monetization/trading/PvP.
- Unlock rule cho world thứ ba đến thứ năm.
- Publish experience, upload asset, permission change, dependency mới, commit/push/merge.

## Technical direction

- Shared pure `OnboardingEngine` sở hữu state/transition và được phát triển TDD.
- `OnboardingService` sở hữu session state theo Player, snapshot, internal server transitions và remote
  intent validation; client không gửi step/completion flag.
- `VillageService` tạo greybox public hub, năm gate/landmark/signage, spawn và proximity anchors.
- Story 05-04 giữ camera Roblox `Custom`; `VillageService` phát physical gate touch và
  `OnboardingService` quyết định action/permission/debounce trước teleport. Client action button chỉ là
  fallback/feedback, không còn là đường travel bắt buộc.
- Starter commit gọi internal onboarding transition; capture success của đúng tutorial Tumblet gọi
  internal transition. World choice remote chỉ nhận exact elemental world ID ở đúng state/range/rate.
- Client chỉ render snapshot, navigation cue, loading/success/failure/invalid state và gửi interaction intent.
- Reset/respawn tái bind cùng state; PlayerRemoving cleanup toàn bộ session/controller/presentation.

## Milestones

1. Authority/Story docs và test seam.
2. Story 05-01 red-green-refactor, Village arrival và onboarding snapshot.
3. Story 05-02 selection integration, responsive input/UI và five-starter presentation.
4. Story 05-03 tutorial route, Tumblet transaction, return/world choice và integration.
5. Static/build/test evidence, Studio checklist, security review, regression audit và phase handoff.

## Risks và controls

- Capture guarantee bypass ngoài tutorial: bind server-owned encounter/wild identity và state; fail closed.
- Replay/duplicate grant: request fingerprint, one-way transition và collection transaction idempotency.
- Client spoof progress/world: exact payload, state, range, ownership, rate và permission validation.
- Respawn duplicate UI/controller/display: idempotent start/bind/cleanup và manual reset cases.
- Phase 4 regression: preserve existing remote behavior and run neighboring tests/build.
- Presentation scope creep: blockout/representative SFX/ambience only; no production NPC economy.

## Validation matrix

- TDD: exact payload, legal/illegal transition, replay, world whitelist and isolation seams.
- Static: `stylua --check src tests`, `selene src tests`, `git diff --check`.
- Build: default project and `artifacts/json/phase5-tests.project.json` if created.
- Studio Play Solo: full outcome, failure/retry/reset, desktop/touch/gamepad and readability.
- Studio Server & Clients: two-player isolation, spam/replay/other-player attempts and respawn.
- Review: authority, trust boundary, ownership, rate, idempotency, lifecycle, artifact/link audit.
- Manual matrix canonical: `docs/testing/PHASE5_STUDIO_TEST_MATRIX.md`.

## Progress log

| Ngày | Progress | Evidence/next |
| --- | --- | --- |
| 2026-08-09 | Decision gate hoàn tất; route `multi-session-initiative`; tạo plan và ba Story | Tiếp theo Story 05-01 theo TDD |
| 2026-08-09 | Triển khai state/validator/Village/UI/Tumblet/world choice; review và static/build pass | Story giữ `Verification`; chạy Studio matrix và bổ sung licensed audio |
| 2026-08-09 | Chấp nhận Story 05-04: camera tự do và cổng chạm để travel | Source/static/build triển khai; retest P5-A/B/D/E/F/I/J trong Studio |
| 2026-08-09 | Người dùng xác nhận P5-A–P5-J pass sau Story 05-04 | Story 05-04 `Done`; raw log/Studio version không được cung cấp; licensed audio/SFX vẫn pending |

## Verification record hiện tại

- Claim: source/static/build và Studio functional/multiplayer/exploit Phase 5 đạt cho implemented scope;
  licensed audio/SFX còn pending.
- Command or manual check: targeted StyLua check; `selene src tests`; Rojo build default và Phase 5;
  `git diff --check`; Markdown link/artifact audit.
- Execution time/date: static/build mới nhất 2026-08-09 21:28:16 +07:00; Studio được người dùng xác nhận
  ngày 2026-08-09, không cung cấp thời điểm chính xác.
- Exit code or pass/fail: các check trên exit 0; full `stylua --check src tests` exit 1 do baseline CRLF
  toàn repository, trong khi targeted changed-file check exit 0.
- Important result: exact validator/state, one-time Tumblet transaction, range/rate/replay, five-starter
  parity, two-world access, camera Custom, physical touch-gate và Phase 4 pre-onboarding gate có
  source/build evidence; P5-A–P5-J pass theo xác nhận người dùng.
- Untested: raw Studio Output/version không được cung cấp; licensed audio/SFX asset vẫn pending.
- Verdict: `supported` cho source/static/build và Studio implemented scope; Phase chưa `DONE` vì audio.

## TDD record

- Red: tạo `Phase5OnboardingTests.server.lua` trước source; `rojo build
  artifacts/json/phase5-tests.project.json -o artifacts/rbxlx/phase5-tests.rbxlx` exit 1 khi các module
  `OnboardingDefinitions`/`OnboardingEngine`/validator chưa tồn tại.
- Green: thêm pure state/validator/world definitions/Tumblet tối thiểu; cùng Rojo build exit 0.
- Refactor: thêm practice transitions, Studio negative UserId coverage, bounded replay ledger và lifecycle
  hardening; targeted changed-source StyLua, Selene và hai Rojo build exit 0 lúc 17:37:26 +07:00.
- Runtime: người dùng xác nhận `[Phase5OnboardingTests] 38 tests passed` sau Story 05-04 ngày 2026-08-09;
  raw Output và Studio version không được cung cấp để lưu trong repository.

## Completion rule

Không đánh dấu Phase 5 `DONE` nếu chưa có fresh automated/static/build evidence và Studio Play Solo +
Server & Clients evidence cho outcome. Nếu Codex không chạy được Studio, giữ Story ở `Verification`,
ghi `Untested` và bàn giao matrix chính xác cho người dùng.
