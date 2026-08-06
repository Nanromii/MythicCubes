# Roblox Studio test guide

## Test case format

Mỗi test case phải có:

- Preconditions
- Steps
- Expected result
- Server Output cần quan sát
- Client Output cần quan sát
- Pass/fail và timestamp

## Chế độ chạy

- **Play Solo:** smoke test một client.
- **Start Server / Start Player:** kiểm tra server/client boundary.
- **Server & Clients:** isolation, remote, ownership và multiplayer.
- **Functional test:** behavior có thể quan sát/đối chiếu.
- **Regression test:** tái hiện case cũ sau thay đổi.
- **Exploit-oriented test:** request không đáng tin từ client.
- **Playtest:** cảm giác, readability, pacing; không thay functional evidence.

## Handoff

Codex không có Studio runtime trong task này. Người thực hiện Studio cần lưu version, số client, actual
result và lỗi Output vào `docs/testing/reports/` hoặc report của story; không chỉ ghi một chữ `PASS`.
