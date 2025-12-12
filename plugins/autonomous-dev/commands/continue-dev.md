---
name: continue-dev
description: Resume feature development, execute next task from feature_list.json
argument-hint: [feature-name]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite
---

# Continue Development (Single Task)

Execute exactly ONE task from `feature_list.json`. This is a convenience wrapper around `/autonomous-dev:run-all --count 1`.

**Feature name (optional):** $ARGUMENTS

---

## What This Command Does

Run the full orchestration workflow for a single task:

1. **ORIENT** - Find feature, read state, check git status
2. **VERIFY** - Regression check on previous work
3. **SELECT** - Pick next incomplete task
4. **IMPLEMENT** - Route to project agent or general-purpose agent
5. **TEST** - Run tests and type checks
6. **UPDATE** - Mark task as passing, update progress.txt
7. **COMMIT** - Git commit the changes
8. **REPORT** - Show progress summary

---

## Usage

This command is equivalent to:
```
/autonomous-dev:run-all <feature-name> --count 1
```

Use `/autonomous-dev:run-all` with `--count N` or `--all` to run multiple tasks in one session.
