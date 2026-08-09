# Quy trình và trạng thái dự án

## SDLC/BMAD Lite

```text
Product/design document intake → Authority classification → Capability inventory
→ Conflict + impact analysis → Phase/Epic schedule → Story → Implementation Plan
→ Coding → Static Validation → Roblox Studio Functional/Multiplayer Test
→ Code Review → Verification Evidence → Complete → Roadmap drift audit
```

Toàn bộ game là Product; mỗi phase là một Epic; mỗi thay đổi độc lập, có thể kiểm tra là một Story;
task là thay đổi nhỏ bên trong Story. Gameplay authority thuộc product docs/decision hoặc người dùng,
không thuộc roadmap, implementation plan, code hiện tại hay suy đoán của Codex.

## Phân lớp statement bắt buộc

Mỗi statement được dùng để lập roadmap hoặc Story phải được gắn đúng một lớp:

- **Current implementation:** hành vi quan sát được từ source/evidence hiện tại; không tự thành product rule.
- **Accepted product rule:** behavior đã được authority chấp nhận và phải được implementation giữ.
- **Target direction:** outcome/hướng tương lai đã có ý nghĩa nhưng chưa đủ chi tiết để code.
- **`DRAFT/TUNABLE`:** proposal/con số cần review; được schedule nhưng không viết thành acceptance production.
- **`TBD`:** quyết định còn thiếu; phải trở thành gate hoặc open question trước Story.
- **Historical evidence:** bằng chứng Phase 0–4; không được viết lại để khớp design mới.
- **Future implementation schedule:** vị trí trong roadmap; không chứng minh feature đã tồn tại hay đã được chấp nhận.

Khi hai statement xung đột, áp dụng authority order trong `AGENTS.md`, ghi cả hai statement/file/section
và lý do resolve. Nếu authority chưa đủ hoặc conflict ảnh hưởng gameplay, permission, security hay
compatibility, giữ `TBD` và dừng đúng Story bị chặn; không âm thầm chọn behavior.

## Trạng thái thực tế trong checkout

| Phase | Trạng thái | Căn cứ và giới hạn |
| --- | --- | --- |
| 0 | `DONE (historical)` | Toolchain/build/lint đã được ghi nhận; task roadmap này không chạy lại. |
| 1 | `DONE (historical)` | Home và starter session có historical source/evidence; không viết lại acceptance. |
| 2 | `DONE (historical)` | Data definitions/validator/registry và test project có historical evidence. |
| 3 | `DONE (historical)` | Combat harness có historical source/Studio evidence; không phải combat production. |
| 4 | `DONE (historical)` | Open-world/capture session slice theo logic cũ đã đóng; không có contact/manual-throw/persistence production. |
| 5 | `SOURCE_VERIFIED_STUDIO_PENDING` | Automated/Play Solo/Server & Clients, gồm camera Custom và physical touch-gate Story 05-04, đã pass theo xác nhận người dùng ngày 2026-08-09; raw log/Studio version không được cung cấp. Licensed audio/SFX vẫn pending nên Phase chưa `DONE`. |
| 6–35 | `NOT_STARTED` | Roadmap mô tả target increment; chưa có implementation/acceptance production mới. |

Phase 0–4 là baseline bất biến. Mọi migration, mở rộng hoặc thay thế behavior cũ nằm ở Phase 5+.
Không đánh dấu phase `DONE` chỉ vì design, code hoặc test cũ tồn tại.

## Quy trình tiếp nhận product/design document

Mỗi khi thêm hoặc sửa document về mechanic/feature, người thực hiện phải cập nhật cùng change set:

1. **Inventory:** ghi document, owner/nguồn quyết định, trạng thái, capability và section liên quan.
2. **Classify:** tách accepted rule, current baseline, target, `DRAFT/TUNABLE`, `TBD` và historical claim.
3. **Trace:** thêm/cập nhật một dòng capability với logic, UI/input, model/animation/environment,
   camera/VFX/audio, persistence/security, dependency, open decision và proposed phase.
4. **Conflict:** đối chiếu product/design/architecture/roadmap; ghi conflict register thay vì sửa lịch sử.
5. **Impact:** xác định phase/story/data schema/remote/security/presentation/device test bị ảnh hưởng.
6. **Schedule:** cập nhật `docs/phases/PHASE_ROADMAP.md`, mapping old→new nếu cần và index liên quan.
7. **Gate:** nếu decision chưa đủ, ghi `Product decisions required before Story`; không mở Story code.
8. **Validate drift:** chạy checklist link, traceability, discipline, status và diff trước merge/completion.

Document mới không được chỉ link từ README rồi để roadmap cũ. Ngược lại, roadmap không được tự biến
proposal trong design doc thành product authority.

## Schema traceability tối thiểu

Active plan của initiative roadmap hoặc change-impact record phải giữ tối thiểu:

| Field | Nội dung |
| --- | --- |
| Capability/mechanic | Một behavior/outcome có thể trace, kể cả còn DRAFT/TBD |
| Source authority + status | File/section và accepted/target/DRAFT/TBD/current/historical |
| Current implementation | Evidence quan sát được hoặc “chưa có”; không suy ra rule |
| Old phase + proposed phase | Nơi cũ và playable increment mới |
| Dependencies | Capability/data/decision dependency thực |
| Four discipline slices | Logic/server; UI/input; model/environment/animation; camera/VFX/audio |
| Persistence/security | Schema, transaction, ownership, remote và exploit impact |
| Open decisions | Một gate cụ thể, không ghi chung “balance later” |
| Validation | Automated/static, Play Solo, Server & Clients, integration/regression |

Không xóa dòng vì capability chưa chốt. Giữ nó dưới dạng dependency/open decision và không claim
implementation hoặc acceptance.

## Quy tắc tổ chức Phase/Epic

- Phase 5+ đánh số nguyên liên tục; không tạo phase thập phân.
- Mỗi phase có đúng một outcome playable chính, quan sát được trong Roblox Studio.
- Mỗi phase chạm ít nhất hai lane: `logic/server`, `UI/UX/input`,
  `model/environment/animation`, `audio/VFX/camera`.
- Mọi cửa sổ ba phase liên tiếp phải chạm đủ bốn lane; không quá hai phase liên tiếp cùng primary lane.
- Gameplay mechanic mới có feedback UI cùng phase; asset/animation/audio đại diện nằm cùng hoặc phase kế tiếp.
- Presentation, mobile, accessibility và performance được làm theo từng slice; phase hardening không phải
  lần đầu bổ sung support.
- Dependency mô tả capability/decision/schema thật, không mặc định “phase trước phải xong”.
- Phase content tự bao gồm data/logic, presentation và validation của content đó.
- Mọi phase tương lai mặc định `NOT_STARTED`; chỉ đổi status bằng evidence mới.

Schema chi tiết và catalog canonical nằm ở `docs/phases/PHASE_ROADMAP.md`.

## Điều kiện bắt đầu một Story

Story phải có:

- authority và trạng thái từng rule;
- outcome playable, in/out scope và capability dependencies;
- product decisions required/open questions; không còn gameplay/security decision bị dùng mà vẫn `TBD`;
- server/client ownership, exact remote validation và transaction/idempotency boundary;
- persistence/migration impact hoặc lý do không có;
- UI/input, model/animation/environment, camera/VFX/audio slice cần thiết;
- mobile/accessibility/performance budget;
- acceptance criteria, automated/static, Play Solo, Server & Clients và regression plan;
- rollback và completion evidence format.

Nếu còn quyết định gameplay quan trọng, route sang `ambiguous-game-design-change` và dùng `grill-me`
từng câu trước khi code. Không gom cả Epic vào một Story.

## Definition of Done cho Story

- Acceptance criteria đạt, scope không mở rộng và decision sử dụng đã được ghi authority.
- Static checks/build/test liên quan có evidence mới.
- Studio functional và multiplayer/exploit test đã chạy khi feature cần; phần chưa chạy ghi rõ.
- Server trust boundary, ownership, rate limit, lifecycle, transaction và migration đã review.
- UI/presentation/device/accessibility budget của chính slice đạt, không defer vô thời hạn.
- Tài liệu, traceability và roadmap impact đã cập nhật.
- Completion evidence ghi command/manual check, thời gian, exit/pass-fail, kết quả và phần chưa test.

## Điều kiện chuyển/đóng Phase

Phase chỉ chuyển trạng thái khi:

1. Tất cả Required Stories đạt Definition of Done bằng evidence mới.
2. Outcome playable chính pass integration gate trong Studio.
3. Automated/static, Play Solo và Server & Clients matrix phù hợp đều được ghi.
4. Không còn finding nghiêm trọng hoặc decision được implementation dùng còn `TBD`.
5. Product/design/architecture docs, conflict register và traceability không drift.
6. Phase kế tiếp có capability dependency thật và đủ authority để mở Story.

`DONE (historical)` chỉ dành cho Phase 0–4 hiện tại. Phase mới không kế thừa status từ code/design cũ.

## Drift audit bắt buộc

Chạy audit khi có product/design document mới, trước Story đầu tiên của phase, trước khi đóng phase và
khi đổi authority/architecture ảnh hưởng nhiều capability:

- mọi product/design file có inventory entry;
- mọi capability có proposed phase hoặc explicit deferred/TBD;
- conflict register không có conflict bị resolve ngầm;
- số phase/status/mapping/index nhất quán;
- discipline-window và schema phase vẫn hợp lệ;
- data/security/presentation/device impact không bị bỏ sót;
- Phase 0–4 diff bằng zero về ngữ nghĩa;
- link và `git diff --check` pass.

Nếu audit phát hiện drift, sửa roadmap/process trong cùng initiative trước khi mở Story bị ảnh hưởng.

## Current Phase 4 handoff

- **Source evidence:** region/spawn, wild lifecycle, companion presentation, shared encounter/capture/
  collection session và test project tồn tại trong checkout.
- **Historical Studio evidence:** người dùng đã xác nhận Play Solo và hai client theo logic Phase 4 cũ;
  task này không có raw Studio Output để tái kiểm chứng.
- **Giới hạn:** chưa có production hitbox/projectile miss/manual throw, progression, persistence,
  three-main formation hoặc production presentation.
- **Bước kế tiếp:** không mở lại Phase 4; dùng roadmap Phase 5+ và tạo Story nhỏ sau khi decision gate đủ.
