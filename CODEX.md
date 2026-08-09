# Phạm vi hoạt động của Codex

`PROJECT_ROOT` là `D:\Project\MythicCubes`. Mọi thao tác phải nằm trong repository này, trừ
việc đọc tài liệu tham khảo mà người dùng chỉ rõ như `D:\VNPT\test.zip`.

## Được phép

- Đọc và sửa source, tests, config và tài liệu trong repository khi yêu cầu cho phép.
- Tạo story, plan, decision, test guide và report theo cấu trúc docs hiện hành.
- Chạy formatter, linter, test và Rojo build với working directory là project root.
- Đề xuất hoặc ghi lại bước người dùng phải làm trong Roblox Studio.
- Tạo commit local chỉ khi người dùng yêu cầu rõ.

## Không được tự làm

- Không sửa file ngoài project, Git global config, Registry, execution policy hay credential.
- Không publish experience, upload asset, chi Robux, tạo paid product hoặc đổi quyền experience.
- Không sửa trực tiếp `prod`, push, force push, merge production, xóa branch hoặc sửa Git history.
- Không chạy `git reset --hard`, `git checkout --`, lệnh xóa dữ liệu hoặc lệnh overwrite rộng khi chưa được yêu cầu rõ.
- Không tự quyết combat formula, capture rate, progression, economy, permission hoặc game design chưa có authority.
- Không thêm dependency hoặc framework test lớn chỉ để hoàn thành tài liệu.

## File mới và file được sửa

Chỉ tạo file mới khi nó có một trách nhiệm rõ ràng, được link từ entry-point hoặc là artifact của
story/plan/test. Không tạo file rỗng để đủ cây thư mục. Không sửa gameplay trong task governance/docs
này; nếu phát hiện lỗi gameplay, ghi vào baseline/report.

Không tạo phase/test/validation `*.project.json` hoặc `*.rbxlx` ở root. Dùng `artifacts/json/` cho
Rojo project theo phase và `artifacts/rbxlx/` cho output; chỉ default mapping/place canonical được giữ root.

## Khi phải hỏi người dùng

Hỏi khi có nhiều behavior sản phẩm hợp lệ nhưng tài liệu chưa quyết định, khi cần thao tác ngoài
project, khi cần thay đổi branch strategy/production, hoặc khi acceptance phụ thuộc vào một
quyết định gameplay chưa được chấp nhận. Dùng `grill-me` để hỏi từng câu cụ thể; không sửa code
trong lúc grill.

## Quy trình sau thay đổi

Chạy validation phù hợp, kiểm tra `git diff --check`, review diff theo scope, cập nhật tài liệu
bị ảnh hưởng và ghi evidence mới. Không dùng validation của phiên trước làm bằng chứng duy nhất.
