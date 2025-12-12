---
name: recall
description: Load full memory bank context when the compact summary isn't enough. Use when user asks "what was I working on", "load memory bank", "recall context", "show full context", "get memory bank", or when you need comprehensive session context beyond the SessionStart summary.
---

# Memory Bank Recall

Load and present full memory bank context for deep session continuity.

## When to Use

- User explicitly requests full context
- Complex task requires understanding previous decisions
- Resuming work after extended break
- Need to reference decision rationale
- SessionStart summary isn't detailed enough

## Workflow

### Step 1: Verify Memory Bank Exists

Check for memory bank directory:

```bash
ls -la "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/" 2>/dev/null || echo "NOT_FOUND"
```

If not found, suggest running `/memory-bank:init`.

### Step 2: Load Context File

Read full context:

```bash
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/context.md"
```

Present with structure:
- **Current Focus**: What's being worked on
- **Active Tasks**: With status indicators
- **Next Steps**: Prioritized actions
- **Session Notes**: Blockers and dependencies

### Step 3: Load Decisions File

Read decisions:

```bash
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/decisions.md"
```

Present recent decisions with:
- Decision title and date
- Context and rationale
- Alternatives that were considered

### Step 4: Synthesize and Recommend

After loading both files, provide:

1. **Quick Summary**: 2-3 sentence overview of project state
2. **Recommended Action**: What to work on based on context
3. **Key Decisions**: Any decisions relevant to likely next work

## Output Format

```
## Memory Bank Loaded

### Current State
[Summary from context.md - focus and active tasks]

### Active Tasks
- [ ] Task 1
- [ ] Task 2
- [x] Completed task

### Recent Decisions
[Most relevant decisions from decisions.md]

### Recommended Next Action
[Based on Next Steps and Active Tasks]
```

## Edge Cases

- **Empty files**: Suggest using `/memory-bank:init` or `memory-bank:capture`
- **Outdated context**: Note last modified date, suggest update if stale (>7 days)
- **Missing files**: Explain what's missing and how to create them
