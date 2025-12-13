# RPG Spec: add-logout-button

**Generated**: 2025-01-15 | **Source**: docs/plans/logout-design.md | **Complexity**: simple

## Purpose
Add logout button to profile dropdown for secure session termination.
**Success Criteria**: Users can log out from any page; session properly invalidated.

## Capabilities
### Capability: Session Management
#### Feature: User Logout
- **Does**: Terminates session and redirects to login
- **Inputs**: User session, auth token | **Outputs**: Cleared session, redirect
- **Key Behavior**: Invalidates server session, clears client tokens
-> **Maps to**: FR-1 | **Implements in**: `src/modules/auth/auth.service.ts`

## Scope
**IN**: Logout button, session invalidation, token cleanup, redirect
**OUT**: Remember me, multi-device sessions, confirmation dialog

## Requirements
### FR-1: Session Termination
**Priority**: P1
**Description**: System SHALL invalidate session when logout triggered.
**Acceptance**: Given user clicks logout -> session invalidated, redirected to login, tokens cleared
**Signals**: [x] State transitions

## Integration
**Services**: AuthService (`src/modules/auth/auth.service.ts`)
**API**: POST /api/auth/logout (new)
**Database**: None

## Dependency Graph (flat)
1. logout-endpoint -> 2. dropdown-button -> 3. e2e-test

## Test Strategy
**Unit**: `AuthService.logout()` - verify invalidation
**E2E**: Logout -> redirect -> protected routes blocked
