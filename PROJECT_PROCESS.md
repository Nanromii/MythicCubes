# Quy trình và trạng thái dự án

## SDLC/BMAD Lite

```text
Game Vision → Product Rules → Phase/Epic → Story → Implementation Plan
→ Coding → Static Validation → Roblox Studio Functional Test → Playtest
→ Code Review → Verification Evidence → Complete
```

Toàn bộ game là Product; mỗi phase là một Epic; mỗi thay đổi độc lập, có thể kiểm tra là một Story;
task là thay đổi nhỏ bên trong Story. Gameplay authority thuộc product docs/decision hoặc người dùng,
không thuộc suy đoán của Codex.

## Trạng thái thực tế trong checkout

| Phase | Trạng thái | Căn cứ và giới hạn |
| --- | --- | --- |
| 0 | `DONE (historical)` | Toolchain/build/lint đã được ghi nhận; chưa chạy lại trong task này. |
| 1 | `DONE (historical)` | Home và starter session đã có source; Studio evidence nằm trong docs cũ. |
| 2 | `DONE (historical)` | Data definitions/validator/registry và test project có trong source. |
| 3 | `DONE (historical)` | Combat harness có source và docs ghi acceptance hai client; chưa retest trong task này. |
| 4 | `DONE (historical)` | Vertical slice Phase 4 theo logic cũ đã có source/test project/guide; người dùng đã xác nhận Studio acceptance hoàn tất trong task này. |
| 5+ | `NOT_STARTED` | Product direction/roadmap có thể tồn tại, nhưng chưa có acceptance implementation. |

Không đánh dấu phase `DONE` chỉ vì có code hoặc design. Phase chỉ hoàn thành khi story bắt buộc,
integration test và completion evidence mới đều có.

## Điều kiện bắt đầu một story

Story phải có authority, outcome, in/out scope, gameplay decisions, open questions, acceptance criteria,
technical/security notes, validation plan và rollback. Nếu còn quyết định gameplay quan trọng, chuyển
sang `ambiguous-game-design-change` và hỏi trước khi code.

## Definition of Done

- Acceptance criteria đạt và scope không mở rộng.
- Static checks/build liên quan có evidence mới.
- Studio functional test và multiplayer test đã chạy khi feature cần.
- Server trust boundary, ownership, rate-limit và lifecycle đã review.
- Tài liệu bị ảnh hưởng cập nhật.
- Completion evidence ghi rõ chưa test/giới hạn.

## Dependency hiện tại

Phase 0–4 là nền tảng đã được ghi nhận theo logic cũ; Phase 4 đã qua source/branch reconciliation và
được người dùng xác nhận Studio acceptance hoàn tất. Không mở lại hoặc thay đổi logic các phase này trong
các task thiết kế tương lai.
Progression, DataStore, private home, economy, boss và PvP là phase sau, không được kéo vào story nền.

Chi tiết product đang có ở `docs/product/` và `docs/design/`; phase catalog đầy đủ ở
`docs/phases/PHASE_ROADMAP.md`, còn hướng dẫn truy cập ở `docs/phases/README.md`.

## Current Phase 4 handoff

- **Source evidence:** region/spawn definitions, wild lifecycle, companion presentation, encounter,
  capture/collection session và dedicated Phase 4 test project đã có trong checkout.
- **Studio evidence:** người dùng xác nhận đã chạy xong Play Solo, Server & Clients với hai client và
  matrix kiểm tra Phase 4 theo logic cũ. Codex không có Studio session/raw Output để tự kiểm chứng lại;
  ngày/giờ và Studio version chi tiết chưa được cung cấp.
- **Bước kế tiếp:** không mở lại Phase 4; các thay đổi hit/miss, manual aim hoặc presentation tương lai
  phải thuộc phase/story mới và không được viết ngược vào logic Phase 0–4 đã hoàn tất.
