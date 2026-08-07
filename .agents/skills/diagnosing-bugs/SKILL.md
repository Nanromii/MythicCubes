---
name: diagnosing-bugs
description: Diagnose Roblox/Luau bugs, failing validation, build failures, and runtime regressions with fresh evidence before a minimal authorized fix. Use after work-router selects a bug-related workflow.
---

# Diagnosing Bugs

Read `AGENTS.md`, `docs/WORKFLOW.md`, relevant authority, source and tests. Keep diagnosis read-only unless the user authorized a fix.

## Workflow

1. Reproduce with the smallest fresh command or Studio scenario; record exit/result.
2. Collect exact error, state, timing, request and call path. Use CodeGraph for navigation when current, then confirm source directly.
3. Minimize inputs and retain a regression case.
4. Rank falsifiable hypotheses and test one variable at a time.
5. State symptom, trigger and root cause separately.
6. Apply only the narrowest authorized fix; use `tdd` for a valuable pure-logic regression seam.
7. Re-run original reproduction, static checks and relevant Studio/multiplayer test.

## Output

Report reproduction, evidence, rejected hypotheses, root cause, changed files, regression proof and untested surfaces.

## Prohibitions

Do not patch from a plausible guess, refactor outside scope, hide errors, weaken validation, or treat old logs/tests as fresh proof.

## Completion criteria

The original reproduction is rerun, root cause is evidence-backed, and the final claim is limited to the checks actually executed.
