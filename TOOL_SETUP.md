# Tool setup và validation

## Tool được project cấu hình

`rokit.toml` pin: Rojo `7.7.0`, StyLua `2.5.2`, Selene `0.31.0`, Wally `0.3.2`. Roblox Studio và
VS Code là công cụ thủ công/IDE; version Studio phải ghi trong report khi test. Không ghi tool không
được project sử dụng.

Kiểm tra version trong PowerShell:

```powershell
rokit --version
rojo --version
stylua --version
selene --version
wally --version
```

Nếu command không có trong PATH, mở terminal mới sau Rokit install; không đổi execution policy hoặc
PATH hệ thống bằng Codex. `setup-tools.ps1` có các bước setup/troubleshooting, nhưng không cần chạy
lại nếu tool đã cài.

## Workflow

```powershell
rojo build default.project.json -o default-current.rbxlx
rojo serve
stylua --check src tests
selene src
```

Mở Roblox Studio, kết nối Rojo plugin để functional test. Play Solo phù hợp smoke test; Start Server /
Start Player hoặc Server & Clients bắt buộc cho isolation/networking. Codex không giả vờ đã chạy Studio
nếu không có log hoặc quyền tương ứng.

## Windows troubleshooting

- Chạy lệnh từ `D:\Project\MythicCubes`.
- Nếu Rokit binary không vào PATH, mở PowerShell/VS Code mới và kiểm tra lại version.
- Nếu Rojo build fail, kiểm tra `default.project.json` và path `src/` trước khi sửa source.
- Với project theo phase, dùng input `artifacts/json/` và output `artifacts/rbxlx/`; không tạo artifact phase ở root.
- Nếu plugin không kết nối, restart Roblox Studio và xác nhận `rojo serve` đang chạy.
