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
