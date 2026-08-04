# Thiết kế game cấp cao

Phần lớn nội dung dưới đây là định hướng sản phẩm. Phase 1 mới triển khai một khu tên `Home` và starter selection placeholder; game đích sẽ migration khu xuất hiện đó thành public hub **Làng Mạch Nguồn**, tách khỏi **Nhà Riêng** của từng user. Core loop hoàn chỉnh chưa được triển khai. Tên “Voxel Creatures” là placeholder; thế giới, sinh vật, vật phẩm và ngôn ngữ hình ảnh phải là IP nguyên bản.

## Tầm nhìn sản phẩm

Tạo một game Roblox thu thập sinh vật dễ tiếp cận, có cảm giác phiêu lưu trong thế giới blocky, chiều sâu đến từ xây đội hình và kỹ năng chủ động thay vì thao tác quá phức tạp.

## Người chơi mục tiêu và core fantasy

Người chơi thích khám phá, sưu tầm và tiến triển theo phiên chơi ngắn đến vừa. Core fantasy là trở thành nhà thám hiểm gắn kết với đội ba sinh vật, tìm giống loài hiếm và vượt qua người bảo hộ của từng vùng.

## Ngôn ngữ

Ngôn ngữ gameplay mặc định là tiếng Việt. Tên riêng nguyên bản của sinh vật có thể được giữ nguyên, còn hướng dẫn, trạng thái, nút bấm, hệ, vai trò và kỹ năng phải có nội dung hiển thị tiếng Việt. UI hệ thống do Roblox cung cấp, như chat và menu CoreGui, phụ thuộc cài đặt ngôn ngữ của Roblox/người chơi và không thuộc source UI của dự án.

## Core gameplay loop

```text
Xuất hiện/giao dịch tại Làng ↔ chuẩn bị tại Nhà Riêng
→ khởi hành qua cổng Làng → khám phá vùng → gặp sinh vật → chiến đấu
→ bắt hoặc nhận phần thưởng → về Nhà trưng bày/huấn luyện/xây đội
→ trở lại Làng → đánh boss/mở vùng mới → lặp lại
```

## Chiến đấu trên map

Combat Phase 3 hiện tại chỉ là test harness để kiểm chứng state, damage, cooldown và server authority. Product combat được chốt theo hướng PvE trực tiếp trên map: ba thú chính đi theo người chơi; sinh vật tự nhiên spawn ngẫu nhiên theo pool của từng vùng, dưới dạng cá thể hoặc cụm; hai bên tự tiếp cận và đánh khi vào đúng tầm. Người chơi có thể chạy ra xa để disengage theo rule server. Ba thú chính giữ HP xuyên suốt expedition; trở về Làng hoặc Nhà Riêng sẽ hồi đầy, còn ngoài world chỉ skill/build hợp lệ mới hồi. Khi cả ba bị hạ, player mặc định được đưa về Nhà Riêng.

PvP chưa thuộc MVP. Hướng tương lai là cho người chơi ở gần nhau gửi/chấp nhận lời thách đấu, sau đó server đưa hai bên tới arena cách ly để thú chiến đấu mà không bị người chơi khác hoặc sinh vật tự nhiên can thiệp.

Chi tiết authority, spawn, aggro/leash, phase allocation và các điểm TBD nằm trong [Thiết kế chiến đấu thế giới mở](../design/OPEN_WORLD_COMBAT.md).

## Onboarding dự kiến

1. Người chơi xuất hiện tại Làng Mạch Nguồn và chọn đúng một trong năm starter nguyên bản, tương ứng Thường, Lửa, Nước, Tự nhiên và Gió.
2. Tutorial giải thích cơ chế bắt và cấp một `Trail Capsule`, thiết bị bắt cơ bản nguyên bản.
3. Người chơi chọn một trong năm world khởi đầu qua cổng ở Làng Mạch Nguồn.
4. Encounter thực hành đầu tiên được server bảo đảm bắt thành công để trao sinh vật thứ hai; loài gặp phụ thuộc world đã chọn.

Onboarding capture và năm world target thuộc các phase sau, chưa được triển khai trong Phase 1. Trường hợp bắt thành công bảo đảm chỉ áp dụng cho encounter tutorial được server đánh dấu; client không tự quyết định kết quả.

## Trụ cột gameplay

- **Làng Mạch Nguồn:** public hub/điểm xuất hiện có NPC chế bóng, đá, tiến hóa, duplicate/skill roll, nhiệm vụ và cổng world; trở về Làng hồi đầy đội.
- **Nhà Riêng:** mỗi user có một không gian riêng để hồi đầy đội, chọn loadout, trưng bày thú/tượng, kích hoạt tượng buff theo hệ và đưa thú vào Khu Tập Luyện nhận XP thụ động.
- **Khám phá vùng:** mỗi vùng có địa hình, mức nguy hiểm, encounter và boss riêng.
- **Thu thập sinh vật:** sinh vật có identity, vai trò và bộ kỹ năng rõ ràng; collection phát triển lâu dài.
- **Đội 3+6:** ba thú chính cùng tham chiến; sáu thú phụ không ra trận, chỉ kích hoạt tổ hợp cộng hưởng cố định. Chỉ đổi đội/loadout tại Nhà Riêng.
- **Chiến đấu bán tự động:** sinh vật tự xử lý hành vi cơ bản; người chơi chọn thời điểm dùng kỹ năng chủ động.
- **Hệ nguyên tố:** số hệ ban đầu nhỏ, quan hệ dễ đọc và được định nghĩa bằng dữ liệu.
- **Bắt sinh vật:** có thể thử ở full HP với chance thấp; làm yếu tăng chance; server quyết định kết quả và mọi lần ném hợp lệ đều tiêu bóng.
- **Boss và mở vùng:** boss kiểm tra khả năng xây đội; chiến thắng mở đường cho khu vực tiếp theo.
- **Sưu tập dài hạn:** sinh vật hiếm, biến thể hoặc mục tiêu collection tạo động lực quay lại nhưng không làm mất tính công bằng cốt lõi.
- **Sinh vật huyền thoại:** encounter đặc biệt gắn với thế giới nguyên bản, có điều kiện và phần thưởng rõ ràng.
- **Thế giới khác:** có thể mở rộng thành chiều không gian mới sau khi core loop ổn định.

- **Năng lượng khám phá:** khởi hành qua cổng Làng tiêu một trong `7/7` lượt, hồi một lượt mỗi 20 phút theo server; teleport Làng ↔ Nhà không tốn lượt, ở ngoài world không có time limit và chuyển subzone không tốn thêm.
- **Trang bị đá:** mỗi creature có bảng 3×3 gồm affinity Máu/Damage được roll khi nhận, mở dần theo level và có tối đa sáu line bonus.
- **Rarity và săn cá thể:** creature/stone dùng sáu bậc Trắng, Xanh lá, Xanh dương, Tím, Vàng, Đỏ. Creature rarity cố định theo loài/evolution line; nhiều loài có thể cùng rarity nhưng các cá thể cùng loài không roll rarity khác nhau. Duplicate cùng loài chỉ khác layout/skill/progression instance và dùng cho truyền XP hoặc skill roll.
- **Elite và event:** elite không capture được nhưng cho XP/loot tốt; World Boss công cộng có contribution leaderboard; legendary wild ở world cao là encounter độc quyền có thể capture.
- **Nhà và tượng:** chỉ friend được chủ mời mới vào Nhà; tượng có thể đến từ boss/shop/drop cực hiếm và chỉ buff creature cùng hệ của chủ khi được kích hoạt.
- **Khu Tập Luyện:** slot giới hạn cho creature không tham chiến nhận lượng XP cố định, chậm và liên tục; nâng cấp facility tăng rate/slot theo definition.

Thiết kế chi tiết được tách theo trách nhiệm:

- [Thế giới, Làng công cộng và vòng lặp khám phá](../design/WORLD_EXPLORATION_PROGRESSION.md).
- [Nhà Riêng, trưng bày, tượng và Khu Tập Luyện](../design/PRIVATE_HOME_HOUSING.md).
- [Rarity, đá trang bị, đội hình và lực chiến](../design/CREATURE_LOADOUT_PROGRESSION.md).
- [Encounter theo cụm và hệ thống bắt](../design/CAPTURE_SYSTEM.md).
- [Hệ thống sinh vật, nguyên tố và kỹ năng](../design/CREATURE_ELEMENT_SKILL_SYSTEM.md).
- [Định hướng hình ảnh, giao diện và âm thanh](../design/VISUAL_AUDIO_UI_DIRECTION.md).

Các hướng trên là game đích; source Phase 4 hiện tại chưa triển khai phần mở rộng.

## Thiết kế sinh vật, nguyên tố và kỹ năng

Product design đã chốt dùng năm hệ ban đầu: Thường (`normal`), Lửa (`fire`), Nước (`water`), Tự nhiên (`nature`) và Gió (`wind`). Sinh vật chỉ dùng skill cùng hệ, có tối đa ba skill theo ba bậc tiến hóa, level giới hạn 1–100 và tiến hóa theo mốc level 18/54. XP curve, skill pool, roll skill và scaling phải data-driven, server-authoritative; những tham số chưa được duyệt vẫn là TBD.

Implementation Phase 4 đã migration registry sang `normal`, `fire`, `water`, `nature`, `wind`, thêm đúng một basic skill `Damage` cho mỗi hệ, giới hạn ba skill và slot theo mốc level. XP/tiến hóa runtime, status, duplicate-gated roll skill và skill pool mở rộng vẫn chưa được triển khai; chúng được phân vào Phase 5/13/15.

Quy tắc đầy đủ, ranh giới implementation và phân bổ phase nằm trong [Hệ thống sinh vật, nguyên tố và kỹ năng](../design/CREATURE_ELEMENT_SKILL_SYSTEM.md).

## MVP dự kiến

- Một public hub Làng Mạch Nguồn, một Nhà Riêng nền cho mỗi user, năm world khởi đầu quy mô nhỏ theo năm hệ và boss/progression route tối thiểu.
- Năm lựa chọn starter nguyên bản, người chơi nhận một; sinh vật thứ hai đến từ tutorial capture theo world đã chọn.
- Một số ít hệ nguyên tố, vai trò và kỹ năng.
- Bốn ball tier kỹ thuật đang được đề xuất cho capture; tên production, balance và nguồn nhận vẫn chờ duyệt. Runtime Phase 4 hiện chỉ có hai thiết bị prototype.
- Năng lượng khám phá 7/7, đội ba chính/sáu phụ, rarity, stone board 3×3, một số resonance catalog mẫu và phiên bản nền của creature display/tượng/training slot.
- Điều kiện mở khóa vùng thứ hai.

MVP là mục tiêu cho các phase sau, không phải trạng thái hiện tại.

## Ngoài MVP

Hàng trăm sinh vật/kỹ năng, PvP, trading, guild, battle pass, matchmaking cạnh tranh và monetization nâng cao chưa thuộc MVP. World Boss/elite/legendary event có phase riêng sau khi PvE, persistence và economy nền ổn định.

## Nguyên tắc IP

Không sử dụng tên, model, hình ảnh, icon, âm thanh, nhạc, kỹ năng đặc trưng, vùng đất, nhân vật hoặc vật phẩm của Pokémon hay bất kỳ IP bên thứ ba nào khi chưa có giấy phép rõ ràng.

Art direction đích là voxel/blocky diorama nguyên bản: sinh vật và môi trường ghép từ các khối hơi vuông vức, có thể bo cạnh nhẹ, màu sạch và silhouette dễ đọc. Prototype sinh vật nên dùng khoảng 6–12 khối thay vì một cube duy nhất; không cần model quá chi tiết. Map, creature, icon, animation, UI, âm nhạc và effect phải được tự thiết kế hoặc có license rõ, không sao chép visual language cụ thể của game khác. Roadmap đưa presentation vào Phase 6–10 và 12 thay vì đợi polish cuối; xem [Định hướng hình ảnh, giao diện và âm thanh](../design/VISUAL_AUDIO_UI_DIRECTION.md).
