# Combat rules

## Current

Combat harness hiện có server-owned state, basic attack theo nhịp, skill request validation, cooldown,
rate-limit/idempotency và snapshot. Damage calculator/element effectiveness là shared pure logic.

## Not yet authority

Open-world encounter, multi-companion, status effect, progression XP, PvP, boss và production combat
formula chưa được source checkout này xác minh. Không tự thêm rule, target selection hoặc formula mới;
mọi proposal phải ghi `DRAFT/TBD` trong design doc và có story/decision trước code.
