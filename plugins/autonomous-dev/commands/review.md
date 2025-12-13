---
name: review
description: Review and validate RPG spec before scaffold
argument-hint: [path-to-spec]
---

Use the `plan-reviewer` agent to review and validate an RPG specification before creating implementation tasks.

**Spec path:** $ARGUMENTS

If no path provided, auto-detect from `docs/oru-agent/*/spec.md`.

**Review criteria:**
- Completeness of capabilities and requirements
- Feasibility of implementation approach
- Risk assessment for database/API changes
- Alignment with existing codebase patterns
- Efficiency of dependency ordering

**Outcomes:**
- **APPROVED**: Proceed with `/autonomous-dev:scaffold`
- **APPROVED WITH CONCERNS**: Note concerns, then proceed
- **NEEDS REVISION**: Edit spec.md or re-run `/autonomous-dev:spec`
- **REJECTED**: Return to `/autonomous-dev:design`
