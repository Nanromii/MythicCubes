# Thiết kế chiến đấu thế giới mở

Tài liệu này phân biệt combat test harness đã hoàn thành ở Phase 3 với cơ chế chiến đấu production được duyệt cho PvE thế giới mở và hướng PvP có thể triển khai sau này.

## Trạng thái quyết định

- **Đã có trong repository:** combat test harness Phase 3, server-authoritative, một sinh vật mỗi phía, basic attack, một active skill, cooldown, health snapshot và UI thử nghiệm.
- **Product design đã chốt:** PvE diễn ra trực tiếp trên map, sinh vật đồng hành đi theo người chơi, sinh vật tự nhiên spawn theo vùng và hai bên tự giao chiến khi vào đúng tầm.
- **Định hướng tương lai, chưa lên lịch:** PvP bằng lời thách đấu giữa hai người chơi và đấu trong arena cách ly.
- **Đã triển khai trên feature Phase 4, chờ Studio acceptance:** một region placeholder, spawn đơn/cụm, companion/wild presentation do server cập nhật, proximity engagement, auto combat, disengage/leash/return, capture và collection theo session.
- **Chưa triển khai:** content quy mô lớn, navigation/pathfinding production, reward/XP, arena và toàn bộ PvP.

Phase 3 được người dùng chấp nhận là `DONE` ngày 2026-08-03 với vai trò test harness sau khi xác nhận checklist Roblox Studio đạt. Việc đóng phase không có nghĩa combat test UI hiện tại là thiết kế production; Studio version và raw Output log chưa được cung cấp nên không được suy đoán.

## PvE thế giới mở đã chốt

### Sinh vật đồng hành

- Người chơi dắt thú đồng hành theo khi di chuyển trên map.
- Sinh vật đồng hành phải có presentation vật lý và bám theo người chơi mà không tự quyết định state quan trọng ở client.
- Khi gặp mục tiêu hợp lệ trong tầm giao chiến, thú đồng hành tự tiếp cận và đánh mục tiêu.
- Số thú cùng tham chiến, đội hình theo sau và cách chọn mục tiêu khi có nhiều mục tiêu vẫn là **TBD**.

### Sinh vật tự nhiên theo vùng

- Mỗi vùng có spawn pool riêng, chỉ chứa sinh vật phù hợp region definition.
- Server spawn sinh vật tự nhiên ngẫu nhiên theo spawn zone đã định nghĩa.
- Spawn có thể là cá thể đơn lẻ hoặc từng cụm; kích thước cụm, mật độ, rarity, respawn time và giới hạn số lượng phải data-driven.
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
- Quy tắc hồi máu/reset health, thời gian mất aggro, xử lý cụm và credit khi nhiều người chơi cùng đánh vẫn là **TBD**; không tự cấp reward nếu mục tiêu chưa bị đánh bại hợp lệ.

Khoảng cách engagement/aggro/disengage không được client gửi lên như sự thật. Phase 4 dùng placeholder data-driven trong `WorldDefinitions.lua`: hai zone có aggro `16/18`, engagement `20/22`, owner-disengage `28/30`, wild leash `42/46`, attack range `6`, respawn `8/10` giây; đây không phải balance production.

## Vertical slice Phase 4 hiện tại

- Region `verdant_meadow` có platform nhỏ và hai zone: `meadow_single` luôn tạo group một cá thể, `meadow_cluster` tạo group hai cá thể.
- `RegionalWildService` sở hữu spawn/despawn, identity, health, state/model và return/respawn; `EncounterService` sở hữu target, range, movement coordination, damage và disengage.
- Mỗi companion chỉ tham gia một encounter với một wild tại một thời điểm trong slice. Wild khác trong cụm vẫn độc lập và có thể được chọn sau; group assist/credit nhiều người là deferred.
- Companion và wild dùng model 6 block anchored, không collision/touch/query. Server cập nhật position/presentation; client chỉ render UI snapshot.
- Khi owner cách companion hoặc wild quá owner-disengage range, companion bỏ combat target và quay lại follow. Server không cho companion khởi tạo encounter mới nếu owner vẫn ở ngoài range, tránh re-aggro trong lúc companion đang chạy về. Khi wild vượt spawn leash hoặc companion hết HP, encounter cũng kết thúc; wild trở về spawn và hồi đầy HP khi return hoàn tất. Đây là rule placeholder được ghi rõ, chưa phải balance production.
- Capture chỉ hợp lệ khi wild đang `Engaging`, đã mất HP, thuộc đúng encounter và người chơi ở trong capture range server đo. Capture thành công dùng nhánh `Defeated → Despawned`, không cấp reward và respawn theo zone.

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
- **Phase 4:** vertical slice PvE thế giới mở đầu tiên gồm companion follow, regional wild spawn tối thiểu, proximity engagement/disengage và tích hợp capture/collection.
- **Phase 5:** XP, reward, level/evolution, boss và progression sau combat.
- **Phase 7:** camera, animation, VFX/SFX, health/aggro feedback, mobile UI và polish.
- **Phase 8:** mở rộng region, spawn pool, creature cluster, AI variety và content production.
- **PvP:** deferred sau khi PvE/core loop ổn định; chưa khởi động phase hoặc task implementation.

## Quyết định implementation Phase 4

1. Dùng một region/two-zone vertical slice và số creature nguyên bản tối thiểu; không mở rộng content Phase 8.
2. Dùng range/leash/return placeholder trong definition; hồi đầy HP sau khi return hoàn tất.
3. Server cập nhật companion/wild model anchored; lifecycle/AI không phụ thuộc combat test UI.
4. Mỗi wild chỉ thuộc một encounter/player; mỗi companion chỉ có một target; collection/inventory tách theo player session.
5. Client position/chance/damage/ownership không được nhận làm dữ liệu thật; capture boundary kiểm tra exact fields, encounter, target, distance, inventory, request ID và rate.

Không chuyển thẳng combat test harness thành production AI bằng cách thêm code vào một service lớn; cần task architecture/code riêng trong Phase 4.
