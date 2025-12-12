---
name: init
description: Initialize memory bank with intelligent codebase analysis
allowed-tools: Read, Grep, Glob, Bash, Write, Task
---

# Initialize Memory Bank

Set up the memory bank for this project with intelligent codebase analysis.

## Process

### Step 1: Check for Existing Memory Bank

```bash
if [ -d "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank" ]; then
  echo "EXISTS"
  ls -la "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/"
else
  echo "NOT_EXISTS"
fi
```

If files already exist, ask the user:
- **Overwrite**: Fresh analysis, replace existing files
- **Keep existing**: Cancel initialization
- **Merge**: Analyze and suggest additions to existing content

### Step 2: Create Directory Structure

```bash
mkdir -p "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"
```

### Step 3: Analyze Codebase

Dispatch the `codebase-analyzer` subagent using the Task tool:

```
Task tool call:
- subagent_type: "memory-bank:codebase-analyzer"
- prompt: "Analyze this codebase and generate initial memory bank files at .claude/memory-bank/. Create context.md with current focus, active tasks, and next steps. Create decisions.md with any recent architectural decisions found in git history or code comments."
```

The agent will:

1. **Examine recent git history**
   - Recent commits (last 7 days)
   - Current branch and status
   - Recently modified files

2. **Identify current work focus**
   - Work-in-progress code (TODO, FIXME comments)
   - Recent file modifications
   - Feature branch names

3. **Extract recent decisions**
   - Architectural patterns in recent commits
   - Technology choices visible in config files
   - Design decisions in code comments

4. **Determine next steps**
   - Incomplete tasks (TODO comments)
   - Failing tests
   - Open issues if accessible

### Step 4: Generate Memory Bank Files

Create `.claude/memory-bank/context.md`:

```markdown
## Current Focus

[Generated from analysis - describe active work area]

## Active Tasks

- [ ] [Identified from TODOs and recent changes]

## Next Steps

1. [Derived from analysis]

## Session Notes

Memory bank initialized on [Today's Date].
[Any blockers or dependencies discovered during analysis]
```

Create `.claude/memory-bank/decisions.md`:

```markdown
## Recent Decisions

### [Decision found in analysis] - [Date]

**Context**: [Derived from code/commits]

**Decision**: [What was chosen]

**Rationale**: [Why, if discoverable]

---

*Memory bank initialized on [Today's Date]. Future decisions will be captured here.*
```

### Step 5: Verify Setup

```bash
echo "=== Memory Bank Initialized ==="
ls -la "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/"
echo ""
echo "=== context.md ==="
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/context.md"
echo ""
echo "=== decisions.md ==="
cat "${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank/decisions.md"
```

### Step 6: Explain Usage

After initialization, explain to the user:

```
Memory Bank initialized successfully!

**How it works:**
- At session start: Compact summary injected automatically (~100-200 tokens)
- Need more context: Use `memory-bank:recall` skill
- Save progress: Use `memory-bank:capture` skill
- Check status: Run `/memory-bank:status`

**Files created:**
- `.claude/memory-bank/context.md` - Current focus, tasks, next steps
- `.claude/memory-bank/decisions.md` - Recent decisions with rationale

The memory bank complements CLAUDE.md with dynamic session state.
```

## Output

Confirm initialization with:
- Files created and their content
- Summary of detected context
- Recommended next action based on analysis
