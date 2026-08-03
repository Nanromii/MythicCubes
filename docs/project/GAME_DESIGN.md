# Thiết kế game cấp cao

Phần lớn nội dung dưới đây là định hướng sản phẩm. Phase 1 mới triển khai Home và starter selection placeholder, chưa triển khai core loop hoàn chỉnh. Tên “Voxel Creatures” là placeholder; thế giới, sinh vật, vật phẩm và ngôn ngữ hình ảnh phải là IP nguyên bản.

## Tầm nhìn sản phẩm

Tạo một game Roblox thu thập sinh vật dễ tiếp cận, có cảm giác phiêu lưu trong thế giới blocky, chiều sâu đến từ xây đội hình và kỹ năng chủ động thay vì thao tác quá phức tạp.

## Người chơi mục tiêu và core fantasy

Người chơi thích khám phá, sưu tầm và tiến triển theo phiên chơi ngắn đến vừa. Core fantasy là trở thành nhà thám hiểm gắn kết với đội ba sinh vật, tìm giống loài hiếm và vượt qua người bảo hộ của từng vùng.

## Ngôn ngữ

Ngôn ngữ gameplay mặc định là tiếng Việt. Tên riêng nguyên bản của sinh vật có thể được giữ nguyên, còn hướng dẫn, trạng thái, nút bấm, hệ, vai trò và kỹ năng phải có nội dung hiển thị tiếng Việt. UI hệ thống do Roblox cung cấp, như chat và menu CoreGui, phụ thuộc cài đặt ngôn ngữ của Roblox/người chơi và không thuộc source UI của dự án.

## Core gameplay loop

```text
Chuẩn bị tại Home → khám phá vùng → gặp sinh vật → chiến đấu
→ bắt hoặc nhận phần thưởng → cải thiện collection/đội hình
→ đánh boss → mở vùng mới → lặp lại với thử thách mới
```

## Chiến đấu trên map

Combat Phase 3 hiện tại chỉ là test harness để kiểm chứng state, damage, cooldown và server authority. Product combat được chốt theo hướng PvE trực tiếp trên map: thú đồng hành đi theo người chơi; sinh vật tự nhiên spawn ngẫu nhiên theo pool của từng vùng, dưới dạng cá thể hoặc cụm; hai bên tự tiếp cận và đánh khi vào đúng tầm. Người chơi có thể chạy ra xa để disengage theo rule server.

PvP chưa thuộc MVP. Hướng tương lai là cho người chơi ở gần nhau gửi/chấp nhận lời thách đấu, sau đó server đưa hai bên tới arena cách ly để thú chiến đấu mà không bị người chơi khác hoặc sinh vật tự nhiên can thiệp.

Chi tiết authority, spawn, aggro/leash, phase allocation và các điểm TBD nằm trong [Thiết kế chiến đấu thế giới mở](../design/OPEN_WORLD_COMBAT.md).

## Onboarding dự kiến

1. Người chơi chọn đúng một trong bốn starter nguyên bản tại Home.
2. Tutorial giải thích cơ chế bắt và cấp một `Trail Capsule`, thiết bị bắt cơ bản nguyên bản.
3. Người chơi chọn một trong bốn tuyến vùng khởi đầu.
4. Encounter thực hành đầu tiên được server bảo đảm bắt thành công để trao sinh vật thứ hai; loài gặp phụ thuộc tuyến vùng đã chọn.

Onboarding capture và bốn tuyến vùng thuộc các phase sau, chưa được triển khai trong Phase 1. Trường hợp bắt thành công bảo đảm chỉ áp dụng cho encounter tutorial được server đánh dấu; client không tự quyết định kết quả.

## Trụ cột gameplay

- **Home:** điểm an toàn để quản lý đội hình, collection và chuẩn bị chuyến đi.
- **Khám phá vùng:** mỗi vùng có địa hình, mức nguy hiểm, encounter và boss riêng.
- **Thu thập sinh vật:** sinh vật có identity, vai trò và bộ kỹ năng rõ ràng; collection phát triển lâu dài.
- **Đội ba sinh vật:** người chơi phối hợp tối đa ba thành viên, cân bằng Công, Thủ, Khống chế và Hỗ trợ.
- **Chiến đấu bán tự động:** sinh vật tự xử lý hành vi cơ bản; người chơi chọn thời điểm dùng kỹ năng chủ động.
- **Hệ nguyên tố:** số hệ ban đầu nhỏ, quan hệ dễ đọc và được định nghĩa bằng dữ liệu.
- **Bắt sinh vật:** làm suy yếu mục tiêu, dùng thiết bị bắt và để server quyết định kết quả.
- **Boss và mở vùng:** boss kiểm tra khả năng xây đội; chiến thắng mở đường cho khu vực tiếp theo.
- **Sưu tập dài hạn:** sinh vật hiếm, biến thể hoặc mục tiêu collection tạo động lực quay lại nhưng không làm mất tính công bằng cốt lõi.
- **Sinh vật huyền thoại:** encounter đặc biệt gắn với thế giới nguyên bản, có điều kiện và phần thưởng rõ ràng.
- **Thế giới khác:** có thể mở rộng thành chiều không gian mới sau khi core loop ổn định.

## Thiết kế sinh vật, nguyên tố và kỹ năng

Product design đã chốt dùng năm hệ ban đầu: Thường (`normal`), Lửa (`fire`), Nước (`water`), Tự nhiên (`nature`) và Gió (`wind`). Sinh vật chỉ dùng skill cùng hệ, có tối đa ba skill theo ba bậc tiến hóa, level giới hạn 1–100 và tiến hóa theo mốc level 18/54. XP curve, skill pool, roll skill và scaling phải data-driven, server-authoritative; những tham số chưa được duyệt vẫn là TBD.

Implementation Phase 2–3 hiện chưa phản ánh toàn bộ target này: registry vẫn dùng `verdant`, `ember`, `tide`, `gale`, chỉ có effect `Damage`, chưa có hệ Thường, XP/tiến hóa/status/roll skill và combat presentation vật lý hoàn chỉnh. Migration source phải được thực hiện trong task code riêng.

Quy tắc đầy đủ, ranh giới implementation và phân bổ phase nằm trong [Hệ thống sinh vật, nguyên tố và kỹ năng](../design/CREATURE_ELEMENT_SKILL_SYSTEM.md).

## MVP dự kiến

- Một Home, bốn tuyến vùng khởi đầu quy mô nhỏ và một boss cho vertical slice.
- Bốn lựa chọn starter nguyên bản, người chơi nhận một; sinh vật thứ hai đến từ tutorial capture theo tuyến vùng đã chọn.
- Một số ít hệ nguyên tố, vai trò và kỹ năng.
- Hai loại thiết bị bắt.
- Điều kiện mở khóa vùng thứ hai.

MVP là mục tiêu cho các phase sau, không phải trạng thái hiện tại.

## Ngoài MVP

Nhiều thế giới, hàng trăm sinh vật/kỹ năng, PvP, trading, guild, daily quest, battle pass, matchmaking, teleport nhiều place, monetization nâng cao và live events chưa thuộc MVP. Chỉ xem xét sau khi vertical slice được kiểm chứng.

## Nguyên tắc IP

Không sử dụng tên, model, hình ảnh, icon, âm thanh, nhạc, kỹ năng đặc trưng, vùng đất, nhân vật hoặc vật phẩm của Pokémon hay bất kỳ IP bên thứ ba nào khi chưa có giấy phép rõ ràng.

Art direction đích là voxel/blocky diorama nguyên bản: sinh vật và môi trường ghép từ các khối hơi vuông vức, có thể bo cạnh nhẹ, màu sạch và silhouette dễ đọc. Prototype sinh vật nên dùng khoảng 6–12 khối thay vì một cube duy nhất; không cần model quá chi tiết. Map, creature, icon, animation, UI và effect phải được tự thiết kế, không sao chép visual language cụ thể của game khác.
