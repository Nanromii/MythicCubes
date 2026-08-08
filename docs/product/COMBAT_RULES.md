# Combat rules

## Current

Combat harness hiện có server-owned state, basic attack theo nhịp, skill request validation, cooldown,
rate-limit/idempotency và snapshot. Damage calculator/element effectiveness là shared pure logic. Phase 4
current slice có auto combat/capture theo target và range placeholder; chưa có production hitbox,
projectile collision, manual aim hoặc server-resolved miss.

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
- Combat production phải cho phép hit/miss theo vị trí và timing: melee/contact có thể hụt khi target rời
  vùng trúng; projectile có thể hụt khi lệch quỹ đạo/impact; area/trap/cloud có thể đặt lệch và không trúng ai.
- Self-buff, self-shield và ally-buff trực tiếp auto-apply nếu cast hợp lệ. Direct non-damaging auto-hit khác
  chỉ là exception khi có decision riêng; projectile, melee contact, area placement và lingering hazard không
  auto-hit.
- Telegraph, knockback/displacement và reposition là combat readability/gameplay signal. Server phải resolve
  cast validity, timing, collision/contact, hit/miss, damage/effect, cooldown và state; client chỉ gửi intent.
- Primitive resolve, input schema, tolerance/latency policy và miss/consume policy cụ thể là `TBD` cho Phase 11.5.
- Server là nguồn quyết định encounter membership, damage, target validity, capture lock và reward boundary;
  client chỉ gửi intent và render kết quả đã được xác nhận.

## Not yet authority

Multi-companion target selection, delivery-specific hit/miss implementation, status effect, progression XP
ngoài các credit đã nêu, PvP, boss và production combat formula chưa được source checkout này xác minh.
Không tự thêm rule, target selection hoặc formula mới; mọi proposal phải ghi `DRAFT/TBD` trong design doc
và có story/decision trước code. Phase 11.5 sẽ là migration target, còn Phase 12 chỉ xử lý presentation.
