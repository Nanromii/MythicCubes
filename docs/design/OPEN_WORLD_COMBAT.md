# Thiết kế chiến đấu thế giới mở

Tài liệu này phân biệt combat test harness đã hoàn thành ở Phase 3 với cơ chế chiến đấu production được duyệt cho PvE thế giới mở và hướng PvP có thể triển khai sau này.

## Trạng thái quyết định

- **Đã có trong repository:** combat test harness Phase 3, server-authoritative, một sinh vật mỗi phía, basic attack, một active skill, cooldown, health snapshot và UI thử nghiệm.
- **Product design đã chốt:** PvE diễn ra trực tiếp trên map, ba sinh vật chính đi theo người chơi, sinh vật tự nhiên spawn theo vùng và hai bên tự giao chiến khi vào đúng tầm; sáu support chỉ kích hoạt resonance.
- **Định hướng tương lai, chưa lên lịch:** PvP bằng lời thách đấu giữa hai người chơi và đấu trong arena cách ly.
- **Đã triển khai trên feature Phase 4, chờ Studio acceptance:** một region placeholder, spawn đơn/cụm, companion/wild presentation do server cập nhật, proximity engagement, auto combat, disengage/leash/return, capture và collection theo session.
- **Game đích đã được bổ sung:** encounter chứa nhiều thành viên cùng spawn cluster, ba companion active, capture target bất kỳ, elite, World Boss và legendary exclusive encounter. Xem [hệ thống bắt](CAPTURE_SYSTEM.md), [world/exploration](WORLD_EXPLORATION_PROGRESSION.md) và [đội hình/loadout](CREATURE_LOADOUT_PROGRESSION.md).
- **Chưa triển khai:** content quy mô lớn, navigation/pathfinding production, reward/XP, arena và toàn bộ PvP.

Phase 3 được người dùng chấp nhận là `DONE` ngày 2026-08-03 với vai trò test harness sau khi xác nhận checklist Roblox Studio đạt. Việc đóng phase không có nghĩa combat test UI hiện tại là thiết kế production; Studio version và raw Output log chưa được cung cấp nên không được suy đoán.

## PvE thế giới mở đã chốt

### Sinh vật đồng hành

- Người chơi chọn ba thú chính tại Nhà Riêng; cả ba có presentation vật lý, follow theo formation và cùng tham chiến.
- Sáu thú phụ không spawn/đánh/nhận XP, chỉ kích hoạt resonance catalog.
- Khi gặp mục tiêu hợp lệ trong tầm, mỗi companion tự tiếp cận và đánh một target server đã xác nhận; ba companion có target/cooldown/skill state riêng.
- Main/support/skill/stone/statue snapshot bị khóa khi khởi hành từ cổng Làng, không đổi giữa expedition.
- Phase 4 hiện chỉ có một companion; ba-active-companion là game đích chưa triển khai.

### Sinh vật tự nhiên theo vùng

- Mỗi vùng có spawn pool riêng, chỉ chứa sinh vật phù hợp region definition.
- Server spawn sinh vật tự nhiên ngẫu nhiên theo spawn zone đã định nghĩa.
- Spawn có thể là cá thể đơn lẻ hoặc từng cụm; kích thước cụm, mật độ, species pool (và từ đó phân bố rarity cố định theo loài), respawn time và giới hạn số lượng phải data-driven. Spawn không roll rarity riêng cho cá thể.
- Server sở hữu spawn/despawn, creature identity, health, AI state và phần thưởng; client không được tự tạo sinh vật hợp lệ hoặc quyết định kết quả.

### Vào giao chiến

- Khi người chơi đưa thú đồng hành tới trong engagement range của sinh vật tự nhiên, thú đồng hành có thể lập tức lao vào đánh.
- Sinh vật tự nhiên có thể chủ động lao vào thú của người chơi khi mục tiêu đi vào aggro range của nó.
- Aggro rule có thể khác theo loài/cụm/vùng nhưng phải đến từ definition đã validation, không hardcode rải rác trong AI.
- Server đo khoảng cách, chọn mục tiêu, xác nhận sinh vật còn sống và quyết định thời điểm bắt đầu combat.
- Client chỉ trình bày movement, animation, health, skill feedback và kết quả server đã xác nhận.

### Rời giao chiến

- Người chơi có thể chạy ra xa để đưa bản thân và thú đồng hành khỏi tầm của sinh vật tự nhiên.
- Server kết thúc engagement khi mục tiêu vượt disengage/leash range và thỏa điều kiện thời gian nếu có.
- Sau disengage, sinh vật tự nhiên trở về spawn area hoặc chuyển state theo definition.
- Thời gian mất aggro và credit nhiều người phải data-driven. Trong game đích, companion không tự hồi đầy khi disengage/new encounter: HP giữ suốt expedition; chỉ khi kết thúc expedition và trở về Làng/Nhà, hoặc nhờ healing skill, regeneration/life steal hợp lệ, mới hồi. Khi cả ba companion bị hạ, player bị đưa về Nhà Riêng và hồi đầy.

Khoảng cách engagement/aggro/disengage không được client gửi lên như sự thật. Phase 4 dùng placeholder data-driven trong `WorldDefinitions.lua`: hai zone có aggro `16/18`, engagement `20/22`, owner-disengage `28/30`, wild leash `42/46`, attack range `6`, respawn `8/10` giây; đây không phải balance production.

## Vertical slice Phase 4 hiện tại

- Region `verdant_meadow` có platform nhỏ và hai zone: `meadow_single` luôn tạo group một cá thể, `meadow_cluster` tạo group hai cá thể.
- `RegionalWildService` sở hữu spawn/despawn, identity, health, state/model và return/respawn; `EncounterService` sở hữu target, range, movement coordination, damage và disengage.
- Mỗi companion chỉ tham gia một encounter với một wild tại một thời điểm trong slice. Wild khác trong cụm vẫn độc lập và có thể được chọn sau; group assist/credit nhiều người là deferred.
- Companion và wild dùng model 6 block anchored, không collision/touch/query. Server cập nhật position/presentation; client chỉ render UI snapshot.
- Khi owner cách companion hoặc wild quá owner-disengage range, companion bỏ combat target và quay lại follow. Server không cho companion khởi tạo encounter mới nếu owner vẫn ở ngoài range, tránh re-aggro trong lúc companion đang chạy về. Khi wild vượt spawn leash hoặc companion hết HP, encounter cũng kết thúc; wild trở về spawn và hồi đầy HP khi return hoàn tất. Đây là rule placeholder được ghi rõ, chưa phải balance production.
- Capture chỉ hợp lệ khi wild đang `Engaging`, đã mất HP, thuộc đúng encounter và người chơi ở trong capture range server đo. Capture thành công dùng nhánh `Defeated → Despawned`, không cấp reward và respawn theo zone.

## Encounter theo cụm — game đích, chưa triển khai

- Server gán `spawnGroupId`, claim mọi thành viên còn hợp lệ trong cùng cluster và lưu danh sách canonical trong encounter. Thành viên đã bị player khác claim hoặc không còn hợp lệ bị loại khỏi danh sách, không làm hỏng encounter của phần còn lại.
- Mọi wild trong encounter có thể di chuyển/tấn công; mỗi trong ba companion giữ đúng một target và chuyển target theo rule deterministic khi target chết, bị bắt, despawn hoặc return.
- Owner disengage kết thúc toàn encounter; leash riêng của một wild chỉ loại thành viên đó. Một companion bị hạ không kết thúc encounter nếu companion khác còn sống; wipe đủ ba mới đưa player về Nhà Riêng.
- Player có thể chọn bất kỳ wild còn sống và capture-eligible trong encounter, kể cả full HP với chance thấp. Client chỉ gửi `{requestId, encounterId, targetWildId, ballId}`; server kiểm tra lại toàn bộ state và transaction.
- Capture thành công một thành viên **không dừng encounter**; nhóm còn lại tiếp tục chiến đấu và player có thể bắt tiếp.
- Chi tiết membership, UX giữ-kéo-thả, công thức xác suất, bốn ball tier, security và test plan nằm trong [CAPTURE_SYSTEM.md](CAPTURE_SYSTEM.md).

## Elite, World Boss và legendary

- Elite là wild đột biến hiếm của world, mạnh/loot/XP cao hơn và không thể capture.
- World Boss là public cross-shard event mục tiêu 4–5 lần/ngày, không capture, có damage/tank/support contribution và reward idempotent.
- Legendary wild chỉ ở world cao được phép, spawn một cá thể, encounter độc quyền và có thể capture; player khác không xen ngang cho tới khi claim được giải phóng.
- Ba loại trên là classification/lifecycle khác nhau, không dùng lẫn creature rarity hoặc evolution stage. Chi tiết ở [WORLD_EXPLORATION_PROGRESSION.md](WORLD_EXPLORATION_PROGRESSION.md).

## State và authority dự kiến

Một sinh vật tự nhiên tối thiểu cần state do server sở hữu:

```text
Spawning → Idle/Roaming → Engaging → Returning hoặc Defeated → Despawned
```

Tên state production có thể thay đổi khi lập task code. Server phải xác thực target, region, ownership, alive state, khoảng cách, cooldown, tần suất request và reward boundary. AI không được phụ thuộc vào UI; shared combat calculation tiếp tục là logic thuần khi phù hợp.

## PvP tương lai, chưa triển khai

- PvP chưa được bật trong MVP ban đầu.
- Khi được duyệt triển khai, người chơi ở gần một người chơi khác có thể gửi lời thách đấu; proximity chỉ mở khả năng tương tác, không tự bắt đầu PvP.
- Cả hai bên phải ở trạng thái hợp lệ và chấp nhận trước khi trận đấu bắt đầu.
- Server đưa hai người chơi cùng thú của họ tới một arena cách ly để tránh người chơi khác hoặc sinh vật tự nhiên can thiệp.
- Arena có thể nằm trong cùng server hoặc dùng cơ chế instance/reserved server; lựa chọn kỹ thuật là **TBD**.
- Server tiếp tục quyết định team hợp lệ, combat state, damage, cooldown, winner, thoát trận và khôi phục vị trí an toàn.
- Matchmaking, ranking, reward, disconnect/forfeit, spectator và anti-win-trading đều chưa có product decision.

## Phân bổ vào phase hiện có

- **Phase 3 — `DONE`:** test harness chứng minh state, damage, cooldown, basic attack, active skill và isolation theo player; không phải open-world encounter production.
- **Phase 4:** vertical slice PvE thế giới mở đầu tiên gồm companion follow, regional wild spawn tối thiểu, proximity engagement/disengage và tích hợp capture/collection. Encounter theo cụm và bốn ball tier mới là thiết kế mở rộng DRAFT chờ duyệt.
- **Phase 5:** XP, reward, level/evolution, expedition energy/HP/wipe và progression sau combat.
- **Phase 6–10:** presentation foundation, Làng, Nhà Riêng, creature art/animation và năm world greybox/environment kit.
- **Phase 12:** camera, combat HUD, target, VFX/SFX, health/aggro feedback, capture interaction và responsive UI.
- **Phase 13:** năm world, năm starter target, rarity, region/spawn pool và content production.
- **Phase 16:** ba companion chính, sáu support, resonance, statue integration, Team Power và team feedback.
- **Phase 17:** elite, World Boss, legendary event, contribution/reward và event presentation.
- **PvP/Ranking:** Phase 20, deferred sau khi PvE/core loop/persistence ổn định.

## Quyết định implementation Phase 4

1. Dùng một region/two-zone vertical slice và số creature nguyên bản tối thiểu; không mở rộng content Phase 13.
2. Dùng range/leash/return placeholder trong definition; hồi đầy HP sau khi return hoàn tất.
3. Server cập nhật companion/wild model anchored; lifecycle/AI không phụ thuộc combat test UI.
4. Mỗi wild chỉ thuộc một encounter/player; mỗi companion chỉ có một target; collection/inventory tách theo player session.
5. Client position/chance/damage/ownership không được nhận làm dữ liệu thật; capture boundary kiểm tra exact fields, encounter, target, distance, inventory, request ID và rate.

Năm quyết định trên mô tả vertical slice 1v1 đang có. Chúng không xác nhận phần mở rộng trong `CAPTURE_SYSTEM.md` đã được accepted hoặc implemented.

Không chuyển thẳng combat test harness thành production AI bằng cách thêm code vào một service lớn; cần task architecture/code riêng trong Phase 4.
