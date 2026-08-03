# Hệ thống sinh vật, nguyên tố và kỹ năng

Tài liệu này là nguồn thiết kế tập trung cho sinh vật, hệ nguyên tố, kỹ năng, level, tiến hóa, roll skill và art direction. Các tài liệu root chỉ tóm tắt và liên kết về đây.

## Cách đọc trạng thái

- **Product design đã chốt:** quy tắc sản phẩm phải được giữ khi triển khai.
- **Implementation hiện có:** hành vi thực sự đang có trong repository và có thể kiểm tra ở thời điểm hiện tại.
- **Lịch cho phase tương lai:** hướng triển khai đã phân phase nhưng chưa được xem là đã có trong runtime.
- **TBD:** quyết định sản phẩm chưa chốt; không được tự suy diễn thành production rule.

## Thuật ngữ

- **Creature/sinh vật/thú đồng hành:** thực thể người chơi sở hữu và sử dụng trong đội hình.
- **Element:** loại damage và quan hệ tương khắc.
- **Status effect:** độc, thiêu đốt, làm chậm, choáng, buff hoặc debuff; status không phải element.
- **Skill tier:** bậc chất lượng và độ phức tạp của skill, từ 1 đến 3.
- **Evolution stage:** bậc tiến hóa của sinh vật, từ 1 đến 3, được xác định theo level.

## Product design đã chốt

### Năm hệ ban đầu

| Internal ID | Tên hiển thị | Bản sắc ban đầu |
| --- | --- | --- |
| `normal` | Thường | Ổn định, đòn vật lý, buff/debuff chỉ số cơ bản, ít phụ thuộc matchup |
| `fire` | Lửa | Damage, tự buff Attack, thiêu đốt |
| `water` | Nước | Đòn bắn, phòng thủ, làm chậm |
| `nature` | Tự nhiên | Giáp, độc, giảm chỉ số đối thủ |
| `wind` | Gió | Tốc độ, nhịp basic attack, multi-hit ở skill cấp cao |

Hệ Thường gây `1.0x` damage lên mọi hệ và nhận `1.0x` damage từ mọi hệ trong phiên bản đầu. Hệ này không có ưu thế hoặc bất lợi nguyên tố, đồng thời có một skill cơ bản một mục tiêu, ổn định và cooldown ngắn.

Chart tương khắc phải đơn giản, nguyên bản và data-driven. Tài liệu này chưa chốt chart production cho Lửa, Nước, Tự nhiên và Gió. Đất, Băng, Điện, Ánh sáng và Bóng tối chỉ là ứng viên mở rộng Phase 8, chưa phải nội dung đã duyệt để triển khai.

Các tên nguyên tố phổ biến như Lửa, Nước, Gió, Ánh sáng hoặc Bóng tối là vocabulary thiết kế chung. Icon, chart, skill, VFX và cách trình bày của dự án vẫn phải được tự thiết kế.

### Skill và slot

- Sinh vật chỉ được sử dụng skill cùng hệ với chính nó.
- Mỗi sinh vật có tối đa ba skill sử dụng trong combat.
- Bậc tiến hóa 1 mở tối đa một slot, bậc 2 mở tối đa hai slot và bậc 3 mở tối đa ba slot.
- Mỗi hệ có đúng một skill cơ bản được cấp mặc định khi nhận sinh vật, không cần roll và thể hiện rõ bản sắc của hệ.
- Skill cơ bản không phải skill mạnh nhất. Việc có cho thay thế skill cơ bản hay không vẫn là **TBD**.

Registry và server khi triển khai đầy đủ phải xác nhận skill tồn tại, cùng `elementId` với creature, phù hợp evolution stage, đã được sở hữu hoặc roll hợp lệ, đang được trang bị và không trùng lặp. Combat server tiếp tục xác nhận cooldown, target và combat state.

Định hướng skill cơ bản, chưa chốt tên production:

| Hệ | Hành vi cơ bản |
| --- | --- |
| Thường | Một đòn trực diện, một hit, một mục tiêu |
| Lửa | Một đòn damage hoặc tự buff Attack |
| Nước | Một đòn bắn vào một đối thủ |
| Tự nhiên | Tự buff Defense hoặc debuff một đối thủ |
| Gió | Buff tốc độ basic attack hoặc một đòn bắn nhanh |

### Skill pool theo bậc

Mỗi hệ cần nhiều hơn một skill có thể học hoặc roll ở mỗi bậc. Pool bậc 1 lớn nhất, pool bậc 2 nhỏ hơn và pool bậc 3 nhỏ nhất. Số lượng tuyệt đối vẫn là **TBD**; mọi con số dùng khi prototyping chỉ là placeholder cho đến khi được duyệt.

- **Bậc 1:** một đòn cận chiến hoặc đòn bắn vào một đối thủ; tự buff một chỉ số; debuff một chỉ số của một đối thủ; tối đa một status effect trên một đối tượng. Không AoE, multi-hit, buff toàn đội hoặc tổ hợp nhiều effect.
- **Bậc 2:** có thể mạnh hơn, multi-hit giới hạn, damage kèm status, buff/debuff chuyên biệt hơn, phạm vi nhỏ hoặc tương tác với basic attack.
- **Bậc 3:** có thể là skill đặc trưng của dạng tiến hóa cuối, dùng AoE/nhiều target, effect mạnh hoặc dài hơn, phối hợp đội hình và có cooldown dài hay trade-off tương ứng.

Các khả năng trên là giới hạn thiết kế cho content tương lai, không phải danh sách effect runtime Phase 3 đang hỗ trợ.

### Roll skill và chống gây khó chịu

Nguyên liệu roll bậc cao đắt hơn, nên hệ thống phải giảm số lần roll vô ích và không buộc người chơi roll vô hạn để tìm một skill mong muốn.

- Roll theo đúng bậc; pool của vật liệu bậc cao không trộn skill bậc thấp.
- Không roll skill khác hệ hoặc duplicate skill sinh vật đang có.
- Pool bậc cao nhỏ hơn pool bậc thấp.
- Khi sinh vật đã có ba skill, kết quả roll không tự ghi đè skill.
- Server trả candidate/result; người chơi xác nhận skill cần thay.
- Request không hợp lệ không tiêu vật liệu.
- Tiêu vật liệu và cấp/thay skill là một transaction server-authoritative.
- Hệ thống cần anti-frustration như lựa chọn candidate, roll không lặp hoặc pity. Candidate count và công thức pity chính xác vẫn là **TBD**.

Thiết kế hiện tại không đưa monetization vào roll skill.

### Level, XP và tiến hóa

Level nằm trong khoảng 1–100. Evolution stage được xác định duy nhất theo level cho evolution line thông thường:

| Level | Evolution stage |
| --- | --- |
| 1–17 | Bậc 1 |
| 18–53 | Bậc 2 |
| 54–100 | Bậc 3 |

Sinh vật tiến hóa lên bậc 2 tại level 18 và bậc 3 tại level 54. Tiến hóa giữ nguyên instance ID, level, XP và các skill hợp lệ; mở thêm slot theo stage; stats được lấy lại từ creature/evolution definition. Evolution line thông thường không yêu cầu vật phẩm. Special evolution và item evolution chưa có product decision.

XP cần cho level tiếp theo tăng dần và curve phải data-driven; công thức production vẫn là **TBD**. Server quyết định XP, level-up và evolution, còn client chỉ hiển thị kết quả đã được server xác nhận.

Cùng một skill có thể scale vừa phải theo evolution stage về damage, tỷ lệ effect, thời gian effect hoặc effect magnitude. Scaling phải data-driven; multiplier production chưa được chốt vì dạng tiến hóa cao đã có stats mạnh hơn.

### Art direction nguyên bản

- Map dùng bố cục voxel/blocky diorama; khối có thể bo cạnh nhẹ nhưng vẫn đọc rõ hình hộp.
- Màu sạch, silhouette đơn giản, dễ đọc và không quá nhiều chi tiết.
- Prototype sinh vật dùng khoảng 6–12 khối thay vì chỉ một cube.
- Mỗi hệ có shape language và palette riêng.
- Map, sinh vật, icon, animation, UI và effect phải do dự án tự thiết kế hoặc có giấy phép rõ ràng.
- Không sao chép model, silhouette, icon, animation, UI, map hoặc visual language cụ thể của Pokémon Quest hay bất kỳ IP bên thứ ba nào. Ý tưởng chung về voxel diorama không cấp quyền sao chép cách thể hiện cụ thể.

## Implementation hiện có trong repository

Phase 2 và Phase 3 hiện có:

- Bốn element ID `verdant`, `ember`, `tide`, `gale` cùng chart placeholder data-driven.
- Bốn creature starter, mỗi creature tham chiếu một skill.
- `SkillEffect` và validator chỉ chấp nhận `Damage`.
- Combat server-authoritative với state `Preparing → Active → Finished`, basic attack định kỳ, một active damage skill, cooldown, target validation, rate limit/idempotency và snapshot UI.
- `OwnedCreature` đã có field level/experience, nhưng XP gain, level-up và evolution chưa được triển khai.
- Validator hiện cho phép tối đa bốn `skillIds`/`equippedSkillIds`; đây là giới hạn code cũ, không phải target design ba slot.
- Client hiện là test UI dựa trên snapshot. Repository chưa có combat arena vật lý hoàn chỉnh hoặc enemy model được spawn để quan sát trận đấu trực tiếp.

Phase 3 được người dùng chấp nhận là `DONE` ngày 2026-08-03 với vai trò combat test harness. Repository vẫn không có Studio version hoặc full runtime matrix được ghi lại; trạng thái `DONE` không biến test UI thành open-world combat production.

## Technical follow-up, không thuộc documentation task

Migration target từ implementation hiện tại sang product design phải là một task code riêng trước khi triển khai Phase 4:

1. Migration element ID từ `verdant/ember/tide/gale` sang `nature/fire/water/wind`.
2. Thêm hệ `normal` và cập nhật effectiveness map theo quyết định balance được duyệt.
3. Thêm đúng một basic skill cho mỗi trong năm hệ.
4. Đổi giới hạn validator từ bốn skill sang tối đa ba và bổ sung slot rule theo evolution stage.
5. Cập nhật registry validation cho same-element, stage eligibility, ownership/equip và duplicate rule theo đúng boundary từng phase.
6. Cập nhật registry tests, creature/skill cross-reference và snapshot/UI nếu tên element được hiển thị.
7. Giữ các effect chưa được runtime hỗ trợ ở trạng thái chưa triển khai; không tạo code giả.

## Phân bổ phase tương lai

- **Phase 3 — `DONE`:** combat test harness server-authoritative; không phải open-world encounter production.
- **Phase 4:** companion follow, regional wild spawn, proximity engagement/disengage và capture/collection vertical slice.
- **Phase 5:** XP, level-up, evolution, stats theo evolution definition, transaction roll skill/anti-frustration và progression server-authoritative.
- **Phase 7:** camera production, responsive UI, animation, VFX/SFX, mobile polish và visual feedback hoàn chỉnh.
- **Phase 8:** nhiều creature line, map/region, element mở rộng, skill pool đầy đủ và content production.

Skill pool content đầy đủ thuộc Phase 8, còn cơ chế roll và transaction thuộc Phase 5. Không mở phase mới chỉ để chứa feature này.
