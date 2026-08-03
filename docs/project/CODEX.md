# Phạm vi làm việc của Codex

`PROJECT_ROOT` là thư mục repository đang mở trong Codex. Mọi thao tác phải được giới hạn trong thư mục này.

## Phạm vi được phép

Codex được phép:

- Đọc và sửa source code, tạo tài liệu trong `PROJECT_ROOT`.
- Chạy formatter, linter, test và build với working directory trong `PROJECT_ROOT`.
- Tạo cấu hình local của project và cập nhật tài liệu tiến độ.
- Đề xuất command để người dùng thực hiện thủ công.

## Phạm vi bị cấm

Codex không được:

- Sửa file ngoài `PROJECT_ROOT` hoặc project Roblox khác.
- Sửa Git global config, Windows Registry, PowerShell execution policy hay biến môi trường hệ thống.
- Cài tool global khi chưa được yêu cầu; đọc hoặc ghi credential ngoài project.
- Tự publish experience, upload asset, chi Robux, tạo sản phẩm trả phí hoặc Game Pass.
- Tự thay đổi quyền truy cập experience.
- Tự push, merge vào `prod`, force push, xóa branch hoặc chạy lệnh phá hủy dữ liệu.

## Quy tắc Git

Codex có thể xem `git status`, `git diff`, đề xuất branch và commit message, hoặc tạo commit local khi người dùng yêu cầu rõ ràng. Codex không tự động:

- Push hoặc merge vào `prod`.
- Rebase branch đã chia sẻ, force push, xóa branch hoặc sửa lịch sử commit.
- Commit secret, file build, cache hay file tạm.

## Xử lý bất định

- Ưu tiên giải pháp đơn giản và không tự thêm dependency.
- Ghi giả định và TODO có ngữ cảnh rõ ràng.
- Không dùng code giả để che tính năng chưa tồn tại.
- Không tuyên bố tính năng hoạt động khi chưa test.
- Nếu cần thao tác ngoài `PROJECT_ROOT`, dừng thao tác đó và ghi hướng dẫn thủ công trong `docs/project/TOOL_SETUP.md` hoặc báo cáo nhiệm vụ.

## Quy trình thay đổi

### Trước thay đổi

1. Đọc tài liệu theo thứ tự trong `docs/project/AGENTS.md`.
2. Kiểm tra Git status và thay đổi sẵn có.
3. Xác định phase hiện tại.
4. Xác định file thuộc scope.
5. Viết kế hoạch ngắn.

### Sau thay đổi

1. Format.
2. Lint.
3. Build.
4. Test nếu có.
5. Kiểm tra Git diff.
6. Cập nhật tài liệu và tiến độ.
7. Báo cáo kết quả, phần chưa xác minh và bước test thủ công.
