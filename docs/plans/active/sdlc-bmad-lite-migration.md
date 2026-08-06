# Plan: SDLC/BMAD Lite migration

## Outcome

Tạo entry-point, workflow, story/plan/test templates và Roblox-specific skills đủ nhẹ để Codex tiếp tục
phát triển theo nhiều phase mà không tự quyết gameplay hay tuyên bố hoàn thành thiếu evidence.

## Current state

Repo có source Roblox/Rojo, docs tập trung ở `docs/project` và design docs nhiều phase. Checkout hiện
chứa source Phase 1–3; Phase 4 trong docs chưa khớp tree source và cần ghi rõ là chưa xác minh.

## Authority

Yêu cầu migration của người dùng, root `AGENTS.md`, product docs, `PROJECT_PROCESS.md` và `WORKFLOW.md`.

## Scope

Root governance docs, docs index/product/templates/baseline, 9 local skills, legacy link compatibility,
reference/link/validation audit. Không sửa gameplay hoặc đưa harness từ ZIP vào repo.

## Out of scope

Combat/capture/boss/region/creature/skill/DataStore/UI/monetization implementation; multi-agent database,
SQLite, locking, CLI orchestration, macOS binary và Git history.

## Milestones

- [x] Discovery repository, source mapping và `test.zip`.
- [x] Proposal và authority boundary.
- [x] Governance/docs migration.
- [x] Skill adaptation.
- [x] Reference/static/diff validation.
- [x] Baseline/final evidence.

## Risks and rollback

Rủi ro chính là broken links hoặc hai tài liệu cùng làm authority. Kiểm tra link sau khi dọn historical
pages; rollback bằng revert commit/files, không reset history.

## Progress log

- 2026-08-06: Discovery cho thấy `.codegraph` tồn tại; đã dùng CodeGraph để đọc call paths. `test.zip`
  chứa `.git`, `__MACOSX`, harness, SQLite schema và các skill/docs tham khảo.
- 2026-08-06: Root entry-point và initializer cho 9 skill đã tạo; đang hoàn thiện nội dung.
- 2026-08-06: 9 skill pass `quick_validate.py` với Python UTF-8 mode; link audit không có link hỏng; source/tests/config không đổi.
- 2026-08-06: Selene direct binary pass; Rojo 7.7.0 build pass. StyLua direct binary fail do line-ending diff trong source hiện hữu; không format source trong docs-only scope. Roblox Studio not run.
- 2026-08-06: Bổ sung `docs/phases/PHASE_ROADMAP.md`, xóa compatibility pages dưới `docs/project/`, cập nhật link historical và xóa `build.rbxlx` artifact.

## Validation matrix

| Area | Evidence cần có | Status |
| --- | --- | --- |
| Markdown links | PowerShell link audit mới | Pass |
| Authority duplication | Root authority + legacy compatibility pages manual review | Pass |
| Skill structure | `quick_validate.py` cho từng skill | Pass |
| Roblox static/build | Selene pass; Rojo build pass; StyLua source line-ending diff | Partial / pre-existing gap |
| Studio | Version, clients, manual result | Not run in this docs task |

## Completion summary

Migration hoàn tất trong phạm vi docs/process/skills. Không có gameplay/source change. Phase 4 vẫn
`AWAITING_SOURCE_VERIFICATION`; Studio chưa chạy; StyLua check của source hiện hữu còn line-ending
diff nên không được tuyên bố clean. Plan giữ ở `active/` như audit trail cho story reconciliation kế tiếp.
