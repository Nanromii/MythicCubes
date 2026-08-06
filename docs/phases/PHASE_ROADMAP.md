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
| 4 | Capture and Collection | `SOURCE_VERIFIED_STUDIO_PENDING` | Open-world PvE, capture và collection session |
| 5 | Progression and Expedition | `NOT_STARTED` | XP, level, energy, HP expedition và region gate |
| 6 | Visual, UI and Audio Foundation | `NOT_STARTED` | Art/UI/audio language và pipeline |
| 7 | Public Village Experience | `NOT_STARTED` | Làng Mạch Nguồn public hub |
| 8 | Private Home and Social Visits | `NOT_STARTED` | Nhà Riêng và friend invite |
| 9 | Creature Art and Animation v1 | `NOT_STARTED` | Thay cube placeholder bằng creature art |
| 10 | World Greybox and Environment Kits | `NOT_STARTED` | Greybox năm world và environment kit |
| 11 | Persistent Data | `NOT_STARTED` | Profile, migration và DataStore an toàn |
| 12 | Combat and Capture Presentation | `NOT_STARTED` | HUD, camera, VFX/SFX và capture feedback |
| 13 | Five Worlds and Rarity Content | `NOT_STARTED` | World, starter, rarity và content pack |
| 14 | Private Home Progression | `NOT_STARTED` | Statue, pedestal và training |
| 15 | Stone, Duplicate and Inventory UX | `NOT_STARTED` | Đá 3×3, duplicate và inventory UX |
| 16 | Formation, Resonance and Power | `NOT_STARTED` | Đội hình 3+6, resonance và Team Power |
| 17 | Elite, World Boss and Legendary | `NOT_STARTED` | Encounter hiếm và event cộng đồng |
| 18 | Village NPC, Quest and Crafting | `NOT_STARTED` | NPC, quest, crafting và economy nền |
| 19 | Mobile, Accessibility and Performance | `NOT_STARTED` | Thiết bị, accessibility và performance |
| 20 | PvP, Rankings and Live Expansion | `NOT_STARTED` | PvP, ranking và live content |

## Phase 0 — Project Foundation

- **Mục tiêu:** tạo repository nhất quán để các phase sau phát triển an toàn.
- **Scope:** source tree, Git, Rojo mapping, bootstrap tối thiểu, formatter, linter và tài liệu nền.
- **Dependency:** Git, Rojo, StyLua, Selene.
- **Gate:** JSON mapping hợp lệ, build/format/lint phù hợp và không có gameplay ngoài scope.
- **Trạng thái:** `DONE (historical)`; không mở lại nếu không có regression cụ thể.

## Phase 1 — Home and Starter Selection

- **Mục tiêu:** player xuất hiện tại Home và chọn đúng một starter đầu tiên.
- **Scope:** Home placeholder, bốn starter, server validation, session state và companion placeholder.
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
- **Scope mục tiêu:** companion follow, regional wild spawn, proximity engagement/disengage, leash,
  làm yếu, capture device, server result, collection và session team.
- **Dependency:** Phase 2–3.
- **Gate:** spawn/AI/target/range/ownership/inventory/idempotency server-authoritative; Studio một client
  và hai client; exploit-oriented remote cases.
- **Trạng thái:** `SOURCE_VERIFIED_STUDIO_PENDING`; source checkout đã có world/capture/collection
  modules, test project và Studio guide sau khi reconcile branch. Story `04-00-reconcile-phase4-source-evidence`
  ghi nhận source evidence; Studio acceptance một client/hai client vẫn chưa chạy.

## Phase 5 — Progression and Expedition

- **Mục tiêu:** nối combat/capture với XP, level, expedition và mở vùng.
- **Scope mục tiêu:** XP/level/evolution, energy 7/7 và recharge, HP expedition, return/wipe, reward và region gate.
- **Dependency:** Phase 4 acceptance và product decision về curve/energy.
- **Gate:** server tính XP/energy/evolution; departure idempotent; teleport không trừ sai; reward không duplicate.
- **Trạng thái:** `NOT_STARTED`; chưa code trước khi Phase 4 được reconcile.

## Phase 6 — Visual, UI and Audio Foundation

- **Mục tiêu:** đặt ngôn ngữ presentation thống nhất và pipeline asset.
- **Scope mục tiêu:** art bible blocky nguyên bản, palette/silhouette, UI components, input rule, audio direction,
  license checklist và performance budget.
- **Dependency:** Phase 0 và reference từ core loop.
- **Gate:** reference frame Studio, desktop/touch/gamepad rule, asset license và component feedback states.
- **Trạng thái:** `NOT_STARTED`; không biến thành polish phase duy nhất.

## Phase 7 — Public Village Experience

- **Mục tiêu:** thay Home placeholder bằng Làng Mạch Nguồn public hub.
- **Scope mục tiêu:** greybox làng, landmark, cổng, signage, lighting, ambience và interaction shell.
- **Dependency:** Phase 6; cần phối hợp Phase 18 NPC nhưng không chờ economy production.
- **Gate:** player spawn ở Làng, tìm được cổng/NPC/đường về Nhà, camera/navigation không kẹt.
- **Trạng thái:** `NOT_STARTED`.

## Phase 8 — Private Home and Social Visits

- **Mục tiêu:** tạo Nhà Riêng theo owner, tách khỏi Làng public.
- **Scope mục tiêu:** teleport, explicit friend invite, guest permission, owner-leave lifecycle, layout và display shell.
- **Dependency:** Phase 6–7.
- **Gate:** stranger không vào, guest read-only, invite có expiry/single-use, owner/guest isolation, placement budget.
- **Trạng thái:** `NOT_STARTED`.

## Phase 9 — Creature Art and Animation v1

- **Mục tiêu:** thay cube placeholder trong core loop bằng creature blocky có rig/animation.
- **Scope mục tiêu:** năm starter và wild đại diện, idle/move/aggro/basic/skill/hit/defeat/capture reaction.
- **Dependency:** Phase 2 identity, Phase 4 state reference, Phase 6 art pipeline.
- **Gate:** silhouette đọc được, animation khớp state server, collision/scale/performance/license đạt.
- **Trạng thái:** `NOT_STARTED`.

## Phase 10 — World Greybox and Environment Kits

- **Mục tiêu:** tạo năm không gian khám phá có bản sắc.
- **Scope mục tiêu:** greybox world, landmark, navigation, spawn/encounter space, biome kit, lighting và ambience.
- **Dependency:** Phase 6–7, creature scale Phase 9 và world rules Phase 5.
- **Gate:** route đọc được, không kẹt, camera/encounter space hợp lệ, performance được đo.
- **Trạng thái:** `NOT_STARTED`.

## Phase 11 — Persistent Data

- **Mục tiêu:** lưu profile và Nhà Riêng an toàn qua session.
- **Scope mục tiêu:** schema version, DataStore, migration, retry, session protection, shutdown và durable idempotency.
- **Dependency:** progression/expedition Phase 5, Nhà Riêng Phase 8 và schema đã ổn định.
- **Gate:** không overwrite active session, migration có test, retry không mất/nhân state, lỗi save quan sát được.
- **Trạng thái:** `NOT_STARTED`; không triển khai DataStore sớm hơn dependency.

## Phase 12 — Combat and Capture Presentation

- **Mục tiêu:** làm combat/capture dễ đọc và có feedback tốt.
- **Scope mục tiêu:** camera, HUD, target selection, HP/aggro/status, hold-drag-release, animation integration,
  VFX/SFX và onboarding.
- **Dependency:** Phase 4–6, 9–11 và encounter space Phase 10.
- **Gate:** người chơi hiểu target/HP/cooldown/result/failure; desktop/touch/gamepad; VFX không che target.
- **Trạng thái:** `NOT_STARTED`.

## Phase 13 — Five Worlds and Rarity Content

- **Mục tiêu:** mở rộng content theo world/starter/rarity trên pipeline đã kiểm chứng.
- **Scope mục tiêu:** region/spawn pool, five-starter parity, canonical rarity, skill/content pool và route đại diện.
- **Dependency:** Phase 5–12.
- **Gate:** world spawn đúng content, species rarity canonical, content validator, balance/performance/IP audit.
- **Trạng thái:** `NOT_STARTED`; rarity/capture policy còn cần decision riêng.

## Phase 14 — Private Home Progression

- **Mục tiêu:** biến Nhà Riêng thành collection/progression loop.
- **Scope mục tiêu:** statue inventory/placement, Bệ Cộng Hưởng, owner-only element buff, training slot, fixed XP,
  offline settlement và upgrade transaction.
- **Dependency:** Phase 5, 8, 11 và 13.
- **Gate:** ownership/guest isolation, non-stacking/cap, conflict validation, retry-safe XP/upgrade.
- **Trạng thái:** `NOT_STARTED`; số bệ/slot/rate/cap vẫn `TBD`.

## Phase 15 — Stone, Duplicate and Inventory UX

- **Mục tiêu:** tạo collection loop dài hạn qua đá và duplicate.
- **Scope mục tiêu:** stone board 3×3, immutable affinity, slot unlock, affix, skill modifier, duplicate XP/skill roll và inventory UX.
- **Dependency:** Phase 5, 6, 11, 13–14.
- **Gate:** ownership, affinity, unlock order, consume/grant idempotency, UI giải thích stat change.
- **Trạng thái:** `NOT_STARTED`; công thức và economy còn `DRAFT/TBD`.

## Phase 16 — Formation, Resonance and Power

- **Mục tiêu:** hỗ trợ đội 3 main + 6 support và Team Power dễ hiểu.
- **Scope mục tiêu:** formation tại Nhà, per-companion target/state, resonance catalog, statue integration và team HUD.
- **Dependency:** Phase 4–5, 11–15.
- **Gate:** support không trực tiếp spawn/đánh/nhận XP, exact combo mới activate, power không dùng current HP hay claim thắng chắc.
- **Trạng thái:** `NOT_STARTED`.

## Phase 17 — Elite, World Boss and Legendary

- **Mục tiêu:** thêm mục tiêu hiếm/event cộng đồng mà không phá trust boundary.
- **Scope mục tiêu:** elite không capture, loot/XP, World Boss schedule/contribution/reward, legendary exclusive spawn,
  announcement và presentation.
- **Dependency:** Phase 5, 11–16.
- **Gate:** daily cap, reward idempotency, contribution server-measured, classification/capture rule, cross-shard threat model.
- **Trạng thái:** `NOT_STARTED`; cần decision về MemoryStore/MessagingService và economy.

## Phase 18 — Village NPC, Quest and Crafting

- **Mục tiêu:** đưa NPC/economy thật vào Làng public.
- **Scope mục tiêu:** NPC cổng, chế bóng, thợ đá, tiến hóa, quest board, reward, recipe, statue exchange/shop hook.
- **Dependency:** Phase 7, 11 và source/sink Phase 5, 14–17.
- **Gate:** recipe/reward/price server-authoritative, consume/grant idempotent, không tự thêm Robux/paid product.
- **Trạng thái:** `NOT_STARTED`.

## Phase 19 — Mobile, Accessibility and Performance

- **Mục tiêu:** đạt chất lượng trên thiết bị mục tiêu.
- **Scope mục tiêu:** touch/gamepad, safe area, text/contrast, reduced effects, streaming/LOD, memory/network/render/audio budget.
- **Dependency:** presentation và system Phase 6–18.
- **Gate:** device matrix, profiler evidence, long session, owner/guest stress, reduced-quality mode không mất gameplay signal.
- **Trạng thái:** `NOT_STARTED`; duy trì budget smoke test từ các phase trước.

## Phase 20 — PvP, Rankings and Live Expansion

- **Mục tiêu:** thêm cạnh tranh và content expansion sau khi PvE/housing ổn định.
- **Scope mục tiêu:** challenge/accept, isolated arena, team validation, result/ranking, season reward và content release pipeline.
- **Dependency:** Phase 5–19 hoàn tất và có telemetry/balance đủ tin cậy.
- **Gate:** không auto-start, hai bên accept, arena isolation, disconnect/forfeit/reward idempotency, ranking không tin client.
- **Trạng thái:** `NOT_STARTED`; không bắt đầu trước khi PvE, team power, event, housing và device quality ổn định.

## Quy tắc chuyển phase

Chỉ chuyển phase khi:

1. Các Story bắt buộc của phase đã `Done` với evidence mới.
2. Integration test của phase đạt.
3. Studio functional/multiplayer test phù hợp đã được ghi.
4. Không còn finding nghiêm trọng chưa xử lý.
5. Product/architecture docs và decision liên quan đã cập nhật.
6. Phase tiếp theo có dependency rõ và không còn gameplay decision quan trọng chưa được chấp nhận.
