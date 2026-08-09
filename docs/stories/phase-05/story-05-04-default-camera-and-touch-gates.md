# Story 05-04: Camera tự do và cổng world chạm để di chuyển

## Status

`Done`

## Outcome

Player dùng camera gameplay mặc định của Roblox ở Làng Mạch Nguồn và tuyến tutorial; khi character
chạm đúng cổng, server tự thực hiện travel nếu state và quyền world hợp lệ mà không cần bấm nút UI.

## Authority

- Yêu cầu trực tiếp được người dùng chấp nhận ngày 2026-08-09.
- `docs/design/VISUAL_AUDIO_UI_DIRECTION.md`: camera gameplay cho phép xoay ở mức hợp lý, không phải
  top-down cố định.
- `docs/plans/active/phase-05-village-onboarding.md` và Stories 05-01–05-03 cho state, world access,
  server authority và session-only lifecycle hiện hành.

## Context

Phase 5 Studio test đã xác nhận flow hiện tại chạy được nhưng camera onboarding bị khóa bằng
`CameraType.Scriptable`, gây khó chịu ở cả Village và tutorial. Travel hiện còn phụ thuộc action button
dù player đã đi tới cổng; interaction mong muốn là physical touch với permission fail-closed.

## In scope

- Bỏ camera Scriptable/RenderStepped của onboarding; giữ Roblox camera `Custom` tại Village, tutorial
  và các landing world.
- Server nhận physical `Touched` từ normal gate, bốn elemental gate và các return gate.
- Touch normal gate bắt đầu tutorial ở đúng state; touch elemental gate chọn/mở world đầu tiên hoặc
  travel world đã mở; touch return gate đưa player về Village ở đúng state.
- Debounce/rate theo player, cleanup lifecycle và snapshot/feedback server hiện hành.
- Cập nhật pure tests và Studio matrix cho camera, auto-travel, locked gate và multiplayer isolation.

## Out of scope

- Đổi rule mở world: cuối onboarding vẫn chỉ có Normal và một elemental world do player chọn.
- ProximityPrompt, portal animation/VFX/SFX production, persistence, energy cost hoặc unlock world mới.
- Đổi layout Village/tutorial, combat/capture hoặc Phase 0–4 historical behavior.

## Gameplay decisions

- Camera ở Village và tutorial hoạt động như camera gameplay mặc định ở các world sau onboarding.
- Cổng travel kích hoạt khi character chạm cổng; action button không còn là interaction bắt buộc.
- Cổng locked, wrong-state hoặc không thuộc accessible world không teleport và không cấp quyền.
- Normal gate chỉ bắt đầu tutorial sau starter; elemental gate ở `WORLD_CHOICE_READY` vẫn là lựa chọn
  world nguyên tố đầu tiên; sau `COMPLETE` chỉ hai world đã mở có thể travel.

## Open questions

Không có quyết định chặn Story này.

## Acceptance criteria

- [ ] Camera giữ `CameraType.Custom` và player xoay/zoom bình thường tại Village và toàn tutorial.
- [ ] Sau starter, character chạm normal gate thì server chuyển sang `NORMAL_TUTORIAL` và teleport đúng
  một lần, không cần action button.
- [ ] Chạm normal gate trước starter hoặc chạm elemental gate sai state không teleport/advance/grant.
- [ ] Ở `WORLD_CHOICE_READY`, chạm một elemental gate hợp lệ mở đúng world đó và teleport đúng một lần.
- [ ] Sau `COMPLETE`, chạm Normal hoặc elemental world đã chọn travel; ba elemental world còn khóa
  không teleport.
- [ ] Chạm return gate từ tutorial/elemental landing đưa đúng player về Village; touch spam không tạo
  transition/teleport lặp hoặc ảnh hưởng player khác.
- [ ] Reset/respawn giữ state/location canonical và touch connection không duplicate.
- [ ] UI/snapshot vẫn render feedback nhưng không chiếm movement/camera hoặc là đường bắt buộc để travel.

## Technical notes

`VillageService` sở hữu geometry và chuyển `BasePart.Touched` thành callback `(Player, gate kind,
worldId?)`; nó không quyết định unlock. `OnboardingService` sở hữu mapping touch → action/state,
permission, rate/debounce và teleport. Player được suy ra server-side từ character chứa touching part;
không thêm remote hoặc payload client. Pure engine tiếp tục quyết định legal transition/access list.

## Security and exploit considerations

Không tin client position, userId, world access hoặc completion. Server phải xác nhận touching part thuộc
character của Player đang trong `Players`, exact state/world whitelist, accessible world và debounce.
Locked/wrong-state touch fail closed; multi-part `Touched` và respawn không được gây duplicate action.

## Validation plan

- Static checks: targeted StyLua, Selene và `git diff --check`.
- Build: default project và Phase 5 test project.
- Automated: mapping state/world touch intent, locked world, wrong state và access regression tại pure seam.
- Studio functional tests: Play Solo camera rotate/zoom, normal gate, first elemental choice, return và
  locked gate không teleport.
- Multiplayer tests: Server & Clients 2; simultaneous touch khác gate, isolation, reset và spam contact.
- Regression/exploit tests: touch trước starter, wrong state, locked world, repeated body-part touch và
  Phase 4 capture pre-onboarding.
- Playtest/game feel: travel xảy ra rõ ràng khi chạm, camera không giật/khóa tại Village/tutorial.

## Completion evidence

- Claim: source Story 05-04 dùng camera `Custom`, server physical touch-gate, pure permission resolution
  và per-player debounce; default/Phase 5 test projects build được.
- Command/check ngày 2026-08-09 21:28: targeted `stylua --check`; `selene src tests`; Rojo build
  `default.project.json` và `artifacts/json/phase5-tests.project.json`; `git diff --check`; source audit
  fixed-camera token và Phase 5 assertion count.
- Result: mọi command exit 0; Selene `0 errors`, `0 warnings`, `0 parse errors`; hai build pass;
  `git diff --check` pass; không còn `CameraType.Scriptable`; test project map 38 Phase 5 assertions.
- Studio evidence: ngày 2026-08-09 người dùng xác nhận P5-A/B/D/E/F/I/J pass sau Story 05-04, gồm
  camera, physical contact, locked gate, debounce, respawn và two-client isolation. Raw Output, Studio
  version và thời điểm chính xác không được cung cấp.
- Untested: không còn acceptance bắt buộc riêng của Story 05-04; licensed audio nằm ngoài scope Story này.
- Verdict: source/static/build và Studio acceptance `supported`; Story `Done` theo xác nhận người dùng.
