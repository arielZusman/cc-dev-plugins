---
name: codex-plan-review
description: Use when completing a plan and ready to call ExitPlanMode, or when seeking external plan validation before implementation - invokes Codex CLI to review plans for completeness, correctness, and clarity, returning structured actionable feedback
---

# Codex Plan Review

Invoke Codex CLI to get external review of implementation plans. Returns structured JSON feedback.

## Prerequisites

```bash
# Install if not available
command -v codex || npm install -g @openai/codex
```

## Workflow Checklist

Copy and track progress:

```
- [ ] Step 1: Identify plan file
- [ ] Step 2: Run Codex review
- [ ] Step 3: Read and apply feedback
```

## Step 1: Identify Plan File

Plans are in `$HOME/.claude/plans/`. Find the current plan:

```bash
ls -t "$HOME/.claude/plans/" | head -5
```

Set the path:

```bash
PLAN_FILE="$HOME/.claude/plans/YOUR_PLAN_NAME.md"
```

## Step 2: Run Codex Review

Get the schema path and run review. Note: Codex CLI requires prompts via stdin (using `-` flag), not as positional arguments.

```bash
SCHEMA_PATH="$(dirname "$0")/schema.json"

cat << 'PROMPT_EOF' | codex exec --output-schema "$SCHEMA_PATH" -o /tmp/plan-review-result.json - 2>&1 | tee /tmp/plan-review-output.log
Review this implementation plan for:
1. COMPLETENESS: Missing steps, edge cases, error handling, dependencies
2. CORRECTNESS: Technical accuracy, feasibility, best practices, potential bugs
3. CLARITY: Ambiguous instructions, unclear scope, missing context

Be critical and thorough. Plan content:

$(cat "$PLAN_FILE")
PROMPT_EOF
```

If running manually (not from skill directory), use the full schema path:

```bash
cat << 'PROMPT_EOF' | codex exec --output-schema /path/to/schema.json -o /tmp/plan-review-result.json -
Review this implementation plan for:
1. COMPLETENESS: Missing steps, edge cases, error handling, dependencies
2. CORRECTNESS: Technical accuracy, feasibility, best practices, potential bugs
3. CLARITY: Ambiguous instructions, unclear scope, missing context

Be critical and thorough. Plan content:

$(cat "$PLAN_FILE")
PROMPT_EOF
```

## Step 3: Read Results

```bash
cat /tmp/plan-review-result.json
```

### Interpreting Results

| Field | Meaning |
|-------|---------|
| `score` | 1-10 rating (8+ good, <6 needs work) |
| `issues` | Problems with severity (critical/major/minor) and category |
| `missing_considerations` | Things the plan didn't account for |
| `strengths` | What the plan does well |

### Applying Feedback

1. **Critical** issues: Must fix before implementation
2. **Major** issues: Should fix or accept as known risk
3. **Minor** issues: Nice to have
4. Re-run if score < 7 after significant changes

## Example Output

```json
{
  "overall_assessment": "Solid plan with clear structure, but missing error handling and rollback strategy",
  "score": 7,
  "issues": [
    {
      "severity": "critical",
      "category": "completeness",
      "description": "No rollback plan if migration fails",
      "suggestion": "Add rollback steps and backup strategy before migration",
      "affected_section": "Task 3: Database Migration"
    }
  ],
  "missing_considerations": [
    "How to handle concurrent requests during deployment",
    "Cache invalidation strategy"
  ],
  "strengths": [
    "Clear task breakdown",
    "Good file organization"
  ]
}
```
