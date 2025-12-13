---
name: codebase-analysis
description: Codebase analysis patterns for brownfield NestJS + Angular projects. Use when analyzing existing code patterns before creating feature tasks.
---

# Codebase Analysis for Brownfield Projects

## NestJS Backend Analysis

Search for and document:

### 1. Module Organization
```
Glob: src/**/*.module.ts
```
How are modules structured? Feature modules vs shared modules?

### 2. Controller/Service/Repository Patterns
```
Glob: src/**/*.controller.ts
Glob: src/**/*.service.ts
```
What's the typical structure? Thin controllers? Service injection patterns?

### 3. DTOs and Validation
```
Glob: src/**/dto/*.ts
```
How is input validation handled? class-validator decorators?

### 4. Guards, Interceptors, Pipes
```
Grep: @Injectable|@Guard|@Interceptor|@Pipe
```
What middleware patterns exist?

### 5. Database Access
```
Grep: @Entity|@Repository|PrismaService
```
TypeORM, Prisma, or other? Repository pattern?

## Angular Frontend Analysis

Search for and document:

### 1. Component Organization
```
Glob: src/**/*.component.ts
```
Standalone vs NgModule? Smart vs presentational?

### 2. State Management
```
Grep: @ngrx|signal\(|BehaviorSubject
```
NgRx, signals, or services?

### 3. Routing Patterns
```
Glob: src/**/*-routing.module.ts
Glob: src/**/routes.ts
```
Lazy loading? Route guards?

### 4. Form Handling
```
Grep: FormGroup|FormControl|ngModel
```
Reactive vs template-driven?

### 5. HTTP and Error Handling
```
Grep: HttpInterceptor|catchError|ErrorHandler
```
Centralized error handling?

### 6. Shared Components
```
Glob: src/app/shared/**/*.ts
```
What's available for reuse?

## Testing Patterns

### NestJS Tests
```
Glob: src/**/*.spec.ts
Glob: test/**/*.e2e-spec.ts
```

### Angular Tests
```
Glob: src/**/*.spec.ts
```

### Playwright E2E
```
Glob: e2e/**/*.spec.ts
Glob: tests/**/*.spec.ts
```

## Output Template

Write findings to `docs/oru-agent/codebase_analysis.md`:

```markdown
# Codebase Analysis

Last updated: [Date]

## NestJS Backend

### Module Structure
[Describe organization]

### Patterns to Follow
- Controllers: [pattern]
- Services: [pattern]
- DTOs: [pattern]
- Database: [TypeORM/Prisma/etc.]

### Reusable Utilities
- [List services, guards, pipes to reuse]

## Angular Frontend

### Component Structure
[Standalone/NgModule, organization]

### State Management
[NgRx/Signals/Services]

### Patterns to Follow
- Components: [pattern]
- Forms: [reactive/template]
- HTTP: [interceptor patterns]

### Reusable Components
- [List shared components, pipes, directives]

## Testing

### Backend Tests
- Unit: [pattern]
- E2E: [pattern]

### Frontend Tests
- Component: [pattern]
- Playwright: [pattern, page objects]
```
