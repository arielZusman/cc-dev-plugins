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

---

## Completed Example

Here's what a filled-in codebase_analysis.md looks like for a typical project:

```markdown
# Codebase Analysis

Last updated: 2025-01-15

## NestJS Backend

### Module Structure
Feature-based modules under `src/modules/`. Each module contains its own controller, service, DTOs, and entities. Shared utilities in `src/common/`.

```
src/
├── modules/
│   ├── auth/           # Authentication module
│   ├── users/          # User management
│   ├── products/       # Product catalog
│   └── orders/         # Order processing
├── common/
│   ├── guards/         # Auth guards
│   ├── interceptors/   # Logging, transform
│   └── pipes/          # Validation pipes
└── config/             # Environment config
```

### Patterns to Follow
- Controllers: Thin controllers, delegate to services. Use `@ApiTags()` for Swagger grouping.
- Services: Business logic here. Constructor injection for dependencies.
- DTOs: class-validator decorators. Separate Create/Update/Response DTOs.
- Database: TypeORM with repository pattern. Entities in `*.entity.ts`.

### Reusable Utilities
- `JwtAuthGuard` - JWT authentication (`src/common/guards/jwt-auth.guard.ts`)
- `RolesGuard` - Role-based access (`src/common/guards/roles.guard.ts`)
- `TransformInterceptor` - Standard response wrapper (`src/common/interceptors/transform.interceptor.ts`)
- `PaginationDto` - Reusable pagination (`src/common/dto/pagination.dto.ts`)

## Angular Frontend

### Component Structure
Standalone components (Angular 17+). Smart/container components in feature folders, presentational components in `shared/`.

```
src/app/
├── features/
│   ├── dashboard/      # Smart components
│   ├── products/
│   └── orders/
├── shared/
│   ├── components/     # Presentational
│   ├── pipes/
│   └── directives/
└── core/
    ├── services/       # Singletons
    └── interceptors/
```

### State Management
Angular Signals for local state. Services with BehaviorSubject for shared state. No NgRx.

### Patterns to Follow
- Components: Standalone with `imports[]`. OnPush change detection.
- Forms: Reactive forms with FormBuilder. Validators in separate files.
- HTTP: HttpClient with interceptors. Error handling in `ErrorInterceptor`.

### Reusable Components
- `DataTableComponent` - Generic table with sorting/pagination (`src/app/shared/components/data-table/`)
- `ConfirmDialogComponent` - Confirmation modal (`src/app/shared/components/confirm-dialog/`)
- `LoadingSpinnerComponent` - Loading indicator (`src/app/shared/components/loading-spinner/`)
- `CurrencyPipe` - Custom currency formatting (`src/app/shared/pipes/currency.pipe.ts`)

## Testing

### Backend Tests
- Unit: Jest with `@nestjs/testing`. Mock repositories with `jest.mock()`. Located alongside source files as `*.spec.ts`.
- E2E: Supertest in `test/*.e2e-spec.ts`. Uses test database with migrations.

### Frontend Tests
- Component: Jest + Angular Testing Library. Located as `*.spec.ts` next to components.
- Playwright: Page object pattern in `e2e/pages/`. Tests in `e2e/tests/`. Run against dev server.
```

---

## How Much Analysis is Enough?

**Minimum viable analysis** should answer:
1. Where do I put new modules/components? (directory structure)
2. What patterns do similar features follow? (at least one example per layer)
3. What can I reuse? (list key utilities/services)
4. How are tests organized? (location and framework)

**Stop when** you can confidently answer: "If I were adding a new CRUD feature, I know exactly which files to create and what patterns to copy."
