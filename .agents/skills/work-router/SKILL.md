---
name: work-router
description: Classify every MythicCubes task into one primary workflow before edits. Use for all repository requests to choose read-only-analysis, tiny-fix, bounded-change, ambiguous-game-design-change, multi-session-initiative, or explicitly requested orchestration.
---

# Work Router

Use first. Read `AGENTS.md`, `CODEX.md`, `PROJECT_PROCESS.md` and `docs/WORKFLOW.md`, then inspect only the authority and source relevant to the request.

## Route

Choose exactly one type: `read-only-analysis`, `tiny-fix`, `bounded-change`, `ambiguous-game-design-change`, `multi-session-initiative`, or `orchestrated-multi-agent-work`. Use the last type only when the user explicitly requests multi-agent orchestration; this repository has no harness database.

## Output

```text
Task type: <one type>
Authority: <files/decisions>
Scope: <in/out>
Workflow: <skills and order>
Validation: <static/build/Studio/manual proof>
Human decision required: <none or one concrete question>
```

## Rules

- Do not promote missing gameplay detail into a product decision.
- For bugs route to `diagnosing-bugs`; for stories route to `planning-game-story`.
- Use a durable plan only for meaningful multi-session work.
- Do not edit while routing an ambiguous product change.

## Completion criteria

The route is recorded before edits and the selected workflow is consistent with the requested scope.
