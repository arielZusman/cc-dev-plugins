#!/bin/bash
# Memory Bank SessionStart Hook
# Injects compact context summary (~100-200 tokens) at session start
# Gracefully handles malformed markdown files

set -uo pipefail
# Note: -e removed to allow graceful error handling

MEMORY_BANK_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/memory-bank"
CONTEXT_FILE="$MEMORY_BANK_DIR/context.md"
DECISIONS_FILE="$MEMORY_BANK_DIR/decisions.md"

# Check if memory bank exists
if [ ! -d "$MEMORY_BANK_DIR" ]; then
  echo "[Memory Bank: Not initialized] Run /memory-bank:init to set up session continuity."
  exit 0
fi

# Extract components separately (with error handling for malformed files)
focus=""
next=""
recent_decision=""

# Extract current focus from context.md (content under ## Current Focus until next ##)
if [ -f "$CONTEXT_FILE" ]; then
  focus=$(awk '/^## Current Focus/{flag=1; next} /^## /{flag=0} flag && NF' "$CONTEXT_FILE" 2>/dev/null | head -3 | tr '\n' ' ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' || true)

  # Extract next steps (first 2 items under ## Next)
  next=$(awk '/^## Next/{flag=1; next} /^## /{flag=0} flag && /^[0-9]/' "$CONTEXT_FILE" 2>/dev/null | head -2 | sed 's/^[0-9]*\. //' | tr '\n' ';' | sed 's/;$//' | sed 's/;/; /g' || true)
fi

# Extract most recent decision from decisions.md (just the title)
if [ -f "$DECISIONS_FILE" ]; then
  recent_decision=$(grep -m1 '^### ' "$DECISIONS_FILE" 2>/dev/null | sed 's/^### //' || true)
fi

# Build summary with consistent prefix when any content exists
if [ -n "$focus" ] || [ -n "$next" ] || [ -n "$recent_decision" ]; then
  summary="[Memory Bank: Active]"
  [ -n "$focus" ] && summary="$summary
**Focus**: $focus"
  [ -n "$next" ] && summary="$summary
**Next**: $next"
  [ -n "$recent_decision" ] && summary="$summary
**Recent Decision**: $recent_decision"

  summary="$summary

Use memory-bank:recall skill for full context if needed."
  echo "$summary"
else
  echo "[Memory Bank: Empty] Context files exist but are empty. Run /memory-bank:init or use memory-bank:capture skill."
fi

exit 0
