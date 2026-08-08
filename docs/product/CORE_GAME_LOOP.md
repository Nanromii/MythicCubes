# Core game loop

## Đã quan sát trong source

Source hiện tại hỗ trợ chọn starter theo session, hiển thị companion placeholder và combat harness
theo snapshot; Phase 4 slice hiện tại dùng auto combat/capture theo target và range placeholder. Đây là
nền kiểm thử/vertical slice historical, chưa phải vòng lặp production đầy đủ và chưa có server-resolved
hitbox, projectile miss hoặc manual throw.

## Vòng lặp mục tiêu

```text
Explore → Encounter → Battle → Capture/Reward → Improve team
→ Unlock region → Repeat
```

Capture bằng bóng là loop chính để thu phục. Cooking, nếu xuất hiện, chỉ là loop phụ trợ cho lure, chuẩn bị hoặc buff cơ hội tiếp cận/hành vi cụm thú; không thay thế capture bằng bóng.
Capture success reward, combat participation/contribution và item drop khi kill là ba loại kết quả riêng. Nếu wild chết và rơi item, user gây đòn cuối cùng (`last-hit final blow`) nhận item đó.
Trong target production, Battle phải đọc được vị trí/timing: đòn có thể hit hoặc miss, knockback/reposition có
thể làm thay đổi resolve; Capture dùng manual aim/hold-drag-release/analog direction và bóng có thể trượt.
Các primitive collision, input schema, miss/consume policy và reward/progression/unlock region chưa được
xác nhận bởi source checkout này; phần chưa chốt giữ `TBD` và thuộc migration Phase 11.5 trước presentation
Phase 12.
Điều kiện unlock, reward table, economy, energy và persistence là `TBD` hoặc product direction trong
`docs/design/`; không dùng file này để bịa formula.
