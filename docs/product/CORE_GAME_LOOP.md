# Core game loop

## Đã quan sát trong source

Source hiện tại hỗ trợ chọn starter theo session, hiển thị companion placeholder và combat harness
theo snapshot. Đây là nền kiểm thử, chưa phải vòng lặp production đầy đủ.

## Vòng lặp mục tiêu

```text
Explore → Encounter → Battle → Capture/Reward → Improve team
→ Unlock region → Repeat
```

Các bước capture, reward, progression và unlock region chưa được xác nhận bởi source checkout này.
Điều kiện unlock, reward table, economy, energy và persistence là `TBD` hoặc product direction trong
`docs/design/`; không dùng file này để bịa formula.
