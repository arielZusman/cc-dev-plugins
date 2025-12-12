---
name: generate-prd
description: Generate structured PRD from brainstorming output for autonomous development (uses RPG method for dependency-aware task graphs)
argument-hint: [path-to-design-doc]
---

Use the `prd-generator` skill to transform a brainstorming/design document into a structured PRD using the **RPG (Repository Planning Graph) method**.

**RPG method produces:**
- Capabilities section (WHAT the system does)
- Module Boundaries (HOW code is organized)
- Dependency Graph with topological phases (Foundation → layers)

**Design document path:** $ARGUMENTS

If no path provided, will auto-detect from `docs/plans/*-design.md`.
