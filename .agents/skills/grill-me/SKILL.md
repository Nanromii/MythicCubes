---
name: grill-me
description: Resolve materially ambiguous Roblox gameplay, UX, permission, scope or acceptance decisions through a one-question-at-a-time interview. Use only when the user invokes it, names it, or accepts the router recommendation; never implement code during the interview.
---

# Grill Me

Read `AGENTS.md`, `docs/WORKFLOW.md`, the smallest relevant product/design/architecture docs and source facts first. Do not ask for information already recorded.

## Interview rules

- Ask exactly one concrete question at a time.
- Give a short recommendation and rationale.
- Start with the decision that changes downstream scope most.
- Keep facts, assumptions and accepted decisions separate.
- Cover flow, exceptional states, permissions, data, security and testable acceptance only when relevant.

## Output

Close with a Change Brief/Product Brief containing objective, user, confirmed scope/out-of-scope, flow,
constraints, permissions, data/integrations, acceptance criteria, assumptions and remaining unknowns.
Write it to the narrow `docs/product/` authority only when the current request authorizes document changes.

## Prohibitions and completion

Do not write source, create implementation plans, spawn agents or silently choose a gameplay rule. Finish when the user confirms shared understanding or the unresolved decision is explicitly recorded.
