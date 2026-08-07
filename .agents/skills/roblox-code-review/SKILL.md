---
name: roblox-code-review
description: Review Roblox/Luau changes, stories, commits or diffs against product/architecture authority and server trust boundaries. Use for code review or implementation compliance; keep the review read-only.
---

# Roblox Code Review

Resolve the narrow review target, read changed files plus callers/tests/config, and use CodeGraph only for navigation. Do not edit, stage or approve.

## Review order

1. Requirement and authority compliance.
2. Logic correctness and stale state.
3. Server/client trust boundary and remote exact-shape validation.
4. Player/creature ownership, rate-limit, replay/idempotency and multiplayer isolation.
5. Lifecycle, cleanup, respawn/reconnect and data-driven boundaries.
6. Regression coverage and fresh validation evidence.

## Finding format

```text
[Critical|High|Medium|Low] Title
Claim:
Authority and evidence:
Location:
Impact:
Required correction:
Validation to rerun:
```

Keep unresolved gameplay decisions separate from technical findings. If no finding exists, still report validation gaps and inspected scope.

## Completion criteria

Findings are evidence-backed and ordered by severity; no “LGTM” or completion claim substitutes for runtime proof.
