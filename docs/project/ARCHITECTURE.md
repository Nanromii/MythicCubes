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

Phase 4 thêm `WorldTypes`, `WorldDefinitions`, `WorldDataRegistry`, `WorldDefinitionValidator`, `SpawnPoolSelector`, `WildLifecycle`, `CaptureRequestValidator`, `CaptureCalculator` và `CollectionEngine`. Definition tập trung region/zone, density, cluster, respawn, range, speed, attack interval và hai capture device. Lifecycle, probability, inventory/ownership/idempotency có boundary thuần để test không phụ thuộc UI.

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

Các service dự kiến cho phase sau:

- `PlayerDataService`: vòng đời và quyền truy cập profile.
- `CreatureService`: thay thế/mở rộng collection/session boundary khi progression/persistence cần aggregate production.
- `RegionService`: quyền truy cập và mở khóa vùng.
- `ProgressionService`: kinh nghiệm, cấp và phần thưởng.
- `EncounterService`: vòng đời encounter và mục tiêu hợp lệ.

Không tách `SkillService` chỉ để bọc một thao tác: Phase 3 giữ shape validation trong shared validator, rule thực thi trong `CombatEngine` và lifecycle trong `CombatService`.

Phase 5 là nơi triển khai XP, level-up, evolution theo mốc 18/54, stat reload data-driven và transaction roll skill server-authoritative/anti-frustration. Phase 7 sở hữu camera/UI/animation/VFX/SFX/mobile polish; Phase 8 sở hữu element, creature, skill pool và map content mở rộng. Không tạo phase mới chỉ cho các feature này.

### Client

`StarterSelectionController` tạo UI starter tối thiểu, gửi intent và chỉ khóa lựa chọn theo response server. Sau xác nhận, bootstrap khởi động `WorldController`; controller này chỉ lấy snapshot, gửi capture intent `{requestId, encounterId, wildId, deviceId}` và hiển thị health/state/result/collection tiếng Việt. Client không gửi position, chance, damage, inventory hay ownership. `CombatController` cũ không chạy trong default project.

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
- Chỉ replicate dữ liệu client thực sự cần; không ghi secret vào log hoặc remote payload.
