---
name: roblox-studio-testing
description: Design concise Roblox Studio test cases for functional, regression, multiplayer, exploit-oriented, and playtest scenarios. Use when a Story or change needs manual Studio validation; distinguish Play Solo, Start Server/Player and Server & Clients.
---

# Roblox Studio Testing

Read the Story acceptance criteria, affected authority and existing Studio guides. Never turn a build/lint result into runtime evidence.

## Test case fields

- Write tester-facing prose in clear Vietnamese. Keep English only for exact Roblox UI labels, commands,
  identifiers, enum values, error codes and established in-game terms that would become ambiguous if
  translated. Do not mix ordinary English nouns into Vietnamese sentences when a natural Vietnamese
  equivalent exists.
- Copy/paste-ready preparation commands before Preconditions. Include the exact project root, build/serve
  input, output artifact and open/run command needed for that case. If Client/Server Command Bar or a
  temporary script is required, provide a complete runnable Luau snippet; never leave the tester to
  reconstruct a command from prose.
- Preconditions and Studio version
- Mode and client count
- Numbered steps
- Expected result
- Actual result
- Server Output and Client Output observations
- Pass/fail, timestamp and untested limits

Every Studio test matrix must be delivered with a separate raw-Output template in the same directory.
Name it `<MATRIX_NAME_WITHOUT_MATRIX>OUTPUT_TEMPLATE.md`; for example,
`PHASE5_STUDIO_TEST_MATRIX.md` pairs with `PHASE5_STUDIO_TEST_OUTPUT_TEMPLATE.md`. The template must have
one matching section per test-case ID, metadata fields, actual result, verdict, and fenced `text` blocks
for unedited Server Output and every Client Output. Link the two files both ways. Never invent, summarize
or pre-fill raw Output that was not actually supplied.

## Select mode

Use Play Solo for smoke tests; Start Server/Start Player for boundary checks; Server & Clients for ownership,
remote, reset/respawn and isolation. Add exploit-oriented cases for invalid IDs, other-player objects,
spam, wrong state, post-respawn requests and out-of-range values. Separate functional correctness from game feel.

## Completion criteria

Each relevant acceptance criterion maps to a manual case or is explicitly marked not applicable/untested;
the paired raw-Output template exists and has exactly the same case IDs; no invented Studio version or raw log.
