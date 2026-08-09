# Roblox Studio test guide

## Test case format

Mỗi test case phải có:

- **Lệnh chuẩn bị (copy/paste):** đặt ngay sau tiêu đề case và trước Preconditions. Cung cấp block
  `powershell` hoàn chỉnh gồm project root, lệnh build/serve đúng project, output artifact và lệnh mở/chạy
  cần thiết cho chính case đó. Không bắt người test ghép lệnh từ phần mô tả hoặc case khác.
- Preconditions
- Steps
- Expected result
- Server Output cần quan sát
- Client Output cần quan sát
- Pass/fail và timestamp

Nếu case cần Client/Server Command Bar hoặc temporary test script, tài liệu phải kèm block `lua` hoàn
chỉnh có thể copy và chạy trực tiếp. Không chỉ ghi “dùng Command Bar” hoặc “tạo temporary script”. Nếu
case thật sự không cần terminal/Command Bar, vẫn ghi rõ `Không cần lệnh bổ sung` thay vì bỏ trường này.

Lệnh phải:

- chạy được từ PowerShell với path chính xác trong repository;
- tuân theo quy ước `default-current.rbxlx` cho default project và `artifacts/json/` → `artifacts/rbxlx/`
  cho phase/test project;
- không chứa placeholder chưa được giải thích;
- không publish place hoặc thay đổi dữ liệu production.

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
