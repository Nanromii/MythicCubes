# Thế giới, Làng công cộng và vòng lặp khám phá

> **Trạng thái:** product direction được người dùng bổ sung ngày 2026-08-04. Tên riêng, tỷ lệ rơi và con số balance được đánh dấu **DRAFT/TUNABLE**. Tài liệu này mô tả game đích, không xác nhận source hiện tại đã triển khai.

Map, landmark, lighting, ambience và motif âm nhạc của Làng, Nhà Riêng và năm world tuân theo [Định hướng hình ảnh, giao diện và âm thanh](VISUAL_AUDIO_UI_DIRECTION.md) và được triển khai từ Phase 6–10, không chờ một đợt polish cuối. Cơ chế Nhà cá nhân nằm trong [Nhà Riêng, trưng bày, tượng và Khu Tập Luyện](PRIVATE_HOME_HOUSING.md).

## Fantasy và bối cảnh nguyên bản

**Làng Mạch Nguồn** là public hub nơi mọi người xuất hiện, gặp NPC và đi qua năm cổng tới năm world khởi đầu. Làng được xây tại nơi năm mạch năng lượng giao nhau, mỗi cổng mang bản sắc của một hệ. Mỗi người chơi đồng thời sở hữu một **Nhà Riêng** có thể teleport về để chuẩn bị đội, trưng bày collection và dùng các tiện ích cá nhân. Người chơi là một **Người Dẫn Mạch**, cùng các sinh vật đồng hành khám phá world, ổn định các vùng bất thường, thu thập sinh vật/vật liệu rồi trở về Nhà và Làng để chuẩn bị chuyến đi tiếp theo.

Câu chuyện không có điểm kết thúc cứng. Boss và nhiệm vụ mở thêm world, còn mục tiêu dài hạn là collection, xây nhiều đội, săn build hiếm, tham gia event, bảng xếp hạng và PvP trong tương lai. Nội dung phải là IP nguyên bản; không dùng sinh vật, vật phẩm, tên hoặc visual language của IP bên thứ ba.

## Năm world khởi đầu

Số world khởi đầu và số starter đều là **năm**, tương ứng năm hệ hiện có. Tên dưới đây là DRAFT:

| World | Hệ chính | Starter tương ứng | Bản sắc gameplay DRAFT |
| --- | --- | --- | --- |
| Bình Nguyên Khởi Sinh | Thường | Pebblit | Cân bằng, dễ đọc, kẻ địch ít cực đoan và phù hợp tutorial tổng quát |
| Quần Đảo Hỏa Mạch | Lửa | Pyrel | Damage bùng nổ, burn, địa hình nguy hiểm theo nhịp |
| Hải Vực Lam Triều | Nước | Tiderook | Phòng thủ, hồi phục, slow và vùng nước thay đổi đường đi |
| Đại Lâm Mầm Sống | Tự nhiên | Bramblet | Armor, poison, hồi phục và đường rừng phân nhánh |
| Thiên Lộ Phong Vân | Gió | Zephlet | Tốc độ, né vùng nguy hiểm, attack cadence và địa hình cao |

Năm world đầu là nhóm world yếu/onboarding và **không spawn legendary wild**. Các world khó hơn được thêm về sau có thể là world chuyên sâu một hệ, world lai hệ hoặc world có rule đặc biệt; chỉ những world được definition cho phép mới có legendary spawn.

Mỗi world gồm nhiều region/subzone. Hai người ở cùng world nhưng khác server shard hoặc event instance có thể không nhìn thấy nhau. World/region/spawn pool/difficulty/reward phải data-driven và có ID nguyên bản ổn định.

## Onboarding năm starter

1. Người chơi đến Làng Mạch Nguồn và xem năm cổng world.
2. Chọn đúng một trong năm starter: Pebblit, Pyrel, Tiderook, Bramblet hoặc Zephlet.
3. Tutorial giải thích ba companion active, basic attack, active skill và capture.
4. Tutorial đưa người chơi tới tuyến tương ứng starter và tạo một encounter được server đánh dấu bảo đảm capture để nhận sinh vật thứ hai.
5. Người chơi được giới thiệu Nhà Riêng, hoàn thiện đội ban đầu, quay lại Làng rồi bắt đầu expedition tự do qua cổng.

Starter được cân bằng cùng rarity khởi đầu để lựa chọn dựa trên lối chơi/hệ, không có lựa chọn mặc định mạnh hơn rõ rệt. Việc source lịch sử Phase 1 hiện chỉ có bốn starter là migration tương lai; không sửa acceptance/history của Phase 1.

## Làng Mạch Nguồn — public hub và NPC

Làng là khu an toàn công cộng và là điểm xuất hiện ban đầu, không phải Nhà Riêng của bất kỳ user nào. Tập NPC DRAFT:

| NPC/chức năng | Trách nhiệm |
| --- | --- |
| Người Giữ Cổng | Chọn world, xem năng lượng khám phá và bắt đầu expedition |
| Thợ Chế Nang | Chế tạo/mua bóng bằng tiền trong game và nguyên liệu; không tự quyết định Robux |
| Thợ Khắc Đá | Chế tạo, quản lý và tinh chỉnh đá trang bị |
| Người Giữ Tiến Hóa | Thực hiện/giải thích evolution khi đủ điều kiện |
| Nhà Đồng Vọng | Dùng duplicate cùng loài để truyền XP hoặc làm điều kiện roll skill |
| Bảng Nhiệm Vụ | Nhiệm vụ ngày, world, sự kiện và onboarding |
| Người Dẫn Lối | Giải thích/teleport tới Nhà Riêng; không cấp quyền vào Nhà của user khác |

Tên NPC và presentation chưa phải production. Crafting, shop và quest đều server-authoritative; giá/recipe/reward cần bảng dữ liệu và economy review riêng. Chọn đội, trưng bày, tượng active và Khu Tập Luyện thuộc Nhà Riêng. Hồi đầy đội là rule safe-zone dùng chung cho cả Làng và Nhà, không cần bình hồi máu hoặc NPC riêng.

## Năng lượng khám phá 7/7

Exploration limit kiểm soát **số expedition khởi hành qua cổng Làng**, không giới hạn thời gian ở ngoài world. Teleport Làng ↔ Nhà Riêng không tiêu energy.

- Maximum: `7/7`.
- DRAFT được chọn: hồi `1` điểm mỗi `20 phút`; từ `0 → 7` mất 140 phút.
- Hồi theo timestamp server và tiếp tục khi offline.
- Trừ đúng một điểm khi server commit một lần khởi hành từ cổng Làng thành công.
- Di chuyển giữa region/subzone trong cùng expedition không trừ thêm.
- Quay về Nhà/Làng không hoàn điểm. Đi qua cổng Làng lần nữa tạo expedition mới và trừ tiếp một điểm.
- Khi `0/7`, người chơi vẫn dùng toàn bộ NPC Làng và Nhà Riêng nhưng không thể bắt đầu expedition.
- Teleport/instance allocation thất bại trước commit không được trừ. Retry cùng expedition request ID không trừ hai lần.
- Disconnect không hoàn năng lượng. Nếu session recovery còn giữ expedition hợp lệ, reconnect tiếp tục expedition; nếu phải đưa về Nhà Riêng để an toàn thì lần năng lượng đã dùng vẫn không được hoàn.
- Event/login/quest có thể thưởng energy refill, nhưng quantity và cap overflow phải được định nghĩa riêng; không tự bán bằng Robux trong thiết kế này.

Exploration energy, timestamp và active expedition cần persistence ở Phase 11. Client chỉ hiển thị snapshot và countdown từ mốc server.

## Khóa loadout và trạng thái expedition

Người chơi chỉnh đội tại Nhà Riêng. Khi chuẩn bị rời Làng qua cổng world, server chốt:

- Ba thú chính cùng tham chiến.
- Sáu thú phụ chỉ dùng cho cộng hưởng.
- Skill, đá và skill modifier của từng thú.
- Statue buff active theo hệ của chủ nhà.
- Bóng/vật phẩm được phép mang theo.

Main/support lineup và creature equipment bị khóa trong expedition; chỉ thay tại Nhà Riêng. Điều này ngăn đổi thú/đá liên tục để né cooldown hoặc counter ngay giữa combat. Inventory bóng có thể giảm do sử dụng nhưng không đổi loadout creature.

Ba thú chính bắt đầu expedition với maximum HP vì Làng và Nhà Riêng đều là safe zone hồi đầy. Ở ngoài world:

- HP được giữ xuyên suốt các encounter trong cùng expedition, không tự hồi đầy sau mỗi trận/disengage.
- Không có bình hồi máu mang theo.
- Chỉ skill hồi máu, buff hồi phục, hút máu hoặc effect hợp lệ của build mới hồi HP ngoài world.
- Một thú bị hạ không tự hồi cho tới khi về Làng hoặc Nhà Riêng, trừ khi sau này có skill revive được duyệt.
- Khi cả ba thú chính bị hạ, expedition kết thúc và player bị đưa về Nhà Riêng.
- Trở về Làng hoặc Nhà Riêng kết thúc expedition và hồi đầy đội trước lần đi tiếp theo; safe zone không tạo bình hồi máu mang ra world.

Player có thể chủ động kết thúc expedition để chọn về Làng hoặc Nhà Riêng khi còn thú sống. Cả hai nơi đều hồi đầy, nhưng chỉ Nhà Riêng cho đổi đội/loadout. Không có cơ chế đổi đội ngoài world.

## Combat, capture và phần thưởng thường

Encounter là shared: nhiều user hợp lệ có thể cùng đánh cùng wild trong cluster; không private cả cụm khi một user engage. Capture bằng bóng là loop chính; cooking chỉ hỗ trợ lure/prep/buff hoặc hành vi cụm, không thay thế capture. Capture lock chỉ áp dụng cho đúng wild đang bị attempt, được tạo atomic khi server chấp nhận request và fail thì unlock lại.

Ba companion chính cùng xuất hiện, follow theo formation và tham chiến. Wild có thể xuất hiện một mình hoặc thành cluster; mọi thành viên hợp lệ trong encounter đều có thể đánh. Mỗi companion giữ một target tại một thời điểm; active skill và target rule phải do server xác nhận.

Capture thành công một wild không dừng encounter. Các wild còn lại tiếp tục đánh; player có thể bắt thêm hoặc disengage. Target full HP vẫn được phép thử bắt với chance thấp; HP càng thấp thì chance càng cao. Mọi lần ném hợp lệ đều tiêu bóng dù thành công hay thất bại.

Đánh bại wild thường cấp:

- XP cho thú chính đã thực sự tham gia encounter.
- Nguyên liệu chế tạo bóng.
- Nguyên liệu chế tạo/nâng đá.
- Tiền trong game hoặc reward token theo world definition.
- Tỷ lệ rất thấp rơi vật phẩm/đá có skill modifier.
- Tỷ lệ cực thấp từ loot entry đủ điều kiện có thể rơi tượng sinh vật để trưng bày/kích hoạt tại Nhà Riêng; species, element và drop table do definition quyết định.

XP DRAFT: thú đã tham gia và còn sống khi encounter kết thúc nhận 100% share; thú đã tham gia nhưng bị hạ nhận 50%. Không chia XP cho sáu support chỉ đứng trong đội phụ.

Participation/contribution, capture success reward và kill reward/item drop là ba loại credit riêng. Nếu wild chết trước khi được bắt và có item drop, user gây `last-hit final blow` nhận item; chi tiết XP/reward participation khác là `TBD`.

## Elite wild

Elite là một biến thể đột biến của loài đang sống trong world đó, không phải evolution stage, rarity tier hoặc legendary classification.

- Spawn với tỷ lệ thấp từ eligible normal spawn entry.
- Có presentation dễ nhận biết nhưng vẫn giữ silhouette nguyên bản của loài.
- HP, attack, defense và AI pressure cao hơn bằng multiplier data-driven.
- **Không thể capture bằng bất kỳ bóng nào.** Server từ chối trước khi tiêu inventory/roll.
- Cho nhiều XP hơn và bảng loot tốt hơn, đặc biệt là stone rarity/roll cao hơn.
- Có tỷ lệ tốt hơn wild thường cho ball material, stone material và skill-modifier item; vẫn chịu world difficulty và drop cap.
- Elite chết đi theo respawn/loot transaction idempotent, không thể nhận reward hai lần.

DRAFT/TUNABLE ban đầu: elite spawn `1–3%` trên eligible spawn, stat multiplier `1,8–2,5x`, XP `2,5x`, loot quality thêm một bậc tối đa nhưng không bảo đảm đá hiếm.

## Vật phẩm skill modifier cực hiếm

Nhóm vật phẩm này được thiết kế dưới dạng đá có primary affinity Máu hoặc Damage và một affix `SkillModifier`, nên vẫn chiếm một trong chín ô đá. Ví dụ đã duyệt về hướng:

- Giảm cooldown skill, chịu cap toàn build.
- Mở rộng vùng tác dụng của skill như vùng phun lửa.
- Tung skill hai lần liên tiếp nhưng tăng cooldown cuối cùng 50%.
- Tăng thời gian buff/debuff/effect.

Một skill chỉ nhận tối đa một modifier cùng loại; modifier unique không stack. Server validate skill tương thích, geometry cap, cooldown floor và effect duration cap. World khó hơn tăng nhẹ xác suất rơi nhưng item vẫn cực hiếm; không hard-code theo tên skill trong service.

## World Boss công cộng

World Boss là event công cộng, không thể capture và khác legendary wild.

### Lịch spawn DRAFT

- Tối đa `5` event ID trong mỗi 24 giờ, mục tiêu 4–5 lần/ngày.
- Các event cách nhau tối thiểu khoảng 3 giờ; lịch do server/global coordinator tạo, không dựa vào đồng hồ client.
- Thông báo toàn server ecosystem cho biết boss xuất hiện ở **world nào**, không tiết lộ subzone chính xác.
- Người chơi phải vào đúng world và tự tìm subzone.
- Nếu world có nhiều shard/instance, một `WorldBossEventId` đại diện một boss logic; các bản trình diễn shard dùng shared global HP/contribution để mọi người có thể tham gia mà không cần cùng một physical server.

Thiết kế cross-server cần MemoryStore/MessagingService và persistence ledger ở phase riêng; fallback prototype có thể giới hạn leaderboard trong một server nhưng không được gọi là global production.

### Contribution và reward

Server ghi ba bảng contribution để không chỉ ưu ái damage dealer:

- Damage hợp lệ gây lên boss.
- Damage hợp lệ tank/mitigate cho đội.
- Support hợp lệ như healing/buff/debuff contribution.

Reward DRAFT:

- Mọi người vượt participation threshold: XP đội chính, tiền trong game, ball/stone material.
- Top bracket từng bảng: rương đá chất lượng cao hơn, boss token và vật liệu event.
- Người kết liễu: finisher chest nhỏ và title/badge theo event; reward này cố ý không mạnh hơn toàn bộ top reward để giảm last-hit stealing.
- Drop cực hiếm: skill-modifier stone/catalyst; world boss khó hơn tăng nhẹ chance nhưng vẫn có cap.
- Tượng/trophy boss theo loot table hoặc achievement; một số tượng có buff element khi được đặt trên Bệ Cộng Hưởng tại Nhà Riêng.

Mỗi player chỉ claim một reward package cho mỗi `WorldBossEventId`. Damage/tank/support giả từ client bị bỏ qua; AFK, alt farming và contribution bất thường cần rule chống abuse.

## Legendary wild độc quyền

Legendary wild chỉ xuất hiện ở world cao hơn có definition cho phép:

- Spawn rate cực thấp và chỉ spawn đúng một cá thể, không bao giờ thành cluster.
- Là creature rarity Đỏ/Legendary và dùng legendary capture rules.
- Player đến sớm và claim encounter hợp lệ có quyền đánh/bắt; player khác không thể xen ngang hoặc gây damage.
- Nếu đội owner bị hạ, owner disengage hoặc encounter hết hiệu lực, claim được giải phóng sau lifecycle reset; player khác phát hiện sau đó có thể claim.
- Legendary không phải World Boss: không có public damage leaderboard và có thể capture.
- Tier 1/2 không được bắt; Tier 3 chance cực thấp; Special/Legendary Ball hữu dụng hơn nhưng không bảo đảm.

Spawn cooldown, per-server/per-world daily cap và thông báo legendary không được chốt. Không công bố vị trí chính xác; discovery phải có giá trị.

## Vòng đời game mở

Không có “màn cuối” bắt buộc. Sau năm world đầu:

- Thêm world, region, sinh vật và skill theo content pack đã validation.
- World cao hơn tăng level, elite pressure, loot quality và cơ hội legendary.
- Boss/event, quest và bảng xếp hạng tạo mục tiêu theo mùa.
- PvP challenge/arena và ranking được thêm sau khi PvE, persistence và balance ổn định.

Power creep phải được kiểm soát bằng stat budget, cap, content tier và migration; không làm world cũ mất toàn bộ giá trị thu thập/nguyên liệu.

## Test plan bắt buộc khi triển khai

- Năm starter/năm cổng mapping đúng hệ; chọn starter vẫn chỉ thực hiện một lần.
- Energy 7/7, hồi offline 20 phút, retry/teleport failure không trừ hai lần và không tin clock client.
- Teleport Làng ↔ Nhà không trừ energy; chỉ khởi hành qua cổng Làng trừ một; chuyển subzone không trừ; quay về không hoàn.
- Loadout main/support/stone bị khóa ngoài world.
- HP giữ xuyên encounter; không có consumable heal; trở về Làng/Nhà đều hồi đầy; wipe đủ ba mặc định đưa về Nhà Riêng.
- Capture full HP có chance thấp nhưng hợp lệ; HP thấp hơn luôn tốt hơn; failure tiêu đúng một bóng.
- Capture một thành viên không dừng encounter còn lại.
- Elite không capture được, multiplier/XP/loot đúng và reward idempotent.
- World boss không quá năm event/ngày, announcement không lộ subzone, contribution/reward không duplicate.
- Legendary chỉ một cá thể, exclusive claim, không bị player khác xen ngang và claim được giải phóng an toàn sau wipe/disengage.
