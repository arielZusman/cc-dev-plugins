---
name: validate-task
description: Validate a completed task using adversarial cooperation pattern
argument-hint: [feature-name] [task-id | --last]
allowed-tools: Task, Read, Glob
---

# Task Validation Command

Validate a completed task implementation using an independent validator agent.

**Arguments:** $ARGUMENTS

## Workflow

### 1. Parse Arguments

Extract from `$ARGUMENTS`:
- `feature_name`: First argument (required)
- `task_id`: Second argument OR `--last` for most recent completed task

### 2. Find Feature

1. **Search for feature directory**:
   ```bash
   ls autonomous-dev/features/*/feature_list.json 2>/dev/null
   ```

2. **Selection logic**:
   - If `feature_name` provided: Read `autonomous-dev/features/<feature_name>/feature_list.json`
   - If no `feature_name` and exactly one feature exists: Use it
   - If multiple features and no name: List them and ask user

### 3. Identify Task

- If `task_id` provided: Find that specific task
- If `--last` provided: Find most recent task with `passes: true`
- Verify task exists

Report:
```
Validating Task #<id>: <description>
Category: <category>
Status: <passes ? "completed" : "incomplete">
```

### 4. Spawn Validator Agent

```
Task tool parameters:
- subagent_type: "task-validator"
- prompt: |
    Validate this completed task:

    Feature: <feature_name>
    Task ID: <task_id>

    Task definition:
    <full task JSON from feature_list.json>

    Produce a validation report with APPROVED or NEEDS_WORK status.
- description: "Validate task #<id>"
```

### 5. Report Results

Display the validation report to the user.

**If NEEDS_WORK:**
- List immediate actions from the validator
- Suggest: "Address these issues and run validation again"

**If APPROVED:**
- Confirm task implementation is complete
- If task was not marked as passing, suggest marking it
- Suggest next steps (continue to next task, etc.)
