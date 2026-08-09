# Plan: Refactor roadmap Phase 5+ và quy trình dự án

## Outcome

Tạo roadmap Phase 5+ mới gồm các playable vertical increment nhỏ, đánh số nguyên liên tục, xen kẽ
logic/server, UI/input, model/animation/environment và camera/VFX/audio; đồng thời sửa
`PROJECT_PROCESS.md` để mọi product/design authority mới đều phải được inventory, phân loại,
trace và schedule mà không viết lại lịch sử Phase 0–4.

## Baseline

- Git working tree sạch trước khi sửa ngày 2026-08-09.
- Phase 0–4 là `DONE (historical)` và bất biến; task không tái kiểm chứng runtime/Studio của các phase này.
- Checkout hiện có năm starter/năm element, session collection/team, spawn đơn/cụm, shared encounter
  participant, auto-combat theo target/range và capture lock/transaction session theo target.
- Capture hiện dùng `baseChance + missingHealthBonus`; chưa có manual aim, trajectory/contact/miss production.
- Chưa có progression runtime, expedition energy production, DataStore, Nhà Riêng production, đội 3+6,
  stone/resonance, boss/economy/PvP hoặc production asset/UI/audio pipeline.
- CodeGraph evidence ngày 2026-08-09: `CaptureService.capture → EncounterService.completeCapture →
  RegionalWildService.capture`; current request chỉ có `encounterId`, `wildId`, `deviceId` và server
  kiểm tra inventory/range/lock/chance. Không dùng baseline này làm product authority.

## Authority

1. Yêu cầu trực tiếp ngày 2026-08-09.
2. `docs/product/*.md` cho accepted product rule.
3. `ARCHITECTURE.md` cho current architecture; `docs/design/*.md` phân biệt accepted direction,
   `DRAFT/TUNABLE` và `TBD`.
4. `docs/phases/PHASE_ROADMAP.md` mới chỉ schedule capability; không tự tạo gameplay rule.
5. Code/source chỉ là evidence về current implementation.

## Files in scope

- `docs/plans/active/phase-roadmap-project-process-refactor.md`
- `docs/phases/PHASE_ROADMAP.md`
- `PROJECT_PROCESS.md`
- `docs/phases/README.md` nếu cần đồng bộ index

## Files out of scope

- Mọi gameplay/test source, `default.project.json`, Rojo mapping và runtime implementation.
- Nội dung/acceptance/story/evidence lịch sử Phase 0–4.
- Công thức balance, permission, monetization, persistence policy hoặc gameplay decision mới.
- Tạo Story implementation cho bất kỳ phase tương lai nào.

## Inventory tài liệu

| Tài liệu | Vai trò | Trạng thái dùng trong plan |
| --- | --- | --- |
| `AGENTS.md`, `CODEX.md` | Invariant, authority, scope | Đã đọc toàn bộ |
| `ARCHITECTURE.md` | Current architecture/baseline | Đã đọc toàn bộ; không nâng thành product rule |
| `PROJECT_PROCESS.md`, `docs/WORKFLOW.md` | Process authority | Đã đọc; cần refactor process governance |
| `docs/product/GAME_VISION.md` | Fantasy, audience, camera, IP boundary | Đã inventory; có statement starter cũ |
| `docs/product/CORE_GAME_LOOP.md` | Core loop target và TBD | Đã inventory |
| `docs/product/COMBAT_RULES.md` | Accepted PvE authority/security boundary | Đã inventory |
| `docs/product/CREATURE_SYSTEM.md` | Current creature schema và target direction | Đã inventory |
| `docs/design/CAPTURE_SYSTEM.md` | Encounter/capture target, formula DRAFT, security | Đã inventory toàn bộ |
| `docs/design/CREATURE_ELEMENT_SKILL_SYSTEM.md` | Năm hệ, skill, level/evolution, delivery | Đã inventory toàn bộ |
| `docs/design/CREATURE_LOADOUT_PROGRESSION.md` | Rarity, stone, duplicate, 3+6, resonance/power | Đã inventory toàn bộ |
| `docs/design/OPEN_WORLD_COMBAT.md` | Open-world combat/current-vs-target/PvP | Đã inventory toàn bộ |
| `docs/design/PRIVATE_HOME_HOUSING.md` | Nhà, visit, showcase, statue, training | Đã inventory toàn bộ |
| `docs/design/VISUAL_AUDIO_UI_DIRECTION.md` | Cross-cutting presentation/accessibility budgets | Đã inventory toàn bộ |
| `docs/design/WORLD_EXPLORATION_PROGRESSION.md` | Làng, onboarding, world, expedition, event/economy | Đã inventory toàn bộ |
| Phase/story/plan indexes và template | Catalog/process structure | Đã đọc toàn bộ |

## Traceability matrix

`Current` mô tả checkout; `Status` mô tả authority, không phải implementation.

| Capability/mechanic | Source authority | Status | Current implementation | Old phase | Dependencies | Logic | UI/input | Model/animation | Audio/VFX | Persistence/security | Open decisions | Proposed new phase |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Core loop, onboarding | `CORE_GAME_LOOP`; `WORLD_EXPLORATION_PROGRESSION` onboarding | Target + DRAFT detail | Starter/session + Phase 4 slice, chưa production onboarding | 6,7,12,13 | Five-starter registry, public hub route | Tutorial state server | Tutorial/input shell | Hub + starter representatives | Camera/cues | One-time selection authority | Tutorial pacing/reward | 5–6 |
| Năm starter/năm element | `CREATURE_ELEMENT_SKILL_SYSTEM`; `WORLD_EXPLORATION_PROGRESSION` | Accepted; names/world DRAFT | Năm definition/năm element hiện có | 13 | Registry, content validation | Same-element validation | Selection parity | 5 silhouettes/rig | Element cue | Server grant once | Production names/chart | 5–6, 23–27 |
| Open-world combat | `COMBAT_RULES`; `OPEN_WORLD_COMBAT` | Accepted direction | Auto target/range placeholder | 11.5,12 | Encounter, delivery policy | Server combat state | HUD/intent | Representative rig | Camera/hit feedback | Remote validation | Formula/tolerance | 7–9 |
| Encounter đơn/cụm | `CAPTURE_SYSTEM`; `OPEN_WORLD_COMBAT` | Shared accepted; retarget DRAFT | Zones đơn/cụm + shared participants, partial membership | 4,10,13 | Spawn registry | Membership/retarget | Cluster state/target | Wild cluster | Aggro/telegraph | Claim/lifecycle | Assist/grace/retarget tuning | 7 |
| Target selection | `COMBAT_RULES`; `CAPTURE_SYSTEM` | Partly accepted, multi-main TBD/DRAFT | Server target placeholder | 11.5,12,16 | Cluster membership | Canonical target | Highlight/input | Target-readable rigs | Camera/cue | No client authority | Focus-fire policy | 7–10,21 |
| Contact/hit/miss | `COMBAT_RULES`; element/skill design | Accepted behavior; primitive TBD | Chưa có | 11.5 | Delivery definitions | Server contact resolve | Cast/telegraph feedback | Attack/hit anim | Hit/miss VFX/SFX | Position/timing abuse | Primitive/tolerance/latency | 8–9 |
| Manual aim/capture throw | `CORE_GAME_LOOP`; `CAPTURE_SYSTEM` | Accepted interaction; schema TBD | Chưa có | 11.5,12 | Contact resolver | Server attempt/contact | Hold–drag–release abstraction | Throw/reaction anim | Aim/camera/throw cues | Untrusted aim, rate/idempotency | Schema, miss/consume | 10 |
| Capture eligibility/formula/device | `COMBAT_RULES`; `CAPTURE_SYSTEM` | Full HP/lock accepted; formula DRAFT | 4 devices + simple chance | 4,11.5,13 | Contact + canonical target data | Pure resolver | Difficulty/result UI | Device/impact representative | Result cues | Atomic lock/transaction | Production curve/tier/names | 11 |
| XP/level/evolution | creature/skill design; world progression | Level/stages accepted; curve TBD | Shape/validation only | 5 | Reward credit | Server XP/level/evolution | Progress feedback | Evolution representative | Level/evolve cues | Idempotent grants | XP curve/scaling | 12 |
| Energy/expedition lifecycle | world progression | 7/7 direction; timing TUNABLE | Chưa có | 5 | Hub gateway, profile later | Departure/session state | Energy/return UI | Gate/safe-zone markers | Transition cues | Commit/idempotency | Recharge/overflow/recovery | 13,15 |
| HP/wipe/return | world progression; open-world combat | Accepted target | Phase 4 placeholder return, chưa team expedition HP | 5 | Multi-encounter state | Server HP/wipe | Team HP/return choice | Defeat/return anim | Wipe/return feedback | Snapshot lock | Revive policy later | 13,21 |
| Reward/participation/contribution/last-hit | `COMBAT_RULES`; world progression | Credit boundaries accepted; tables TBD | Capture grant session; no production reward | 5,17 | Encounter attribution | Server ledger | Reward explanation | Drop proxy | Reward cues | Anti-duplicate/abuse | Contribution/XP/drop tables | 12,28–29,31–32 |
| Public village | world progression; visual direction | Accepted role; content DRAFT | Phase 1 Home placeholder | 7,18 | Spawn/onboarding | Hub interaction shell | Navigation/signage | Village greybox | Lighting/ambience/music | Server gates | NPC content/economy | 5,31–32 |
| Private home/social visit | housing design | Accepted boundary; caps TBD | Chưa có production | 8 | Village route | Instance/invite lifecycle | Invite/permission UI | Home/showcase shell | Home ambience | Friend/owner/guest validation | Guest cap/instance tech | 14,16 |
| Statue/pedestal/training | housing design | Direction; values TUNABLE | Chưa có | 14 | Home, progression, persistence | Buff/settlement | Management UI | Pedestal/training props | Activation/XP cues | Owner-only/idempotent | Slots/rates/caps/cost | 17 |
| Persistence/migration | housing/loadout/world designs | Required direction; behavior details need decision | Session-only | 11 | Stable profile schema | Repository/session coordinator | Save status/recovery | N/A | Error cue | DataStore/migration/session protection | Recovery/conflict/retention | 15 then per-feature slices |
| Creature rarity | loadout progression | Species-fixed accepted; names/bands DRAFT | Chưa có production rarity | 13 | Species definitions | Canonical registry | Non-color-only treatment | Silhouette treatment | Rarity cue | Server definition/migration | Catalog/balance | 23–30 |
| Stone board 3×3/affinity | loadout progression | Structure accepted; roll/caps DRAFT | Chưa có | 15 | Owned instance + persistence | Affinity/unlock | Board UI | Stone proxies | Equip/line cues | Server RNG/ownership | Rates/line bonus/caps | 18 |
| Affix/skill modifier | loadout progression; skill design | Direction; pools/caps DRAFT | Chưa có | 15 | Stone/runtime capability tags | Equip/stat resolve | Explain deltas | Stone variants | Modifier feedback | Transaction/conflict | Pools/ranges/caps | 19 |
| Duplicate transfer/skill roll | loadout + skill designs | Same-species requirement accepted; values TBD | Chưa có | 15,18 | XP, skill pool, persistence | Server consume/grant | Confirm/candidate UI | NPC/material proxy | Roll/consume cues | Idempotent donor transaction | 20%, pity/candidate/material | 20 |
| Formation 3 main + 6 support | open combat; loadout | Accepted | Một companion session | 16 | Home loadout, encounter | Per-companion state | Formation/team HUD | 3 follow/combat rigs | Team combat cues | Snapshot/slot ownership | Target policy | 21 |
| Resonance/Team Power | loadout progression | Catalog principle accepted; formula DRAFT | Chưa có | 16 | Formation/stats | Canonical resolve | Preview/explanation | Formation presentation | Activation cue | No client totals | Catalog/caps/reference values | 22 |
| Five worlds/environment kits | vision; world + visual designs | Five accepted; names/content DRAFT | Một placeholder region | 10,13 | World registry + core combat | Region/spawn data | Route/map/signage | Kit/landmark per world | Lighting/ambience/music | Server spawn/gates | Names/budgets/content tables | 23–27 |
| Creature model/rig/animation | visual direction | Quality direction | 6-block anchored placeholders | 9 | State/event contracts | State binding | Readability | Rig/animation pipeline | Action SFX/VFX | Client presentation only | Asset budgets | 6–10 then every content phase |
| UI design system/input | visual direction | DRAFT quality gate | Debug/minimal UI | 6,12,19 | Input abstraction | State contracts | Responsive components | UI assets | UI audio | Client intent only | Typography/assets | Starts 5, extends every phase |
| Camera/HUD/target feedback | vision; visual direction | Camera accepted; details DRAFT | Minimal world UI | 12 | Encounter events | Authoritative snapshots | HUD/highlight | Readable silhouettes | Camera/VFX/SFX | No outcome fabrication | Camera/tolerance settings | 7–11,21,28–30 |
| VFX/SFX/ambience/music | visual direction | DRAFT direction/license gate | Placeholder/minimal | 6,12,19 | Asset pipeline/event contracts | Event-driven | Settings/feedback | Effect anchors | Per-slice assets | License/perf budgets | Production assets/mix | Every phase as needed |
| Elite | world progression | Non-capture accepted; values DRAFT | Chưa có | 17 | World/combat/reward | Server classification/loot | Threat/reward UI | Elite variant | Elite cue | Anti-capture/reward ledger | Spawn/multiplier/drop | 28 |
| World Boss | world progression | Direction; global tech/economy TBD | Chưa có | 17 | Persistence/event/reward | Contribution/event state | Event/contribution UI | Boss arena/model | Boss camera/audio/VFX | Cross-shard/anti-abuse | Coordinator/schedule/reward | 29 |
| Legendary | world + capture designs | Exclusive encounter direction; tuning TBD | Chưa có | 17 | High world + capture formula | Claim/lifecycle | Discovery/capture UI | Legendary representative | Discovery/capture cues | Exclusive lock/caps | Spawn/cooldown/table | 30 |
| NPC/quest | world progression | Direction; content/economy TBD | Chưa có | 18 | Village/persistence/reward | Quest state | Dialogue/board UI | NPC/facade | Interaction/reward cues | Server progress/grant | Quest/reward tables | 31 |
| Crafting/economy | world/capture/housing designs | Sources direction; values TBD | Chưa có | 18 | Material sources + persistence | Recipe/source/sink | Craft/shop UI | Craft props | Craft cues | Atomic consume/grant | Prices/recipes/currency | 32 |
| Mobile/accessibility/performance | visual direction | Cross-cutting required | Chưa có production evidence | 19 | Every slice | Budget telemetry | Touch/gamepad/safe area | LOD/rig budgets | Reduced effects/mix | Network budgets | Device targets/budgets | Smoke 5+, harden 33 |
| PvP/ranking/live expansion | open combat; world progression | Future direction/TBD | Chưa có | 20 | Stable PvE/profile/balance | Arena/result/ranking/release gates | Challenge/rank/update UI | Arena/content pack | PvP/rank/release cues | Accept/isolation/anti-abuse/compatibility | Matchmaking/ranking/reward/live rules | 33–35 |

## Conflict register

| ID | Statements và vị trí | Authority/handling | Resolution |
| --- | --- | --- | --- |
| C-01 | `GAME_VISION.md` “bốn starter/bốn element”; creature/world docs nói năm; Phase 1 history nói năm | Product docs mới và source baseline đều cho năm; history không được viết lại | Roadmap Phase 5+ dùng five-starter parity; giữ Phase 0–4 nguyên văn; ghi vision statement là stale |
| C-02 | `WORLD_EXPLORATION_PROGRESSION.md` nói Phase 1 lịch sử chỉ bốn starter; historical roadmap Phase 1 nói năm | Historical conflict, không đủ lý do sửa history | Không sửa Phase 0–4; migration/parity nằm Phase 5+ và Story phải xác minh baseline |
| C-03 | `CAPTURE_SYSTEM.md` nói valid attempt/failure tiêu bóng; cùng file để miss/consume policy `TBD` | Accepted failure boundary không quyết định mọi contact miss | Phase 10–11 tách contact/miss khỏi roll; Story bị gate bởi policy miss/consume cụ thể |
| C-04 | `CAPTURE_SYSTEM.md` DRAFT `EncounterRecord.ownerUserId`; accepted rule nói encounter shared nhiều participant | DRAFT schema thấp hơn accepted shared rule | Không schedule private cluster ownership; schema/coordinator phải được quyết định trước Story Phase 7 |
| C-05 | Shared encounter chung và legendary exclusive claim trong world design | Legendary là exception capability cụ thể nhưng details còn TBD | Phase 30 tách riêng; Story phải ghi explicit exclusive permission/lifecycle |
| C-06 | Các design doc còn nhắc old Phase 11.5/12 hoặc gán boss vào old Phase 5 | Đây là schedule cũ, không phải product rule | Bảng old→new là canonical migration; không dùng số thập phân trong roadmap mới |
| C-07 | Energy ghi `7/7`, 20 phút nhưng được đánh dấu DRAFT/TUNABLE; yêu cầu cấm tự chốt energy policy | Chưa đủ authority production | Schedule Phase 13 nhưng gate Story bằng decision recharge/overflow/recovery |
| C-08 | Capture formula có bảng DRAFT chi tiết trong khi current runtime dùng simple formula | DRAFT không thay current và không tự thành production acceptance | Phase 11 yêu cầu decision/balance trước Story; status vẫn `NOT_STARTED` |

## Quyết định tổ chức phase

- Phase 0–4 giữ nguyên văn về ngữ nghĩa và trạng thái.
- Phase 5+ đánh số nguyên liên tục; old Phase 11.5 bị tách thành contact, projectile/area và manual throw.
- Mỗi phase có đúng một observable playable outcome và đầy đủ schema bắt buộc.
- Presentation đi cùng mechanic/content; foundation được triển khai just-in-time từ Phase 5.
- Pattern discipline được kiểm tra bằng metadata từng phase: mỗi phase ≥2 lane; mọi cửa sổ ba phase có đủ
  `logic/server`, `UI/UX/input`, `model/environment/animation`, `audio/VFX/camera`; primary lane không lặp quá hai.
- Mobile/accessibility/performance có smoke budget từ Phase 5; Phase hardening cuối không phải lần đầu hỗ trợ.
- Persistence mở bằng profile/migration foundation rồi mỗi feature sau tự sở hữu schema/transaction slice.
- DRAFT/TBD được schedule như dependency/decision gate, không được viết thành acceptance production.

## Milestones

1. Inventory/traceability/conflict register.
2. Roadmap Phase 5+ và old→new mapping.
3. Process governance cho document intake/change impact/traceability/drift audit.
4. Static validation và diff review.

## Risks

- Roadmap dài có thể thiếu field hoặc vi phạm cửa sổ discipline; dùng script kiểm tra cấu trúc.
- Schedule có thể vô tình chốt DRAFT; review các từ `TBD`, `DRAFT/TUNABLE`, “decision required”.
- Index/process có thể lệch roadmap; link và phase-range được kiểm tra sau sửa.
- Historical Phase 0–4 có thể bị thay đổi do patch rộng; diff riêng section này phải bằng zero.

## Rollback

Chỉ revert ba tài liệu roadmap/process/index và active plan bằng patch có mục tiêu; không dùng reset/checkout,
không chạm thay đổi ngoài scope của người dùng.

## Progress log

| Ngày | Progress | Evidence/next |
| --- | --- | --- |
| 2026-08-09 | Đọc toàn bộ tài liệu bắt buộc, route `multi-session-initiative`, git sạch, tạo inventory/matrix/conflict register | CodeGraph current-source query pass; tiếp theo viết roadmap |
| 2026-08-09 | Thay roadmap cũ bằng Phase 5–35, refactor process intake/drift và đồng bộ phase index | Static verification pass lúc 15:48:55 +07:00; Phase 0–4 identical |

## Validation matrix

| Milestone/criterion | Evidence | Status |
| --- | --- | --- |
| Phase 0–4 bất biến | So sánh section với `git show HEAD`; identical | Pass |
| Phase 5+ số nguyên liên tục, tất cả `NOT_STARTED` | Parse 31 heading Phase 5–35 và status | Pass |
| Mỗi phase đủ schema | Parse 24 field bắt buộc cho 31 phase | Pass |
| Mỗi phase ≥2 discipline; mọi cửa sổ 3 đủ 4 lane | Mỗi phase ghi đủ bốn lane; window tự đạt | Pass |
| Không quá hai primary discipline liên tiếp | Script parse primary lane | Pass |
| Trace toàn bộ capability bắt buộc | Traceability matrix + phase catalog 5–35 | Pass |
| Old→new mapping đầy đủ | Mapping old Phase 5–20 và 11.5 → Phase 5–35 | Pass |
| Process có intake/impact/trace/drift workflow | Keyword/manual structure audit | Pass |
| Links/whitespace/diff hợp lệ | Relative-link check + `git diff --check` | Pass |

## Chưa kiểm chứng

- Không chạy Roblox Studio; task chỉ thay governance/documentation.
- Không retest Phase 0–4, không xác nhận asset/content/runtime Phase 5+.
- Không chốt bất kỳ formula, tuning, permission, persistence recovery hoặc live/PvP rule nào còn mở.

## Completion summary

Documentation refactor đã đạt scope và static validation ngày 2026-08-09. Giữ plan ở đúng đường dẫn
`active/phase-roadmap-project-process-refactor.md` theo yêu cầu trực tiếp; không chuyển sang `completed/`
trong task này. Roblox Studio không chạy vì không có runtime change và không dùng để claim gameplay.

### Verification record

- Claim: Roadmap Phase 5+ và process governance phản ánh inventory product/design hiện có mà không đổi Phase 0–4.
- Command or manual check: PowerShell parse phase/schema/discipline/status/history/process/link và `git diff --check`.
- Execution time/date: 2026-08-09 15:48:55 +07:00.
- Exit code or pass/fail: Exit code 0, pass.
- Important result: 31 future phase liên tục 5–35; mỗi phase đủ 24 field và bốn discipline; primary run ≤2;
  Phase 0–4 identical với `HEAD`; process controls và diff check pass.
- Untested: Roblox Studio/functional/multiplayer/playtest; gameplay source/test/runtime không thay đổi.
- Verdict: supported cho claim documentation/governance; không phải evidence gameplay implementation.
