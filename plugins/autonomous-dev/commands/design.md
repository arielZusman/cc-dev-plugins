---
name: design
description: Create a structured design document through free-form conversation
argument-hint: [feature-description]
---

Use the design-facilitator subagent to create a structured design document through free-form conversation.

This command helps you:
- Organize your feature ideas into structured requirements
- Clarify scope (MVP vs future)
- Identify edge cases and technical considerations
- Produce a design document optimized for the `spec` command

**User's feature description:** $ARGUMENTS

**Output:** `docs/oru-agent/<feature>/design.md`

**Workflow Position:**
```
/autonomous-dev:design    →  Creates design document
        ↓
/autonomous-dev:spec      →  Creates RPG spec
        ↓
/autonomous-dev:scaffold  →  Creates feature_list.json
        ↓
/autonomous-dev:run       →  Implements tasks
```
