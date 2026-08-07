---
name: tdd
description: Apply focused red-green-refactor testing to pure Roblox/Luau logic such as damage, state transitions, cooldowns, permissions, target validation, schemas, progression rules, and regressions. Use when a valuable automated seam exists; do not force it on visual Studio-only work.
---

# Tdd

Read the Story acceptance criteria, current shared module and test project before editing.

## Workflow

1. Choose one observable behavior and write the smallest failing test.
2. Run it fresh and record red output.
3. Implement the minimum change, preserving server authority and data-driven definitions.
4. Run the focused test and record green output.
5. Refactor only after green, then run neighboring tests and relevant StyLua/Selene/Rojo checks.
6. For networking, complement pure tests with Roblox Studio and exploit-oriented scenarios.

## Good candidates

Damage/effectiveness, state machines, cooldowns, permission/ownership, exact remote payload validation,
data schema, progression and regression bugs.

## Not mandatory

Animation, layout, asset placement, camera feel and other visual polish without a stable pure seam.

## Output and completion

Record red/green/refactor commands, exit codes and behavior assertions. Do not claim runtime correctness from unit tests alone.
