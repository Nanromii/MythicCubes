# Hướng dẫn cho Codex

Đây là điểm vào chính cho mọi agent làm việc trong repository MythicCubes/VoxelCreatures.
Đọc file này trước, sau đó đọc `CODEX.md`, `ARCHITECTURE.md`, `PROJECT_PROCESS.md` và chỉ
đọc tài liệu product/story/test liên quan tới yêu cầu hiện tại.

## Project invariants

- Đây là game Roblox dùng Rojo; `default.project.json` là mapping filesystem → Roblox DataModel.
- Root chỉ giữ `default.project.json`, `default-current.rbxlx` và tooling output generic; mọi Rojo
  project JSON và RBXLX dành riêng cho phase/test/validation phải nằm dưới `artifacts/json/` và
  `artifacts/rbxlx/` theo [`artifacts/README.md`](artifacts/README.md).
- Server là nguồn quyết định cho gameplay quan trọng. Client chỉ gửi intent và render kết quả đã được server xác nhận.
- Mọi `RemoteEvent` và `RemoteFunction` phải validate type, shape, state, ownership, range, rate và quyền ở server khi phù hợp.
- Player không được điều khiển creature, inventory, combat state hoặc dữ liệu của player khác.
- Ưu tiên definition/registry data-driven; không thêm logic riêng cho từng creature nếu schema hiện có đáp ứng được.
- Không thêm DataStore, monetization hoặc dependency mới trước phase được authority cho phép.
- Không dùng tên, asset, hình ảnh hoặc nội dung sao chép Pokémon hay IP bên thứ ba chưa được phép.
- Không sửa file ngoài repository; không sửa trực tiếp branch production.
- Commit message viết bằng tiếng Anh; tài liệu dự án viết bằng tiếng Việt, giữ nguyên identifier/command/thuật ngữ kỹ thuật cần thiết.
- Không coi code hoặc test cũ là bằng chứng mới cho một tuyên bố hoàn thành.

## Authority order

Khi có mâu thuẫn, ưu tiên theo thứ tự:

1. Yêu cầu trực tiếp mới nhất của người dùng.
2. Product decision đã được chấp nhận.
3. Architecture decision đã được chấp nhận.
4. Story đang thực hiện.
5. Active implementation plan.
6. Kiến trúc hiện tại.
7. Code và test hiện tại như bằng chứng về hành vi quan sát được, không tự trở thành product rule.

Nếu mâu thuẫn ảnh hưởng gameplay, permission, security hoặc compatibility, dừng trước khi
chọn behavior và ghi rõ câu hỏi cần người dùng quyết định.

## Task routing

Mỗi yêu cầu phải được phân loại bằng skill `.agents/skills/work-router` thành đúng một loại chính:

- `read-only-analysis`
- `tiny-fix`
- `bounded-change`
- `ambiguous-game-design-change`
- `multi-session-initiative`
- `orchestrated-multi-agent-work`

Loại cuối chỉ dùng khi người dùng yêu cầu rõ; dự án này không tự kích hoạt orchestration nhiều agent.

## Phạm vi và quy tắc chung

- Khảo sát trước khi sửa: status, authority docs, source mapping, tests và validation hiện có.
- Không tự tạo gameplay rule còn thiếu; dùng `TBD` hoặc skill `grill-me` để hỏi từng quyết định.
- Bug phải đi qua reproduce → evidence → hypothesis → root cause trước khi patch.
- Feature phải có story, scope, acceptance criteria và validation plan trước khi code.
- Không mở rộng phase, đổi branch strategy, thêm dependency hoặc đổi kiến trúc chỉ vì thấy có thể hữu ích.

## Completion rule

Không tuyên bố task/story/phase hoàn thành nếu chưa có bằng chứng mới trong phiên hiện tại.
Bằng chứng phải ghi command hoặc manual check, thời điểm, exit code/pass-fail, kết quả quan trọng
và phần chưa test. Roblox Studio functional test/multiplayer test phải được ghi rõ là chưa chạy
nếu Codex không có quyền thực hiện trong Studio.

## Tài liệu dự án

Các tài liệu historical còn lại dưới `docs/project/` chỉ giữ thông tin tham khảo/changelog/coding
standards. Authority hiện hành là các file root, `docs/product/`, `docs/phases/`, `docs/WORKFLOW.md`,
`docs/stories/` và `docs/plans/`.
