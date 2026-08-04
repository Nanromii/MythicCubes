# Quy trình và tiến độ dự án

## Tổng quan

| Phase | Tên                                | Trạng thái    | Mục tiêu                                                         |
| ----- | ----------------------------------- | --------------- | ------------------------------------------------------------------ |
| 0     | Project Foundation                  | `DONE`        | Repository, Rojo, Git, tài liệu và toolchain tối thiểu        |
| 1     | Home and Starter Selection          | `DONE`        | Home và lựa chọn một trong bốn starter có server xác nhận |
| 2     | Creature Data System                | `DONE`        | Mô hình dữ liệu sinh vật, hệ, vai trò và kỹ năng         |
| 3     | Combat Vertical Slice               | `DONE`        | Test harness chiến đấu bán tự động server-authoritative        |
| 4     | Capture and Collection              | `IN_PROGRESS` | PvE trên map, bắt sinh vật, collection và đội hình theo session |
| 5     | Progression and Expedition          | `NOT_STARTED` | Cấp độ, energy, HP expedition, boss và mở vùng                   |
| 6     | Visual, UI and Audio Foundation      | `NOT_STARTED` | Art bible, design system, audio direction và asset pipeline       |
| 7     | Public Village Experience           | `NOT_STARTED` | Làng public hub, NPC facade, cổng, landmark, lighting và ambience |
| 8     | Private Home and Social Visits      | `NOT_STARTED` | Nhà riêng, invite-only friend visit và trưng bày nền               |
| 9     | Creature Art and Animation v1       | `NOT_STARTED` | Thay cube placeholder cho starter/wild mẫu bằng rig/animation      |
| 10    | World Greybox and Environment Kits  | `NOT_STARTED` | Greybox năm world, biome kit, navigation, lighting và ambience     |
| 11    | Persistent Data                     | `NOT_STARTED` | Lưu profile an toàn, Nhà Riêng và migration                        |
| 12    | Combat and Capture Presentation     | `NOT_STARTED` | Camera, HUD, target, VFX/SFX và cảm giác bắt/chiến đấu             |
| 13    | Five Worlds and Rarity Content      | `NOT_STARTED` | Năm world/năm starter, rarity và content pack đại diện             |
| 14    | Private Home Progression            | `NOT_STARTED` | Tượng buff theo hệ, Bệ Cộng Hưởng và Khu Tập Luyện                 |
| 15    | Stone, Duplicate and Inventory UX   | `NOT_STARTED` | Đá 3×3, duplicate progression và màn hình quản lý                  |
| 16    | Formation, Resonance and Power      | `NOT_STARTED` | Ba main, sáu support, cộng hưởng, lực chiến và team HUD            |
| 17    | Elite, World Boss and Legendary     | `NOT_STARTED` | Encounter hiếm, event công cộng và nguồn tượng                     |
| 18    | Village NPC, Quest and Crafting     | `NOT_STARTED` | NPC thật, quest, crafting bóng/đá/tượng và economy nền             |
| 19    | Mobile, Accessibility and Performance | `NOT_STARTED` | Hoàn thiện thiết bị, khả năng tiếp cận và performance toàn game  |
| 20    | PvP, Rankings and Live Expansion    | `NOT_STARTED` | Arena PvP, bảng xếp hạng và mở rộng world/content dài hạn         |

Trạng thái hợp lệ: `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, `DONE`.

## Phase 0 — Project Foundation

- **Mục tiêu:** tạo nền tảng repository nhất quán để các phase sau phát triển an toàn.
- **Scope:** cấu trúc repository, Git, Rojo mapping, tài liệu, formatter, linter, tool checklist, hai bootstrap tối thiểu và build thử.
- **Deliverables:** `default.project.json`, source tree, bootstrap server/client, cấu hình development và toàn bộ tài liệu root.
- **Acceptance criteria:** cấu trúc/tài liệu đầy đủ; JSON Rojo hợp lệ; source strict và không có gameplay; StyLua/Selene sạch; `rojo build` thành công nếu tool có sẵn; diff chỉ thuộc Phase 0.
- **Out of scope:** mọi gameplay, asset nội dung, package bên thứ ba, publish và branch production.
- **Dependencies:** Git, Rojo CLI, StyLua, Selene; kiểm tra Studio/plugin cần thao tác thủ công.
- **Test thủ công:** kết nối `rojo serve`, xác nhận mapping và hai bootstrap, Play Test rồi đọc Output.
- **Trạng thái:** `DONE` — Rojo 7.7.0, StyLua 2.5.2 và Selene 0.31.0 đã được pin/cài; format check, lint và Rojo build đều trả exit code 0 ngày 2026-08-01.
- **Cập nhật gần nhất:** 2026-08-01.
- **Bước tiếp theo:** giữ validation foundation trong mọi phase; dùng binary pin trực tiếp nếu shim Rokit của terminal hiện tại chưa resolve được đường dẫn.

## Phase 1 — Home and Starter Selection

- **Mục tiêu:** người chơi xuất hiện tại Home và chọn một starter đầu tiên.
- **Scope:** một Home placeholder, UI chọn đúng một trong bốn starter, server validation lựa chọn và hiển thị một sinh vật placeholder cạnh người chơi; chưa cần chiến đấu hoặc capture hoàn chỉnh.
- **Deliverables:** flow vào Home, bốn starter definitions tối thiểu, request/response an toàn và presentation placeholder cho lựa chọn duy nhất.
- **Acceptance criteria:** chỉ một starter được chấp nhận một lần theo rule, server là nguồn sự thật, sinh vật đã chọn hiển thị đúng và reconnect có hành vi đã định nghĩa.
- **Out of scope:** combat hoàn chỉnh, capture, progression và DataStore production.
- **Dependencies:** Phase 0 `DONE`; quyết định tạm thời về session state khi persistence chưa có.
- **Test thủ công:** vào Play Test, chọn starter hợp lệ/không hợp lệ, thử gửi request lặp và kiểm tra hai phía client/server.
- **Trạng thái:** `DONE` — implementation đã hoàn tất và người dùng xác nhận rõ Phase 1 hoàn thành. Không bổ sung Roblox Studio version, log hoặc test output chi tiết vì chưa có dữ liệu đó trong repository.
- **Cập nhật gần nhất:** 2026-08-03.
- **Bước tiếp theo:** giữ `docs/guides/PHASE_1_STUDIO_TEST.md` làm regression matrix; không mở lại Phase 1 nếu không có regression cụ thể.

## Phase 2 — Creature Data System

- **Mục tiêu:** tạo nền dữ liệu data-driven cho sinh vật và kỹ năng.
- **Scope:** `CreatureDefinition`, `OwnedCreature`, `ElementDefinition`, `RoleDefinition`, `SkillDefinition`, validation và dữ liệu mẫu tối thiểu.
- **Deliverables:** typed definitions, validator, registry nhỏ và test case hợp lệ/không hợp lệ.
- **Acceptance criteria:** definition sai bị từ chối rõ ràng, ID duy nhất, không hardcode data trong service và module shared không chứa player state.
- **Out of scope:** hàng trăm nội dung, combat/capture đầy đủ và balance production.
- **Dependencies:** Phase 0; yêu cầu starter từ Phase 1 được ghi nhận.
- **Test thủ công:** nạp registry trong Studio, kiểm tra log validation và thử các fixture sai có chủ đích.
- **Trạng thái:** `DONE` — typed schema, bốn catalog definition, validator, registry và test project đã được triển khai; Studio suite đạt 11/11 test và registry trả đúng `4 4 4 4` ngày 2026-08-02.
- **Cập nhật gần nhất:** 2026-08-02.
- **Bước tiếp theo:** không mở rộng schema ngoài nhu cầu thật; chuẩn bị thiết kế combat state machine khi Phase 3 được bắt đầu.

## Phase 3 — Combat Vertical Slice

- **Mục tiêu:** chứng minh một trận chiến bán tự động end-to-end.
- **Scope:** vertical slice hiện dùng một sinh vật mỗi phía để chứng minh tự tìm mục tiêu, đánh thường, kỹ năng chủ động, cooldown, damage, khắc hệ và kết thúc trận; kiến trúc sản phẩm hướng tới đội tối đa ba sinh vật.
- **Deliverables:** combat state server-authoritative, request kỹ năng, kết quả replicate và deterministic tests cho logic thuần.
- **Acceptance criteria:** client không quyết định damage; target/cooldown/state được validation; trận kết thúc nhất quán và test công thức ổn định.
- **Out of scope:** PvP, matchmaking, balance quy mô lớn và VFX hoàn chỉnh.
- **Dependencies:** Phase 2 và starter flow đủ dùng.
- **Test thủ công:** chơi nhiều starter matchup, thử spam remote/target sai và kiểm tra kết thúc thắng-thua.
- **Trạng thái:** `DONE` — người dùng xác nhận checklist Roblox Studio đạt và chấp nhận combat vertical slice hiện tại là test harness hoàn thành ngày 2026-08-03. Implementation có server state, basic attack, active skill, cooldown, snapshot UI, request validation và terminal validation. Studio version/raw Output log không được cung cấp; trạng thái này không xác nhận test UI là combat production.
- **Cập nhật gần nhất:** 2026-08-03.
- **Bước tiếp theo:** giữ Studio guide làm regression checklist; không mở rộng test harness. Lập kế hoạch Phase 4 riêng cho open-world PvE trước khi viết code.

## Phase 4 — Capture and Collection

- **Mục tiêu:** đưa combat/capture vào một vertical slice PvE trực tiếp trên map và quản lý sinh vật sở hữu.
- **Scope:** companion follow, regional wild spawn tối thiểu theo cá thể/cụm, proximity engagement/disengage, làm yếu mục tiêu, hai thiết bị bắt, server quyết định kết quả, collection, đội hình và kho sinh vật.
- **Deliverables:** wild lifecycle/AI tối thiểu, regional spawn definition, range/leash rule server-authoritative, capture request an toàn, inventory consumption, owned creature record và UI/flow quản lý cơ bản.
- **Acceptance criteria:** server sở hữu spawn/AI/target/distance; người chơi có thể vào và rời engagement theo rule; ownership/inventory/encounter/range được kiểm tra; capture không nhân đôi vật phẩm hoặc sinh vật.
- **Out of scope:** trading, marketplace, collection hàng trăm sinh vật.
- **Dependencies:** Phase 2 và Phase 3.
- **Test thủ công:** spawn cá thể/cụm đúng vùng, companion/wild aggro đúng tầm, chạy xa để disengage, bắt thành công/thất bại, inventory thiếu, request lặp và collection đầy.
- **Trạng thái:** `IN_PROGRESS` — migration năm hệ/ba slot, region vertical slice, spawn đơn/cụm, companion follow, server encounter/leash/damage, hai capture device, transaction idempotent, collection session, UI tiếng Việt và suite Phase 4 đã được triển khai. Terminal validation phải đạt đầy đủ; Studio matrix vẫn chờ người dùng chạy/xác nhận nên phase chưa được phép chuyển `DONE`.
- **Cập nhật gần nhất:** 2026-08-03.
- **Bước tiếp theo:** chạy [PHASE_4_STUDIO_TEST.md](../guides/PHASE_4_STUDIO_TEST.md) với một và hai client, ghi actual result/Output; chỉ sau xác nhận của người dùng mới review merge vào `master`.

## Phase 5 — Progression and Expedition

- **Mục tiêu:** tạo vòng tiến triển từ chiến đấu đến vùng mới.
- **Scope:** XP, level 1–100, evolution mốc 18/54, stat scaling, expedition energy 7/7 hồi 20 phút, HP giữ xuyên encounter, hồi đầy tại Làng/Nhà Riêng, team wipe return và boss/region unlock tối thiểu.
- **Deliverables:** XP curve, evolution/stat rules, expedition state machine/idempotent departure, reward grant và region gate.
- **Acceptance criteria:** server tính XP/level/evolution/energy; chỉ khởi hành qua cổng Làng trừ đúng một, teleport Làng–Nhà không trừ; offline recharge đúng; không tự hồi ngoài world; wipe đủ đội về Nhà Riêng; boss reward không nhận lặp.
- **Out of scope:** stone, duplicate skill roll, resonance, global event, PvP và nhiều world production.
- **Dependencies:** Phase 3, Phase 4 và region definitions tối thiểu.
- **Test thủ công:** XP/evolution boundary, energy/reconnect/teleport retry, HP xuyên encounter, chủ động return Làng/Nhà đều hồi đầy, wipe về Nhà Riêng, boss reward và region gate.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** chỉ bắt đầu sau Phase 4 acceptance; chốt XP curve và expedition schema trước code.

## Phase 6 — Visual, UI and Audio Foundation

- **Mục tiêu:** đặt ngôn ngữ presentation thống nhất trước khi sản xuất thêm nhiều màn hình, map và sinh vật.
- **Scope:** art bible voxel nguyên bản, palette/silhouette năm hệ, UI design system tiếng Việt, input abstraction, audio direction, asset/licensing pipeline và budget hiệu năng.
- **Deliverables:** style guide, component kit mẫu, HUD wireframe, asset naming/import checklist, audio map và budget cho rig/part/particle/light/audio.
- **Acceptance criteria:** có reference frame chạy được trong Studio; desktop/touch/gamepad có rule chung; rarity không chỉ dựa vào màu; asset có nguồn/license; feature mới không dùng raw default UI trừ debug.
- **Out of scope:** model đủ toàn bộ creature, map production, toàn bộ UI feature và nhạc hoàn chỉnh.
- **Dependencies:** Phase 0 về IP/toolchain và Phase 4 làm reference cho core loop hiện tại; không cần chờ toàn bộ logic tương lai.
- **Test thủ công:** reference scene trên device emulator, safe area/text scaling, contrast, input focus, asset import và profile budget ban đầu.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** chốt reference frame Làng/Nhà Riêng/exploration/combat và bộ UI component nhỏ trước khi mở asset production.

## Phase 7 — Public Village Experience

- **Mục tiêu:** thay khu xuất hiện placeholder bằng Làng Mạch Nguồn public hub có bố cục, landmark và trải nghiệm di chuyển dễ nhớ.
- **Scope:** greybox làng, quảng trường/năm cổng, khu NPC tương lai, teleport point tới Nhà Riêng, signage, lighting, ambient sound và interaction shell không giả có gameplay.
- **Deliverables:** public-hub layout, navigation landmarks, modular village kit bản đầu, NPC facade có nhãn trạng thái và camera/onboarding pass.
- **Acceptance criteria:** người chơi luôn xuất hiện ở Làng; tìm được cổng/NPC/điểm về Nhà không cần menu ẩn; facade chưa hoạt động báo rõ; spawn/camera không kẹt; desktop/mobile dùng được.
- **Out of scope:** Nhà Riêng, quest/crafting/economy transaction thật, model NPC cuối và toàn bộ decoration production.
- **Dependencies:** Phase 6 presentation foundation; dùng flow `Home` placeholder hiện tại làm functional reference nhưng không coi nó là target Home.
- **Test thủ công:** first-join route, năm cổng/khu chức năng, teleport point shell, camera collision, touch navigation, lighting và ambient mix.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** blockout Làng theo chức năng Phase 18 để tránh xây lại khi NPC gameplay xuất hiện.

## Phase 8 — Private Home and Social Visits

- **Mục tiêu:** tạo Nhà Riêng thật sự cho mỗi user, tách khỏi public hub và có nền social/showcase an toàn.
- **Scope:** một Nhà theo owner, teleport Làng–Nhà, friend-only explicit invite, accept/kick/owner-leave lifecycle, layout nền, creature/statue display shell và placement budget.
- **Deliverables:** private-home instance flow, invite token/permission model, owner/guest UI, showcase placement schema, Nhà modular kit và reserved area cho pedestal/training.
- **Acceptance criteria:** chỉ friend được chủ mời mới vào; guest read-only; owner leave/kick đưa guest về Làng; teleport Nhà không tốn energy; display không clone/xóa ownership; layout đạt budget.
- **Out of scope:** statue buff, passive XP, full decoration catalog, trading và public home browser.
- **Dependencies:** Phase 6 UI/art foundation và Phase 7 public hub/teleport point.
- **Test thủ công:** owner/friend/stranger, invite giả/hết hạn/retry, kick/leave, multi-guest cap, placement bounds, display ownership, touch UI và performance.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** prototype một Nhà owner + một guest invite end-to-end trước decoration production.

## Phase 9 — Creature Art and Animation v1

- **Mục tiêu:** bỏ cảm giác chỉ nhìn các cục cube trong core loop sớm nhất có thể.
- **Scope:** concept/silhouette, model blocky modular, rig và animation set tối thiểu cho năm starter cùng nhóm wild vertical slice đại diện năm hệ.
- **Deliverables:** production pipeline creature, model/rig mẫu, idle/move/aggro/basic/skill/hit/defeat/capture reaction và scale/collision convention.
- **Acceptance criteria:** năm starter và wild mẫu không còn cube đơn; silhouette/hệ đọc được ở camera gameplay; animation state khớp server state; asset đạt budget và không sao chép IP.
- **Out of scope:** toàn bộ catalog, model cho mọi evolution và mọi loài thuộc các bậc rarity, cinematic và animation polish cuối; rarity không phải variant roll của cùng một loài.
- **Dependencies:** Phase 2 data identity, Phase 4 state reference và Phase 6 visual/audio foundation.
- **Test thủ công:** follow, cluster combat, capture success/failure, defeated state, showcase snapshot, animation interruption, camera scale và stress nhiều rig.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** làm một starter hoàn chỉnh end-to-end rồi nhân pipeline sang bốn starter còn lại và wild mẫu.

## Phase 10 — World Greybox and Environment Kits

- **Mục tiêu:** cho người chơi khám phá năm không gian có bản sắc thay vì lặp một map placeholder.
- **Scope:** greybox năm world Thường/Lửa/Nước/Tự nhiên/Gió, landmark/navigation, vùng spawn, modular biome kit bản đầu, lighting, ambience và music motif prototype.
- **Deliverables:** năm route chơi được, environment kit/palette, world boundary, camera/nav validation và art replacement plan theo khu vực.
- **Acceptance criteria:** mỗi world phân biệt được bằng hình khối/landmark/âm thanh chứ không chỉ màu; đường đi và encounter space hoạt động; không có vùng kẹt; budget được đo trong Studio.
- **Out of scope:** map production khổng lồ, đủ mọi region, weather system hoàn chỉnh và toàn bộ content creature.
- **Dependencies:** world design Phase 5, Phase 6 foundation, cổng Làng Phase 7 và creature scale Phase 9.
- **Test thủ công:** route readability, spawn/aggro space, camera occlusion, boundary escape, touch traversal, lighting/ambience và performance từng world.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** dựng một representative route cho mỗi world trước khi art-pass sâu một map duy nhất.

## Phase 11 — Persistent Data

- **Mục tiêu:** lưu PlayerProfile và Nhà Riêng an toàn qua session.
- **Scope:** DataStore, retry, session protection, save lifecycle, migration và lỗi lưu cho collection, XP/evolution, energy, expedition, inventory, private-home layout/upgrade/statue/training extension fields.
- **Deliverables:** profile schema versioned, load/save service, migration, shutdown path, idempotency durability và observability an toàn.
- **Acceptance criteria:** không ghi đè session đang hoạt động; retry có giới hạn; migration có test; lỗi lưu không làm mất state im lặng; invite theo phiên không biến thành whitelist vĩnh viễn.
- **Out of scope:** analytics warehouse, cross-experience economy và backup ngoài Roblox.
- **Dependencies:** schema sở hữu/progression/expedition Phase 2–5, private-home schema Phase 8 và môi trường test DataStore; presentation Phase 6–10 không tạo shadow profile riêng.
- **Test thủ công:** first join, rejoin, simulated failure, bind-to-close, schema cũ, concurrent session, home layout round-trip và stale guest state.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** threat model dữ liệu, private-home ownership và migration plan trước implementation.

## Phase 12 — Combat and Capture Presentation

- **Mục tiêu:** biến core loop đang hoạt động thành trải nghiệm chiến đấu/bắt thú dễ đọc và có cảm giác phản hồi tốt.
- **Scope:** camera production, combat HUD, target selection, health/aggro/status, hold–drag–release capture, animation integration, elemental VFX, SFX/music transition và onboarding ngắn.
- **Deliverables:** responsive HUD, target/capture UI, feedback state machine, VFX/SFX kit năm hệ bản đầu, camera settings và accessibility controls liên quan hiệu ứng.
- **Acceptance criteria:** người chơi hiểu mục tiêu, HP, cooldown, kết quả hit/capture và lý do request thất bại; UI dùng được trên desktop/touch/gamepad; VFX không che target; audio cue rõ.
- **Out of scope:** stone/formation/event/economy UI và mobile optimization cuối toàn game.
- **Dependencies:** Phase 4 capture/combat, Phase 6 design system, Phase 9 rig/animation, Phase 10 encounter space và Phase 11 profile boundary.
- **Test thủ công:** một/cụm wild, target switch, full/low HP capture, success/failure, ba companion fixture, device emulator, reduced effects và audio mix.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** prototype một encounter hoàn chỉnh có camera–HUD–animation–VFX–SFX trước khi mở rộng content.

## Phase 13 — Five Worlds and Rarity Content

- **Mục tiêu:** hoàn thiện content foundation cho năm world/năm starter và sáu bậc rarity trên pipeline hình ảnh đã được kiểm chứng.
- **Scope:** region/spawn pool, five-starter parity, sáu creature rarity cố định theo loài, skill/content pool ban đầu, boss route thường và representative art/audio content cho mỗi world.
- **Deliverables:** world/species-rarity definitions, content pack validator, authoring pipeline, five-starter onboarding migration, content/asset pack và regression suite.
- **Acceptance criteria:** đủ năm starter cân bằng; mỗi world chỉ spawn content hợp lệ; mỗi species một rarity canonical; stat/skill/presentation policy đúng; IP/license được review; thêm content không sửa service.
- **Out of scope:** stone, resonance, elite/public boss/legendary spawn, PvP và hàng trăm content.
- **Dependencies:** Phase 5 progression, Phase 6–10 pipeline/presentation, Phase 11 persistence và Phase 12 core-loop presentation.
- **Test thủ công:** smoke test từng content pack, progression route, rarity readability không chỉ bằng màu, balance pass, performance và asset/license audit.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** chốt vertical content budget cho một route đại diện mỗi world trước khi tăng số lượng creature.

## Phase 14 — Private Home Progression

- **Mục tiêu:** biến Nhà Riêng thành vòng collection/progression có giá trị bằng tượng theo hệ và Khu Tập Luyện.
- **Scope:** statue inventory/placement, Bệ Cộng Hưởng active, element-only owner buff, non-stacking/cap, training slots, fixed XP rate theo facility level, offline timestamp settlement và upgrade transaction.
- **Deliverables:** statue/training definitions, pedestal/buff resolver, training assignment/XP service, upgrade schema, Nhà Riêng UI và source-hook contract cho drop/boss/shop tương lai.
- **Acceptance criteria:** chỉ statue active buff đúng element của owner; guest không nhận/chỉnh buff; cùng hệ không stack; creature conflict bị từ chối; XP online/offline cố định không nhân rarity/level; retry không grant hai lần.
- **Out of scope:** World Boss/shop/quest source production (tích hợp Phase 17–18), public housing browser, trading và paid housing.
- **Dependencies:** Phase 5 XP/evolution, Phase 8 private-home authority, Phase 11 persistence và Phase 13 species/element content.
- **Test thủ công:** placement/active cap, five-element match, guest isolation, expedition snapshot, training slot conflict, offline elapsed, level/evolution cap, upgrade cost/rate/slot và retry/rejoin.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** chốt số bệ/slot/rate/cap DRAFT bằng simulation trước code.

## Phase 15 — Stone, Duplicate and Inventory UX

- **Mục tiêu:** tạo vòng săn cá thể/loot dài hạn với màn hình quản lý rõ ràng tại Nhà Riêng và dịch vụ NPC Làng đúng trách nhiệm.
- **Scope:** bảng 3×3, Health/Damage affinity immutable, unlock level 1/10/…/80, stone rarity/affix, sáu line bonus, skill modifier, XP transfer 20%, duplicate-gated skill roll và inventory/equip UX.
- **Deliverables:** equipment schema/validator, RNG seed/order, equip transaction, stat aggregation, duplicate ledger, inventory/compare/stone-board UI và feedback chế tạo/trang bị.
- **Acceptance criteria:** affinity/order không reroll; slot mở đúng một lần; stone đúng affinity; line/cap đúng; duplicate cùng loài bắt buộc; invalid/retry không mất item hai lần; UI giải thích thay đổi stat.
- **Out of scope:** resonance/team power, public event và PvP.
- **Dependencies:** Phase 5 progression, Phase 6 UI system, Phase 11 profile, Phase 13 rarity/content, Phase 14 Nhà Riêng boundary và stat runtime hỗ trợ affix.
- **Test thủ công:** capture nhiều duplicate/layout, level jump, equip/unequip tại Nhà, sáu line, modifier compatible/incompatible, NPC duplicate transaction và touch inventory.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** balance stat/affix budget, wireframe inventory/stone board và profile migration trước implementation.

## Phase 16 — Formation, Resonance and Power

- **Mục tiêu:** đưa ba thú chính cùng chiến đấu, tạo giá trị cho sáu thú phụ và trình bày đội hình dễ hiểu.
- **Scope:** formation 3 main + 6 support, Nhà-Riêng-only edit, per-companion target/state, fixed resonance catalog, element-signature buff, statue buff integration, Team Power và team HUD/preview.
- **Deliverables:** formation/resonance definitions, server coordinator ba companion, stat snapshot, power calculator, Nhà formation screen và combat team HUD.
- **Acceptance criteria:** support không spawn/đánh/nhận XP/cộng power trực tiếp; exact combo mới kích hoạt; resonance/statue source tách rõ và cap đúng; Team Power không dùng current HP hoặc tuyên bố chắc thắng.
- **Out of scope:** PvP balance production và matchmaking.
- **Dependencies:** Phase 4 group encounter, Phase 5 progression, Phase 11 persistence, Phase 12 presentation, Phase 13 content, Phase 14 statue và Phase 15 equipment.
- **Test thủ công:** formation follow/combat, target distribution, wipe đủ ba, support isolation, resonance/statue on-off, power comparison, element counter và desktop/touch editing tại Nhà.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** prototype coordinator ba companion bằng fixture nhỏ và wireframe formation trước khi mở content.

## Phase 17 — Elite, World Boss and Legendary

- **Mục tiêu:** thêm mục tiêu săn hiếm/event cộng đồng với hình ảnh, âm thanh và nguồn tượng đủ rõ.
- **Scope:** elite mutation không capture, boosted XP/loot, ultra-rare statue drop hook, World Boss tối đa năm event/ngày, cross-shard contribution/reward/statue, legendary exclusive spawn và presentation riêng.
- **Deliverables:** spawn classifier, loot/statue table, event scheduler/ID, announcement, contribution boards, reward ledger, exclusive lifecycle và elite/boss/legendary VFX/audio language.
- **Acceptance criteria:** elite/world boss không capture; event không quá cap ngày; reward/tượng một lần; contribution do server đo; legendary không cluster/xen ngang; statue reward đúng owner/element/idempotency.
- **Out of scope:** guild raid, auction/trading và competitive PvP.
- **Dependencies:** Phase 5 rewards, Phase 11 persistence, Phase 12 presentation, Phase 13 world content, Phase 14 statue, Phase 15 loot và Phase 16 combat team.
- **Test thủ công:** elite loot/tượng rate, daily cap, multi-shard contribution, AFK/duplicate reward, legendary claim, statue grant/pedestal, camera/VFX/audio và low-end performance.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** threat model MemoryStore/MessagingService và prototype boss reward/tượng transaction trước production event.

## Phase 18 — Village NPC, Quest and Crafting

- **Mục tiêu:** đưa gameplay/economy thật vào các khu chức năng public của Làng Mạch Nguồn đã dựng từ Phase 7.
- **Scope:** NPC cổng, chế bóng, thợ đá, tiến hóa, Nhà Đồng Vọng, bảng quest; quest/login/event reward, statue shop/exchange/crafting hook và material sink.
- **Deliverables:** quest/crafting/shop definitions, NPC model/animation/interaction UI, reward/recipe/statue transaction, economy telemetry hooks và Vietnamese onboarding.
- **Acceptance criteria:** mọi recipe/reward/price server-authoritative; không duplicate consume/grant; NPC/khu vực khớp signage/layout; mua tượng mặc định bằng tiền game/token; không tự thêm Robux/paid product.
- **Out of scope:** player trading, guild, battle pass và marketplace nâng cao.
- **Dependencies:** Phase 7 Làng và Phase 5/11/14–17 cung cấp progression, persistence, Nhà Riêng, item và event source/sink.
- **Test thủ công:** NPC permission/range, recipe đủ/thiếu, retry, quest claim, statue buy/exchange, login boundary, departure gate, camera/dialog và touch UI.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** economy source/sink simulation và interaction prototype trên đúng khu Làng trước code production.

## Phase 19 — Mobile, Accessibility and Performance

- **Mục tiêu:** hoàn thiện chất lượng trên thiết bị mục tiêu sau khi các feature đã tự có presentation riêng.
- **Scope:** end-to-end touch/gamepad pass, accessibility settings, localization layout, streaming/LOD, private-home guest/display load, memory/network/render/audio optimization và quality tiers.
- **Deliverables:** device matrix, performance budgets đã đo, graphics/effect options, accessibility checklist, loading/streaming UX và optimization report.
- **Acceptance criteria:** Làng, Nhà Riêng và core loop dùng được trên thiết bị mục tiêu; safe area/touch/text/contrast đạt rule; Nhà display/guest load không vượt budget; giảm chất lượng không mất tín hiệu gameplay.
- **Out of scope:** tạo presentation lần đầu cho feature cũ hoặc thay lại toàn bộ art direction.
- **Dependencies:** foundation Phase 6 và các system/presentation Phase 7–18.
- **Test thủ công:** thiết bị/emulator mục tiêu, network throttling, memory/render/physics/audio profiler, long session, owner/guest stress, text scaling, reduced effects và input switching.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** duy trì budget smoke test từ Phase 6; Phase 19 chỉ đóng các vấn đề cross-system còn lại.

## Phase 20 — PvP, Rankings and Live Expansion

- **Mục tiêu:** thêm cạnh tranh dài hạn mà không phá core collection/PvE/housing và giữ pipeline content/presentation nhất quán.
- **Scope:** proximity challenge, accept, isolated arena, team validation, PvP result/ranking, seasonal leaderboard và pipeline thêm world/skill/creature/art/audio/Private-Home content.
- **Deliverables:** arena lifecycle/presentation, matchmaking/ranking rules, anti-win-trading, season reset/reward ledger và content release checklist.
- **Acceptance criteria:** không tự bắt đầu PvP; cả hai chấp nhận; arena cách ly; disconnect/forfeit/reward idempotent; ranking không tin client; content mới qua validation, performance và IP audit.
- **Out of scope:** feature social/economy chưa có product decision như guild war hoặc trading production.
- **Dependencies:** Phase 5–19 hoàn tất và có telemetry balance/hiệu năng đủ tin cậy.
- **Test thủ công:** challenge/decline, arena isolation, disconnect, exploit/rematch farming, rank season, device matrix và regression PvE/Nhà Riêng.
- **Trạng thái:** `NOT_STARTED`.
- **Cập nhật gần nhất:** 2026-08-04.
- **Bước tiếp theo:** chưa bắt đầu trước khi PvE/team power/event/housing và chất lượng thiết bị ổn định.

## Trạng thái hiện tại

- **Current Phase:** Phase 4 `IN_PROGRESS`; Phase 0–3 là `DONE`, Phase 5 chưa bắt đầu.
- **Current Task:** đồng bộ game đích để tách Làng public khỏi Nhà Riêng, thêm friend invite, showcase, tượng buff theo hệ và Khu Tập Luyện; docs-only, không sửa Luau, không đổi trạng thái phase lịch sử hoặc Studio acceptance.
- **Completed Work:** source Phase 4 vẫn là vertical slice 1v1/session như trước. Tài liệu/roadmap tương lai được tách thành Phase 5–20, trong đó Phase 7 là Làng, Phase 8 là Nhà nền/social, Phase 14 là Nhà Riêng progression và presentation có mốc Phase 6–10/12; không được tính là implementation hoặc acceptance.
- **Known Issues:** chưa có kết quả Studio Phase 4; runtime vẫn coi `Home` placeholder là spawn chung, còn bốn starter, một companion, encounter 1v1, hai capture device, full-HP rejection, cube/map/UI placeholder và không có Nhà Riêng/invite/showcase/tượng/training/persistence/progression/energy/rarity/stone/resonance/event.
- **Blockers:** remote HEAD GitHub vẫn cần chuyển từ `master` sang `prod` bằng Settings hoặc API client đã xác thực.
- **Next Recommended Task:** hoàn tất Studio matrix Phase 4 hiện tại. Sau acceptance, bắt đầu Phase 5 và Phase 6 theo dependency; Phase 7 migration spawn chung thành Làng, Phase 8 mới tạo Nhà Riêng. Implementation sau đó đi theo Phase 9–20 và quality gate presentation/housing; không sửa placeholder lịch sử trước acceptance Phase 4.

## Change History

| Ngày      | Phase | Thay đổi                                                                                      |
| ---------- | ----- | ----------------------------------------------------------------------------------------------- |
| 2026-08-01 | 0     | Khởi tạo repository foundation; ghi nhận toolchain còn thiếu và đặt Phase 0`BLOCKED`. |
| 2026-08-01 | 0     | Xác minh Rojo 7.7.0, StyLua 2.5.2, Selene 0.31.0 cùng build/format/lint; chuyển Phase 0 sang `DONE`. |
| 2026-08-01 | 1     | Triển khai Home, starter team selection server-authoritative và placeholder presentation; giữ `IN_PROGRESS` chờ Studio Play Test. |
| 2026-08-02 | 1     | Sửa bootstrap dùng sai Rojo sibling path; thêm remote timeout, Home marker và `RespawnLocation`; chờ Studio regression test. |
| 2026-08-02 | 1     | Đổi onboarding sang chọn một trong bốn starter; ghi nhận hướng tutorial capture nguyên bản cho phase sau. |
| 2026-08-02 | 2     | Thêm typed creature data, definitions, validator, registry và test project; giữ `IN_PROGRESS` chờ Studio suite. |
| 2026-08-02 | 2     | Studio validation đạt 11/11 test, registry trả `4 4 4 4`; chuyển Phase 2 sang `DONE`. |
| 2026-08-03 | 3     | Bắt đầu combat vertical slice trên feature branch; thêm server-authoritative encounter, damage skill, snapshot UI và test project; giữ `IN_PROGRESS` chờ Studio runtime. |
| 2026-08-03 | 1–3   | Ghi nhận xác nhận Phase 1 `DONE`; đồng bộ target design năm hệ, skill/progression/evolution/roll/art direction; Markdown/link/scope audit, StyLua, Selene và ba Rojo build đạt bằng binary pin; Phase 3 giữ `IN_PROGRESS`. |
| 2026-08-03 | 3     | Gom tài liệu project-level vào `docs/project/`, giữ `README.md` ở root; link audit, StyLua, Selene và ba Rojo build đạt; Phase 3 không đổi trạng thái. |
| 2026-08-03 | 3     | Sửa UI starter/combat chồng nhau, bỏ cỏ 3D che camera, Việt hóa presentation hiện tại; terminal validation đạt, chờ Studio regression với hai client. |
| 2026-08-03 | 3–4   | Người dùng chấp nhận Phase 3 `DONE` như test harness; chốt target PvE trực tiếp trên map với regional spawn/proximity/disengage và deferred PvP arena; Markdown link audit, StyLua, Selene và ba Rojo build đạt; Phase 4 chưa bắt đầu. |
| 2026-08-03 | 3     | Người dùng xác nhận toàn bộ checklist Studio Phase 3 đạt, gồm Server & Clients với hai client; không có Studio version/raw Output log; duyệt tích hợp feature vào `master`. |
| 2026-08-03 | 4     | Bắt đầu Phase 4 trên feature branch; triển khai migration năm hệ/ba slot, open-world region/spawn/encounter, capture/collection session, UI và suite; giữ `IN_PROGRESS` chờ Studio matrix. |
| 2026-08-03 | 4     | Studio feedback phát hiện companion tiếp tục đánh khi owner rút lui; tách owner-disengage khỏi wild spawn leash, thêm regression test và giữ `IN_PROGRESS` chờ retest. |
| 2026-08-03 | 4     | Studio retest phát hiện companion re-aggro khi còn trong vùng; bắt buộc owner proximity khi acquire target mới và thêm regression test trước lần retest tiếp theo. |
| 2026-08-04 | 4     | Soạn thiết kế DRAFT docs-only cho encounter nhiều wild, chọn target giữ-kéo-thả, làm yếu, công thức capture data-driven và bốn ball tier; chưa accepted/implemented, chờ người dùng duyệt quyết định mở. |
| 2026-08-04 | 5–13  | Người dùng bổ sung game đích: năm world/starter, energy 7/7, đá 3×3, đội 3+6/resonance, rarity, elite, World Boss, legendary, duplicate và open-ended PvP/ranking; cập nhật docs/future phases, không sửa source hoặc trạng thái Phase 0–4. |
| 2026-08-04 | 6–18  | Tách presentation khỏi một phase polish cuối: thêm foundation UI/art/audio, Home village, creature art/animation, world greybox/environment, combat/capture presentation và mobile/accessibility/performance xen kẽ các phase gameplay; không sửa source hoặc Phase 0–4. |
| 2026-08-04 | 7–20  | Tách Làng Mạch Nguồn public khỏi Nhà Riêng từng user; thêm explicit friend invite, showcase, tượng buff cùng hệ, Khu Tập Luyện XP thụ động và các phase riêng cho nền/tiến triển Nhà; không sửa source hoặc Phase 0–4. |
