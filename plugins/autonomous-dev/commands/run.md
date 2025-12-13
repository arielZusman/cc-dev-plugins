---
name: run
description: Execute tasks from feature_list.json with full 8-phase workflow
argument-hint: [feature-name] [--count N] [--all] [--validate]
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task, TodoWrite
---

# Autonomous Development Orchestrator

Execute tasks from `feature_list.json` with full 8-phase workflow. Routes implementation to project-specific agents or the built-in `general-purpose` agent.

**Arguments provided:** $ARGUMENTS

---

## PHASE 1: ORIENT (Parse & Understand State)

### 1.1 Parse Arguments

Extract from `$ARGUMENTS`:
- `feature_name`: First non-flag argument (optional)
- `count`: Number from `--count N` (default: 5)
- `run_all_flag`: True if `--all` flag is present (overrides count)
- `validate_flag`: True if `--validate` flag is present (enables adversarial validation)

### 1.2 Find Feature Directory

1. **Search for feature directories**:
   ```bash
   ls docs/oru-agent/*/feature_list.json 2>/dev/null
   ```

2. **Selection logic**:
   - If `feature_name` provided → use that specific feature
   - If no `feature_name` and exactly one feature exists → use it
   - If multiple features and no name → list them and ask user which to use

### 1.3 Read Feature State

Read these files from the feature directory:
- `feature_list.json` - Task definitions and status
- `progress.txt` - Previous session notes
- `docs/oru-agent/codebase_analysis.md` - Patterns to follow (if exists)

### 1.4 Check Git Status

```bash
git status
git log --oneline -3
```

Ensure working directory is clean before proceeding.

### 1.5 Count and Report

- Total tasks in feature_list.json
- Completed tasks (`passes: true`)
- Remaining tasks (`passes: false`)

**Announce**:
```
Feature: <feature-name>
Progress: X/Y tasks complete
Will run: Z tasks this session
```

---

## PHASE 2: VERIFY (Regression Check)

**Goal**: Ensure previous work still functions before adding new code.

### Steps

1. **Find last completed task**: Look for most recent task with `passes: true`

2. **If no completed tasks**: Skip to PHASE 3

3. **If completed tasks exist**:
   - Identify relevant test command from task or codebase_analysis.md
   - Run verification:
     ```bash
     npm test -- --testPathPattern=<module>
     npx tsc --noEmit
     ```

4. **If verification fails**:
   - Log the regression in progress.txt
   - **Stop and report** - do not proceed with new work
   - Suggest fixing the regression first

5. **If verification passes**: Proceed to PHASE 3

---

## PHASE 3: Orchestration Loop

For each task (up to count limit):

### 3.1 SELECT Task

1. **Pick first incomplete task**: First task with `passes: false`
2. **Read task details**:
   - `id`, `category`, `description`
   - `delegateTo` - Agent to use (optional)
   - `skills` - Skills to load (optional)
   - `tdd`, `testCriteria` - TDD requirements
   - `existing_patterns`, `reuse` - Context
   - `steps` - Implementation guidance

3. **Create TodoWrite items** for tracking

### 3.2 IMPLEMENT (Route to Agent)

**If task has `delegateTo` field:**

Spawn the project-specific agent:

```
Task tool parameters:
- subagent_type: "<delegateTo>" (e.g., "backend")
- prompt: |
    Implement this task for feature: <feature-name>

    Task #<id>: <description>
    Category: <category>

    Steps:
    <steps as numbered list>

    Patterns to follow:
    <existing_patterns>

    Components to reuse:
    <reuse>

    Skills to use: <skills array if present>

    <If tdd: true>
    Use TDD (RED-GREEN-REFACTOR):
    Test criteria:
    <testCriteria as numbered list>
    </If>

    Return a summary of what was implemented.
- description: "Task #<id>: <brief description>"
```

**If NO `delegateTo` field:**

Spawn the built-in general-purpose agent:

```
Task tool parameters:
- subagent_type: "general-purpose"
- prompt: |
    Implement this task for feature: <feature-name>

    Task #<id>: <description>
    Category: <category>

    Steps:
    <steps as numbered list>

    Patterns to follow:
    <existing_patterns>

    Components to reuse:
    <reuse>

    <If tdd: true>
    Use TDD (RED-GREEN-REFACTOR):
    Test criteria:
    <testCriteria as numbered list>
    </If>

    Return a summary of what was implemented.
- description: "Task #<id>: <brief description>"
```

Wait for the agent to complete.

### 3.3 TEST (Verify Implementation)

Run verification after implementation:

1. **Run unit tests** for affected module:
   ```bash
   npm test -- --testPathPattern=<module>
   ```

2. **For e2e-test tasks**, run integration tests:
   ```bash
   npm run test:e2e
   ```

3. **Check TypeScript compilation**:
   ```bash
   npx tsc --noEmit
   ```

4. **Check linting** (if configured):
   ```bash
   npm run lint
   ```

5. **If any check fails**:
   - Log the failure
   - **Stop orchestration** - do not mark task as passing
   - Report what failed and suggest fixes

### 3.3.5 VALIDATE (Optional - If --validate flag)

If `validate_flag` was set:

1. **Spawn validator agent**:
   ```
   Task tool parameters:
   - subagent_type: "validator"
   - prompt: |
       Validate this completed task:

       Feature: <feature_name>
       Task ID: <task_id>

       Task definition:
       <full task JSON>

       Produce a validation report with APPROVED or NEEDS_WORK status.
   - description: "Validate task #<id>"
   ```

2. **Check validator result**:
   - If APPROVED: Continue to PHASE 3.4
   - If NEEDS_WORK:
     - Log validation feedback in progress.txt
     - **Stop orchestration**
     - Display validation report with immediate actions
     - Do NOT mark task as passing

### 3.4 UPDATE (Mark Progress)

Only if all tests pass:

1. **Update feature_list.json**:
   - Change `"passes": false` → `"passes": true` for the completed task
   - Do NOT modify any other fields

2. **Update progress.txt**:
   ```
   ## Session: YYYY-MM-DD

   Task #<id>: <description>
   - Agent used: <delegateTo or general-purpose>
   - What was implemented
   - Tests added/updated
   - Any notes
   ```

### 3.5 COMMIT (Git Commit)

Create a commit for the completed task:

```bash
git add .
git commit -m "feat(<feature-name>): <task description>

- <what was implemented>
- <tests added/updated>
- Task #<id> of <total> completed

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

### 3.6 Report Progress

```
[Task <id>/<total>] Completed: <description>
Agent: <delegateTo or general-purpose>
Progress: X/Y tasks complete
```

### 3.7 Continue or Stop

- If more tasks remain AND within count limit → continue to next task (back to 3.1)
- If count limit reached → exit to PHASE 4
- If all tasks complete → exit to PHASE 4

---

## PHASE 4: Final Summary

### If tasks remain:

```
## Orchestration Complete

Feature: <feature-name>
Tasks completed this session: N
Total progress: X/Y tasks (Z%)

Remaining tasks:
- #<id>: <description>
- #<id>: <description>

Run `/autonomous-dev:run <feature-name>` to continue.
```

### If feature complete:

```
## Feature Complete!

Feature: <feature-name>
All <total> tasks finished successfully.

Next steps:
- Review the implementation
- Run full test suite
- Create PR if ready
```

---

## Error Handling

### Implementation Failure
If agent reports failure or tests don't pass:
1. Log the failure reason in progress.txt
2. Do NOT mark task as passing
3. Report current progress
4. Stop orchestration
5. Suggest investigating the failure

### Regression Detected
If PHASE 2 verification fails:
1. Report which test/check failed
2. Do NOT proceed with new work
3. Suggest fixing regression first

### Feature Not Found
If no `feature_list.json` found:
1. Report error: "No feature found"
2. List available features (if any)
3. Suggest running `/autonomous-dev:scaffold` to create a new feature

### All Tasks Already Complete
If feature is 100% complete:
1. Report success: "Feature already complete!"
2. Suggest next steps (PR, new feature, etc.)
