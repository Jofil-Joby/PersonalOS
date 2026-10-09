# PersonalOS — Database Architecture

**Version:** 2.0  
**Status:** Target data-model specification  
**Storage:** Android Room over SQLite

This document describes the intended data model, not entities already implemented in the app. Build it incrementally; do not create every table before the corresponding feature needs it.

## 1. Storage principles

1. Local-first storage for core records.
2. Stable UUID string primary keys unless another strategy has a measured benefit.
3. Preserve meaningful events and progression history.
4. Keep derived values reproducible from source data where practical.
5. Define foreign keys, uniqueness, indexes, and deletion behavior deliberately.
6. Apply related event/progression updates transactionally.
7. Provide a Room migration and test for each schema change.
8. Minimize sensitive data and never store API secrets in the database.
9. Use typed columns for frequently queried values; reserve JSON for genuinely flexible metadata.
10. Do not imply cloud backup, multi-device sync, or multi-user support merely because the schema could later accommodate them.

## 2. Conventions

- **IDs:** UUID strings.
- **Timestamps:** epoch milliseconds in UTC.
- **Calendar dates:** explicit local date key such as ISO-8601 text; store a time-zone identifier when day boundaries matter.
- **Durations:** integer seconds or minutes, consistently defined and named.
- **XP:** integer Long values in the persisted ledger.
- **Money:** integer minor units plus ISO currency code; avoid floating-point balances.
- **Scores:** documented scale, meaning, and direction; never convert missing values silently to zero.
- **Enums:** stable string/code values, never ordinal positions.
- **Nullability:** null means unknown, not applicable, or not provided, not zero.
- **Time fields:** distinguish occurrence time from record creation/update time.

A timestamp is an instant; a local date is a calendar concept. Do not use midnight timestamps as an ambiguous substitute for a date.

## 3. Profile and progression

### User
Fields: id (PK), name, birthDate (optional), createdAt, updatedAt.

One User has one Character and many Goals, Tasks, Events, XPTransactions, Challenges, tracking records, plans, preferences, and recommendations. The first release may support one local profile; multi-profile support is not assumed.

### Character
Fields: id (PK), userId (unique FK), level, totalXp, overallScore (optional), rank (optional), progressionRuleVersion, createdAt, updatedAt.

Character state is a current projection. The XP ledger explains how progression was earned.

### Attribute
Fields: id (PK), characterId (FK), type, level, xp, score (optional), progressionRuleVersion, createdAt, updatedAt.

Initial types: BODY, KNOWLEDGE, SKILLS, ACADEMIC, MUSIC, FINANCE, TIME, DISCIPLINE.

Constraint: unique(characterId, type). Overall progression is derived rather than stored as a duplicate OVERALL attribute.

### AttributeHistory
Fields: id (PK), attributeId (FK), timestamp, level, xp, score (optional), reason, sourceEventId (optional), ruleVersion.

Write snapshots after meaningful progression changes or deliberate aggregation intervals, not on every screen render.

## 4. Goals, milestones, and tasks

### Goal
Fields: id (PK), userId (FK), parentGoalId (self-FK, optional), name, description (optional), level, category, linkedAttributeType (optional), priority, difficulty, importance (optional), urgency (optional), impact (optional), deadline (optional), progress, progressMode, status, xpReward (optional), createdAt, updatedAt, completedAt (optional), archivedAt (optional).

Levels: LONG_TERM, YEARLY, MONTHLY, WEEKLY, DAILY.  
Progress modes: MANUAL, MILESTONE, TASKS, MEASURED.  
Statuses: ACTIVE, COMPLETED, PAUSED, CANCELLED, ARCHIVED.

Rules:
- Define the progress range, normally 0–100 for percentage-based goals.
- Parent and child goals must belong to the same user.
- Circular parent relationships are prohibited.
- Completion/archive preserves history.
- The progress mode defines the authoritative source of progress.
- Rewards must not duplicate rewards from the same result.

### GoalMilestone
Fields: id (PK), goalId (FK), name, description (optional), targetValue (optional), currentValue (optional), unit (optional), orderIndex, completed, xpReward (optional), createdAt, completedAt (optional).

Relationship: Goal 1:N GoalMilestone. Completion must be idempotent.

### Task
Fields: id (PK), userId (FK), goalId (optional FK), name, description (optional), category, priority, difficulty (optional), estimatedMinutes (optional), actualMinutes (optional), scheduledStart (optional), scheduledEnd (optional), deadline (optional), status, createdAt, updatedAt, completedAt (optional), cancelledAt (optional).

Statuses: PENDING, IN_PROGRESS, COMPLETED, POSTPONED, CANCELLED.

Rules: scheduled end follows start; durations are positive; rescheduling preserves history; completion can create a TaskCompletion event only once; task completion is not automatically proof of the real-world outcome.

## 5. Event history and XP ledger

### Event
A normalized record of an action or occurrence. Domain tables hold structured details that do not belong in the shared event.

Fields: id (PK), userId (FK), type, category, source, occurredAt, durationSeconds (optional), difficulty (optional), quality (optional), result (optional), goalId (optional FK), taskId (optional FK), relatedEntityType (optional), relatedEntityId (optional), metadataJson (optional), validationStatus, validationReason (optional), createdAt, updatedAt.

Types may include STUDY, WORKOUT, EXERCISE_SET, CODING, MUSIC_PRACTICE, SLEEP, NUTRITION_SUMMARY, EXPENSE, INCOME, TASK_COMPLETION, GOAL_MILESTONE, CHALLENGE_PROGRESS, RECOVERY, and MANUAL_ACTIVITY.

Sources may include MANUAL, SYSTEM, HEALTH_CONNECT, USAGE_STATS, CALENDAR, GITHUB, IMPORT, and AI_PROPOSED. AI-proposed records must be confirmed or explicitly authorized before being treated as observed activity.

Validation statuses: VALID, SUSPICIOUS, DUPLICATE, REJECTED.

Rules:
- Keep flagged source records inspectable unless the user deletes them or another policy requires removal.
- Duplicate events are not eligible for another progression reward.
- Frequently queried domain details belong in typed tables, not metadataJson.
- Imported records should retain source identifiers or idempotency keys.

### XPTransaction
Fields: id (PK), userId (FK), eventId (optional FK), attributeId (optional FK), type, baseXp, calculationJson, finalXp, reason, ruleVersion, idempotencyKey (unique), timestamp.

Types: ACTION, CONSISTENCY, GROWTH, CHALLENGE, RECOVERY, DISCIPLINE, LEARNING.

Rules:
- Ledger entries are append-only in normal operation.
- Corrections use reversal/adjustment entries rather than silent edits.
- Unique idempotency keys prevent repeated rewards.
- XP is deterministic; no unconstrained AI adjustment.
- Internal fractional calculations must have explicit rounding rules; persisted XP is integer.
- Character and attribute totals must be reconcilable with the ledger.

## 6. Challenges

Fields: id (PK), userId (FK), name, description (optional), type, difficulty, targetJson with schema version, startAt, endAt, progress, status, xpReward (optional), createdAt, completedAt (optional).

Types may include DAILY, WEEKLY, MONTHLY, SKILL_TEST, PHYSICAL, ACADEMIC, FINANCE, TIME, STREAK, EXPERIMENT, and later BOSS. Statuses may include AVAILABLE, ACTIVE, COMPLETED, FAILED, EXPIRED, LOCKED. Implement after the core progression model is stable.

## 7. Domain-specific tracking

These are target models. Add each table when its feature is implemented.

### BodyRecord
id, userId, occurredAt, weightKg (optional), steps (optional), walkingDistanceMeters (optional), energyScore (optional), recoveryScore (optional), source.

### Workout and ExerciseSet
Workout: id, userId, occurredAt, type, durationSeconds, difficulty (optional), performanceScore (optional), notes (optional).  
ExerciseSet: id, workoutId (FK), exerciseName, setNumber, reps (optional), loadGrams (optional), durationSeconds (optional), completed.

Relationship: Workout 1:N ExerciseSet. Define load units and conversions in code.

### NutritionRecord
id, userId, localDate, calories (optional), proteinGrams (optional), carbsGrams (optional), fatGrams (optional), waterMl (optional), daily target fields (optional), createdAt, updatedAt.

Use a defined daily aggregation policy. No detailed meal diary is required initially.

### SleepRecord
id, userId, sleepStart, sleepEnd, durationMinutes, quality (optional), isNap, source.

Validate start/end and consistency between interval and duration.

### AcademicRecord
id, userId, type, title, subject (optional), deadline (optional), progress, score (optional), weakAreasJson (optional), completedAt (optional), createdAt, updatedAt.

Types may include ASSIGNMENT, EXAM, STUDY_SESSION, PRACTICAL, PROJECT, TEST.

### Skill and practice history
The product needs stable skill identity plus repeated practice history. A simple SkillRecord may start the feature, but separate Skill and SkillSession entities are preferable when one current record cannot preserve multiple sessions. Fields may include skill name/category/level, practice duration, project, result, occurrence time, and notes.

### MusicRecord
id, userId, occurredAt, practiceMinutes, piece (optional), technique (optional), skillLevel (optional), performanceScore (optional), notes (optional).

### FinanceRecord
id, userId, occurredAt, type, category, amountMinor, currencyCode, description (optional), source, linkedGoalId (optional).

Types: INCOME, EXPENSE, SAVING, TRANSFER. Transfers must not be counted as income/expense unless a report explicitly defines that treatment.

### Budget
id, userId, category, periodStart, periodEnd, limitMinor, currencyCode, createdAt.

Define the date and time-zone semantics for budget periods.

### DigitalLifeRecord (future)
id, userId, localDate, totalScreenMinutes, productiveMinutes (optional), unproductiveMinutes (optional), pickups (optional), notifications (optional), appDataJson (optional), source.

Productive/unproductive classifications must be transparent or user-defined; screen time alone is not a moral score.

## 8. Planning, preferences, and recommendations

### DailyPlan
id, userId, localDate, timeZoneId, generatedAt, version, status, reasoningSummary (optional).

Constraint: unique(userId, localDate, version). Preserve earlier versions when useful for plan-versus-actual analysis.

### DailyPlanItem
id, dailyPlanId (FK), taskId (optional FK), startAt (optional), endAt (optional), orderIndex, status, plannedMinutes (optional).

An item may represent a task or a protected block such as a break. Validate overlapping blocks according to planning rules.

### UserPreference
id, userId (FK), key, value, updatedAt. Constraint: unique(userId, key). Use typed/validated settings where practical rather than storing core business data as arbitrary strings.

### AIRecommendation
id, userId, createdAt, type, title, explanation, priority, confidence, evidenceJson, status, relatedGoalId (optional), relatedTaskId (optional), outcomeFeedback (optional).

Statuses: PROPOSED, ACCEPTED, MODIFIED, REJECTED, COMPLETED, EXPIRED. Define scoring semantics before persisting opaque impact/urgency/relevance/readiness numbers.

### AIInteraction (future traceability)
id, userId, occurredAt, type, userMessage (optional), responseSummary (optional), recommendationId (optional), confidence (optional), accepted (optional), feedback (optional), modelIdentifier (optional).

Store only what is needed for audit and user-facing history. Do not retain full sensitive conversations by default.

### IntegrationConnection (future)
id, userId, provider, enabled, permissionState, lastSyncAt (optional), metadataJson (optional).

Tokens and secrets belong in secure platform storage or a properly secured backend, never as plain text here.

## 9. Derived analytics

### CorrelationResult (optional cache)
id, userId, metricA, metricB, correlationValue, sampleSize, confidence (optional), generatedAt, interpretation (optional), algorithmVersion.

This is replaceable derived data, not source-of-truth data. Show sample size and limitations. Never present correlation as causal proof.

Persist aggregates only when performance or stable snapshots justify it. Prefer recalculation from source records until profiling demonstrates a need for caching.

## 10. Relationships

- User → Character, Goals, Tasks, Events, XPTransactions, Challenges, tracking records, plans, preferences, recommendations, integrations.
- Character → Attributes → AttributeHistory.
- Goal → child Goals, GoalMilestones, Tasks.
- Task → Events → XPTransactions.
- Workout → ExerciseSets.
- DailyPlan → DailyPlanItems.
- AIRecommendation → optional goal/task references.

Use Room relations or explicit repository queries as appropriate. Avoid loading a large nested graph for every screen.

## 11. Indexes and constraints

Recommended indexes:
- Event(userId, occurredAt)
- Event(userId, type, occurredAt)
- Goal(userId, status, deadline)
- Goal(parentGoalId)
- Task(userId, status, deadline)
- Task(goalId, status)
- XPTransaction(userId, timestamp)
- XPTransaction(eventId)
- AttributeHistory(attributeId, timestamp)
- FinanceRecord(userId, occurredAt)
- SleepRecord(userId, sleepStart)
- DailyPlan(userId, localDate)

Important uniqueness constraints include Character(userId), Attribute(characterId, type), UserPreference(userId, key), and XPTransaction(idempotencyKey). Add indexes based on actual query patterns.

## 12. Atomic event-to-progression flow

1. Validate input.
2. Normalize units and source identifiers.
3. Check duplicates and idempotency rules.
4. Persist domain record and event.
5. Determine progression eligibility using deterministic rules.
6. Insert XP ledger entries.
7. Update character/attribute projections and history.
8. Commit related database changes atomically where possible.

If a later step fails, the system must not leave an event rewarded twice or a current XP total that disagrees with its ledger. Cross-transaction flows must be resumable and idempotent.

## 13. Corrections, deletion, and migrations

- Corrections preserve the audit trail required to explain changes.
- XP corrections use reversal/adjustment entries.
- User deletion follows an explicit deletion policy.
- Imported records remain distinguishable from manual records.
- Every schema change increments the Room database version and has a migration path and test.
- Never use destructive migration for user data in production unless the user explicitly chose a reset.

## 14. Implementation order

1. User, Character, Attribute.
2. Goal, GoalMilestone, Task.
3. Event, XPTransaction, AttributeHistory.
4. DailyPlan and DailyPlanItem.
5. Tracking tables alongside each domain.
6. AIRecommendation and AIInteraction when recommendations exist.
7. IntegrationConnection and DigitalLifeRecord when integrations exist.
8. Optional analytics caches only after profiling.

## 15. Example

For an 80-minute workout, Workout stores structured details, Event records the normalized occurrence and source, validation checks fields and duplicates, XPTransaction explains any reward, Attribute/Character projections update, and AttributeHistory records the change. Analytics and recommendations may use this history later.

The database should answer both “What is the current score?” and “Which records and rules produced it?”
