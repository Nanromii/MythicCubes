# Quy ước Git

## Branch model

```text
prod
└── master
    └── feature/<phase-or-story>
```

`prod` là production ổn định; `master` là development/integration; `feature/...` là story hoặc
bounded change; dùng `fix/...` cho bug nhỏ và `docs/...` cho docs-only. Không sửa trực tiếp `prod`.

### Quy tắc bắt buộc khi đặt tên branch

- Tên branch công việc phải bắt đầu **trực tiếp** bằng đúng một trong ba loại: `feature/`, `fix/` hoặc
  `docs/`. Phần sau dấu `/` dùng chữ thường, số và dấu gạch nối để mô tả phase, story hoặc thay đổi.
- Không thêm tiền tố tên agent, công cụ, người thực hiện hoặc môi trường trước loại công việc. Đặc biệt,
  mọi dạng `codex/...`, `codex/feature/...`, `agent/...` hoặc `<tên-người>/...` đều không hợp lệ.
- Agent phải kiểm tra tên đầy đủ trước khi chạy `git switch -c`; không được tự áp dụng quy ước đặt tên
  branch từ công cụ nếu quy ước đó thêm tiền tố ngoài ba loại được phép ở trên.
- Branch cũ có tên không đúng quy tắc không tạo thành tiền lệ. Không tự đổi tên branch cũ nếu người dùng
  chưa yêu cầu; chỉ áp dụng quy tắc này cho mọi branch được tạo từ thời điểm quy tắc có hiệu lực.

Ví dụ:

```text
Hợp lệ:       feature/phase-05-village-onboarding
Hợp lệ:       fix/village-camera-lock
Hợp lệ:       docs/studio-test-output-template
Không hợp lệ: codex/feature/phase-05-village-onboarding
Không hợp lệ: codex/village-onboarding
Không hợp lệ: quang/feature/village-onboarding
```

## Thao tác thường dùng

```powershell
git switch master
git switch -c feature/phase-04-story-01
git status
git diff --check
git add <files>
git commit -m "docs: add Roblox story workflow"
```

Dùng Conventional Commit với message tiếng Anh, mô tả một thay đổi có chủ đích. Không commit
`*.rbxlx`, cache, secret, log hoặc file tạm nếu không có lý do repository rõ ràng. Project JSON theo
phase nằm ở `artifacts/json/`; output phase/test/validation nằm ở `artifacts/rbxlx/`, không ở root.

## Merge và rollback

- Review và validation trên feature branch trước khi merge vào `master`.
- Chỉ merge `master` vào `prod` sau acceptance/Studio evidence của scope release và người dùng yêu cầu.
- Khi conflict, xác định authority trước, giải từng file nhỏ, chạy lại validation; không dùng reset để che conflict.
- Rollback an toàn bằng revert commit hoặc khôi phục artifact đã biết; không rewrite shared history.
- Không force push, xóa branch, rebase branch đã chia sẻ hoặc chạy `git reset --hard` nếu chưa được yêu cầu rõ.
