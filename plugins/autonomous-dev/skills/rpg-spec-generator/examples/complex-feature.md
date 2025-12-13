# RPG Spec: usage-metrics-export

**Generated**: 2025-01-15 | **Source**: docs/oru-agent/usage-metrics-export/design.md | **Complexity**: complex

## Purpose
Enable users to track usage metrics and export to CSV/JSON/PDF formats.
**Success Criteria**: Dashboard with date filtering; exports complete in <30s for 1yr data.

## Capabilities

### Capability: Metrics Collection
#### Feature: Event Tracking
- **Does**: Captures user activity events | **Inputs**: event type, user ID, timestamp
- **Key Behavior**: Batches events, deduplicates | **Maps to**: FR-1
-> **Implements in**: `src/modules/metrics/metrics-collector.service.ts`

#### Feature: Aggregation Engine
- **Does**: Computes daily/weekly/monthly aggregates
- **Key Behavior**: Scheduled runs, incremental updates | **Maps to**: FR-2
-> **Implements in**: `src/modules/metrics/aggregation.service.ts`

### Capability: Data Export
#### Feature: Export Job Management
- **Does**: Manages async export jobs with progress tracking
- **Key Behavior**: Queues jobs, retry on failure, notifications | **Maps to**: FR-3, FR-4
-> **Implements in**: `src/modules/export/export-job.service.ts`

<!-- Additional capabilities: User Interface (dashboard) - see FR-5 -->

## Scope
**IN**: Event tracking, aggregation, CSV/JSON/PDF export, async jobs, dashboard
**OUT**: Real-time streaming, custom metrics, scheduled exports, third-party integrations

## Requirements

### FR-1: Event Capture
**Priority**: P1 | **Signals**: [x] Pure data change
**Description**: System SHALL capture events with timestamp, user ID, metadata.
**Acceptance**: Event stored and queryable within 5 seconds.

### FR-2: Metric Aggregation
**Priority**: P1 | **Signals**: [x] Conditional logic, [x] Edge cases
**Description**: System SHALL compute daily/weekly/monthly aggregates.
**Acceptance**: Aggregation job produces summaries, handles timezone boundaries.

### FR-3: Async Export Processing
**Priority**: P1 | **Signals**: [x] State transitions, [x] Critical business logic
**Description**: System SHALL process large exports asynchronously with progress.
**Acceptance**: Job ID returned immediately, progress updated, retry on failure.

<!-- Additional requirements: FR-4 (PDF export), FR-5 (Dashboard) -->

## Integration
**Services**: QueueService, StorageService, NotificationService
**API**: GET /api/metrics, POST /api/exports, GET /api/exports/:id/download (all new)
**Database**: metric_events, metric_aggregates, export_jobs (new tables, migration required)

## Module Boundaries

### Module: metrics-collector
- **Responsibility**: Capture and store raw events | **Location**: `src/modules/metrics/`
- **Exports**: MetricsCollectorService, MetricEvent | **Uses**: TypeORM

### Module: export-job
- **Responsibility**: Async job lifecycle | **Location**: `src/modules/export/`
- **Exports**: ExportJobService, ExportJob | **Depends On**: format-transformer
- **Uses**: QueueService, StorageService

<!-- Additional modules: aggregation, format-transformer, metrics-api -->

## Dependency Graph
**Phase 0 (Foundation)**: database-migrations
**Phase 1 (Data)**: metric-event-entity, export-job-entity, dto-definitions
**Phase 2 (Service)**: metrics-collector-service (FR-1), aggregation-service (FR-2), export-job-service (FR-3)
**Phase 3 (API)**: metrics-controller, exports-controller
**Phase 4 (Validation)**: e2e-tests

## Risk Areas
**Business Logic**: Aggregation timezone handling, large dataset streaming, retry state machine
**Integration**: Queue availability fallback, storage quotas, PDF generation performance

## Implementation Hints
**Patterns**: `src/modules/reports/report-generator.service.ts` (async job pattern)
**Reuse**: QueueService (Bull), StorageService, ChartJS wrapper

## Test Strategy
**Unit (TDD)**: AggregationService (timezone edges), ExportJobService (state transitions, retry)
**E2E**: Dashboard -> select range -> export CSV -> download -> verify data
