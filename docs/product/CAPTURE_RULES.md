# Capture rules

Capture/collection là product direction trong `docs/design/CAPTURE_SYSTEM.md`, không phải behavior đã
được source hiện tại chứng minh. Các mục như encounter membership, ball tier, capture chance, HP curve,
rarity/classification và inventory transaction đều `DRAFT/TUNABLE/TBD` cho tới khi người dùng chấp nhận.

Khi triển khai, client chỉ gửi intent; server phải kiểm tra encounter, ownership, target, range, state,
inventory, rate-limit và idempotency. Story riêng phải có Studio functional test và exploit-oriented test.
