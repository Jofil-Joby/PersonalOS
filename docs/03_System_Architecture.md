# PersonalOS — System Architecture

**Version:** 2.0  
**Status:** Target architecture  
**Platform:** Android, Kotlin, Jetpack Compose, Room

This document describes the intended architecture. A listed component is planned until it exists in the repository and has been tested.

## 1. Architecture goals

PersonalOS must support multiple tracking domains without turning every screen into an isolated system. The architecture should keep core behavior offline, make event and XP processing deterministic, preserve history, isolate optional AI/integrations, handle failures without corrupting data, and remain testable.

Avoid abstractions with no current use. Add layers when they protect a real boundary, not merely to create more folders.

## 2. High-level flow

**Compose UI → ViewModel → Use Case → Repository interface → Repository implementation → Room or optional external source**

Domain operations may call focused services such as EventProcessor, ProgressionEngine, GoalProgressCalculator, or PlanningEngine. They must not bypass repositories to query Room directly.

Layer responsibilities:
- **Presentation:** rendering, navigation, interaction, UI state.
- **Domain:** business rules, validation, calculations, orchestration.
- **Data:** Room entities, DAOs, mapping, repositories, import persistence.
- **Core/platform:** shared result/error types, clock/dispatcher abstractions where useful, dependency wiring, Android boundaries.
- **AI:** context selection, provider abstraction, safety constraints, explanation.
- **Integrations:** permission-aware connectors and external-data normalization.
- **Background work:** deferrable imports, reminders, and summaries when implemented.

## 3. Suggested package organization

Use one consistent root package that matches the Gradle namespace. Do not mix com.example.personalos and com.jofil.personalOS in the same application.

- core: common types, dependency wiring, navigation
- data/local: entities, DAOs, database, mappers
- data/repository: repository implementations
- domain/model: domain types
- domain/repository: interfaces
- domain/usecase: application operations
- domain/engine: event, progression, planning, analytics
- feature: home, today, goals, character, tracking, progress, settings
- ai: provider abstraction and context builder
- integrations: Health, calendar, GitHub, usage data
- workers: WorkManager jobs when needed

This is a logical organization, not a requirement to create every package immediately. Keep the initial project simple until real complexity justifies additional modules.

## 4. Presentation and ViewModels

Compose UI responsibilities:
- display screens and reusable components
- collect input and render state
- show loading, empty, success, and error states
- support accessibility and adaptive layouts
- delegate actions to ViewModels

Rules:
- UI does not query Room or calculate XP.
- Composables should be stateless where practical.
- Empty data is valid and distinct from an error.
- Consequential operations must not repeat merely because a screen recomposes.
- Screen state should handle configuration changes appropriately.

ViewModels expose StateFlow or equivalent lifecycle-aware state, receive UI actions, invoke use cases, and translate results into presentation state. They must not contain large algorithms, direct SQL, or hidden side effects triggered by rendering.

## 5. Domain and use cases

The domain layer contains product rules and does not depend on Compose or Room details.

Initial use cases may include:
- CreateOrUpdateProfile
- CreateGoal, UpdateGoal, ArchiveGoal
- CreateTask, RescheduleTask, CompleteTask
- RecordActivity, ValidateEvent, ProcessEvent
- CalculateProgressionReward, ApplyProgression
- GetTodayOverview, GenerateDailyPlan, GetNextBestAction
- CalculateGoalProgress, GetProgressSummary, ComparePeriods
- GenerateWeeklyReview
- ExportUserData, DeleteUserData

Do not create a class for every trivial line of code. Use cases should represent meaningful business operations or stable application boundaries.

## 6. Data layer

Room is the local source of truth for core user-created records. The data layer defines entities and DAOs, maps database models to domain models, implements repository interfaces, enforces storage constraints, runs migrations, and exposes query results.

Repositories expose domain-friendly operations rather than DAO details. Network and platform integrations remain separate data sources and are not required for local core operations.

## 7. Event processing

EventProcessor coordinates normalized activity recording; it does not replace domain-specific records.

Expected flow:
1. Receive user action or imported record.
2. Validate required fields and units.
3. Normalize the input and retain its source.
4. Check stable source IDs and duplicate rules.
5. Persist the domain record and normalized event.
6. Determine progression eligibility.
7. Apply deterministic progression rules.
8. Update history and derived state.
9. Return a result for UI and analytics.

Invalid input returns a useful error. Suspicious data is flagged with a reason. Duplicate processing is idempotent. Records are not discarded solely because they are ineligible for XP. Related writes use a transaction where possible.

## 8. Progression engine: XP, levels, attributes

The progression engine is deterministic and independently unit-testable.

Conceptual model:

**final XP = bounded base XP × bounded difficulty × bounded relevance × bounded quality × bounded improvement × bounded consistency**

Not every event uses every factor. Each factor needs a defined range and meaning. Do not use an unconstrained AI-adjustment multiplier.

Responsibilities:
- determine eligible XP categories
- calculate rewards using versioned rules
- prevent duplicate rewards
- apply diminishing returns where justified
- calculate level thresholds
- update attribute and character projections
- write auditable XP transactions and progression history
- reconcile ledger totals with current projections

Example mappings:
- WORKOUT → Body
- STUDY → Academic and/or Knowledge according to explicit rules
- CODING → Skills
- MUSIC_PRACTICE → Music
- relevant finance behavior → Finance
- time-planning behavior → Time and/or Discipline under explicit rules

An event affects multiple attributes only when configured. Do not award XP to several categories merely because an event could be associated with them.

Levels, XP, and scores are distinct concepts. Progressive thresholds and later prestige/mastery levels are possible, but the curve must be simulated and tested.

## 9. Goals and tasks

Goal processing handles hierarchy, milestones, status transitions, and progress. Progress may come from manual input, milestones, linked tasks, or measured events. The configured progress mode determines the authoritative source. Prevent double counting when multiple records describe the same achievement.

Task processing handles state transitions, schedules, estimates, actual duration, and completion history. Completing a task may create a normalized event, but only idempotently.

Priority should be explainable. Importance, urgency, impact, deadline, effort, readiness, and available time may inform recommendations, but no opaque formula should silently override user-set priorities.

## 10. Daily planning engine

Inputs:
- local date and time zone
- available time and fixed commitments
- active goals and deadlines
- task priority and duration estimates
- workload and user preferences
- recent plan-versus-actual history
- recovery/rest constraints when provided

Outputs:
- ordered plan items and optional time blocks
- rationale and relevant constraints
- conflicts and tasks that do not fit

Rules:
- preserve fixed commitments and explicit user choices
- avoid accidental overlapping work blocks
- include breaks and realistic transition time where appropriate
- do not fill every minute by default
- propose changes instead of silently rewriting important plans
- treat user edits as authoritative

## 11. “What should I do right now?”

Candidate actions include scheduled/due tasks, high-impact goal actions, tasks that unblock other work, a small next step for an overdue goal, planned recovery, or a break when appropriate.

Consider urgency, relevance, available time, readiness, and confidence. Provide a short reason and allow dismissal, editing, or acceptance.

Interrupt only when the expected benefit justifies the interruption. A home-screen recommendation is preferable to an unnecessary notification.

## 12. Analytics and “You vs Old You”

Inputs include events, domain records, goals, tasks, XP ledger, attribute history, and data coverage.

Outputs may include daily/weekly/monthly summaries, trends, consistency, personal records, goal progress, comparisons across yesterday/7 days/30 days/90 days/year/custom ranges, possible bottlenecks, and correlations.

Rules:
- normalize for period length where appropriate
- show sample size and data coverage
- avoid comparing unlike periods without explanation
- distinguish measurements, associations, and hypotheses
- do not infer causation from correlation
- avoid strong conclusions from sparse data

## 13. AI context builder and coach

AI is optional and must not control core state. The context builder selects only relevant information: preferences, active goals/deadlines, tasks/workload, recent events, relevant trends, user constraints, and prior recommendation outcomes where useful.

Do not send an uncontrolled database dump or unrelated sensitive records.

Planned capabilities include next-action suggestions, daily plans, weekly reviews, bottleneck analysis, possible opportunities, overload detection, and experiments.

Confidence:
- **KNOWN:** direct stored fact or deterministic calculation.
- **LIKELY:** pattern supported by sufficient observations.
- **HYPOTHESIS:** tentative interpretation needing more evidence.

Recommendations must identify their basis and limitations. Users can accept, edit, or reject them. Changes to important goals, targets, schedules, or financial plans require explicit confirmation.

## 14. AI memory and traceability

If AI memory is added, store structured and reviewable information such as explicit preferences, strategies marked useful/unhelpful, recurring patterns with supporting observations, experiments, and feedback.

Do not blindly retain every conversation. Memory should have a source and timestamp, and users should be able to correct or delete it. An inferred preference is not a confirmed fact.

## 15. Integrations and background work

Potential integrations: Health Connect, Android UsageStatsManager, Calendar Provider, GitHub, finance providers, and wearables.

Common flow: permission and explanation → connector → source record → normalization → duplicate check → local persistence → event processing.

Integrations are optional and must handle denied/revoked permissions. Imported data must be distinguishable from manual data.

WorkManager may handle deferrable imports, synchronization, summaries, and reminders. Workers must be idempotent, respect platform constraints, and not assume exact execution times.

## 16. Error handling and reliability

Use controlled errors appropriate to the layer: ValidationError, NotFoundError, ConflictError, StorageError, PermissionError, IntegrationError, AIProviderError, and NetworkError.

- Core tracking continues offline.
- External failures do not erase local records.
- Errors are actionable without exposing secrets or sensitive content.
- Transactions protect related state changes.
- Retries are safe.
- Empty results are distinct from failures.

## 17. Privacy and security

Request permissions only when needed. Explain integration use. Store secrets using secure platform mechanisms or a properly secured backend. Never commit keys or tokens. Minimize AI context and disclose external processing. Support export and deletion. Avoid logging health/financial content. Make integration status, last sync, and disconnection understandable.

## 18. Testing strategy

- **Unit:** validation, XP, levels, goal progress, priority, analytics.
- **Database/repository:** constraints, relations, transactions, migrations, queries.
- **Integration:** event-to-progression pipeline, import idempotency, failure recovery.
- **UI:** primary journeys, empty/error states, accessibility, state restoration.
- **Scenarios:** new user, missed tasks, overloaded day, goal completion, duplicate import, revoked permission, offline use, export, deletion.

Core rules must be testable without launching a screen or calling a remote AI provider.

## 19. End-to-end flows

**Manual activity:** UI → ViewModel → RecordActivity → EventProcessor → Repository → Room → ProgressionEngine → ledger/projections/history → updated UI.

**Task completion:** UI → CompleteTask → validate transition → persist completion/event once → eligible progression → goal progress → updated UI.

**Automatic import:** connector → normalized source record → idempotency check → local persistence → event processing → analytics.

**Recommendation:** local facts/history → context builder → deterministic rules and/or AI → evidence-aware recommendation → user decision → outcome tracking.

## 20. Architecture decision

Keep the core product deterministic, local-first, and testable. Treat AI, integrations, cloud backup, predictive models, and advanced gamification as replaceable extensions. The UI may evolve; stored history and business rules must remain coherent.
