# Phase roadmap và trạng thái Epic

Tài liệu này là catalog đầy đủ của các Epic hiện tại. `PROJECT_PROCESS.md` giữ quy trình và bảng
trạng thái tóm tắt; file này giữ mục tiêu, phạm vi, dependency và gate của từng phase.

## Quy ước trạng thái

- `DONE (historical)`: có evidence lịch sử trong repository, chưa phải validation mới của task hiện tại.
- `AWAITING_SOURCE_VERIFICATION`: tài liệu hoặc branch nói đã có implementation nhưng checkout hiện tại chưa chứng minh đủ.
- `SOURCE_VERIFIED_STUDIO_PENDING`: source implementation đã có trong checkout nhưng chưa có evidence Roblox Studio đủ để đóng phase.
- `IN_PROGRESS`: đang có story implementation hợp lệ và còn acceptance chưa đóng.
- `NOT_STARTED`: chưa có implementation/acceptance production.
- `BLOCKED`: có blocker cụ thể cần người dùng hoặc môi trường giải quyết.

Phase là Epic, không phải một task duy nhất. Mỗi phase phải được chia thành Story có acceptance
criteria, implementation plan và validation evidence.

## Tổng quan

| Phase | Tên | Trạng thái hiện tại | Mục tiêu ngắn |
| --- | --- | --- | --- |
| 0 | Project Foundation | `DONE (historical)` | Repository, Rojo, Git và toolchain nền |
| 1 | Home and Starter Selection | `DONE (historical)` | Home và starter selection server-authoritative |
| 2 | Creature Data System | `DONE (historical)` | Data-driven creature, element, role và skill |
| 3 | Combat Vertical Slice | `DONE (historical)` | Combat harness server-authoritative |
| 4 | Capture and Collection | `DONE (historical)` | Open-world PvE, capture và collection session |
| 5 | Làng và onboarding năm starter | `NOT_STARTED` | Player mới xuất hiện ở Làng Mạch Nguồn, chọn một trong năm starter và hoàn tất tuyến hướng dẫn đầu tiên. |
| 6 | Tuyến khám phá đầu và creature pipeline | `NOT_STARTED` | Player đi từ cổng Làng tới một route Thường playable với starter rig/animation đại diện thay cube đơn. |
| 7 | Encounter cụm shared và target feedback | `NOT_STARTED` | Hai player có thể tham gia cùng cụm wild; membership, target và disengage đọc được mà không private cluster. |
| 8 | Melee contact, telegraph và displacement | `NOT_STARTED` | Melee có thể hit hoặc miss theo contact server-resolved; telegraph/knockback làm thay đổi kết quả quan sát được. |
| 9 | Projectile, area và lingering resolve | `NOT_STARTED` | Một projectile và một area/hazard đại diện có thể lệch hoặc hết hạn mà không auto-hit. |
| 10 | Ném bóng thủ công và capture contact | `NOT_STARTED` | Player hold–drag–release/analog để ném; bóng có thể trượt, chạm target hợp lệ hoặc bị race invalid. |
| 11 | Capture formula, device và transaction | `NOT_STARTED` | Một contact hợp lệ chạy qua device policy, full-HP eligibility, lock/roll/consume/grant server-side và feedback rõ. |
| 12 | XP, level và evolution vertical slice | `NOT_STARTED` | Combat/capture reward hợp lệ tăng XP, level/evolution cho một creature và trình bày thay đổi canonical. |
| 13 | Expedition energy, HP và return | `NOT_STARTED` | Player khởi hành qua cổng, giữ HP qua nhiều encounter và kết thúc/wipe về safe zone với energy commit đúng một lần. |
| 14 | Profile persistence và migration | `NOT_STARTED` | Reconnect/retry giữ collection, progression và expedition data canonical mà không nhân/mất state. |
| 15 | Nhà Riêng và social visit | `NOT_STARTED` | Owner vào Nhà Riêng, mời đúng friend và guest tham quan read-only rồi trở về Làng an toàn. |
| 16 | Tượng và Bệ Cộng Hưởng | `NOT_STARTED` | Owner đặt một tượng active theo hệ và thấy buff chỉ áp dụng đúng creature của mình trước expedition. |
| 17 | Khu Tập Luyện | `NOT_STARTED` | Owner gửi một creature hợp lệ vào training và nhận XP timestamp-settled đúng một lần online/offline. |
| 18 | Bảng đá 3×3 và inventory build | `NOT_STARTED` | Player equip/tháo đá đúng affinity, mở cell theo level và thấy line bonus/stat delta canonical. |
| 19 | Duplicate transfer và skill roll | `NOT_STARTED` | Owner tiêu đúng một duplicate cùng loài để transfer XP hoặc nhận skill candidate mà retry không tiêu hai lần. |
| 20 | Đội hình 3 chính + 6 phụ | `NOT_STARTED` | Ba main follow/đánh với state riêng; sáu support không spawn/nhận XP và loadout khóa khi khởi hành. |
| 21 | Resonance và Lực chiến ước lượng | `NOT_STARTED` | Exact catalog combo kích hoạt resonance cho main và UI giải thích Team Power canonical trước khi đi. |
| 22 | World Thường production slice | `NOT_STARTED` | Player hoàn tất một expedition route Thường với environment kit, rarity/content validation và full slice feedback. |
| 23 | World Lửa production slice | `NOT_STARTED` | Player hoàn tất một expedition route Lửa đọc được hazard/landmark và gặp content Lửa canonical. |
| 24 | World Nước production slice | `NOT_STARTED` | Player hoàn tất một expedition route Nước với đường đi/slow-defense identity và feedback accessible. |
| 25 | World Tự nhiên production slice | `NOT_STARTED` | Player hoàn tất một expedition route Tự nhiên với phân nhánh đọc được và content poison/armor được support. |
| 26 | World Gió và five-world parity | `NOT_STARTED` | Player hoàn tất route Gió và five-world tour đạt parity về onboarding, device input và quality smoke gates. |
| 27 | Elite encounter | `NOT_STARTED` | Player nhận biết, đánh bại và nhận reward từ elite; mọi capture attempt elite bị từ chối không consume. |
| 28 | World Boss công cộng | `NOT_STARTED` | Nhiều player đóng góp vào một boss event và mỗi account nhận tối đa một package canonical. |
| 29 | Legendary exclusive encounter | `NOT_STARTED` | Một legendary ở world cho phép được claim độc quyền, tranh chấp an toàn và capture bằng policy riêng. |
| 30 | Quest và NPC Làng | `NOT_STARTED` | Player nhận, theo dõi và hoàn thành một quest server-authoritative qua NPC/Bảng Nhiệm Vụ. |
| 31 | Crafting và economy foundation | `NOT_STARTED` | Player dùng material canonical để craft một capture device qua transaction idempotent và UI giải thích source/sink. |
| 32 | Mobile, accessibility và performance hardening | `NOT_STARTED` | Core PvE–housing–content route đạt device/accessibility/performance budgets đã smoke-test từ Phase 5. |
| 33 | PvP arena opt-in | `NOT_STARTED` | Challenge/accept và combat cách ly |
| 34 | Ranking và season transaction | `NOT_STARTED` | Result cập nhật rank canonical |
| 35 | Live content release slice | `NOT_STARTED` | Content pack versioned có rollback |

## Phase 0 — Project Foundation

- **Mục tiêu:** tạo repository nhất quán để các phase sau phát triển an toàn.
- **Scope:** source tree, Git, Rojo mapping, bootstrap tối thiểu, formatter, linter và tài liệu nền.
- **Dependency:** Git, Rojo, StyLua, Selene.
- **Gate:** JSON mapping hợp lệ, build/format/lint phù hợp và không có gameplay ngoài scope.
- **Trạng thái:** `DONE (historical)`; không mở lại nếu không có regression cụ thể.

## Phase 1 — Home and Starter Selection

- **Mục tiêu:** player xuất hiện tại Home và chọn đúng một starter đầu tiên.
- **Scope:** Home placeholder, năm starter, server validation, session state và companion placeholder.
- **Dependency:** Phase 0.
- **Gate:** selection một lần, invalid/retry/rate-limit bị xử lý server-side, presentation đúng owner.
- **Trạng thái:** `DONE (historical)`; giữ Studio guide làm regression matrix.

## Phase 2 — Creature Data System

- **Mục tiêu:** tạo nền data-driven cho creature và skill.
- **Scope:** typed definitions, owned creature shape, element, role, skill, validator, registry và fixtures.
- **Dependency:** Phase 0–1.
- **Gate:** ID/cross-reference/schema invalid bị từ chối; shared không giữ player state; test data validation.
- **Trạng thái:** `DONE (historical)`; không mở rộng schema nếu chưa có story.

## Phase 3 — Combat Vertical Slice

- **Mục tiêu:** chứng minh một trận combat end-to-end bằng harness.
- **Scope:** một creature mỗi phía, basic attack, active skill, cooldown, damage, element effectiveness,
  snapshot, request validation và kết thúc trận.
- **Dependency:** Phase 2 và starter flow.
- **Gate:** server tính damage/state; target/cooldown/ownership được validate; isolation hai client.
- **Trạng thái:** `DONE (historical)`; đây là harness, không phải combat production.

## Phase 4 — Capture and Collection

- **Mục tiêu:** open-world PvE vertical slice có encounter, capture và collection session.
- **Scope mục tiêu:** companion follow, regional wild spawn, shared encounter cho nhiều user hợp lệ,
  proximity engagement/disengage, leash, làm yếu, capture device, capture lock theo từng target,
  server result, collection và session team.
- **Dependency:** Phase 2–3.
- **Gate:** spawn/AI/target/range/participant membership/capture lock/inventory/idempotency
  server-authoritative; Studio một client và hai client; exploit-oriented remote cases.
- **Trạng thái:** `DONE (historical)`; Studio acceptance một client/hai client đã được xác nhận hoàn tất.
  Source checkout đã có world/capture/collection modules, test project và Studio guide sau khi reconcile branch.
  Story `04-00-reconcile-phase4-source-evidence` ghi nhận source evidence; Story `04-02-shared-encounter-capture-targeting-and-expedition-hp`
  ghi nhận acceptance Studio của Phase 4.

## Mapping roadmap cũ → roadmap mới

| Old phase | New phase(s) | Lý do tách/gộp/di chuyển |
| --- | --- | --- |
| 5 Progression and Expedition | 12–14 | Tách XP/evolution, expedition session và persistence để mỗi outcome có transaction/gate riêng. |
| 6 Visual, UI and Audio Foundation | 5–33; hardening 32 | Foundation triển khai just-in-time theo slice; Phase 32 chỉ harden evidence đã có. |
| 7 Public Village Experience | 5, 30–31 | Hub/onboarding đi sớm; NPC quest và crafting/economy chỉ mở khi data/reward đủ. |
| 8 Private Home and Social Visits | 15 | Giữ một vertical slice owner/invite/guest/showcase rõ ràng. |
| 9 Creature Art and Animation v1 | 6–11, 20, 22–29 | Asset/rig/animation đi cùng route/mechanic/content đại diện, không thành polish silo. |
| 10 World Greybox and Environment Kits | 6, 22–26 | Route đầu chứng minh pipeline; mỗi world production có acceptance riêng. |
| 11 Persistent Data | 14 rồi 15–33 theo feature | Persistence foundation chỉ mở sau schema progression; mỗi feature sở hữu migration slice. |
| 11.5 Contact/Control | 8–10 | Tách melee, projectile/area và manual capture để primitive/policy được quyết định độc lập. |
| 12 Combat/Capture Presentation | 7–11 và mọi content phase | HUD/camera/VFX/audio đi cùng authoritative mechanic, không đứng thành polish phase. |
| 13 Five Worlds and Rarity Content | 22–26, 29 | Tách từng world route; legendary chỉ sau event/capture/persistence prerequisites. |
| 14 Private Home Progression | 16–17 | Statue/pedestal và training có transaction/validation khác nhau nên tách. |
| 15 Stone, Duplicate and Inventory UX | 18–19 | Board/equip và donor/skill-roll là hai outcome độc lập. |
| 16 Formation, Resonance and Power | 20–21 | Multi-companion runtime tách khỏi build preview/resonance/power. |
| 17 Elite, World Boss and Legendary | 27–29 | Ba classification/lifecycle/reward model khác nhau cần ba phase. |
| 18 Village NPC, Quest and Crafting | 30–31 | Quest progression tách khỏi economy consume/grant. |
| 19 Mobile, Accessibility and Performance | Smoke gate 5–31; hardening 32 | Support bắt đầu sớm; phase cuối chỉ harden/profiler/device matrix. |
| 20 PvP, Rankings and Live Expansion | 33–35 | Tách arena, ranking/season và content release vì có authority, transaction và acceptance khác nhau. |

## Phase 5 — Làng và onboarding năm starter

- Outcome playable: Player mới xuất hiện ở Làng Mạch Nguồn, chọn một trong năm starter và hoàn tất tuyến hướng dẫn đầu tiên.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: GAME_VISION; WORLD_EXPLORATION_PROGRESSION onboarding; VISUAL_AUDIO_UI_DIRECTION.
- Current baseline: Phase 1 chỉ có Home/starter session historical; chưa có public hub/onboarding production.
- In scope: Village spawn, five-starter parity, tutorial state, interaction shell, UI design tokens đầu tiên, camera/ambience đại diện.
- Out of scope: NPC economy, persistence, full world content.
- Dependencies: Canonical five-starter registry; public-hub spawn; one-time starter authority.
- Product decisions required before Story: Tutorial pacing/reward và production names còn DRAFT/TBD.
- Logic/server slice: Server giữ onboarding/starter state và gate tương tác.
- UI/UX/input slice: Responsive selection/tutorial UI cho mouse, touch, gamepad.
- Model/environment/animation slice: Village greybox, năm starter display silhouette/blockout.
- Camera/VFX/audio slice: Camera 3/4, navigation cue, UI SFX và village ambience đầu tiên.
- Server/client ownership: Server xác nhận selection/progress; client chỉ gửi lựa chọn và render.
- Security/exploit risks: Spam/replay selection, spoof tutorial step, asset/IP audit.
- Persistence/data impact: Session-only; profile fields chỉ được draft để Phase persistence tiếp nhận.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 6 — Tuyến khám phá đầu và creature pipeline

- Outcome playable: Player đi từ cổng Làng tới một route Thường playable với starter rig/animation đại diện thay cube đơn.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: CREATURE_ELEMENT_SKILL_SYSTEM; VISUAL_AUDIO_UI_DIRECTION; world design.
- Current baseline: Một placeholder region và model anchored 6-block; chưa có pipeline asset production.
- In scope: Pipeline concept→rig→animation, route Thường greybox, follow/navigation và action set đại diện.
- Out of scope: Full five-world content, contact combat production.
- Dependencies: Onboarding gate; creature identity/state events; region registry.
- Product decisions required before Story: Asset budget, production names và final kit vẫn DRAFT.
- Logic/server slice: Server sở hữu route/spawn/state; animation bind vào state confirmed.
- UI/UX/input slice: Route/signage và fallback/loading feedback.
- Model/environment/animation slice: Starter + wild representative rig; idle/move/aggro/basic/hit/defeat.
- Camera/VFX/audio slice: Camera route, movement/basic cues, Thường ambience motif.
- Server/client ownership: Server state; client animation/camera only.
- Security/exploit risks: Model collision/query không được tạo gameplay hit; license/IP audit.
- Persistence/data impact: Không có durable content state; chỉ stable asset/content IDs.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 7 — Encounter cụm shared và target feedback

- Outcome playable: Hai player có thể tham gia cùng cụm wild; membership, target và disengage đọc được mà không private cluster.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: COMBAT_RULES; OPEN_WORLD_COMBAT; CAPTURE_SYSTEM encounter.
- Current baseline: Phase 4 có spawn group/shared participant partial và auto target placeholder.
- In scope: Canonical cluster membership, multi-participant lifecycle, deterministic retarget seam, target/aggro HUD.
- Out of scope: Contact hit/miss, three-main formation, production rewards.
- Dependencies: Spawn group identity; route/rig state binding.
- Product decisions required before Story: Assist range, grace time, retarget/focus policy DRAFT/TBD.
- Logic/server slice: Server claim/mutate membership không yield; participant/leash lifecycle.
- UI/UX/input slice: Cluster member list, target/highlight, disengage/failure feedback.
- Model/environment/animation slice: Cluster formation and aggro/return animation integration.
- Camera/VFX/audio slice: Readable encounter camera, aggro/target/return VFX/SFX.
- Server/client ownership: Server quyết định membership/target/range; client highlight không cấp quyền.
- Security/exploit risks: Concurrent claim, spoof encounter/target, stale snapshot, participant isolation.
- Persistence/data impact: Session coordinator only; event IDs prepared for later durable ledger.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 8 — Melee contact, telegraph và displacement

- Outcome playable: Melee có thể hit hoặc miss theo contact server-resolved; telegraph/knockback làm thay đổi kết quả quan sát được.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: COMBAT_RULES; skill design delivery; OPEN_WORLD_COMBAT.
- Current baseline: Auto combat hiện gây damage theo target/range, chưa có contact resolve.
- In scope: Delivery schema cho melee-contact, cast timing, contact volume, hit/miss, telegraph và displacement đại diện.
- Out of scope: Projectile/area, production damage formula, status catalog.
- Dependencies: Canonical encounter/target; representative rig/animation.
- Product decisions required before Story: Primitive, latency/tolerance, telegraph timing và miss/consume policy TBD.
- Logic/server slice: Server resolve cast/contact/displacement/cooldown; pure seams khi phù hợp.
- UI/UX/input slice: Cast state, telegraph, hit/miss và cooldown feedback cùng phase.
- Model/environment/animation slice: Melee wind-up/contact/hit/whiff/knockback animation.
- Camera/VFX/audio slice: Camera readability, telegraph, hit/whiff VFX/SFX.
- Server/client ownership: Client gửi cast intent; server đo state/position/timing và phát event.
- Security/exploit risks: Position/target spoof, replay/rate, double resolve, out-of-range cast.
- Persistence/data impact: Không durable; event/result IDs phải idempotent trong session.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 9 — Projectile, area và lingering resolve

- Outcome playable: Một projectile và một area/hazard đại diện có thể lệch hoặc hết hạn mà không auto-hit.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: COMBAT_RULES; skill delivery design; OPEN_WORLD_COMBAT.
- Current baseline: Chưa có projectile collision hoặc area placement production.
- In scope: Delivery registry projectile/area/hazard, authoritative trajectory/impact/overlap và representative assets.
- Out of scope: Full skill pool, status/economy, capture projectile.
- Dependencies: Melee resolver/event contract; validated skill definitions.
- Product decisions required before Story: Primitive/tick/tolerance và direct non-damaging exceptions TBD.
- Logic/server slice: Server resolve origin, path/impact, lifetime, overlap, effect/cooldown.
- UI/UX/input slice: Aim/placement preview chỉ là intent; hit/miss/expiry feedback.
- Model/environment/animation slice: Projectile, impact zone và hazard model/animation representative.
- Camera/VFX/audio slice: Camera framing, telegraph, impact/miss/expiry VFX/SFX.
- Server/client ownership: Client gửi normalized intent; server không tin collision/position/result.
- Security/exploit risks: Forged origin/direction, tunneling, duplicate impact, excessive instances.
- Persistence/data impact: Không durable; deterministic definition/version recorded in event.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 10 — Ném bóng thủ công và capture contact

- Outcome playable: Player hold–drag–release/analog để ném; bóng có thể trượt, chạm target hợp lệ hoặc bị race invalid.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: CORE_GAME_LOOP; COMBAT_RULES; CAPTURE_SYSTEM UX/security.
- Current baseline: Capture hiện chọn wildId theo target/range và không có aim/trajectory.
- In scope: Input abstraction, server attempt/contact, target overlay, throw/reaction presentation, target race handling.
- Out of scope: Production capture formula/economy và full device art catalog.
- Dependencies: Encounter target list; authoritative projectile/contact seam.
- Product decisions required before Story: Exact input schema, primitive, latency/tolerance và valid-miss consume policy TBD.
- Logic/server slice: Server validate attempt context và resolve contact candidate/miss.
- UI/UX/input slice: Hold–drag–release mouse/touch/stick, cancel/release/failure states.
- Model/environment/animation slice: Ball throw/impact/miss và wild reaction animation representative.
- Camera/VFX/audio slice: Aim camera, trajectory hint, throw/impact/miss SFX/VFX.
- Server/client ownership: Client aim/target hint untrusted; server canonical contact/result boundary.
- Security/exploit risks: Remote spam, forged aim/origin, stale target, lock race, request conflict.
- Persistence/data impact: Session request ledger; durable consume deferred tới persistence.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 11 — Capture formula, device và transaction

- Outcome playable: Một contact hợp lệ chạy qua device policy, full-HP eligibility, lock/roll/consume/grant server-side và feedback rõ.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: COMBAT_RULES; CAPTURE_SYSTEM formula/security.
- Current baseline: Bốn device và simple chance session đã có; target formula mới là DRAFT.
- In scope: Data-driven classification/device resolver, target lock, injected RNG, atomic consume/grant, difficulty/result UI.
- Out of scope: Crafting sources, legendary content, production economy.
- Dependencies: Manual contact outcome; canonical HP/level/stage/rarity data seams.
- Product decisions required before Story: Production curve/cap/tier/name, chance display và miss/consume distinction DRAFT/TBD.
- Logic/server slice: Server đọc canonical target/device, roll và commit logical transaction.
- UI/UX/input slice: Device selection, eligibility/difficulty, success/failure/inventory feedback.
- Model/environment/animation slice: Four-device representative models and capture reactions.
- Camera/VFX/audio slice: Result cadence, shake/reduced-effect alternative, capture SFX/VFX.
- Server/client ownership: Client không gửi HP/chance/RNG/contact/result; server ledger canonical.
- Security/exploit risks: Lock contention, retry/fingerprint conflict, duplicate grant/respawn/consume.
- Persistence/data impact: Session idempotency; durable ledger/profile schema declared for Phase 14.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 12 — XP, level và evolution vertical slice

- Outcome playable: Combat/capture reward hợp lệ tăng XP, level/evolution cho một creature và trình bày thay đổi canonical.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: creature/skill design level/evolution; combat reward boundaries.
- Current baseline: Owned shape có level/experience/slot validation; chưa có gain/evolution runtime.
- In scope: Server XP grant, level 1–100, stage 1/18/54, skill-slot unlock, representative evolution feedback.
- Out of scope: Production XP curve, broad reward/economy, special evolution.
- Dependencies: Canonical participation/capture/kill credit events; stable definitions.
- Product decisions required before Story: XP curve, participation share, scaling và special evolution TBD.
- Logic/server slice: Server attribute credit, apply XP/level/evolution exactly once.
- UI/UX/input slice: XP bar, level/evolution/slot unlock summary and failure states.
- Model/environment/animation slice: One evolution transition/model swap representative.
- Camera/VFX/audio slice: Level/evolution camera cue, VFX/SFX with reduced mode.
- Server/client ownership: Client chỉ render grant result; server quyết định credit/XP/stage/stats.
- Security/exploit risks: Forged reward, duplicate event, level overflow, invalid definition migration.
- Persistence/data impact: Session progression first; versioned fields/idempotency prepared for persistence.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 13 — Expedition energy, HP và return

- Outcome playable: Player khởi hành qua cổng, giữ HP qua nhiều encounter và kết thúc/wipe về safe zone với energy commit đúng một lần.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world progression energy/expedition; open-world combat HP rules.
- Current baseline: Chưa có production expedition/energy; current slice có return placeholder.
- In scope: Departure transaction, session snapshot, HP continuity, active/down/wipe, voluntary return, safe-zone heal.
- Out of scope: Offline recharge durability, items/revive, final balance.
- Dependencies: Village gate; progression state; encounter lifecycle.
- Product decisions required before Story: Recharge timing/overflow/reconnect recovery và energy policy production DRAFT/TBD.
- Logic/server slice: Server lock loadout, commit departure, track HP/wipe/return/heal.
- UI/UX/input slice: Energy/party HP/return destination/failure UI across inputs.
- Model/environment/animation slice: Gate transition, downed/return animations and safe-zone markers.
- Camera/VFX/audio slice: Departure/return camera/audio, wipe feedback, low-HP readability.
- Server/client ownership: Server owns energy/expedition/HP; client cannot request heal or alter snapshot.
- Security/exploit risks: Retry teleport/departure, disconnect, duplicate heal/refund, loadout mutation.
- Persistence/data impact: Session schema; durable energy/timestamp/active expedition deferred to Phase 14.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 14 — Profile persistence và migration

- Outcome playable: Reconnect/retry giữ collection, progression và expedition data canonical mà không nhân/mất state.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: ARCHITECTURE; housing/loadout/world persistence requirements.
- Current baseline: Mọi player data hiện session-only; không có DataStore production.
- In scope: Versioned profile, session protection, migration, retry/backoff, shutdown, durable idempotency và save status UI.
- Out of scope: Home/stone/event schemas chưa ổn định; monetization/trading.
- Dependencies: Stable collection/progression/expedition schema and transaction IDs.
- Product decisions required before Story: Conflict recovery, retention, active-expedition resume/fallback policy cần product/architecture decision.
- Logic/server slice: Server repository/coordinator owns load/save/migrate/commit ordering.
- UI/UX/input slice: Loading/save/error/recovery status; no false success.
- Model/environment/animation slice: Minimal safe-zone loading presentation.
- Camera/VFX/audio slice: Non-intrusive save/error cues; no gameplay signal loss.
- Server/client ownership: Client không gửi profile/version/commit; server validates ownership/session.
- Security/exploit risks: Concurrent session, stale overwrite, partial commit, retry/rejoin duplication.
- Persistence/data impact: Đây là persistence foundation; migration fixtures bắt buộc trước live schema.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 15 — Nhà Riêng và social visit

- Outcome playable: Owner vào Nhà Riêng, mời đúng friend và guest tham quan read-only rồi trở về Làng an toàn.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: PRIVATE_HOME_HOUSING; VISUAL_AUDIO_UI_DIRECTION.
- Current baseline: Home lịch sử là placeholder; chưa có private-home production.
- In scope: Home instance/layout/showcase shell, invite/accept/kick/expiry/lifecycle, owner/guest UI và ambience.
- Out of scope: Statue/training, full decoration economy, public discovery.
- Dependencies: Village teleport shell; persisted owner profile; Roblox friendship validation.
- Product decisions required before Story: Guest cap, instance technology và decoration budget TBD.
- Logic/server slice: Server owns home instance, invite, permission, placement/showcase references.
- UI/UX/input slice: Owner/guest role, invite expiry, accept/kick, read-only affordances.
- Model/environment/animation slice: Home greybox, showcase props, bounded placement preview.
- Camera/VFX/audio slice: Home camera/lighting/ambience and invite/permission cues.
- Server/client ownership: Client requests invite/placement; server revalidates friend, owner, bounds, budget.
- Security/exploit risks: Forged/reused invite, stranger join, guest mutation, owner-leave cleanup.
- Persistence/data impact: Persist home ID/layout/showcase canonical; invites remain session-only.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 16 — Tượng và Bệ Cộng Hưởng

- Outcome playable: Owner đặt một tượng active theo hệ và thấy buff chỉ áp dụng đúng creature của mình trước expedition.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: housing statue rules; loadout authority.
- Current baseline: Chưa có statue inventory/pedestal/buff.
- In scope: Statue definitions/inventory, display vs active pedestal, element buff snapshot, UI explanation.
- Out of scope: Training, statue economy/drop rates, multiple-system balance.
- Dependencies: Private home/profile; canonical element/stats; expedition snapshot.
- Product decisions required before Story: Pedestal counts, buff values/caps, acquisition tables DRAFT/TBD.
- Logic/server slice: Server validate ownership, element, non-stack, active state and stat recompute.
- UI/UX/input slice: Pedestal management, buff source preview, cap/error feedback.
- Model/environment/animation slice: Representative statue/pedestal placement and activation animation.
- Camera/VFX/audio slice: Activation VFX/SFX/lighting readable without color only.
- Server/client ownership: Guest cannot activate/benefit; server locks expedition snapshot.
- Security/exploit risks: Forged statue/element, stacking, mid-expedition mutation, duplicate activation.
- Persistence/data impact: Persist statue inventory/placement/active mapping with migration.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 17 — Khu Tập Luyện

- Outcome playable: Owner gửi một creature hợp lệ vào training và nhận XP timestamp-settled đúng một lần online/offline.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: PRIVATE_HOME_HOUSING training; progression authority.
- Current baseline: Chưa có training/facility/offline XP.
- In scope: Facility level/slots, assignment conflict, timestamp settlement, XP/evolution integration, management feedback.
- Out of scope: Production rates/cost/cap and economy.
- Dependencies: Private home/profile; XP resolver; canonical lineup/activity state.
- Product decisions required before Story: Slot count, rates, upgrade cost và elapsed cap policy DRAFT/TBD.
- Logic/server slice: Server settles whole-minute XP and validates assignment/withdraw/upgrade.
- UI/UX/input slice: Slot/timer/rate/settlement/evolution summary and confirm states.
- Model/environment/animation slice: Training prop and creature display snapshot.
- Camera/VFX/audio slice: Training ambience/activity/reward cues with effect budget.
- Server/client ownership: Guest/client clock cannot grant XP; server time and ownership canonical.
- Security/exploit risks: Clock spoof, double settlement, donor/lineup conflict, retry upgrade.
- Persistence/data impact: Persist facility/slots/timestamps; migration must not reroll or duplicate elapsed.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 18 — Bảng đá 3×3 và inventory build

- Outcome playable: Player equip/tháo đá đúng affinity, mở cell theo level và thấy line bonus/stat delta canonical.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: CREATURE_LOADOUT_PROGRESSION stone board; visual direction.
- Current baseline: Chưa có stone instance, affinity, board hoặc inventory UX.
- In scope: Nine affinity/unlock order, level unlock, equip/unequip, line resolve, basic rarity/affix schema, responsive board.
- Out of scope: Full drop/crafting economy and rare skill modifier effects.
- Dependencies: Persistent creature instance; level/evolution; private-home edit boundary.
- Product decisions required before Story: Affinity RNG, affix ranges, line bonuses/caps và fee DRAFT/TBD.
- Logic/server slice: Server creates affinity/order, validates slot/item uniqueness and recomputes stats.
- UI/UX/input slice: 3×3 board, locked/open/active line, stat delta, non-color rarity treatment.
- Model/environment/animation slice: Stone icons/models and board/pedestal presentation.
- Camera/VFX/audio slice: Equip/line activation SFX/VFX and reduced-effects alternative.
- Server/client ownership: Client sends instance IDs only; server owns RNG, stats, slots and conflicts.
- Security/exploit risks: Item duplication, dual equip, reroll on reconnect/migration, stat spoof.
- Persistence/data impact: Persist stone instances, affinity/order/equip/affix versioned and immutable where required.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 19 — Duplicate transfer và skill roll

- Outcome playable: Owner tiêu đúng một duplicate cùng loài để transfer XP hoặc nhận skill candidate mà retry không tiêu hai lần.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: loadout duplicate rules; creature skill-roll rules.
- Current baseline: Chưa có duplicate consume/transfer/roll transaction.
- In scope: Receiver/donor validation, combat-earned XP provenance, candidate generation/confirm/replace, material seams, UI/NPC shell.
- Out of scope: Production pity/count/material/economy and full skill content.
- Dependencies: Persistent inventory; XP resolver; skill pool/slot validation.
- Product decisions required before Story: Transfer rate, base XP, candidate count, pity, material quantity DRAFT/TBD.
- Logic/server slice: Server creates candidate and atomic consume/grant/replace ledger.
- UI/UX/input slice: Irreversible confirm, donor conflicts, candidate/replace UI and result explanation.
- Model/environment/animation slice: Nhà Đồng Vọng representative NPC/interaction prop.
- Camera/VFX/audio slice: Transfer/roll/reward cues without implying hidden odds not approved.
- Server/client ownership: Client cannot choose RNG result/XP; server validates same species/state/ownership.
- Security/exploit risks: Replay, donor double-spend, transferred-XP loop, equipped/training conflicts.
- Persistence/data impact: Durable transaction/fingerprint; donor removal and grant commit together.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 20 — Đội hình 3 chính + 6 phụ

- Outcome playable: Ba main follow/đánh với state riêng; sáu support không spawn/nhận XP và loadout khóa khi khởi hành.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: OPEN_WORLD_COMBAT; CREATURE_LOADOUT_PROGRESSION formation.
- Current baseline: Runtime có một companion/session team; chưa có 3+6 production.
- In scope: Formation editor, slot validation, three companion coordinator/targets/HP, support exclusion, team HUD/animation.
- Out of scope: Resonance/Team Power and final AI tuning.
- Dependencies: Home edit boundary; encounter cluster; expedition snapshot; persisted creatures.
- Product decisions required before Story: Per-companion target/focus rule và formation spacing tuning DRAFT/TBD.
- Logic/server slice: Server owns nine-slot snapshot and per-main combat state; support membership only.
- UI/UX/input slice: Formation editor, three-main HUD, target/down state and expedition lock feedback.
- Model/environment/animation slice: Three-rig follow/combat formation, collision/LOD budget.
- Camera/VFX/audio slice: Group camera framing, per-main hit/down cues and audio concurrency budget.
- Server/client ownership: Client cannot duplicate slots/spawn support/change expedition lineup.
- Security/exploit risks: Same instance in slots, target isolation, support reward leak, network/rig load.
- Persistence/data impact: Persist lineup; snapshot immutable for expedition and migration-valid.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 21 — Resonance và Lực chiến ước lượng

- Outcome playable: Exact catalog combo kích hoạt resonance cho main và UI giải thích Team Power canonical trước khi đi.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: CREATURE_LOADOUT_PROGRESSION resonance/Team Power.
- Current baseline: Chưa có resonance catalog hoặc power runtime.
- In scope: Catalog validation, beneficiary/stat cap resolve, canonical power estimate, preview/recommended range and activation feedback.
- Out of scope: Production catalog/formula/reference/balance and ranking use.
- Dependencies: Formation/final stats; stone/statue modifiers; home preview.
- Product decisions required before Story: Catalog, caps, reference stats, formula and display thresholds DRAFT/TBD.
- Logic/server slice: Server resolves exact IDs/effects and recomputes canonical power.
- UI/UX/input slice: Formation preview, sources/caps, estimated label and non-guarantee explanation.
- Model/environment/animation slice: Resonance link presentation around lineup.
- Camera/VFX/audio slice: Activation VFX/SFX and readable non-color signals.
- Server/client ownership: Client total ignored; support only activates catalog, never adds direct power.
- Security/exploit risks: Forged total/catalog, stacking overflow, stale snapshot, power used as hard win permission.
- Persistence/data impact: Persist selected lineup only; compute from versioned definitions, store definition version.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 22 — World Thường production slice

- Outcome playable: Player hoàn tất một expedition route Thường với environment kit, rarity/content validation và full slice feedback.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: world exploration; visual world kits; creature rarity rules.
- Current baseline: Một placeholder meadow exists; no production world kit/content pack.
- In scope: Normal world route/landmarks/spawn pool/representative species/loot seams, camera/audio/UI and mobile smoke.
- Out of scope: Other four worlds, final economy/balance.
- Dependencies: Expedition, formation, capture/progression, content registry.
- Product decisions required before Story: Production names, species/rarity/loot/difficulty tables DRAFT/TBD.
- Logic/server slice: Server validates region/spawn/classification/reward IDs.
- UI/UX/input slice: Route/world/difficulty/reward UI and accessibility cues.
- Model/environment/animation slice: Normal kit, landmarks and representative creature variants.
- Camera/VFX/audio slice: Normal ambience/music, combat transition and world VFX.
- Server/client ownership: Client cannot spawn content/rarity/reward; server gates region and reward.
- Security/exploit risks: Invalid content cross-ref, spawn/reward duplication, streaming boundaries.
- Persistence/data impact: Persist stable world/content IDs and versioned unlock/reward references.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 23 — World Lửa production slice

- Outcome playable: Player hoàn tất một expedition route Lửa đọc được hazard/landmark và gặp content Lửa canonical.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world exploration; visual kits; element/creature rules.
- Current baseline: Chưa có production Lửa world.
- In scope: Fire route, safe hazard rhythm, spawn/content registry, presentation and validation.
- Out of scope: Other worlds, final balance.
- Dependencies: Reusable world pipeline; expedition/content resolver.
- Product decisions required before Story: Hazard damage/timing, names, content/reward tables DRAFT/TBD.
- Logic/server slice: Server owns hazard timing/damage, spawn and reward.
- UI/UX/input slice: Hazard telegraph, route/map and reward feedback.
- Model/environment/animation slice: Fire kit/landmarks/creatures and hazard animation.
- Camera/VFX/audio slice: Fire lighting/VFX/ambience/music with reduced-effects mode.
- Server/client ownership: Client hazard visuals never decide damage; server validates region/state.
- Security/exploit risks: Hazard spoof/desync, streaming/contact, reward duplicate.
- Persistence/data impact: Stable content IDs; no new schema without migration impact review.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 24 — World Nước production slice

- Outcome playable: Player hoàn tất một expedition route Nước với đường đi/slow-defense identity và feedback accessible.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: world exploration; visual kits; element/skill rules.
- Current baseline: Chưa có production Nước world.
- In scope: Water route/kit, navigation motif, representative content/effect integration and validation.
- Out of scope: Nature/Wind worlds, final content balance.
- Dependencies: Reusable world pipeline; supported water effects only.
- Product decisions required before Story: Water path/effect/reward tables and names DRAFT/TBD.
- Logic/server slice: Server owns route gates, effect state, spawn/reward.
- UI/UX/input slice: Navigation/effect/HUD cues not relying on color/reflection.
- Model/environment/animation slice: Water kit, bridges/waterfalls, representative creatures.
- Camera/VFX/audio slice: Water ambience/music/VFX and mix/performance budgets.
- Server/client ownership: Client presentation cannot change slow/defense/outcome.
- Security/exploit risks: Path/streaming, effect spoof, reward duplicate, readability.
- Persistence/data impact: Content IDs/version and any unlock data migrate through profile.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 25 — World Tự nhiên production slice

- Outcome playable: Player hoàn tất một expedition route Tự nhiên với phân nhánh đọc được và content poison/armor được support.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world exploration; visual kits; element/skill rules.
- Current baseline: Chưa có production Tự nhiên world/effects catalog.
- In scope: Nature route/kit, branch landmarks, supported representative effect, spawn/reward validation.
- Out of scope: Wind world, full skill/status catalog and balance.
- Dependencies: Reusable world pipeline; approved runtime effect capabilities.
- Product decisions required before Story: Poison/armor formula/timing, names/content/reward tables DRAFT/TBD.
- Logic/server slice: Server owns branch gates, effect ticks/state and rewards.
- UI/UX/input slice: Branch navigation, status/effect and reward feedback.
- Model/environment/animation slice: Nature kit/root landmarks/creatures and effect animation.
- Camera/VFX/audio slice: Nature ambience/music/VFX with status accessibility cue.
- Server/client ownership: Client cannot apply ticks/buff/rewards or select canonical path state.
- Security/exploit risks: Tick duplication, effect stacking, navigation/streaming, reward abuse.
- Persistence/data impact: Versioned effect/content IDs; migration required before schema change.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 26 — World Gió và five-world parity

- Outcome playable: Player hoàn tất route Gió và five-world tour đạt parity về onboarding, device input và quality smoke gates.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: world exploration; visual kits; five-element authority.
- Current baseline: Chưa có production Gió world; five-world parity absent.
- In scope: Wind route/kit/content plus cross-world parity audit for routes, starter mapping, mobile/accessibility/performance.
- Out of scope: New worlds, legendary worlds and final optimization.
- Dependencies: Four prior world slices; shared content pipeline.
- Product decisions required before Story: Wind mechanics/content tables, five-world unlock/difficulty balance DRAFT/TBD.
- Logic/server slice: Server owns wind movement/effect/spawn/reward and parity definitions.
- UI/UX/input slice: Wind route/effect UI; cross-world input/safe-area/text audit.
- Model/environment/animation slice: Wind kit/highland landmarks/creatures; LOD parity.
- Camera/VFX/audio slice: Wind ambience/music/VFX; cross-world audio/particle budgets.
- Server/client ownership: Client movement intent bounded; server state/reward canonical.
- Security/exploit risks: Movement/position spoof, fall/recovery, streaming, content mismatch.
- Persistence/data impact: Stable five-world catalog and unlock version migration.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 27 — Elite encounter

- Outcome playable: Player nhận biết, đánh bại và nhận reward từ elite; mọi capture attempt elite bị từ chối không consume.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world progression elite; capture classification rules.
- Current baseline: Chưa có elite classification/spawn/reward production.
- In scope: Eligible spawn mutation, elite stats/AI, non-capture validation, reward ledger, presentation.
- Out of scope: World Boss, legendary, production spawn/drop balance.
- Dependencies: Five-world content; combat/capture/progression/persistence.
- Product decisions required before Story: Spawn rate, multipliers, XP/drop/caps DRAFT/TBD.
- Logic/server slice: Server selects classification, resolves combat/non-capture/reward.
- UI/UX/input slice: Elite threat/classification/reward and capture-rejection feedback.
- Model/environment/animation slice: Representative elite variant/animation treatment.
- Camera/VFX/audio slice: Elite telegraph/camera/VFX/SFX/music layer.
- Server/client ownership: Client cannot mark elite, bypass rejection or claim reward.
- Security/exploit risks: Classification spoof, duplicate loot, contribution/last-hit boundary, farming caps.
- Persistence/data impact: Durable defeat/reward ID and eligible content version.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 28 — World Boss công cộng

- Outcome playable: Nhiều player đóng góp vào một boss event và mỗi account nhận tối đa một package canonical.
- Primary discipline: `audio/VFX/camera`.
- Supporting disciplines: logic/server, UI/UX/input, model/environment/animation.
- Authority: world progression World Boss; combat authority.
- Current baseline: Chưa có boss/global coordinator/contribution ledger.
- In scope: Prototype event lifecycle, damage/tank/support contribution, reward claim, announcement/search UI, boss presentation.
- Out of scope: Global cross-shard production, final schedule/economy, legendary.
- Dependencies: Stable shared combat, persistence/reward ledger, world content.
- Product decisions required before Story: Coordinator tech, schedule, thresholds, anti-AFK/alt, reward table TBD.
- Logic/server slice: Server measures contribution and event/reward lifecycle; prototype scope explicit.
- UI/UX/input slice: Announcement without subzone leak, contribution/reward UI and failure/reconnect states.
- Model/environment/animation slice: Boss arena/model/telegraphs and crowd LOD.
- Camera/VFX/audio slice: Boss camera, layered VFX/SFX/music and reduced-effects signal.
- Server/client ownership: Client cannot report contribution/result; server coordinator canonical.
- Security/exploit risks: Cross-server replay, fake contribution, AFK/alt, double claim, load spike.
- Persistence/data impact: Durable WorldBossEventId and per-player claim ledger; cross-shard design decision required.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 29 — Legendary exclusive encounter

- Outcome playable: Một legendary ở world cho phép được claim độc quyền, tranh chấp an toàn và capture bằng policy riêng.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world progression legendary; capture classification.
- Current baseline: Chưa có legendary spawn/claim/content.
- In scope: Eligible-world exclusive spawn, claim/release lifecycle, legendary capture/device policy, discovery and presentation.
- Out of scope: Production roster/rates/cooldown/daily cap/announcement.
- Dependencies: High-world content; capture transaction; persistence.
- Product decisions required before Story: Roster, spawn/cooldown/caps, claim expiry and production capture tuning DRAFT/TBD.
- Logic/server slice: Server owns exclusive claim, combat/capture eligibility, release/reset.
- UI/UX/input slice: Discovery/claim/lock/difficulty/capture feedback without exact location leak.
- Model/environment/animation slice: Representative legendary model/animation and exclusive spawn set.
- Camera/VFX/audio slice: Discovery camera/audio/VFX and capture result treatment.
- Server/client ownership: Only claimant intents accepted; client cannot classify/spawn/release.
- Security/exploit risks: Claim race, disconnect/wipe release, outsider damage, duplicate capture/reward.
- Persistence/data impact: Durable spawn/capture/claim recovery policy must be decided before Story.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 30 — Quest và NPC Làng

- Outcome playable: Player nhận, theo dõi và hoàn thành một quest server-authoritative qua NPC/Bảng Nhiệm Vụ.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: world village/NPC/quest direction; visual direction.
- Current baseline: Village only has future shell; no production NPC/quest.
- In scope: NPC interaction contract, quest definition/state/progress/reward, dialogue/board UI and representative assets.
- Out of scope: Crafting/shop/full economy, live quest scale.
- Dependencies: Village; persistence/reward ledger; playable world events.
- Product decisions required before Story: Quest catalog, prerequisites, cadence, reward tables and localization TBD.
- Logic/server slice: Server validates progress from canonical events and commits reward.
- UI/UX/input slice: Dialogue/quest board/tracker/claim/error across inputs.
- Model/environment/animation slice: Representative NPC, board and interaction animation.
- Camera/VFX/audio slice: NPC/quest/reward SFX and village mix integration.
- Server/client ownership: Client cannot send progress/completion/reward; only accept/claim intent.
- Security/exploit risks: Quest replay, forged progress, duplicate claim, prerequisite bypass.
- Persistence/data impact: Versioned quest state and reward transaction migration.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 31 — Crafting và economy foundation

- Outcome playable: Player dùng material canonical để craft một capture device qua transaction idempotent và UI giải thích source/sink.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: world/capture/housing crafting sources; no monetization authority.
- Current baseline: Chưa có currency/material/recipe/economy production.
- In scope: Versioned material/currency/recipe definitions, craft consume/grant, NPC shop shell, audit counters and presentation.
- Out of scope: Robux/paid products, trading, full balance/live economy.
- Dependencies: Quest/wild/boss material sources; persistence inventory; capture devices.
- Product decisions required before Story: Currencies, recipes, prices, drop/source/sink tables and caps TBD; monetization out.
- Logic/server slice: Server prices/validates/commits consume and grant atomically.
- UI/UX/input slice: Recipe/source/missing material/confirm/result/inventory UI.
- Model/environment/animation slice: Crafting NPC/workbench/device presentation.
- Camera/VFX/audio slice: Craft/reward SFX/VFX and ambience integration.
- Server/client ownership: Client cannot submit price/count/result; server uses versioned recipe.
- Security/exploit risks: Replay, integer bounds, duplicate grant, stale recipe, economy abuse.
- Persistence/data impact: Durable inventory/recipe version/transaction ledger and migration.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 32 — Mobile, accessibility và performance hardening

- Outcome playable: Core PvE–housing–content route đạt device/accessibility/performance budgets đã smoke-test từ Phase 5.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: VISUAL_AUDIO_UI_DIRECTION; quality gates of every prior phase.
- Current baseline: Mỗi phase mới phải có smoke gate; chưa có full device/profiler evidence.
- In scope: Touch/gamepad parity hardening, safe area/text/contrast, reduced effects, streaming/LOD/network/audio budgets, long-session fixes.
- Out of scope: New gameplay/content, PvP rules.
- Dependencies: All representative routes/features and early smoke evidence.
- Product decisions required before Story: Target device matrix and numeric budgets require accepted technical decision.
- Logic/server slice: Server/network batching/budgets hardened without changing gameplay rules.
- UI/UX/input slice: Full input/safe-area/text-scaling/contrast/reduced-effects audit.
- Model/environment/animation slice: LOD/rig/streaming/placement budgets hardened.
- Camera/VFX/audio slice: Particle/light/audio/mix/camera comfort hardened.
- Server/client ownership: Accessibility settings are presentation only; no client gameplay authority expansion.
- Security/exploit risks: Low-device desync, network flood, hidden signals, owner/guest stress.
- Persistence/data impact: Profile settings schema/migration; no gameplay data policy change.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 33 — PvP arena opt-in

- Outcome playable: Hai player chủ động challenge/accept và hoàn tất một trận combat trong arena cách ly với result canonical.
- Primary discipline: `logic/server`.
- Supporting disciplines: UI/UX/input, model/environment/animation, audio/VFX/camera.
- Authority: OPEN_WORLD_COMBAT PvP future; world live direction.
- Current baseline: Chưa có PvP, ranking, season/live pipeline or authority details.
- In scope: Challenge/accept/decline, isolated arena, team validation, combat result/forfeit và PvP presentation.
- Out of scope: Ranking, season reward, live content release, automatic PvP và paid rewards.
- Dependencies: Stable PvE combat/profile/formation/device quality and telemetry/balance evidence.
- Product decisions required before Story: Arena technology, matchmaking, PvP formula và disconnect/forfeit policy đều TBD.
- Logic/server slice: Server owns challenge state, arena isolation, team validation, combat/result/forfeit.
- UI/UX/input slice: Challenge/accept/decline, arena HUD/result và accessibility.
- Model/environment/animation slice: Arena greybox/team spawn/presentation.
- Camera/VFX/audio slice: Arena camera, PvP cues/music and result feedback.
- Server/client ownership: Both players must accept; client cannot choose team/result/forfeit.
- Security/exploit risks: Forced match, outsider interference, invalid team, disconnect exploit, replay result.
- Persistence/data impact: Durable match/result ledger only after product/architecture decisions; chưa cập nhật rank.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, rig/particle/audio/network budget; số cụ thể phải được Story chốt từ device target.
- Required Stories: logic/data/security; presentation/content; Studio functional và multiplayer/exploit validation cho đúng outcome.
- Automated/static validation: Schema/registry/pure transaction/security tests liên quan; format, lint, build và regression phù hợp.
- Roblox Studio Play Solo validation: Chứng minh outcome end-to-end, success/failure, camera/input/readability và lifecycle chính.
- Roblox Studio Server & Clients validation: Kiểm tra isolation, race/retry/ownership và replication; nếu không có surface multiplayer, Story phải chứng minh lý do.
- Integration/regression gate: Không đổi acceptance Phase 0–4; core loop, server trust boundary và các slice prerequisite vẫn pass bằng evidence mới.
- Exit gate: Outcome playable được quan sát trong Studio; Stories bắt buộc có evidence; mọi DRAFT/TBD dùng bởi implementation đã có decision hoặc feature tương ứng không được mở.
- Status: `NOT_STARTED`

## Phase 34 — Ranking và season transaction

- Outcome playable: Một PvP result hợp lệ cập nhật ranking thử nghiệm đúng một lần và player xem được rank/season state canonical.
- Primary discipline: `UI/UX/input`.
- Supporting disciplines: logic/server, model/environment/animation, audio/VFX/camera.
- Authority: PvP/ranking future direction trong `OPEN_WORLD_COMBAT` và world progression; chưa có production rule.
- Current baseline: Chưa có ranking, season hoặc telemetry/balance production.
- In scope: Rating transaction seam, leaderboard view, season ID, disconnect/result eligibility, audit và presentation đại diện.
- Out of scope: Production formula/reward, cross-experience global scale, live content deployment và monetization.
- Dependencies: Accepted arena result ledger; stable identity/profile; anti-win-trading telemetry seam.
- Product decisions required before Story: Ranking formula, eligible modes, season cadence, reset, disconnect/forfeit và reward policy đều TBD.
- Logic/server slice: Server validates eligible result, applies versioned rating transaction and publishes canonical rank.
- UI/UX/input slice: Rank/season/placement/result explanation, loading/error and accessibility states.
- Model/environment/animation slice: Arena podium/profile rank treatment representative; không dùng màu làm tín hiệu duy nhất.
- Camera/VFX/audio slice: Rank-change/result cue có reduced-effects mode và không che thông tin.
- Server/client ownership: Client không gửi rating delta, placement, season reward hoặc leaderboard truth.
- Security/exploit risks: Win trading, replay result, alt farming, leaderboard scraping/load, season-boundary race.
- Persistence/data impact: Durable match→rating idempotency, season version và migration/reset policy bắt buộc.
- Performance/accessibility budget: Smoke desktop/touch/gamepad, safe area/text/contrast, leaderboard pagination/network/audio budget; số cụ thể phải được Story chốt.
- Required Stories: ranking transaction/security; rank/season presentation; Studio multiplayer và abuse validation.
- Automated/static validation: Rating invariants bằng injected definitions, idempotency/season-boundary/security tests; format, lint, build.
- Roblox Studio Play Solo validation: Dùng controlled fixture để kiểm tra rank UI, loading/error và non-color state; không claim multiplayer acceptance.
- Roblox Studio Server & Clients validation: Hai client result→rank, retry/disconnect/forfeit/duplicate và isolation/visibility cases.
- Integration/regression gate: PvP arena result vẫn canonical; profile migration và PvE state không bị sửa; Phase 0–4 bất biến.
- Exit gate: Một eligible result cập nhật rank đúng một lần với evidence; mọi formula/reward/season rule dùng đã có decision.
- Status: `NOT_STARTED`

## Phase 35 — Live content release slice

- Outcome playable: Một content pack versioned được bật trong môi trường test, xuất hiện đúng registry/presentation và rollback về version trước an toàn.
- Primary discipline: `model/environment/animation`.
- Supporting disciplines: logic/server, UI/UX/input, audio/VFX/camera.
- Authority: world content expansion direction; `VISUAL_AUDIO_UI_DIRECTION`; không có live-event/monetization authority production.
- Current baseline: Chưa có release catalog, feature gating, content migration hoặc rollback production.
- In scope: Versioned content manifest, validation, gated activation, client compatibility UI, representative asset/audio pack và rollback drill.
- Out of scope: Paid/live-event economy, production cadence, user segmentation và content scale chưa được duyệt.
- Dependencies: Stable registries/profile migration/device budgets; accepted compatibility and release ownership architecture.
- Product decisions required before Story: Release authority, rollout/rollback policy, compatibility window, telemetry gate và live reward policy đều TBD.
- Logic/server slice: Server validates manifest/version/dependencies, gates content and preserves canonical fallback.
- UI/UX/input slice: Update/compatibility/unavailable states và discovery feedback trên mọi input/device.
- Model/environment/animation slice: Một representative original content pack tuân asset/LOD/license budgets.
- Camera/VFX/audio slice: Pack có camera/VFX/audio integration, channel budgets và fallback khi asset thiếu.
- Server/client ownership: Client không tự bật content/version/reward; server manifest và compatibility gate canonical.
- Security/exploit risks: Manifest spoof, incompatible client/profile, partial rollout, stale cache, rollback duplication và asset license.
- Persistence/data impact: Content/version references phải forward/backward compatible; rollback không xóa/reroll owned data.
- Performance/accessibility budget: Pack phải pass device matrix, streaming/LOD, text/contrast, reduced effects, network/audio budgets trước activation.
- Required Stories: manifest/gating/rollback; representative pack/presentation; compatibility/device/Studio validation.
- Automated/static validation: Manifest/schema/cross-reference/migration/rollback fixtures, asset/license audit, format/lint/build.
- Roblox Studio Play Solo validation: Activate pack, traverse/use representative content, simulate missing/incompatible asset và rollback.
- Roblox Studio Server & Clients validation: Mixed join/rejoin/cache/activation boundary, consistent registry, rollback và no duplicate reward/state.
- Integration/regression gate: Core PvE/housing/PvP profile tải được ở version trước/sau; Phase 0–4 và canonical ownership không đổi.
- Exit gate: Pack activation và rollback đều observable/pass bằng evidence; live policy còn TBD không được đưa production.
- Status: `NOT_STARTED`

## Quy tắc chuyển phase và kiểm soát drift

Chỉ chuyển phase khi:

1. Mọi Story bắt buộc có authority, out-of-scope, threat model và evidence mới.
2. Automated/static, Play Solo và Server & Clients gate phù hợp đều được ghi pass; phần không chạy ghi rõ.
3. Không còn finding nghiêm trọng hoặc product decision được phase sử dụng còn TBD.
4. Dependency được kiểm tra theo capability thực, không chỉ theo số phase.
5. Traceability matrix và old→new mapping được cập nhật khi authority đổi.
6. Presentation, mobile/accessibility/performance của chính slice đạt budget; không defer toàn bộ sang Phase 32.
7. PROJECT_PROCESS.md document-intake/drift audit đã chạy và phase status chỉ đổi bằng completion evidence.

Phase 0–4 là historical baseline bất biến. Mọi migration behavior cũ, kể cả hitbox, projectile collision,
manual throw, persistence hoặc production presentation, bắt đầu ở Phase 5+ và không được backport vào
acceptance/history cũ.
