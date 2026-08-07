---
name: planning-game-story
description: Turn an approved Roblox gameplay or bounded system request into a small playable Story with authority, scope, acceptance criteria, server/client ownership, exploit risks, and Studio validation. Use before implementation; never implement code from this skill.
---

# Planning Game Story

Read `AGENTS.md`, product authority, `ARCHITECTURE.md`, `PROJECT_PROCESS.md`, relevant design docs and existing source/tests. Use `grill-me` if a material gameplay decision is unresolved.

## Workflow

1. State the player/system outcome and why it belongs to the current phase.
2. Link accepted authority; mark proposals `DRAFT/TBD`.
3. Split the phase into one independently playable/observable increment.
4. Define in/out scope, gameplay decisions, open questions and dependencies.
5. Specify server/client ownership, remote payload intent, validation, rate-limit, idempotency and multiplayer isolation.
6. Write observable acceptance criteria and a validation matrix: static, build, Studio functional, multiplayer, exploit and playtest.
7. Save under `docs/stories/phase-xx/` using `docs/stories/templates/story.md`.

## Output

A Story with status, authority, context, scope, acceptance criteria, technical/security notes, validation plan and completion evidence placeholder.

## Prohibitions

Do not invent formulas, expand scope, create code, or mark acceptance complete. A plan is execution guidance, not product authority.

## Completion criteria

Another agent can implement the smallest increment without asking broad questions, and all remaining questions are concrete and explicit.
