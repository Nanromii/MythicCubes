---
name: implementation-walkthrough
description: Explain an existing Roblox/Luau implementation, branch or large change by runtime flow, ownership boundaries, source reading order and evidence limits. Use for navigation/walkthrough requests, not formal correctness review.
---

# Implementation Walkthrough

State the evidence boundary first: observed source is not proof of correctness or Studio behavior. Read the narrow target, relevant callers/consumers/tests and current authority; use CodeGraph for navigation then confirm source.

## Output order

1. Three-minute overview and one useful flow diagram when material.
2. Must-read, supporting and proof-read files.
3. Server bootstrap, client bootstrap, shared modules, remotes and state changes.
4. Reference-to-implementation table with `Observed`, `Partially observed`, `Potential mismatch`, `Not independently verified` or `Not applicable`.
5. Unknowns, validation evidence and review handoff.

Use cautious language such as “the code configures” and “not independently verified”; do not assign review severity or claim compliance.

## Completion criteria

The reader can follow one primary runtime path and knows exactly what was observed, inferred, historical and still untested.
