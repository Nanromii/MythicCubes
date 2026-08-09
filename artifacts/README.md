# Artifacts

Thư mục này giữ file project/build dành riêng cho phase, test hoặc validation để root repository
chỉ còn entry point canonical.

## Cấu trúc

- `json/`: Rojo project JSON dành riêng cho phase/test. Vì project file nằm sâu hơn root hai cấp,
  mọi `$path` bên trong phải resolve từ vị trí file, thường bắt đầu bằng `../../src/` hoặc `../../tests/`.
- `rbxlx/`: place build dành riêng cho phase/test/validation. Các file `*.rbxlx` bị Git ignore;
  `README.md` trong thư mục này giữ directory và quy ước trong checkout mới.

## File được phép ở root

- `default.project.json`: Rojo mapping canonical của game.
- `default-current.rbxlx`: default place canonical để mở build hiện tại trong Roblox Studio.
- `sourcemap.json`: output tooling generic, không gắn với phase.

Không tạo `phaseN-*.project.json`, `phaseN-*.rbxlx`, `*-tests.rbxlx` hoặc `*-validation.rbxlx` ở root.
Lệnh chuẩn:

```powershell
rojo build default.project.json -o default-current.rbxlx
rojo build artifacts/json/phase4-tests.project.json -o artifacts/rbxlx/phase4-tests.rbxlx
rojo serve artifacts/json/phase4-tests.project.json --port 34876
```

Khi thêm phase test project mới, đặt JSON vào `artifacts/json/`, output vào `artifacts/rbxlx/`,
cập nhật guide/story/command liên quan và chạy build để xác nhận relative path.
