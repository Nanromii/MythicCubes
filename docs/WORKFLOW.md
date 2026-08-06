# Workflow SDLC/BMAD Lite cho Roblox

## Phân loại bắt buộc

Chạy `.agents/skills/work-router` trước mọi yêu cầu. Skill phải trả lời ngắn:

```text
Task type:
Authority:
Scope:
Workflow:
Validation:
Human decision required:
```

`orchestrated-multi-agent-work` không tự dùng trong project cá nhân này.

## Bug

```text
Reproduce → Collect evidence → Minimize reproduction → Form hypothesis
→ Verify root cause → Add regression protection when useful → Minimal fix
→ Static validation → Studio reproduction → Report evidence
```

Không patch theo phỏng đoán. Phân biệt symptom, trigger và root cause; giữ reproduction cũ để retest.

## Bounded feature

```text
Read authority → Confirm scope → Acceptance criteria → Implementation plan
→ Smallest playable increment → Static validation → Studio functional test
→ Multiplayer test if relevant → Review → Completion evidence
```

Story nhỏ vẫn cần out-of-scope để ngăn feature creep.

## Gameplay chưa rõ

```text
Identify unresolved decision → Ask one concrete question
→ Record accepted decision → Update product authority → Plan implementation
```

Dùng `grill-me`; không viết code trong lúc quyết định còn mở.

## Initiative nhiều phiên

Dùng đúng một file trong `docs/plans/active/`. Mỗi phiên ghi progress log, decision, risk và validation
matrix. Chỉ chuyển file sang `docs/plans/completed/` sau khi mọi milestone/acceptance có evidence mới.

## Completion gate

Skill `verification-before-completion` phải ghi:

```text
Claim:
Command or manual check:
Execution time/date:
Exit code or pass/fail:
Important result:
Untested:
Verdict:
```

Studio test là evidence riêng với build/lint. Không dùng test cũ làm bằng chứng duy nhất.
