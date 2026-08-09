# Quy ước Git

## Branch model

```text
prod
└── master
    └── feature/<phase-or-story>
```

`prod` là production ổn định; `master` là development/integration; `feature/...` là story hoặc
bounded change; dùng `fix/...` cho bug nhỏ và `docs/...` cho docs-only. Không sửa trực tiếp `prod`.

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
