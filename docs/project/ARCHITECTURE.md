# Kiến trúc dự án

Tài liệu này mô tả kiến trúc dự kiến và phần hiện có. Phase 4 đang triển khai vertical slice PvE trực tiếp trên map, capture và collection theo session; progression, persistence, PvP và polish production vẫn chưa tồn tại.

## Nguyên tắc

- **Server-authoritative:** server quyết định dữ liệu thật, chiến đấu, phần thưởng và tiến trình.
- **Data-driven:** definition tách khỏi service xử lý; nội dung mới chủ yếu được thêm bằng dữ liệu đã validation.
- **Module hóa theo trách nhiệm:** tránh service khổng lồ, coupling và circular dependency; không tạo service chỉ để bọc một function đơn giản.
- **Shared thuần:** shared definitions chứa type, cấu hình và logic thuần; không quản lý trạng thái người chơi.
- **Client trình bày:** client phụ trách input, UI, camera và hiển thị kết quả do server xác nhận.
- Không tạo framework nội bộ hoặc abstraction phức tạp trước khi có nhu cầu thực tế.

## Các tầng chính

### Shared

Phase 2 triển khai type, definition, validator và registry thuần cho sinh vật, owned creature, element, role và skill. Registry validate shape, ID duy nhất và cross-reference ngay khi load; service/controller chỉ đọc dữ liệu qua registry hoặc starter view.

Phase 3 thêm `CombatTypes`, `CombatDamageCalculator`, `ElementEffectiveness`, `CombatRequestValidator`, `CombatRequestRateLimiter` và `CombatEngine`. Damage calculation là deterministic pure function; Phase 4 tái sử dụng calculator/chart này cho basic attack trên map mà không phụ thuộc UI harness.

Migration prerequisite Phase 4 đã đổi registry sang `normal`, `fire`, `water`, `nature`, `wind`, thêm một basic skill cho mỗi hệ, validation same-element và tối đa ba equipped skill theo mốc stage. Effect ngoài `Damage`, XP/evolution runtime và roll/progression vẫn chưa được triển khai. Xem [Hệ thống sinh vật, nguyên tố và kỹ năng](../design/CREATURE_ELEMENT_SKILL_SYSTEM.md).

Phase 4 thêm `WorldTypes`, `WorldDefinitions`, `WorldDataRegistry`, `WorldDefinitionValidator`, `SpawnPoolSelector`, `WildLifecycle`, `CaptureRequestValidator`, `CaptureCalculator` và `CollectionEngine`. Definition hiện tập trung region/zone, density, cluster, respawn, range, speed, attack interval và hai capture device prototype. Lifecycle, probability, inventory/ownership/idempotency có boundary thuần để test không phụ thuộc UI.

Game đích trong [capture](../design/CAPTURE_SYSTEM.md), [world/exploration](../design/WORLD_EXPLORATION_PROGRESSION.md), [loadout](../design/CREATURE_LOADOUT_PROGRESSION.md) và [Nhà Riêng](../design/PRIVATE_HOME_HOUSING.md) cần shared schema cho `spawnGroupId`, wild level/evolution/classification, creature rarity cố định trong species/evolution definition, bốn ball, expedition energy, private-home layout/placement/invite session, statue/pedestal, training slot/timestamp, stone/affix/3×3 board, 3+6 lineup, resonance, loot và contribution event. Pure resolver phải có injected RNG/versioned balance; service không hard-code tên creature, ball, stone, statue, resonance hoặc world và không roll creature rarity khi tạo instance.

Shared không truy cập DataStore trực tiếp, tự đổi trạng thái người chơi, phụ thuộc UI hoặc tin dữ liệu client.

### Server

Các service hiện có trong Phase 1:

- `HomeService`: tạo platform và spawn placeholder ở server khi runtime bắt đầu.
- `StarterSelectionService`: sở hữu một lựa chọn starter theo session, validate remote và khôi phục presentation sau respawn.
- `StarterDisplayService`: tạo một block placeholder đã được server xác nhận cạnh nhân vật.

Service regression từ Phase 3:

- `CombatService`: sở hữu encounter theo player, state machine `Preparing → Active → Finished`, rate limit/idempotency request, lịch basic attack và replication snapshot.
- `CombatEngine`: module shared không chứa mutable global state; nhận combat state, validate ownership/target/skill/cooldown rồi gọi pure damage calculation.

`CombatService` và `CombatController` được giữ để regression Phase 3 nhưng không được default bootstrap Phase 4 khởi động.

Các service Phase 4:

- `CollectionService`: sở hữu session collection, active team và inventory capture; starter/capture record dùng `CollectionEngine`, không có DataStore.
- `CompanionService`: tạo model blocky không collision, follow character và nhận target presentation từ encounter coordinator; không quyết định damage/ownership.
- `RegionalWildService`: sở hữu regional spawn/despawn, wild identity/health/state/model, return và respawn queue.
- `EncounterService`: chọn target hợp lệ, khóa wild theo encounter/player, đo range/leash, điều phối movement, cooldown basic attack và server damage.
- `CaptureService`: validate exact payload, request ID, rate, device/inventory, encounter/target/alive/weakened/range; tính random ở server và điều phối transaction idempotent.
- `RemoteFactory`: quản lý tập trung việc tạo/kiểm tra `ReplicatedStorage.Remotes` cho server services.

Trong game đích chưa triển khai, `EncounterService` sở hữu `wildIds`, ba companion targets và per-entity cooldown; `RegionalWildService` sở hữu cluster/elite/legendary identity và claim nguyên tử không yield; `CaptureService` nhận đúng một `targetWildId`, cho phép full-HP capturable target, từ chối Elite/WorldBoss, tiêu bóng sau validation và phối hợp idempotency ledger với inventory, collection, encounter membership, wild lifecycle và respawn.

Các service dự kiến cho phase sau:

- `PlayerDataService`: vòng đời và quyền truy cập profile.
- `CreatureService`: thay thế/mở rộng collection/session boundary khi progression/persistence cần aggregate production.
- `RegionService`: quyền truy cập và mở khóa vùng.
- `ProgressionService`: kinh nghiệm, cấp và phần thưởng.
- `ExpeditionService`: energy 7/7, timestamp hồi 20 phút, cổng Làng departure và loadout/statue snapshot lock.
- `PrivateHomeService`: instance theo owner, teleport Làng–Nhà, explicit friend invite, guest permission, placement budget và owner-leave lifecycle.
- `StatueService`: statue inventory, Bệ Cộng Hưởng, element match, non-stacking/cap và owner-only buff snapshot.
- `TrainingService`: slot assignment, facility upgrade, fixed XP rate và offline timestamp settlement idempotent.
- `EquipmentService`: stone inventory/equip, slot unlock, line bonus và skill modifier.
- `FormationService`: ba main, sáu support, resonance snapshot và Team Power canonical.
- `LootService`: server loot table, duplicate-safe reward transaction và elite modifier.
- `WorldEventService`: global World Boss schedule/contribution/reward; legendary exclusive spawn policy tách khỏi public boss.

Không tách `SkillService` chỉ để bọc một thao tác: Phase 3 giữ shape validation trong shared validator, rule thực thi trong `CombatEngine` và lifecycle trong `CombatService`.

Phase 5 sở hữu XP/level/evolution và expedition boundary. Phase 6 tạo visual/UI/audio foundation; Phase 7 dựng Làng public; Phase 8 tạo Nhà Riêng/social visit/showcase foundation; Phase 9 creature art/animation; Phase 10 năm world greybox; Phase 11 persistence; Phase 12 combat/capture presentation; Phase 13 năm world/rarity content; Phase 14 tượng/training Nhà Riêng progression; Phase 15 stone/duplicate/inventory; Phase 16 formation/resonance/power; Phase 17 elite/boss/legendary; Phase 18 NPC/economy Làng; Phase 19 mobile/accessibility/performance; Phase 20 PvP/ranking/live expansion. Presentation contract nằm trong [Định hướng hình ảnh, giao diện và âm thanh](../design/VISUAL_AUDIO_UI_DIRECTION.md), housing contract trong [Nhà Riêng](../design/PRIVATE_HOME_HOUSING.md), trạng thái trong `PROJECT_PROCESS.md`.

### Client

`StarterSelectionController` tạo UI starter tối thiểu, gửi intent và chỉ khóa lựa chọn theo response server. Sau xác nhận, bootstrap khởi động `WorldController`; controller này hiện chỉ lấy snapshot, gửi capture intent `{requestId, encounterId, wildId, deviceId}` và hiển thị health/state/result/collection tiếng Việt. Client không gửi position, chance, damage, inventory hay ownership. `CombatController` cũ không chạy trong default project.

UX game đích đổi intent thành `{requestId, encounterId, targetWildId, ballId}` sau thao tác giữ-kéo-thả. Danh sách target đến từ snapshot server; highlight và bóng 3D chỉ là presentation. Client Nhà Riêng gửi intent chọn main/support, equip stone, đặt/activate tượng, training assignment và mời friend; client Làng gửi intent NPC/crafting/quest/departure world. Client không gửi stat, rarity, affinity, Team Power, buff total, XP elapsed, energy timestamp, loot hoặc RNG result.

## Ranh giới client-server

Luồng sử dụng kỹ năng dự kiến:

```text
Client gửi ý định sử dụng kỹ năng
→ Server xác thực người chơi và sinh vật
→ Server kiểm tra cooldown, trạng thái và mục tiêu
→ Server tính kết quả
→ Server cập nhật trạng thái
→ Server gửi kết quả hiển thị về client
```

Luồng bắt sinh vật dự kiến:

```text
Client yêu cầu sử dụng thiết bị bắt
→ Server kiểm tra inventory
→ Server kiểm tra encounter và khoảng cách
→ Server tính tỷ lệ
→ Server quyết định kết quả
→ Server cập nhật collection
→ Server gửi kết quả cho client
```

## Data flow

Các luồng đã triển khai gồm bootstrap, Home/starter/collection theo session, regional spawn, proximity encounter, auto damage, leash return và capture. Mọi distance dùng position Workspace do server quan sát.

Target sau Phase 3 là PvE trực tiếp trên map: `EncounterService`/wild lifecycle tương lai sở hữu regional spawn, AI state, aggro, engagement, disengage/leash và return/despawn; server đo khoảng cách và quyết định target. Companion follow và wild movement chỉ trình bày state server-authoritative. PvP được deferred; nếu triển khai, proximity chỉ mở lời thách đấu, hai bên phải chấp nhận và server cách ly trận đấu trong arena. Xem [Thiết kế chiến đấu thế giới mở](../design/OPEN_WORLD_COMBAT.md).

- **Khởi động server:** bootstrap nạp cấu hình đã validation, khởi tạo service theo dependency order, rồi cho phép gameplay request.
- **Khởi động client:** bootstrap nạp controller, nhận snapshot được server cấp và bật input/UI khi sẵn sàng.
- **Tải PlayerProfile:** server tải và validate profile, áp dụng migration, giữ session rồi gửi snapshot an toàn cho client.
- **Chọn sinh vật khởi đầu:** client gửi lựa chọn; server kiểm tra trạng thái chưa chọn, definition hợp lệ, ghi ownership và trả kết quả.
- **Bắt đầu encounter:** server tìm wild `Idle` gần companion trong aggro/engagement range, chuyển nó sang `Engaging` và khóa encounter/player; client không có remote bắt đầu trận.
- **Sử dụng kỹ năng:** server validation payload, player/combat, quyền điều khiển, request ID, rate, skill/equipped state, cooldown và target trước khi tính damage.
- **Bắt sinh vật:** server validation exact fields/request ID/rate/device/inventory/encounter/target/alive/weakened/range, tính chance/roll, tiêu thụ đúng một thiết bị; success thêm owned record và despawn wild, failure không tạo ownership.
- **Bắt một target trong encounter cụm — game đích:** server kiểm tra target thuộc membership canonical, capturable classification, rarity/ball eligibility, level/stage/species/HP modifier và cap; full HP được roll chance thấp; mọi throw hợp lệ tiêu một bóng; success không dừng các thành viên còn lại.
- **Vào game/đi Nhà:** server spawn player tại Làng; teleport Làng–Nhà không trừ energy. Khi một expedition kết thúc và player tới Làng hoặc Nhà, server hồi đầy canonical team HP. Nhà của friend chỉ nhận guest khi server xác minh friendship và explicit invite còn hạn do owner tạo.
- **Khởi hành từ Làng:** server kiểm tra energy/loadout/profile, giữ idempotency key, trừ đúng một energy khi cổng world commit rồi khóa expedition/statue snapshot; subzone transfer không trừ thêm.
- **Level/stone slot:** server cấp XP, xác định mọi level threshold bị vượt và mở cell tiếp theo từ immutable unlock order đúng một lần.
- **Equip/formation:** server kiểm tra ownership, owner đang ở Nhà Riêng và không expedition, slot affinity, duplicate placement và resonance catalog; recompute final stats/Team Power từ canonical data.
- **Tượng:** server kiểm tra statue ownership, pedestal/element/cap và owner state; guest không activate. Buff chỉ áp dụng creature cùng hệ của owner và được snapshot khi expedition bắt đầu.
- **Khu Tập Luyện:** server khóa creature/slot, từ chối main/support/expedition/donor conflict và settle `wholeMinutes × canonical facility rate`; retry/rejoin không grant XP hai lần.
- **Consume duplicate:** server khóa donor/receiver, kiểm tra cùng loài, tháo stone prerequisite, rồi commit XP transfer hoặc skill-roll material đúng một lần.
- **Elite loot:** server từ chối capture classification, resolve XP/loot table và grant idempotent theo defeat ID.
- **World Boss:** global event coordinator giới hạn tối đa năm event/ngày, aggregate contribution và cấp một reward package/player/event ID.
- **Legendary wild:** server tạo một cá thể trong eligible world shard, khóa exclusive encounter và chỉ release claim qua lifecycle hợp lệ.
- **Đánh boss:** server tạo encounter boss, theo dõi trạng thái và cấp phần thưởng một lần khi điều kiện đạt.
- **Mở khóa vùng:** server kiểm tra boss/progression prerequisite, cập nhật profile và phát snapshot mới.
- **Lưu dữ liệu:** server đánh dấu dirty, lưu có retry phù hợp, xử lý đóng session và ghi lỗi có context.

## Quy tắc dependency

- Client không import server module; server không import UI module.
- Shared không import implementation của client hoặc server.
- Service không phụ thuộc ngược vào controller; definition không gọi service.
- Utility không chứa mutable global state.
- Remote name được quản lý tập trung; không tạo `RemoteEvent` tùy tiện trong từng feature.
- Dependency đi từ bootstrap đến service/controller, rồi đến shared definition và utility; không đi ngược tầng.

## Rojo mapping

| Filesystem | Roblox DataModel |
| --- | --- |
| `src/ReplicatedStorage` | `ReplicatedStorage` |
| `src/ServerScriptService` | `ServerScriptService` |
| `src/ServerStorage` | `ServerStorage` |
| `src/StarterPlayer/StarterPlayerScripts` | `StarterPlayer.StarterPlayerScripts` |
| `src/StarterGui` | `StarterGui` |

`src/StarterPlayer` có thêm một cấp filesystem để phản ánh rõ service đích, nhưng `default.project.json` ánh xạ trực tiếp thư mục con `StarterPlayerScripts`. `assets`, `tests`, `scripts` và `docs` không được đồng bộ vào DataModel.

## Bảo mật

- Validate kiểu, giới hạn, ownership và state cho mọi remote request.
- Áp dụng rate limit gameplay khi abuse có thể gây tải hoặc lợi thế.
- Kiểm tra khoảng cách, cooldown, encounter state và inventory ở server.
- Không tin timestamp, damage hoặc kết quả random do client gửi.
- Không tin ID sinh vật sở hữu trước khi đối chiếu profile server.
- Không tin energy countdown, rarity, stone affinity/affix, slot unlock, resonance, Team Power, loot hoặc contribution do client gửi.
- Không tin friend/home owner, invite, placement bounds, statue element/buff, training timestamp/rate/XP hoặc guest permission do client gửi.
- Mọi consume/grant/duplicate/WorldBoss reward cần request/event ID và idempotency ledger; invalid request không tạo side effect.
- Chỉ replicate dữ liệu client thực sự cần; không ghi secret vào log hoặc remote payload.
