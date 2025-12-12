---
name: status
description: Show current memory bank status, health, and contents summary
allowed-tools: Read, Bash
---

# Memory Bank Status

Display current memory bank state and health assessment.

## Process

### Step 1: Check Directory Exists

```bash
MEMORY_BANK_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"

if [ -d "$MEMORY_BANK_DIR" ]; then
  echo "STATUS: INITIALIZED"
  ls -la "$MEMORY_BANK_DIR/"
else
  echo "STATUS: NOT_INITIALIZED"
fi
```

If not initialized, display:
```
## Memory Bank Status: Not Initialized

Run `/memory-bank:init` to set up session continuity for this project.
```

### Step 2: Analyze File Health

For each memory bank file, check:

```bash
MEMORY_BANK_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"

for file in context.md decisions.md; do
  path="$MEMORY_BANK_DIR/$file"
  if [ -f "$path" ]; then
    echo "=== $file ==="

    # Cross-platform date handling (using absolute paths for sandbox compatibility)
    if [[ "$OSTYPE" == "darwin"* ]]; then
      mod_date=$(/usr/bin/stat -f '%Sm' -t '%Y-%m-%d %H:%M' "$path")
      mod_time=$(/usr/bin/stat -f '%m' "$path")
    else
      mod_date=$(/usr/bin/stat -c '%y' "$path" | /usr/bin/cut -d'.' -f1)
      mod_time=$(/usr/bin/stat -c '%Y' "$path")
    fi

    echo "Modified: $mod_date"
    echo "Words: $(/usr/bin/wc -w < "$path" | /usr/bin/tr -d ' ')"
    echo "Lines: $(/usr/bin/wc -l < "$path" | /usr/bin/tr -d ' ')"
    current_time=$(/bin/date +%s)
    age_days=$(( (current_time - mod_time) / 86400 ))
    echo "Age: $age_days days"
    echo ""
  else
    echo "=== $file ==="
    echo "Status: MISSING"
    echo ""
  fi
done
```

### Step 3: Display Content Summary

Show abbreviated content:

```bash
MEMORY_BANK_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"

echo "=== Context Summary ==="
if [ -f "$MEMORY_BANK_DIR/context.md" ]; then
  # Show Current Focus section (using absolute paths for sandbox compatibility)
  /usr/bin/awk '/^## Current Focus/{flag=1; next} /^## /{flag=0} flag' "$MEMORY_BANK_DIR/context.md" | /usr/bin/head -3
else
  echo "(file missing)"
fi

echo ""
echo "=== Recent Decisions ==="
if [ -f "$MEMORY_BANK_DIR/decisions.md" ]; then
  # Show first 3 decision titles (using absolute paths for sandbox compatibility)
  /usr/bin/grep '^### ' "$MEMORY_BANK_DIR/decisions.md" | /usr/bin/head -3 | /usr/bin/sed 's/^### /- /'
else
  echo "(file missing)"
fi
```

### Step 4: Health Assessment

Determine overall health:

| Status | Condition |
|--------|-----------|
| **Healthy** | Both files exist, updated within 7 days, >50 words each |
| **Stale** | Files exist but >7 days old |
| **Sparse** | Files exist but <50 words |
| **Incomplete** | One file missing |
| **Empty** | Both files exist but empty/minimal |
| **Not Initialized** | Directory doesn't exist |

### Step 5: Provide Recommendations

Based on health status:

- **Healthy**: "Memory bank is ready. Context will be loaded at next session start."
- **Stale**: "Consider running `memory-bank:capture` to update with current state."
- **Sparse**: "Memory bank has minimal content. Use `memory-bank:capture` after your next work session."
- **Incomplete**: "Missing [file]. Run `/memory-bank:init` or create manually."
- **Empty**: "Files exist but lack content. Run `/memory-bank:init` for fresh analysis."

## Output Format

```
## Memory Bank Status

**Health**: [Healthy/Stale/Sparse/Incomplete/Empty/Not Initialized]

### context.md
- Last modified: [Date]
- Word count: [N]
- Age: [N] days
- Focus: [First line of Current Focus]

### decisions.md
- Last modified: [Date]
- Decision count: [N]
- Latest: [Most recent decision title]

### Recommendations
[Based on health assessment]
```
