# Thiết kế chiến đấu thế giới mở

Tài liệu này phân biệt combat test harness đã hoàn thành ở Phase 3 với cơ chế chiến đấu production được duyệt cho PvE thế giới mở và hướng PvP có thể triển khai sau này.

## Trạng thái quyết định

- **Đã có trong repository:** combat test harness Phase 3, server-authoritative, một sinh vật mỗi phía, basic attack, một active skill, cooldown, health snapshot và UI thử nghiệm.
- **Product design đã chốt:** PvE diễn ra trực tiếp trên map, sinh vật đồng hành đi theo người chơi, sinh vật tự nhiên spawn theo vùng và hai bên tự giao chiến khi vào đúng tầm.
- **Định hướng tương lai, chưa lên lịch:** PvP bằng lời thách đấu giữa hai người chơi và đấu trong arena cách ly.
- **Chưa triển khai:** regional spawn, AI di chuyển vật lý, aggro/proximity, disengage/leash, open-world combat presentation, arena và toàn bộ PvP.

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

Khoảng cách engagement/aggro/disengage không được client gửi lên như sự thật và chưa chốt số production trong tài liệu này.

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

## Technical follow-up trước Phase 4

1. Chốt một region vertical slice, spawn zones và một số ít wild creature definitions nguyên bản.
2. Chốt engagement, aggro, disengage/leash và return-to-spawn rule tối thiểu.
3. Thiết kế server lifecycle cho wild creature và companion follow không phụ thuộc combat test UI.
4. Xác định interaction giữa open-world combat, capture và nhiều người chơi trong cùng vùng.
5. Viết threat model cho client position spoofing, target spoofing, remote spam, kill/reward duplication và NPC ownership.

Không chuyển thẳng combat test harness thành production AI bằng cách thêm code vào một service lớn; cần task architecture/code riêng trong Phase 4.
