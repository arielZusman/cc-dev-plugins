---
name: capture
description: Save current session state to memory bank for future session continuity. Use when user asks "save context", "update memory bank", "capture state", "store this decision", "remember this for next time", or when suggesting updates after significant work is completed.
---

# Memory Bank Capture

Save current session state to memory bank for future session continuity.

## When to Use

- After completing significant work
- Before ending a session
- After making architectural decisions
- When user explicitly requests save
- Proactively suggest after detecting significant changes

## Proactive Suggestion Triggers

Suggest memory bank update when you detect:
- New files created in key directories (src/, lib/, tests/)
- Test files added or modified
- Configuration changes (package.json, tsconfig, etc.)
- Documentation updates
- Multi-file refactoring
- Architectural decisions made during conversation

Use this format:
> I notice you've made significant changes to [area]. Would you like me to update the memory bank to capture the current focus and any decisions made?

## Workflow

### Step 1: Analyze Current Session

Review the current conversation to identify:
1. What work was accomplished
2. What decisions were made and why
3. What remains to be done
4. Any blockers or dependencies discovered

### Step 1.5: Ensure Directory Exists

Before writing, ensure the memory bank directory exists:

```bash
mkdir -p "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"
```

If the directory didn't exist (first-time capture), consider suggesting `/memory-bank:init` for a more thorough initialization with codebase analysis instead of a simple capture.

### Step 2: Read Existing Files

Load current memory bank state:

```bash
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/context.md" 2>/dev/null || echo "# No existing context"
```

```bash
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/decisions.md" 2>/dev/null || echo "# No existing decisions"
```

### Step 3: Update Context File

Write updated content to `.claude/memory-bank/context.md`:

```markdown
## Current Focus

[Updated focus based on session work - 2-3 sentences describing what's being worked on]

## Active Tasks

- [ ] [Updated task list based on current state]
- [x] [Mark completed tasks from this session]

## Next Steps

1. [Updated next actions based on conversation]
2. [Prioritized follow-ups]

## Session Notes

[New blockers, dependencies, or critical context discovered]
Last updated: [Today's date]
```

**Guidelines:**
- Keep under 300 words (target ~150)
- Be specific: include file paths and component names
- Focus on actionable information
- Don't duplicate CLAUDE.md content

### Step 4: Update Decisions File (If Applicable)

If architectural or design decisions were made this session, **prepend** to `.claude/memory-bank/decisions.md`:

```markdown
### [Decision Title] - [Today's Date]

**Context**: [Why this decision was needed]

**Decision**: [What was decided - be specific]

**Rationale**: [Why this choice over alternatives]

**Alternatives Considered**:
- [Alt 1]: [Why not chosen]

---

[Keep existing decisions below...]
```

**Guidelines:**
- Only add decisions that affect future work
- Keep the 5 most recent decisions
- Be concise but include enough context to understand "why"

### Step 5: Confirm Save

After writing files, confirm:
- Which files were updated
- Summary of captured state
- Reminder that compact summary will appear at next session start

## Quality Checks

Before saving, verify:
- [ ] context.md under 300 words
- [ ] Specific file paths and component names included
- [ ] Next steps are actionable
- [ ] Decisions include rationale, not just the choice
- [ ] No duplication of CLAUDE.md content
- [ ] Date stamp updated
