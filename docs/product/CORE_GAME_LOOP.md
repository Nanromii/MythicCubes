# Core game loop

## Đã quan sát trong source

Source hiện tại hỗ trợ chọn starter theo session, hiển thị companion placeholder và combat harness
theo snapshot. Đây là nền kiểm thử, chưa phải vòng lặp production đầy đủ.

## Vòng lặp mục tiêu

```text
Explore → Encounter → Battle → Capture/Reward → Improve team
→ Unlock region → Repeat
```

Capture bằng bóng là loop chính để thu phục. Cooking, nếu xuất hiện, chỉ là loop phụ trợ cho lure, chuẩn bị hoặc buff cơ hội tiếp cận/hành vi cụm thú; không thay thế capture bằng bóng.
Capture success reward, combat participation/contribution và item drop khi kill là ba loại kết quả riêng. Nếu wild chết và rơi item, user gây đòn cuối cùng (`last-hit final blow`) nhận item đó.
Các bước reward còn lại, progression và unlock region chưa được xác nhận bởi source checkout này.
Điều kiện unlock, reward table, economy, energy và persistence là `TBD` hoặc product direction trong
`docs/design/`; không dùng file này để bịa formula.
