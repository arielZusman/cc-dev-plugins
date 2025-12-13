---
name: rpg-spec-generator
description: Generate RPG (Repository Planning Graph) specs from design documents. Creates dependency-aware, topologically-ordered specifications optimized for scaffold command processing.
---

# RPG Spec Generator

Transform brainstorming/design documents into structured specifications using the **RPG (Repository Planning Graph) method**.

**Key RPG principles applied:**
- **Dual-Semantics**: Separate WHAT (Capabilities) from HOW (Module Boundaries)
- **Explicit Dependencies**: Topological ordering with Foundation -> layers
- **Progressive Refinement**: Capabilities -> Requirements -> Tasks

## When to Use

- After completing `superpowers:brainstorming`
- When design documents exist in `docs/oru-agent/*/design.md`
- Before running `/oru-agent:scaffold`

## Examples

### Simple Feature (1-2 modules)
See: `examples/simple-feature.md`

### Complex Feature (multi-layer)
See: `examples/complex-feature.md`

---

## Workflow

### Step 1: Locate Design Document

If an explicit path was provided as argument, use that. Otherwise auto-detect from recent design docs:

```bash
ls -t docs/oru-agent/*/design.md 2>/dev/null | head -5
```

If no document found: Ask user to provide the path or run `/oru-agent:design` first.

### Step 2: Analyze Design Document

Read the design document and extract:

1. **Feature identity**: Derive kebab-case name from the title/topic
2. **Capability domains**: Group related features into high-level WHAT categories
3. **Requirements**: User stories, feature descriptions, acceptance criteria
4. **Scope boundaries**: What's included vs excluded (look for "Phase 1", "MVP", explicit scope)
5. **Integration points**: APIs, services, databases mentioned
6. **Complexity signals**: Business logic, conditional flows, state machines
7. **Module structure**: How code should be organized (HOW - maps capabilities to files)
8. **Dependency layers**: Foundation -> Data -> Service -> API -> Validation ordering

### Step 2.5: Determine Feature Complexity

Based on analysis, classify complexity:

| Complexity | Criteria | Template Mode |
|------------|----------|---------------|
| **Simple** | 1-2 modules, single capability domain, no state transitions | Minimal template |
| **Medium** | 3-4 modules, 2-3 capability domains, some conditional logic | Standard template |
| **Complex** | 5+ modules, multiple domains, state machines, critical business logic | Full template |

**Complexity Signals:**
- Count of capability domains identified
- Number of requirements with "state transitions" or "conditional logic"
- Database changes requiring migrations
- Integration with external services

Set `COMPLEXITY_LEVEL` (simple/medium/complex) for use in Step 4.

### Step 3: Check Existing Codebase Analysis

Look for existing context to reference:

```bash
cat docs/oru-agent/codebase_analysis.md 2>/dev/null || echo "NOT_FOUND"
```

**Note**: This reads the cached analysis created by previous scaffold runs. If the file doesn't exist, the spec will have minimal pattern references, and the scaffold command will perform full analysis when processing this spec.

If found, extract:
- Module patterns to reference in `existing_patterns`
- Services that could be reused
- Testing patterns in place

### Step 4: Generate Spec

Use the appropriate template based on `COMPLEXITY_LEVEL`:

#### Simple Feature Template (skip these sections):
- Skip: Module Boundaries (infer from single capability)
- Skip: Risk Areas
- Collapse: Dependency Graph to flat list
- Skip: Implementation Hints

#### Medium Feature Template (include):
- All Simple sections plus:
- Module Boundaries (abbreviated)
- Dependency Graph (2-3 phases)

#### Complex Feature Template (full):
- All sections included
- Full Module Boundaries with exports
- Full 5-phase Dependency Graph
- Risk Areas
- Implementation Hints

---

#### Markdown Template (spec.md)

```markdown
# RPG Spec: [Feature Name]

**Generated**: [Today's date]
**Source**: [Path to design doc]
**Version**: 1.0
**Complexity**: simple | medium | complex

---

## Purpose

[Extract from design - 1-2 sentences on why this feature exists]

**Success Criteria**:
- [ ] [Measurable outcome from design goals]
- [ ] [User-facing deliverable]

---

## Capabilities

[Group related features into capability domains - WHAT the system does, not HOW]

### Capability: [Domain Name]
[Brief description of what this capability domain covers]

#### Feature: [Name]
- **Does**: [One sentence - what it accomplishes]
- **Inputs**: [What data/context it needs]
- **Outputs**: [What it produces/returns]
- **Key Behavior**: [Core logic or transformations]
-> **Maps to**: FR-X, FR-Y
-> **Implements in**: `src/modules/[module]/[file].ts`

#### Feature: [Name]
- **Does**: [What it accomplishes]
- **Inputs**: [Required data]
- **Outputs**: [What it produces]
- **Key Behavior**: [Core logic]
-> **Maps to**: FR-Z
-> **Implements in**: `src/modules/[module]/[file].ts`

[Repeat for each capability domain...]

---

## Scope

### IN SCOPE
- [Items explicitly in design]
- [Phase 1 / MVP items]

### OUT OF SCOPE
- [Excluded items from design]
- [Future phases]
- [Items beyond MVP]

---

## Requirements

### FR-1: [Requirement Name]
**Priority**: P1 | P2 | P3

**Description**:
The system SHALL [action from design].

**Acceptance Criteria**:
```gherkin
Given [precondition]
When [action]
Then [expected result]
```

**Implementation Signals** (helps scaffold command determine task structure):
- [ ] Contains conditional logic or branching
- [ ] Involves state transitions
- [ ] Pure data structure change
- [ ] Has edge cases (thresholds, boundaries)
- [ ] Critical business logic

[Repeat for each major requirement...]

---

## Integration Context

### Existing Services to Use
| Service | Purpose | Path |
|---------|---------|------|
| [Name] | [Reuse purpose] | [Path from codebase_analysis] |

### API Changes
- [ ] New endpoint: [METHOD] [path]
- [ ] Modified endpoint: [details]

### Database Changes
- [ ] New table: [name]
- [ ] Modified table: [name] - [columns]
- [ ] Migration required: Yes/No

---

## Module Boundaries
<!-- Skip for Simple complexity -->

[Define clear boundaries for new code - maps Capabilities to code structure (HOW)]

### Module: [kebab-case-name]
- **Responsibility**: [Single clear purpose - one sentence]
- **Capability**: [Links to which Capability section above]
- **Location**: `src/modules/[path]/`
- **Exports**:
  - `ClassName` - [what it provides]
  - `functionName()` - [what it does]
- **Depends On**: [Other NEW modules in this feature]
- **Uses**: [EXISTING services/utilities to import]

### Module: [kebab-case-name]
- **Responsibility**: [Single purpose]
- **Capability**: [Links to Capability]
- **Location**: `src/modules/[path]/`
- **Exports**:
  - `ClassName` - [purpose]
- **Depends On**: [Internal dependencies]
- **Uses**: [External dependencies]

[For simple features, may have only 1-2 modules]

---

## Dependency Graph

[Organize items in topological order - foundation first, then layers that depend on previous layers]

### Foundation Layer (Phase 0) - No Dependencies
These must be built first - they have no dependencies on other items in this feature.

- **[config/env changes]**: [What foundational configuration is needed]
- **[database-migrations]**: [Schema changes that must exist first]

### Data Layer (Phase 1) - Depends on Foundation
- **[entity-definitions]**: Depends on [database-migrations]
- **[dto-definitions]**: Depends on [entity-definitions]

### Service Layer (Phase 2) - Depends on Data
- **[business-logic-service]**: Depends on [entity-definitions, dto-definitions]
  - Contains: [List which requirements FR-X, FR-Y]

### API Layer (Phase 3) - Depends on Services
- **[controller-endpoints]**: Depends on [business-logic-service, dto-definitions]

### Validation Layer (Phase 4) - Depends on API
- **[e2e-tests]**: Depends on [controller-endpoints]
  - Validates: [Which user flows are tested]

[Adjust layers based on actual feature complexity. Simple features may use flat list instead of phases.]

---

## Risk Areas
<!-- Skip for Simple complexity -->

### Business Logic Complexity
- [Area]: [Why complex, edge cases]

### Integration Risks
- [Risk]: [Mitigation]

---

## Implementation Hints
<!-- Skip for Simple complexity -->

### Existing Patterns to Follow
- `[path/to/similar/feature]` - [What pattern to copy]

### Reusable Components
- [Service/Utility]: [How to leverage]

---

## Test Strategy

### Unit Tests (TDD for complex logic)
- [Service method]: [Test scenarios from acceptance criteria]

### E2E Test Scenario
1. Happy path: [Main user flow]
2. Edge case: [Important boundary]
```

### Step 4.5: Validate Dependency Graph (DAG Check)

Before writing output, validate the dependency graph is acyclic:

**Validation Rules:**
1. **No self-references**: No item depends on itself
2. **Phase ordering**: Phase N items only depend on Phase < N items
3. **No forward references**: Items cannot depend on items defined later in same phase
4. **Completeness**: All `Depends On` references resolve to defined items

**Validation Procedure:**
```
For each item in Dependency Graph:
  For each dependency in item.depends_on:
    - Verify dependency exists in an earlier phase
    - Verify no circular path back to item
```

**If validation fails:**
- List the circular/invalid dependencies
- Suggest corrections (move item to later phase, or remove dependency)
- Do NOT proceed to write output until resolved

### Step 5: Write Spec File

The feature directory should already exist from `/oru-agent:design`. If not, create it:

```bash
mkdir -p docs/oru-agent/<feature-name>
```

**Write spec**: Use the Write tool to create `docs/oru-agent/<feature-name>/spec.md` with the generated content from Step 4.

**Verify the write**:

```bash
ls -lh docs/oru-agent/<feature-name>/spec.md
```

### Step 6: Report and Suggest Next Steps

After generating the spec, provide:

1. **Summary**:
   - Feature name derived
   - Complexity level determined
   - Number of requirements identified
   - How many have TDD complexity indicators
   - Dependencies identified
   - DAG validation status

2. **Next step command**:
   ```
   Spec generated at: docs/oru-agent/<feature-name>/spec.md

   Next step - run scaffold with this spec:
   /oru-agent:scaffold @docs/oru-agent/<feature-name>/spec.md
   ```

---

## Quality Checks

Before finalizing the spec, verify:

**Core Checks:**
- [ ] Feature name is kebab-case (max 30 characters)
- [ ] Complexity level is set (simple/medium/complex)
- [ ] All requirements have implementation signals checked
- [ ] IN SCOPE and OUT OF SCOPE sections are explicit
- [ ] At least one E2E scenario exists
- [ ] Integration context references actual paths when available

**RPG Method Checks:**
- [ ] Each Capability has at least one Feature defined
- [ ] Each Feature maps to at least one FR-N requirement
- [ ] Module Boundaries define clear exports and single responsibility (medium/complex only)
- [ ] Dependency Graph has Foundation Layer (Phase 0) with no dependencies
- [ ] No circular dependencies between layers (Phase N only depends on Phase < N)
- [ ] Each layer builds on previous layers in topological order
- [ ] DAG validation passed

---

## Mapping Rules

| Design Section | Spec Section |
|----------------|--------------|
| High-level features, domains | Capabilities (WHAT) |
| Goals, Objectives, "Why" | Purpose + Success Criteria |
| Features, User Stories | Requirements (FR-N) |
| "Phase 1", "MVP", explicit scope | IN SCOPE; rest -> OUT OF SCOPE |
| Technical Design, Architecture | Integration Context + Module Boundaries (HOW) |
| Code organization, file structure | Module Boundaries |
| Sequencing, Dependencies | Dependency Graph (with phases) |
| Risks, Challenges, Edge Cases | Risk Areas |
| Testing Notes | Test Strategy |

---

## Implementation Signals Guide

The implementation signals help the scaffold command determine how to break down requirements into tasks and whether TDD is needed.

**Check "Contains conditional logic or branching" when**:
- Threshold checks or boundary conditions
- If/else paths based on data
- Validation with multiple outcomes

**Check "Involves state transitions" when**:
- Multi-step cascading behavior
- State machine transitions
- Workflow progression logic

**Check "Pure data structure change" when**:
- Just adding fields to existing structures
- Simple CRUD operations
- Configuration changes

**Check "Has edge cases" when**:
- Boundary conditions exist
- Error handling with recovery
- Rate limits or quotas

**Check "Critical business logic" when**:
- Affects billing, permissions, or security
- Core domain calculations
- Data integrity requirements

Init-spec uses these signals to determine task categories (database/entity/dto/service/controller/e2e-test) and TDD requirements.

---

## Complexity-Based Section Reference

| Section | Simple | Medium | Complex |
|---------|--------|--------|---------|
| Purpose | Yes | Yes | Yes |
| Capabilities | Yes | Yes | Yes |
| Scope | Yes | Yes | Yes |
| Requirements | Yes | Yes | Yes |
| Integration Context | Yes | Yes | Yes |
| Module Boundaries | No | Abbreviated | Full |
| Dependency Graph | Flat list | 2-3 phases | 5 phases |
| Risk Areas | No | Optional | Yes |
| Implementation Hints | No | Optional | Yes |
| Test Strategy | Yes | Yes | Yes |
