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

## Reference note

The active instructions are above; this note preserves the initializer layout.

## Reference note: initializer guidance

The active skill has already selected its workflow. The following generic guidance is not an instruction:

**1. Workflow-Based** (best for sequential processes)
- Works well when there are clear step-by-step procedures
- Example: DOCX skill with "Workflow Decision Tree" -> "Reading" -> "Creating" -> "Editing"
- Structure: ## Overview -> ## Workflow Decision Tree -> ## Step 1 -> ## Step 2...

**2. Task-Based** (best for tool collections)
- Works well when the skill offers different operations/capabilities
- Example: PDF skill with "Quick Start" -> "Merge PDFs" -> "Split PDFs" -> "Extract Text"
- Structure: ## Overview -> ## Quick Start -> ## Task Category 1 -> ## Task Category 2...

**3. Reference/Guidelines** (best for standards or specifications)
- Works well for brand guidelines, coding standards, or requirements
- Example: Brand styling with "Brand Guidelines" -> "Colors" -> "Typography" -> "Features"
- Structure: ## Overview -> ## Guidelines -> ## Specifications -> ## Usage...

**4. Capabilities-Based** (best for integrated systems)
- Works well when the skill provides multiple interrelated features
- Example: Product Management with "Core Capabilities" -> numbered capability list
- Structure: ## Overview -> ## Core Capabilities -> ### 1. Feature -> ### 2. Feature...

Patterns can be mixed and matched as needed. Most skills combine patterns (e.g., start with task-based, add workflow for complex operations).

Delete this entire "Structuring This Skill" section when done - it's just guidance.]

## Additional resources

No additional skill-specific content is required. Examples from the initializer are retained only as reference:
- Code samples for technical skills
- Decision trees for complex workflows
- Concrete examples with realistic user requests
- References to scripts/templates/references as needed]

## Resources

Create only the resource directories this skill actually needs. Delete this section if no resources are required.

### scripts/
Executable code (Python/Bash/etc.) that can be run directly to perform specific operations.

**Examples from other skills:**
- PDF skill: `fill_fillable_fields.py`, `extract_form_field_info.py` - utilities for PDF manipulation
- DOCX skill: `document.py`, `utilities.py` - Python modules for document processing

**Appropriate for:** Python scripts, shell scripts, or any executable code that performs automation, data processing, or specific operations.

**Note:** Scripts may be executed without loading into context, but can still be read by Codex for patching or environment adjustments.

### references/
Documentation and reference material intended to be loaded into context to inform Codex's process and thinking.

**Examples from other skills:**
- Product management: `communication.md`, `context_building.md` - detailed workflow guides
- BigQuery: API reference documentation and query examples
- Finance: Schema documentation, company policies

**Appropriate for:** In-depth documentation, API references, database schemas, comprehensive guides, or any detailed information that Codex should reference while working.

### assets/
Files not intended to be loaded into context, but rather used within the output Codex produces.

**Examples from other skills:**
- Brand styling: PowerPoint template files (.pptx), logo files
- Frontend builder: HTML/React boilerplate project directories
- Typography: Font files (.ttf, .woff2)

**Appropriate for:** Templates, boilerplate code, document templates, images, icons, fonts, or any files meant to be copied or used in the final output.

---

**Not every skill requires all three types of resources.**
