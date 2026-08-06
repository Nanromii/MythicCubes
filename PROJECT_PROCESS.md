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
| 4 | `IN_PROGRESS (source verified; Studio pending)` | Source Phase 4 đã được reconcile vào checkout, gồm world/capture services, test project và guide; Roblox Studio acceptance vẫn chưa có evidence mới. |
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

Phase 0–3 là nền tảng đã được ghi nhận; Phase 4 đã qua source/branch reconciliation nhưng vẫn cần
Studio acceptance trước khi chuyển `DONE` hoặc bắt đầu phase sau.
Progression, DataStore, private home, economy, boss và PvP là phase sau, không được kéo vào story nền.

Chi tiết product đang có ở `docs/product/` và `docs/design/`; phase catalog đầy đủ ở
`docs/phases/PHASE_ROADMAP.md`, còn hướng dẫn truy cập ở `docs/phases/README.md`.

## Current Phase 4 handoff

- **Source evidence:** region/spawn definitions, wild lifecycle, companion presentation, encounter,
  capture/collection session và dedicated Phase 4 test project đã có trong checkout.
- **Chưa có evidence:** Roblox Studio Play Solo, Server & Clients với hai client và raw Output cho
  Phase 4. Không dùng test cũ hoặc source presence để tuyên bố phase hoàn thành.
- **Bước kế tiếp:** chạy [PHASE_4_STUDIO_TEST.md](docs/guides/PHASE_4_STUDIO_TEST.md), ghi actual
  result/Output, sau đó review acceptance và cập nhật trạng thái phase.
