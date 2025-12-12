---
name: feature-schema
description: feature_list.json schema and examples for autonomous feature development. Use when creating feature task lists.
---

# Feature List Schema

## Top-Level Structure

```json
{
  "featureName": "string",           // kebab-case feature name
  "projectResources": {              // Optional: detected project agents/skills
    "agents": {
      "agent-name": "description"
    },
    "skills": {
      "skill-name": "description"
    }
  },
  "tasks": [...]                     // Array of task objects
}
```

## Task Schema

```json
{
  "id": number,
  "category": "database" | "entity" | "dto" | "service" | "controller" | "e2e-test",
  "description": "What this task implements",
  "delegateTo": "agent-name",  // Optional: project agent to use for implementation
  "skills": ["skill-name"],    // Optional: project skills to load
  "tdd": boolean,              // Include for service tasks with complex logic
  "testCriteria": string[],    // Include when tdd is true
  "existing_patterns": ["path/to/similar/code.ts"],
  "reuse": ["ExistingService", "sharedUtil"],
  "steps": ["Step 1", "Step 2", "..."],
  "passes": false
}
```

### Delegation Fields

- **`delegateTo`** (optional): Name of a project-specific agent to handle this task. If not set, the built-in `general-purpose` agent is used.
- **`skills`** (optional): Array of project skill names to load for this task. These are passed to the implementing agent.

## Example: Simple Task (no TDD, with delegation)

Database migrations and structural changes don't need TDD.

```json
{
  "id": 1,
  "category": "database",
  "description": "Create migration to add user_preferences columns",
  "delegateTo": "backend",
  "existing_patterns": ["backend/main/src/migrations/"],
  "reuse": [],
  "steps": [
    "Step 1: Run migration:create command",
    "Step 2: Implement up() with ALTER TABLE",
    "Step 3: Implement down() to reverse changes",
    "Step 4: Run migrate and verify columns exist"
  ],
  "passes": false
}
```

## Example: Complex Task (with TDD and skills)

Service tasks with complex logic should use TDD.

```json
{
  "id": 4,
  "category": "service",
  "description": "Implement autoExtendIfNeeded() with cascade logic (3m → 6m → 1y)",
  "delegateTo": "backend",
  "skills": ["nestjs-patterns"],
  "tdd": true,
  "testCriteria": [
    "Returns false when mentionsFetched >= 50 (threshold met)",
    "Returns false when secondary query not configured",
    "Triggers 3-month extension when mentionsFetched < 50",
    "Stops cascade when threshold reached after any extension",
    "Cascades to 6-month if 3-month doesn't reach threshold",
    "Cascades to 1-year (max) if 6-month doesn't reach threshold",
    "Sets autoExtendedTime=true and autoExtendedTimeRange on completion",
    "Updates currentStage to 'auto_extending' during processing",
    "Handles errors gracefully without throwing"
  ],
  "existing_patterns": [
    "backend/main/src/social-listening-v2/services/extended-time.service.ts"
  ],
  "reuse": [
    "calculateExtendedStartDate()",
    "processSegmentExtendedTime()",
    "MentionFetchOrchestrationService"
  ],
  "steps": [
    "Step 1: Create test file with tests for all testCriteria items",
    "Step 2: Run tests to verify they fail (RED phase)",
    "Step 3: Implement minimal code to pass first test",
    "Step 4: Iterate: add next test, make it pass",
    "Step 5: Refactor while keeping all tests green"
  ],
  "passes": false
}
```

## Example: E2E Test Task (one per feature)

Exactly one e2e-test task at the end of the feature.

```json
{
  "id": 7,
  "category": "e2e-test",
  "description": "E2E test: verify complete auto-extend flow from segment creation",
  "delegateTo": "e2e-runner",
  "skills": ["api-testing"],
  "existing_patterns": [
    "backend/main/src/social-listening-v2/__tests__/e2e/extended-time.spec.ts"
  ],
  "reuse": ["createTestApp", "TestAppContext", "API fixtures"],
  "steps": [
    "Step 1: Create e2e test file",
    "Step 2: Set up test module with mocked services",
    "Step 3: Test happy path: segment with auto-extension triggered",
    "Step 4: Test edge cases: threshold already met, max range reached",
    "Step 5: Verify response includes autoExtendedTime fields",
    "Step 6: Run e2e tests and verify all pass"
  ],
  "passes": false
}
```

## Requirements Checklist

When creating feature_list.json:

- [ ] Order tasks by dependency: database → entity → dto → service → controller → e2e-test
- [ ] Use only the six allowed categories (no "functional", "integration", "types", "test")
- [ ] For `service` tasks with complex logic: include `tdd: true` and `testCriteria`
- [ ] Include exactly ONE `e2e-test` task at the end
- [ ] Include `existing_patterns` pointing to similar code in the codebase
- [ ] Include `reuse` listing services/components to leverage
- [ ] All tasks start with `"passes": false`
- [ ] Tasks can only be marked as passing, never removed or edited
