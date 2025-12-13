---
name: scaffold
description: Initialize autonomous feature development with codebase analysis and feature list creation
argument-hint: <spec-text-or-file-path>
---

Use the scaffold subagent to initialize autonomous feature development for this brownfield project.

**Specification provided:** $ARGUMENTS

**Before spawning the agent**, extract available specialized agents from your Task tool's `subagent_type` list and include them in the prompt. Format:

```
Available Agents for Task Delegation:
- <agent-name>: <description>
- ...
```

Include all agents that could handle backend, frontend, or testing tasks. Always include `general-purpose` as the fallback.
