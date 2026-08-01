# Thiết kế game cấp cao

Toàn bộ nội dung dưới đây là định hướng sản phẩm, **chưa được triển khai trong Phase 0**. Tên “Voxel Creatures” là placeholder; thế giới, sinh vật, vật phẩm và ngôn ngữ hình ảnh phải là IP nguyên bản.

## Tầm nhìn sản phẩm

Tạo một game Roblox thu thập sinh vật dễ tiếp cận, có cảm giác phiêu lưu trong thế giới blocky, chiều sâu đến từ xây đội hình và kỹ năng chủ động thay vì thao tác quá phức tạp.

## Người chơi mục tiêu và core fantasy

Người chơi thích khám phá, sưu tầm và tiến triển theo phiên chơi ngắn đến vừa. Core fantasy là trở thành nhà thám hiểm gắn kết với đội ba sinh vật, tìm giống loài hiếm và vượt qua người bảo hộ của từng vùng.

## Core gameplay loop

```text
Chuẩn bị tại Home → khám phá vùng → gặp sinh vật → chiến đấu
→ bắt hoặc nhận phần thưởng → cải thiện collection/đội hình
→ đánh boss → mở vùng mới → lặp lại với thử thách mới
```

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

## MVP dự kiến

- Một Home và một vùng Đồng Cỏ nguyên bản.
- Ba sinh vật khởi đầu, một số sinh vật hoang dã và một boss.
- Một số ít hệ nguyên tố, vai trò và kỹ năng.
- Hai loại thiết bị bắt.
- Điều kiện mở khóa vùng thứ hai.

MVP là mục tiêu cho các phase sau, không phải trạng thái hiện tại.

## Ngoài MVP

Nhiều thế giới, hàng trăm sinh vật/kỹ năng, PvP, trading, guild, daily quest, battle pass, matchmaking, teleport nhiều place, monetization nâng cao và live events chưa thuộc MVP. Chỉ xem xét sau khi vertical slice được kiểm chứng.

## Nguyên tắc IP

Không sử dụng tên, model, hình ảnh, icon, âm thanh, nhạc, kỹ năng đặc trưng, vùng đất, nhân vật hoặc vật phẩm của Pokémon hay bất kỳ IP bên thứ ba nào khi chưa có giấy phép rõ ràng.

