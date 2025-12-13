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
/oru-agent:design    →  Creates design document
        ↓
/oru-agent:spec      →  Creates RPG spec
        ↓
/oru-agent:scaffold  →  Creates feature_list.json
        ↓
/oru-agent:run       →  Implements tasks
```
