---
name: tdd-patterns
description: TDD decision patterns for brownfield NestJS projects. Use when creating feature tasks to determine which need tdd:true and testCriteria.
---

# TDD Patterns for Feature Tasks

## Understanding When to Use TDD

Tasks with complex logic benefit from Test-Driven Development because:
- Tests define expected behavior before implementation
- Edge cases are captured upfront
- Refactoring is safer with test coverage

Simple structural changes (migrations, entity fields, DTOs) don't need TDD - they either succeed or fail immediately at runtime. No complex behavior to test.

## Allowed Categories (use only these)

The `category` field must be one of these exact values:

| Category | Description | Use TDD? |
|----------|-------------|----------|
| `database` | Migrations, schema changes | No |
| `entity` | TypeORM/Prisma entity field additions | No |
| `dto` | Request/response DTO classes | No |
| `service` | Business logic methods | **Yes** (when complex) |
| `controller` | API endpoint wiring | No |
| `e2e-test` | Feature integration test | N/A |

**Do not invent other categories.** Categories like "functional", "integration", "types", "test", or "unit-test" are not valid.

## TDD Decision Checklist

Before creating each `service` task, evaluate:

1. **Complex logic?** Does this method have clear inputs/outputs with transformation logic?
   → Set `tdd: true`

2. **Edge cases?** Are there thresholds, boundaries, or conditional paths?
   → Add each to `testCriteria`

3. **Cascading behavior?** Does it involve state transitions or multi-step logic?
   → Set `tdd: true`

4. **Structural change?** Is it just adding fields or wiring?
   → No TDD needed

## Testing Structure Rules

1. **Embed unit testing** directly in `service` tasks using `tdd: true` and `testCriteria`

2. **Create exactly ONE `e2e-test` task** at the end of the feature

3. **Do not create separate test tasks** - no "test" or "unit-test" category tasks

## When to Set tdd: true

Set `tdd: true` for service tasks with:
- Complex business logic with clear inputs/outputs
- Edge cases (thresholds, boundaries, cascades)
- Critical paths (data integrity, error handling)
- Pure functions with transformations
- State machine behavior
- Conditional branching logic

## When NOT to Set tdd: true

Do not set `tdd: true` for:
- Migrations (either work or crash on startup)
- Entity field additions (just data structures)
- DTO additions (just type definitions)
- Simple CRUD / passthrough code
- Controller wiring (thin wrappers)
- Configuration changes
