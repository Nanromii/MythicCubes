# Tài liệu dự án

## Điểm vào

- Quy tắc agent: [`AGENTS.md`](../AGENTS.md), [`CODEX.md`](../CODEX.md)
- Kiến trúc hiện tại: [`ARCHITECTURE.md`](../ARCHITECTURE.md)
- Quy trình và phase: [`PROJECT_PROCESS.md`](../PROJECT_PROCESS.md), [`phases/README.md`](phases/README.md)
- Workflow task: [`WORKFLOW.md`](WORKFLOW.md)
- Product authority: [`product/`](product/)
- Story/plan/decision: [`stories/`](stories/), [`plans/`](plans/), [`decisions/`](decisions/)
- Test/verification: [`testing/`](testing/)

## Tài liệu historical

`docs/project/` chỉ còn các tài liệu historical như changelog, coding standards và learning notes.
Nội dung authority hiện tại nằm ở root và các thư mục trong trang này. `docs/design/` là design detail;
mỗi file phải ghi rõ `accepted`, `DRAFT` hoặc `TBD` và không được tự biến thành implementation contract.

## Nguyên tắc viết tài liệu

- Một behavior chỉ có một authority chính.
- Phân biệt `Current`, `Target`, `Implemented`, `Historical evidence` và `TBD`.
- Không ghi test pass hoặc phase done nếu không có evidence phù hợp.
- Dùng ví dụ từ source hiện tại; không dùng design tương lai để mô tả runtime đã tồn tại.
