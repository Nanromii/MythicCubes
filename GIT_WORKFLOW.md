# Quy trình Git

## Mô hình branch

```text
prod
master
feature/*
fix/*
hotfix/*
release/*
docs/*
chore/*
```

### `prod`

`prod` chỉ chứa code ổn định, đang hoặc sẵn sàng publish. Không commit trực tiếp và không merge feature trực tiếp vào `prod`. Branch này chỉ nhận merge từ `release/*` hoặc `hotfix/*`, sau khi người dùng xác nhận.

### `master`

`master` là branch development/integration. Feature và fix thông thường bắt đầu từ đây rồi merge trở lại đây. `master` có thể chưa sẵn sàng production nhưng không được trở thành nơi giữ code thử nghiệm bị hỏng kéo dài.

### Feature branch

```powershell
git switch master
git pull
git switch -c feature/creature-data-system
```

Sau khi validation thành công:

```powershell
git add .
git commit -m "feat: add creature data foundation"
git switch master
git merge --no-ff feature/creature-data-system
```

Chỉ push khi người dùng yêu cầu rõ ràng và sau khi kiểm tra branch đích.

### Fix branch

Fix branch tạo từ `master`, ví dụ `fix/rojo-mapping`, `fix/client-bootstrap`, `fix/remote-validation`.

### Hotfix branch

Hotfix tạo từ `prod` khi production cần sửa ngay:

```text
prod → hotfix/* → prod → merge ngược lại master
```

### Release branch

Tạo từ `master` khi chuẩn bị production, ví dụ `release/0.1.0`. Chỉ sửa bug, version, tài liệu release và cấu hình production; không thêm feature lớn.

### Docs và chore

`docs/*` dành cho thay đổi tài liệu độc lập. `chore/*` dành cho tooling, cấu hình hoặc bảo trì không làm thay đổi gameplay.

## Conventional Commits

```text
feat: add initial rojo project structure
fix: correct starter player mapping
docs: add project architecture guide
chore: configure stylua and selene
refactor: simplify server bootstrap
test: add element chart validation
build: add rojo build configuration
ci: add source validation workflow
```

Message viết bằng tiếng Anh, chữ thường sau dấu `:`, ngắn gọn và mô tả một thay đổi chính. Không dùng message mơ hồ như `update`, `fix bug`, `changes` hoặc `done`; không gộp nhiều feature không liên quan.

Scope có thể dùng khi hữu ích:

```text
feat(combat): add elemental damage calculation
fix(rojo): correct replicated storage mapping
docs(process): update phase 0 status
```

## Quy tắc merge

- Feature và fix thông thường → `master`.
- Release → `prod`.
- Hotfix → `prod`, sau đó merge ngược vào `master`.
- Không merge khi build hoặc validation thất bại.
- Không force push branch dùng chung hoặc rebase branch nhiều người dùng khi chưa thống nhất.
- Ưu tiên merge có lịch sử rõ ràng; merge vào `prod` cần người dùng xác nhận.

## Version

Dùng Semantic Versioning `MAJOR.MINOR.PATCH`:

- `0.1.0`: vertical slice đầu tiên.
- `0.2.0`: thêm capture.
- `0.2.1`: sửa lỗi capture.
- `1.0.0`: production chính thức đầu tiên.

## Khởi tạo branch

`prod` được tạo từ foundation commit `a9a000f` và dùng làm production branch. `master` được giữ làm development/integration branch. Default branch trên GitHub phải là `prod`; sau khi thay đổi cần xác minh bằng remote HEAD, không chỉ bằng symbolic ref local.
