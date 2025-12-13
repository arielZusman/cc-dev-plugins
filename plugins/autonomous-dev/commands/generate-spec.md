---
name: generate-spec
description: Generate RPG spec from brainstorming/design document
argument-hint: [path-to-design-doc]
---

Use the `rpg-spec-generator` skill to transform a brainstorming/design document into a structured RPG specification.

**Output:** `spec.md` - Structured specification for init-spec processing

**RPG method produces:**
- Capabilities section (WHAT the system does)
- Module Boundaries (HOW code is organized)
- Dependency Graph with topological phases (Foundation -> layers)

**Design document path:** $ARGUMENTS

If no path provided, will auto-detect from `docs/oru-agent/*/design.md`.
