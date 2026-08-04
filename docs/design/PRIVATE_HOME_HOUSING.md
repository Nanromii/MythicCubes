# Nhà Riêng, trưng bày, tượng và Khu Tập Luyện

> **Trạng thái:** product direction được người dùng bổ sung ngày 2026-08-04. Tên hiển thị, số slot, tốc độ XP, chi phí nâng cấp và chỉ số buff vẫn là **DRAFT/TUNABLE**. Chưa được triển khai trong source hiện tại.

Roadmap tách Phase 8 cho nền Nhà/social/showcase và Phase 14 cho statue/training progression sau khi persistence, XP và species content đủ ổn định.

## Phân biệt Làng và Nhà Riêng

- **Làng Mạch Nguồn:** public hub nơi người chơi xuất hiện khi vào game. Làng chứa NPC, shop/crafting/quest, cổng đi world và các dịch vụ công cộng.
- **Nhà Riêng:** không gian riêng gắn với đúng một chủ sở hữu. Người chơi có thể teleport từ Làng về Nhà và quay lại Làng.
- Từ “Home” trong implementation/Phase 1 lịch sử chỉ là tên của placeholder hiện tại, không còn là tên đúng của public hub trong game đích.

Mỗi user có đúng một Nhà Riêng được persistence bằng `ownerUserId`. Nhà có layout, decoration, creature display, statue inventory/pedestal, Training Area và upgrade state riêng. Không dùng client làm nguồn sự thật cho ownership, placement, buff hoặc XP.

## Teleport và quyền vào Nhà

Nhà Riêng không phải server công cộng có thể tự tìm và join. Luồng khách vào Nhà:

1. Chủ nhà đang ở trong Nhà và chọn một người trong danh sách bạn bè.
2. Server xác minh quan hệ bạn bè Roblox tại thời điểm mời và tạo invite có `inviteId`, `homeOwnerUserId`, `guestUserId`, thời hạn ngắn và trạng thái single-use.
3. Người được mời chủ động chấp nhận khi invite còn hiệu lực.
4. Server teleport/đưa guest vào đúng instance của Nhà chủ; retry cùng invite không tạo quyền hoặc teleport trùng.
5. Chủ nhà có thể kick guest. Khi chủ rời Nhà hoặc instance đóng, toàn bộ guest được đưa về Làng Mạch Nguồn.

Quy tắc bắt buộc:

- Chỉ bạn bè của chủ nhà mới có thể nhận lời mời; là bạn bè thôi vẫn chưa đủ, phải có lời mời hiện hành do chủ nhà gửi.
- Guest không thể tự join qua danh sách server, follow, teleport payload giả hoặc invite đã hết hạn/dùng rồi.
- Số guest đồng thời là **TBD** theo performance/device test.
- Guest chỉ có quyền tham quan và dùng interaction xã hội được whitelist. Guest không thể đặt/lấy decoration, đổi tượng active, nhận buff, quản lý thú, nhận reward, cho thú vào tập luyện hoặc tiêu tài nguyên của chủ.
- Lời mời là quyền theo phiên, không phải whitelist vĩnh viễn. Block/unfriend/kick làm mất quyền vào ở lần validation tiếp theo.

## Trưng bày sinh vật và vật phẩm

Nhà cho phép chủ sở hữu tạo các khu trưng bày:

- creature showcase;
- tượng và trophy;
- decoration/furniture nguyên bản;
- badge/title/event memento nếu được thêm sau này.

Creature showcase là presentation snapshot tham chiếu owned creature; không clone ownership và không tạo thêm creature instance gameplay. Xóa/move showcase không xóa thú. Một creature đang tập luyện có thể xuất hiện bằng display snapshot, nhưng model trưng bày không tham chiến, không nhận XP riêng và không được guest thao tác.

Placement phải dùng grid/bounds/collision/budget do server validate. Mỗi Nhà có giới hạn decoration, rig và effect để tránh lag; upgrade có thể mở thêm không gian hoặc budget theo definition, không tin transform/count từ client.

## Tượng sinh vật và buff theo hệ

Mỗi tượng có `statueId`, species hình mẫu, element canonical, tier/level nếu definition cho phép, nguồn sở hữu và một `StatueBuffDefinition`. Tượng của sinh vật hệ Lửa chỉ buff sinh vật hệ Lửa của chính chủ nhà; tương tự cho Thường, Nước, Tự nhiên và Gió.

### Nguồn nhận tượng

- phần thưởng hoặc drop cực hiếm từ World Boss;
- drop cực hiếm từ wild/elite đủ điều kiện;
- quest, event, achievement hoặc boss token exchange;
- mua bằng tiền trong game tại shop được định nghĩa;
- crafting nếu sau này có recipe được duyệt.

“Mua” trong thiết kế hiện tại mặc định là tiền trong game/token. Robux, paid product hoặc trading không tự được thêm nếu chưa có quyết định monetization riêng.

### Tượng trưng bày và tượng active

Người chơi có thể đặt nhiều tượng để trang trí, nhưng chỉ tượng đặt trên **Bệ Cộng Hưởng** active mới tạo buff. Để tránh pay-to-stack và nhồi hàng chục tượng:

- DRAFT ban đầu có tối đa một bệ active cho mỗi hệ cơ bản, mở dần qua nâng cấp Nhà.
- Hai tượng cùng hệ không cộng dồn; chủ chọn đúng một tượng active cho hệ đó.
- Đổi tượng active chỉ thực hiện tại Nhà Riêng khi chủ không ở expedition.
- Buff chỉ áp dụng cho creature của chủ có element khớp; guest và creature của guest không nhận buff.
- Expedition dùng statue-buff snapshot khi khởi hành. Thay decoration/invite không sửa stats giữa expedition.
- Team Power đọc final canonical stats sau buff nhưng UI phải tách rõ phần tăng đến từ tượng.

Ví dụ DRAFT: một tượng Pyrel hệ Lửa có thể cho toàn bộ creature Lửa của chủ `+3% Attack`. Tượng khác cùng hệ có thể thiên về Max HP, Defense hoặc một chỉ số hợp lệ khác; exact stat/cap do data định nghĩa. Không dùng tên model để suy element hoặc buff.

## Khu Tập Luyện

Khu Tập Luyện cho phép đặt một số creature không tham chiến vào slot để nhận XP thụ động chậm nhưng liên tục.

### Slot và điều kiện

- Số slot có giới hạn; DRAFT khởi đầu là một slot và các mốc nâng cấp có thể mở thêm, cap production vẫn TBD.
- Creature đang ở main lineup, support lineup hoặc active expedition không thể được đưa vào tập luyện.
- Creature đang tập luyện không thể được dùng làm duplicate donor, trade/consume hoặc tham gia lineup cho tới khi rút ra.
- Chỉ chủ nhà có thể thêm/rút creature; guest không có quyền.
- Một creature chỉ có thể nằm trong đúng một training slot và một Nhà tại một thời điểm.

### XP cố định và nâng cấp

Mỗi cấp Khu Tập Luyện khai báo một tốc độ cố định `xpPerMinute`. Mọi creature đang chiếm slot ở cùng facility level nhận cùng số XP theo thời gian, không nhân theo rarity, level, Team Power hoặc XP requirement:

```text
wholeMinutes = floor((serverNow - lastTrainingTimestamp) / 60)
earnedXP = wholeMinutes * TrainingRateByFacilityLevel[facilityLevel]
```

Tăng cấp facility có thể tăng `xpPerMinute`, số slot hoặc cả hai theo definition. Tốc độ cụ thể, số tier, material và tiền nâng cấp đều TUNABLE; không tự thêm Robux. Vì XP nhận là số cố định trong khi XP curve tăng theo level, Khu Tập Luyện hữu ích để nuôi thú phụ nhưng chậm hơn chiến đấu chủ động ở level cao.

XP được tính liên tục cả khi online lẫn offline bằng timestamp server, không chạy vòng lặp tick cho từng Nhà. XP dừng ở level cap; level-up/evolution chuẩn vẫn do progression service resolve. Retry/rejoin/save failure không được nhân đôi thời gian hoặc XP. Nếu cần anti-overflow kỹ thuật, cap elapsed chỉ được thêm sau khi có quyết định sản phẩm rõ, không âm thầm làm sai lời hứa “liên tục”.

## Hồi phục, đội hình và luồng expedition

- Người chơi vào game tại Làng Mạch Nguồn, không tự spawn trong Nhà Riêng.
- Chọn main/support, đổi đá/skill và tượng active tại Nhà Riêng. NPC crafting, quest, evolution và duplicate service nằm ở Làng.
- Chủ có thể teleport từ Làng về Nhà để chuẩn bị; từ Nhà quay lại Làng để dùng cổng world.
- Energy bị trừ khi server commit khởi hành từ cổng Làng, không phải khi teleport giữa Làng và Nhà.
- Chủ động kết thúc expedition có thể đưa người chơi về Làng Mạch Nguồn hoặc Nhà Riêng theo lựa chọn hợp lệ; đến một trong hai safe zone đều hồi đầy đội. Wipe đủ ba mặc định đưa người chơi về Nhà Riêng và cũng hồi đầy.
- Khởi hành chỉ hợp lệ khi người chơi đã rời trạng thái guest/training management, loadout hợp lệ và expedition snapshot được server khóa.

## Persistence và authority

Profile cần lưu tối thiểu:

- `privateHomeVersion`, layout/upgrade/budget;
- decoration/statue inventory và placement canonical;
- active pedestal theo element;
- training facility level, slot assignments và server timestamps;
- invite không lưu như quyền dài hạn; invite theo phiên nằm ở service/instance state.

Mọi placement transaction, statue activation, upgrade, training assignment/withdraw và XP settlement đều idempotent. Client chỉ gửi intent/instance ID/transform đề xuất; server kiểm tra ownership, state, bounds, cost và conflict trước commit.

## Test plan

- Join luôn vào Làng; teleport Nhà/quay lại Làng không tiêu exploration energy.
- Kết thúc expedition về Làng hoặc Nhà đều hồi đầy đội đúng một lần; disengage/new encounter ngoài world không hồi.
- Người lạ, bạn chưa được mời, invite giả/hết hạn/dùng lại đều không vào được.
- Chỉ đúng friend được mời có thể accept; owner kick/leave đưa guest về Làng.
- Guest không sửa placement, statue, training, inventory, reward hoặc buff.
- Creature display không clone ownership/XP và xóa display không xóa owned creature.
- Chỉ tượng trên bệ active buff đúng element của owner; cùng hệ không stack; guest không nhận buff.
- Expedition snapshot không đổi khi owner thay statue sau đó; Team Power giải thích đúng nguồn buff.
- Training slot cap đúng; creature main/support/expedition/donor conflict bị từ chối.
- XP online/offline theo đúng whole minute và facility rate cố định; không nhân rarity/level; retry/rejoin không grant hai lần.
- Upgrade tăng đúng rate/slot theo definition; cost transaction không duplicate; XP dừng ở level cap và evolution resolve đúng.
