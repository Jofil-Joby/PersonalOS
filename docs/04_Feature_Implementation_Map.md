# PersonalOS — Feature and Implementation Map

**Version:** 2.0  
**Status:** Planning reference

This map describes intended work, not current implementation status. A row in a document is not evidence that a feature exists in the app.

## 1. Delivery stages

- **Stage 1 — Core usable system:** profile, local storage, character/attributes, goals/tasks, events, XP, Today, initial manual tracking, basic history, export/delete.
- **Stage 2 — Full tracking and analytics:** all tracking domains, richer goal progress, comparisons, trends, correlations with caveats, challenges.
- **Stage 3 — Intelligence and automation:** recommendation history, AI coach, AI memory, integrations, background work, notifications, widgets, backup.
- **Stage 4 — Advanced extensions:** experiments, boss-style challenges, local AI, predictive models, visual character evolution, advanced integrations and optional social features.

Stages sequence implementation; they do not reduce the full PersonalOS vision.

## 2. Feature map

| Feature | Data/models | Implementation area | Dependencies | Stage | Acceptance focus |
|---|---|---|---|---|---|
| Profile/preferences | User, UserPreference | Room, repository, settings UI | DB foundation | 1 | Persist offline and survive restart |
| Character | Character | Progression domain, Compose | Profile, XP rules | 1 | Level and XP agree with ledger |
| Attributes/history | Attribute, AttributeHistory | Domain, Room | Character, event mapping | 1 | Every change has reason and history |
| Goal hierarchy | Goal | Room, use cases, UI | Profile | 1 | Lifecycle works; no parent cycles |
| Milestones | GoalMilestone | Room, goal calculator | Goals | 1 | Completion is idempotent |
| Tasks | Task | Room, use cases, Today UI | Profile, optional goal | 1 | Schedule/complete/postpone/cancel safely |
| Normalized events | Event | Event processor, Room | Profile, domain records | 1 | Source/time/category are retained |
| Event validation | Validation rules | Domain | Event model | 1 | Invalid, suspicious, duplicate behavior defined |
| XP ledger | XPTransaction | Deterministic progression engine | Events | 1 | No duplicate reward for same source event |
| Level progression | Versioned level rules | Domain, character UI | XP ledger | 1 | Threshold boundaries tested |
| Today dashboard | Daily overview | Compose, ViewModel | Tasks, profile | 1 | Useful offline; clear UI states |
| Daily plan | DailyPlan, DailyPlanItem | Planning engine, Room, Compose | Goals/tasks/time | 1 | No accidental overlap; edits respected |
| Next action | Tasks, goals, context | Deterministic recommendation rules | Today, priority | 1 | Explainable, dismissible suggestion |
| Body/fitness | BodyRecord, Workout, ExerciseSet | Room, domain forms, analytics | Events, validation | 1 foundation; 2 full | Units and workout details validated |
| Nutrition | NutritionRecord | Manual entry, Room, analytics | Events, date policy | 1 foundation; 2 full | Daily totals and targets clear |
| Sleep | SleepRecord | Manual entry, Room, analytics | Events, time zones | 1 foundation; 2 full | Start/end/duration validated |
| Academic | AcademicRecord, study events | Domain feature, Room, UI | Goals/tasks/events | 2 | Deadlines, sessions, progress, scores |
| Coding/skills | Skill, practice history | Domain feature, Room, UI | Events/goals | 2 | Skill identity distinct from practice sessions |
| Music | MusicRecord | Domain feature, Room, UI | Events/goals | 2 | Sessions, pieces, techniques and progress |
| Finance | FinanceRecord, Budget | Domain feature, Room, UI | Currency/validation rules | 2 | Correct units and transaction categories |
| Time/discipline | Events, tasks, preferences | Planning and analytics | Daily plan/history | 2 | Metric definitions are explicit |
| History/summaries | Events, tracking records | Query layer, analytics | Tracking modules | 1 basic; 2 full | Missing/empty periods handled |
| You vs Old You | Historical aggregates | Analytics/charts | Sufficient history | 2 | Periods normalized; coverage shown |
| Personal records | Domain history | Analytics | Tracking modules | 2 | Record definitions are repeatable |
| Correlations | CorrelationResult or computed result | Statistics/analytics | Adequate history | 2 | Sample size/limits shown; no causal claims |
| Challenges | Challenge, events, XP ledger | Challenge engine/UI | Stable goals and XP | 2 | Progress and rewards are idempotent |
| AI context builder | Relevant history slices | AI boundary | Local data/privacy policy | 3 | Only relevant authorized context sent |
| AI recommendations | AIRecommendation | AI provider abstraction/domain | Context and rules | 3 | Evidence, confidence, user decision recorded |
| Weekly review | Aggregates/recommendations | Analytics, optional AI | Reliable history | 3 | Facts distinguished from hypotheses |
| AI memory | Structured preferences/outcomes | Local storage/AI | Recommendation history/privacy | 3 | Inspect, correct, delete memory |
| Health Connect | Imported health records | Android adapter | Permissions/normalization | 3 | Revocation, partial data, duplicates handled |
| Screen time | DigitalLifeRecord | UsageStatsManager | Explicit permission | 3 | Missing permission and classifications clear |
| Calendar | External calendar events | Calendar connector | Permission/conflict rules | 3 | Scope clear; user changes respected |
| GitHub | Coding activity imports | API connector | Security/event normalization | 3 | Repeated sync does not duplicate activity |
| Finance integrations | Imported transactions | Provider adapter | Security/currency/consent | 3+ | Scope and reconciliation clear |
| Wearables | Imported measurements | Provider adapters | Provider permissions | 3+ | Source and units retained |
| Notifications | Tasks/plans/recommendations | Android notifications/WorkManager | Stable planning state | 3 | Opt-in, useful frequency, no repeated spam |
| Widgets | Character/Today/goals | App Widgets/Glance | Stable query/state layer | 3 | Safe refresh and privacy |
| Export/import | User-owned records | Serialization/file handling | Schema/version policy | 1 basic; 3 richer | Validated, duplicate-safe, usable export |
| Backup/sync | Local records/backup format | Secure backend/platform storage | Security/conflict policy | 3 | Restore and conflict behavior documented |
| Experiments | Goals/events/outcomes | Experiment workflow/analytics | Baseline data | 4 | Hypothesis, period, outcome, limits retained |
| Boss challenges | Challenge/prerequisites/rewards | Advanced challenge engine | Challenges/progression | 4 | No duplicate reward; history preserved |
| Local AI | Context/provider interface | On-device model adapter | Device/privacy evaluation | 4 | Fallback on unsupported devices |
| Predictive models | History/features/outcomes | Analytics/ML | Sufficient validated data | 4 | Evaluation and uncertainty reported |
| Character evolution | Character/level state | Compose/graphics | Stable progression | 4 | Visual change has defined meaning |
| Social/public features | Explicit public data | Backend/security/UI | Separate privacy/abuse review | Optional future | Not required for personal core |

## 3. Dependency order

**Profile and persistence → goals/tasks → events and validation → XP ledger and attributes → Today planning → domain tracking → analytics → recommendations → automation and advanced features**

This is a dependency guide, not a rule that all UI must wait until every engine is finished. Build thin vertical slices with enough persistence, domain logic, and UI to validate real user journeys.

## 4. Domain-model rules

- Shared events provide common history but do not replace domain-specific tables.
- Tracking modules normalize units and validate before progression.
- Each goal has one declared source of truth for progress.
- XP and level calculations are deterministic and versioned.
- AI output is not a source of truth for measured activity.
- Imported records retain source identifiers for deduplication.
- Analytics are derived from source data until performance justifies caching.
- Every optional integration has a graceful no-permission path.

## 5. Readiness checklist

Before implementing a feature, define:
1. User problem and expected outcome.
2. Data model and ownership.
3. Input fields, units, and validation.
4. Use cases and state transitions.
5. Dependencies and failure behavior.
6. History, correction, and deletion behavior.
7. Empty, loading, error, and success UI states.
8. Offline behavior.
9. Privacy and permission requirements.
10. Unit, database, integration, and UI tests.
11. Acceptance criteria.
12. Delivery stage and deferred items.

The important decisions should be clear enough to build and test. Minor visual details can evolve during UI work.

## 6. Definition of complete

A feature is complete only when implementation exists, primary behavior works end-to-end, data persists where required, validation and edge cases are handled, errors are actionable, tests cover important rules, privacy/permissions are correct, offline/network behavior matches the promise, and documentation reflects reality.

## 7. Status convention

- **Planned:** specified, not started.
- **In progress:** implementation underway.
- **Implemented:** code exists but acceptance checks may remain.
- **Verified:** acceptance criteria and tests pass.
- **Deferred:** intentionally postponed with a reason.

Do not mark a feature implemented because only a schema or UI placeholder exists.
