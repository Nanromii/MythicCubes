# Định hướng hình ảnh, giao diện và âm thanh

> **Trạng thái:** định hướng sản phẩm DRAFT ngày 2026-08-04. Tài liệu này đặt quality gate cho các phase tương lai; không xác nhận asset hoặc hệ thống presentation đã được triển khai.

## Mục tiêu

MythicCubes giữ phong cách voxel/blocky diorama nguyên bản nhưng không dừng ở các cube debug. Người chơi phải sớm nhìn thấy một thế giới có bản sắc, sinh vật có silhouette và chuyển động riêng, giao diện dễ hiểu và âm thanh phản hồi rõ hành động. Presentation được phát triển xen kẽ với gameplay thay vì gom thành một đợt polish cuối dự án.

Ba nguyên tắc:

1. Placeholder chỉ tồn tại trong phạm vi prototype có thời hạn và phải được ghi nhãn rõ.
2. Mỗi feature gameplay mới phải có trạng thái loading, success, failure và feedback tối thiểu phù hợp với desktop/mobile.
3. Asset, icon, nhạc, SFX, VFX và visual language phải nguyên bản hoặc có nguồn/license được lưu lại; không sao chép IP hay bộ nhận diện của game khác.

## Ngôn ngữ hình ảnh

- **Hình khối:** modular voxel/blocky, cạnh có thể bo nhẹ, tỷ lệ cách điệu và silhouette đọc được từ camera gameplay.
- **Màu sắc:** mỗi hệ và world có palette riêng; rarity không chỉ phân biệt bằng màu mà còn dùng khung, ký hiệu hoặc hiệu ứng để hỗ trợ người chơi khó phân biệt màu.
- **Độ chi tiết:** ưu tiên khối lớn, điểm nhận dạng rõ và vật liệu sạch hơn là model dày đặc chi tiết. Creature prototype 6–12 khối là điểm bắt đầu, không phải tiêu chuẩn production cuối.
- **Khả năng đọc combat:** wild, companion, elite, boss, vùng nguy hiểm, mục tiêu capture và target hiện tại phải phân biệt được trong chuyển động.
- **Hiệu năng:** thiết lập budget cho triangle/part, texture, particle, light, âm thanh đồng thời và số rig hoạt động trước khi sản xuất hàng loạt.

## Năm bộ nhận diện world

Năm world ban đầu dùng chung quy tắc modular nhưng có silhouette môi trường, palette, ánh sáng và motif âm thanh khác nhau:

| Hệ | Hướng môi trường | Dấu hiệu điều hướng | Hướng âm thanh |
| --- | --- | --- | --- |
| Thường | đồng cỏ, đá sáng, kiến trúc gần gũi | đường đất, cột mốc và đồi thấp | nhạc khám phá nhẹ, nhạc cụ mộc |
| Lửa | đá núi lửa, khe nhiệt, tương phản nóng | cột khói, dòng dung nham an toàn làm landmark | nhịp gõ rõ, lớp âm trầm nóng |
| Nước | đảo nhỏ, thác, hồ và cầu | dòng nước, tháp ven bờ, ánh phản chiếu | motif chảy, pad mềm và âm thanh nước |
| Tự nhiên | rừng tầng, rễ lớn, nấm/cây phát sáng | cây cổ thụ, vòm rễ và khoảng trống | gỗ, lá, sinh vật nền và nhịp hữu cơ |
| Gió | cao nguyên, đảo nổi, cờ/vải chuyển động | luồng gió, cối gió và silhouette trên cao | sáo/gió, texture thoáng và nhịp nhẹ |

Tên, palette và nhạc cụ cụ thể vẫn là DRAFT. Greybox phải chứng minh đường đi, khoảng nhìn, landmark, vùng spawn và camera trước khi thay bằng art kit production.

## Làng Mạch Nguồn — public hub

Làng phải là một public hub có thể nhận biết bằng landmark, không chỉ là phòng menu 3D. Bố cục cần giúp người chơi nhìn hoặc đi tới nhanh các khu:

- quảng trường/cổng world;
- Nhà Đồng Vọng và các NPC progression;
- chế tạo bóng và vật phẩm;
- thợ đá/trang bị;
- tiến hóa, quest và phần thưởng;
- điểm teleport về Nhà Riêng và điểm xuất phát expedition.

Phase Làng đầu tiên chỉ cần facade và interaction shell cho NPC chưa có logic, nhưng biển hiệu, màu khu, khoảng cách và đường đi phải phản ánh đúng chức năng tương lai để tránh xây lại toàn bộ map.

## Nhà Riêng

Nhà của từng user phải có cảm giác cá nhân và khác public hub. Layout nền cần chừa vùng rõ cho creature showcase, tượng/trophy, Bệ Cộng Hưởng, Khu Tập Luyện, quản lý đội và cổng quay lại Làng. Decoration dùng grid/bounds/budget để dễ thao tác trên touch và không làm camera kẹt.

Guest phải nhìn được ai là chủ Nhà và quyền hiện tại của mình. UI mời/accept/kick cần rõ invite có thời hạn; không trình bày Nhà như server công cộng. Creature/tượng trưng bày phải dùng silhouette/lighting dễ đọc nhưng không tạo quá nhiều rig/particle cùng lúc. Chi tiết quyền và gameplay nằm trong [Nhà Riêng, trưng bày, tượng và Khu Tập Luyện](PRIVATE_HOME_HOUSING.md).

## Creature art, rig và animation

Pipeline tối thiểu:

1. concept, silhouette và điểm nhận dạng hệ/rarity;
2. blockout ở camera gameplay;
3. model/material và rig;
4. animation set;
5. VFX/SFX riêng cho hành động chính;
6. kiểm tra scale, collision, follow, combat, capture và hiệu năng trong Studio.

Animation set tối thiểu cho creature được đưa vào vertical slice:

- idle;
- đi/chạy hoặc kiểu di chuyển đặc trưng;
- phát hiện/aggro;
- basic attack;
- active skill đại diện;
- trúng đòn;
- bị hạ;
- phản ứng khi bị ném bóng và khi capture thành công/thất bại.

Năm starter và một nhóm wild đại diện cho năm hệ được làm trước. Không cần chờ đủ toàn bộ catalog mới thay cube placeholder ở core loop.

## Giao diện và input

- UI ưu tiên tiếng Việt, typography dễ đọc và thuật ngữ thống nhất với tài liệu gameplay.
- Một design system chung định nghĩa typography, spacing, button, panel, icon state, rarity treatment, health/energy, cooldown và notification.
- Layout responsive cho chuột/bàn phím, touch và gamepad; mọi thao tác quan trọng đi qua input abstraction.
- Tôn trọng safe area, kích thước touch target, text scaling và tương phản. Màu không phải tín hiệu duy nhất.
- HUD chỉ hiển thị thông tin cần cho trạng thái hiện tại; inventory, stone board, formation, statue pedestal và training management dùng màn hình riêng tại Nhà Riêng hoặc đúng NPC Làng theo trách nhiệm feature.
- UI debug có thể tồn tại cho test nhưng không được mặc định thay thế presentation của build người chơi.

## Camera, VFX và phản hồi combat/capture

- Camera giữ được player, ba companion và mục tiêu quan trọng trong khung hình mà không rung/chuyển cảnh quá mức.
- Target highlight, vùng skill, damage/heal/status, aggro và nguy hiểm phải có thứ tự thị giác rõ.
- VFX theo hệ dùng shape, nhịp và chuyển động riêng, không chỉ đổi màu cùng một particle.
- Capture cần có hold–drag–release feedback, đường ngắm nếu được duyệt, phản ứng mục tiêu, nhịp chờ kết quả và kết quả thành công/thất bại rõ ràng.
- Tránh flash dày, screen shake mạnh hoặc particle che target; cung cấp tùy chọn giảm hiệu ứng nếu cần.

## Âm nhạc và SFX

Audio được xây từ sớm theo lớp để không phải gắn nhạc ngẫu nhiên ở cuối:

- một theme cho Làng và một ambience/theme nhẹ cho Nhà Riêng;
- một motif khám phá cho mỗi world;
- lớp combat có thể chuyển vào/ra mượt;
- lớp elite/boss/event riêng;
- SFX tối thiểu cho UI, bước/di chuyển, basic attack, skill, hit, defeat, capture, equip/craft và reward.

Prototype có thể dùng loop đơn giản, nhưng volume, fade, ưu tiên channel và nguồn/license phải được quản lý ngay từ đầu. Nhạc không được lấn voice/UI cue hoặc tạo mệt mỏi khi người chơi khám phá lâu.

## Cột mốc presentation bắt buộc

- **Sau Phase 6:** có art bible, UI design system, audio direction, asset pipeline và performance budget; feature mới không dùng raw default UI trừ màn debug.
- **Sau Phase 7:** Làng có layout public hub, landmark, navigation, lighting và ambient sound đại diện; NPC chưa có logic được thể hiện bằng facade có nhãn.
- **Sau Phase 8:** Nhà Riêng có layout/showcase/social invitation shell, lighting và ambience đại diện, tách rõ với Làng.
- **Sau Phase 9:** năm starter và nhóm wild vertical slice không còn là cube đơn; có rig và animation set tối thiểu.
- **Sau Phase 10:** năm world có greybox chơi được cùng environment kit/lighting/ambient identity bản đầu.
- **Sau Phase 12:** combat/capture core có camera, HUD, VFX, SFX và feedback đại diện chất lượng mục tiêu.
- Mỗi phase gameplay từ Phase 13 trở đi tự chịu trách nhiệm cho UI/VFX/SFX/animation liên quan; Phase 19 chỉ hoàn thiện mobile, accessibility và performance toàn game, không phải lúc presentation mới bắt đầu.

## Studio QA thủ công

- Kiểm tra desktop, touch emulator và gamepad cho Làng, Nhà Riêng, invite/showcase/training UI, HUD, menu và capture.
- Chạy camera/combat với ba companion, một cụm wild, elite và boss placeholder; xác nhận target không bị che.
- Profile trên thiết bị mục tiêu thấp với budget rig, particle, light và audio đồng thời.
- Kiểm tra text scaling, safe area, tương phản, tín hiệu không phụ thuộc màu và tùy chọn giảm hiệu ứng.
- Nghe mix ở Làng, Nhà Riêng, exploration, combat và boss transition; không có loop gãy, âm thanh chồng quá mức hoặc cue quan trọng bị mất.
- Audit asset ID, nguồn, quyền sử dụng và mức độ nguyên bản trước khi content pack được chấp nhận.
