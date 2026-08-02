# Thiết lập công cụ trên Windows

Trạng thái được ghi nhận ngày **2026-08-01** từ terminal tại `PROJECT_ROOT`. Không công cụ nào được tự động cài trong Phase 0.

## Checklist môi trường

| Tool                            |    Bắt buộc | Trạng thái     | Phiên bản      | Cách kiểm tra                                 | Mục đích                        | Ghi chú                                                              |
| ------------------------------- | ------------: | ---------------- | ---------------- | ----------------------------------------------- | ---------------------------------- | --------------------------------------------------------------------- |
| Roblox Studio                   |           Có | `MANUAL_CHECK` | Chưa xác minh  | Mở Studio → About                             | Chạy, test và publish experience | Cài từ Roblox; cần restart Studio sau plugin                       |
| Roblox account                  |           Có | `MANUAL_CHECK` | Không áp dụng | Kiểm tra trạng thái đăng nhập Studio      | Quyền truy cập experience        | Không ghi credential vào repository                                 |
| Git                             |           Có | `INSTALLED`    | 2.45.1.windows.1 | `git --version`                               | Quản lý source                   | Command đã chạy thành công                                       |
| Codex App                       |           Có | `MANUAL_CHECK` | Chưa xác minh  | Xác nhận app đang mở đúng`PROJECT_ROOT` | Hỗ trợ phát triển              | Không đoán phiên bản từ môi trường terminal                  |
| VS Code/editor tương đương |           Có | `MANUAL_CHECK` | Chưa xác minh  | Mở editor và repository                       | Chỉnh source                      | Có thể dùng editor khác hỗ trợ Luau                             |
| Rojo CLI                        |           Có | `INSTALLED`    | 7.7.0            | `rojo --version`                              | Đồng bộ và build DataModel     | Binary pin đã build project thành công; xem ghi chú Rokit shim bên dưới |
| Rojo plugin                     |           Có | `MANUAL_CHECK` | Chưa xác minh  | Plugins → Rojo trong Studio                    | Kết nối Studio với Rojo CLI     | Cài từ nguồn Rojo chính thức                                     |
| Luau Language Server            |           Có | `MANUAL_CHECK` | Chưa xác minh  | Kiểm tra extension và diagnostics             | Type/language diagnostics          | Chọn platform Roblox                                                 |
| StyLua                          |           Có | `INSTALLED`    | 2.5.2            | `stylua --version`                            | Format Luau                        | `stylua --check src tests` đã đạt                              |
| Selene                          |           Có | `INSTALLED`    | 0.31.0           | `selene --version`                            | Lint Luau/Roblox                   | `selene src` đạt 0 error, 0 warning, 0 parse error               |
| Tool manager Roblox             | Khuyến nghị | `INSTALLED`    | Rokit 1.2.0      | `rokit --version`                             | Pin phiên bản tool               | Manifest project pin toàn bộ CLI dùng trong build                 |
| Wally                           | Khuyến nghị | `INSTALLED`    | 0.3.2            | `wally --version`                             | Package manager khi cần           | Đã pin nhưng Phase 1 chưa có dependency                             |
| Git LFS                         | Khuyến nghị | `NOT_CHECKED`  | Chưa xác minh  | `git lfs version`                             | Quản lý asset lớn               | Chỉ bật khi repository thực sự có asset lớn                     |
| Blender                         | Khuyến nghị | `OPTIONAL`     | Chưa xác minh  | Mở Blender → About                            | Tạo model nguyên bản            | Không bắt buộc cho source foundation                               |
| Image editor                    | Khuyến nghị | `OPTIONAL`     | Chưa xác minh  | Mở ứng dụng                                  | Icon và UI nguyên bản           | Theo dõi license font/brush/asset                                    |
| Audio editor                    | Khuyến nghị | `OPTIONAL`     | Chưa xác minh  | Mở ứng dụng                                  | Xử lý âm thanh nguyên bản     | Theo dõi license sample                                              |

## Hướng dẫn theo tool

### Roblox Studio và Roblox account

- **Cài:** tải Studio từ trang Roblox chính thức và đăng nhập bằng tài khoản có quyền với experience.
- **Cấu hình:** bật các quyền/plugin cần thiết tối thiểu; không chia sẻ token hoặc cookie.
- **Thành công:** mở được place, Play Test chạy và Output hiển thị log.
- **Lỗi phổ biến:** sai tài khoản, thiếu quyền, Studio/plugin quá cũ hoặc firewall chặn localhost.
- **Restart:** khởi động lại Studio sau cài/cập nhật plugin.

### Git

- **Cài:** dùng Git for Windows từ nguồn chính thức nếu command chưa có.
- **Cấu hình:** cấu hình danh tính Git theo chính sách cá nhân; Codex không sửa global config.
- **Thành công:** `git --version` và `git status` chạy trong repository.
- **Lỗi phổ biến:** PATH chưa cập nhật hoặc line ending bị đổi ngoài ý muốn; `.editorconfig` của project dùng LF.
- **Restart:** mở terminal mới sau khi cài.

### Codex App và editor

- **Cài:** cài Codex App và editor từ nguồn chính thức.
- **Cấu hình:** mở đúng thư mục `PROJECT_ROOT`; editor dùng UTF-8, LF và tôn trọng `.editorconfig`.
- **Thành công:** thấy `default.project.json`, diagnostics Luau và không truy cập nhầm project.
- **Lỗi phổ biến:** mở thư mục cha, extension xung đột hoặc workspace setting ghi đè config.
- **Restart:** reload editor/app sau khi cài extension.

### Rojo CLI và plugin

- **Cài:** chọn một tool manager Roblox và làm theo hướng dẫn chính thức của Rojo để pin phiên bản; hoặc dùng phương thức cài Windows được Rojo hỗ trợ. Không cài global tự động từ nhiệm vụ này.
- **Cấu hình:** CLI dùng `default.project.json`; plugin kết nối địa chỉ do `rojo serve` hiển thị.
- **Thành công:** `rojo --version`, `rojo build -o build.rbxlx` và kết nối plugin đều hoạt động.
- **Lỗi phổ biến:** CLI không nằm trong PATH, plugin/CLI lệch phiên bản, port bận, firewall chặn localhost hoặc mapping JSON sai.
- **Restart:** mở terminal mới sau cài CLI; restart Studio sau cài plugin.

### Luau Language Server

- **Cài:** cài extension Luau Language Server tương thích với editor từ marketplace chính thức của editor.
- **Cấu hình:** dùng platform Roblox và đọc `.luaurc`; Phase 0 không dùng alias tùy chỉnh.
- **Thành công:** bootstrap có type diagnostics, autocomplete Roblox API hoạt động.
- **Lỗi phổ biến:** mở sai folder, platform không phải Roblox hoặc extension khác tranh quyền file Lua.
- **Restart:** reload editor sau cài/cập nhật.

### StyLua

- **Cài:** cài qua tool manager đã chọn hoặc binary chính thức, pin phiên bản cho team khi quy trình được thống nhất.
- **Cấu hình:** tự đọc `stylua.toml` tại root.
- **Thành công:** `stylua --check src tests` trả exit code 0.
- **Lỗi phổ biến:** PATH cũ, editor dùng formatter khác hoặc version không hỗ trợ option config.
- **Restart:** mở terminal mới và reload editor nếu dùng format-on-save.

### Selene

- **Cài:** cài qua tool manager đã chọn hoặc release chính thức.
- **Cấu hình:** `selene.toml` dùng `std = "roblox"`; không tải standard library không rõ nguồn.
- **Thành công:** `selene src` trả exit code 0 và nhận biết Roblox globals.
- **Lỗi phổ biến:** bản Selene cũ thiếu Roblox std, chạy sai working directory hoặc disable rule quá rộng.
- **Restart:** mở terminal mới sau cài.

### Công cụ khuyến nghị

- **Tool manager:** chọn một giải pháp duy nhất, pin Rojo/StyLua/Selene và commit manifest trong nhiệm vụ riêng. Thành công khi clone mới có thể cài đúng version. Lỗi thường gặp là nhiều manager cùng quản lý PATH; mở terminal mới sau thay đổi.
- **Wally:** chỉ thêm khi có dependency thật. Thành công khi `wally --version` chạy và package lock được review. Không cần trong Phase 0.
- **Git LFS:** cài và chạy `git lfs install` chỉ khi người dùng quyết định theo dõi asset lớn; cần review pattern trước khi migrate file.
- **Blender/image/audio editor:** dùng để tự tạo nội dung hoặc nội dung có giấy phép; lưu file nguồn theo quy ước asset. Restart chỉ cần khi installer yêu cầu.

## Quy trình Rojo với Studio

1. Mở terminal tại project.
2. Chạy `rojo serve`.
3. Mở Roblox Studio.
4. Mở hoặc tạo một place.
5. Mở plugin Rojo.
6. Kết nối tới Rojo server được CLI hiển thị.
7. Kiểm tra source được đồng bộ đúng theo `ARCHITECTURE.md`.
8. Chạy Play Test.
9. Xem Output và xác nhận log bootstrap server/client, không có lỗi khởi động.

## Build, format và lint

```powershell
rojo build -o build.rbxlx
stylua --check src tests
stylua src tests
selene src
```

Ngày 2026-08-01, các binary pin đã chạy thành công với kết quả: Rojo build exit 0, StyLua check exit 0 và Selene exit 0 với 0 lỗi/cảnh báo/parse error. `build.rbxlx` chỉ là artifact xác minh và không được commit.

Trong terminal Codex hiện tại, shim tại `%USERPROFILE%\.rokit\bin` báo lỗi đường dẫn dù binary backing trong Rokit tool storage hoạt động đúng. Nếu gặp cùng lỗi, mở terminal mới và chạy lại `rokit self-install`; trong lúc chẩn đoán có thể gọi đúng binary đã pin trong tool storage. Không thay đổi execution policy hay Git/global config để né lỗi này.

## Checklist xác nhận cuối

- [ ] Roblox Studio đã cài
- [ ] Đã đăng nhập Roblox Studio
- [ ] Rojo plugin đã cài
- [X] Rojo CLI hoạt động
- [X] Codex App mở đúng PROJECT_ROOT
- [X] Git hoạt động
- [ ] VS Code hoạt động
- [ ] Luau Language Server hoạt động
- [X] StyLua hoạt động
- [X] Selene hoạt động
- [X] rojo build thành công
- [ ] rojo serve kết nối được Studio
- [ ] Bootstrap server xuất hiện trong Studio
- [ ] Bootstrap client xuất hiện trong Studio
- [ ] Play Test không có lỗi khởi động
