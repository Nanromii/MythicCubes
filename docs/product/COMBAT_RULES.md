# Combat rules

## Current

Combat harness hiện có server-owned state, basic attack theo nhịp, skill request validation, cooldown,
rate-limit/idempotency và snapshot. Damage calculator/element effectiveness là shared pure logic.

## Product rules cho PvE thế giới mở

- Encounter ngoài tự nhiên là shared cho nhiều user hợp lệ. Nhiều user có thể cùng đánh cùng một wild
  trong cùng encounter; không private cả cụm chỉ vì một user bắt đầu engage.
- Capture bằng bóng là cơ chế thu phục chính. Cooking, nếu có, chỉ là hỗ trợ lure, prep, buff cơ hội
  tiếp cận hoặc ảnh hưởng hành vi cụm thú; không thay thế capture bằng bóng.
- Khi server chấp nhận một capture attempt hợp lệ, server tạo capture lock atomic trên đúng wild target.
  User khác không thể attempt cùng target trong thời gian lock; lock không áp dụng cho cả encounter/cluster.
  Capture success làm target không còn cho người khác bắt; capture failure unlock target để user hợp lệ tiếp tục thử.
- `combat participation/contribution`, `capture success reward` và `kill reward / item drop` là ba credit
  riêng. Nếu wild chết trước khi được bắt và có item drop, user gây đòn kết liễu cuối cùng (`last-hit final blow`)
  nhận item đó.
- Server là nguồn quyết định encounter membership, damage, target validity, capture lock và reward boundary;
  client chỉ gửi intent và render kết quả đã được xác nhận.

## Not yet authority

Multi-companion target selection, status effect, progression XP ngoài các credit đã nêu, PvP, boss và
production combat formula chưa được source checkout này xác minh. Không tự thêm rule, target selection
hoặc formula mới; mọi proposal phải ghi `DRAFT/TBD` trong design doc và có story/decision trước code.
