# PersonalOS — Development Roadmap

**Version:** 2.0  
**Status:** Proposed implementation plan

This roadmap describes intended work. Phase status should be updated only after inspecting the repository and verifying acceptance criteria.

## 1. Development strategy

Build PersonalOS through vertical slices backed by stable foundations. Do not wait until every engine exists before building a usable screen, and do not polish screens that depend on business rules that have not been implemented.

Principles:
- Keep core behavior local-first and offline.
- Make event processing, XP, and goal progress deterministic and testable.
- Deliver a real user journey at each milestone.
- Implement all tracking domains over time without flattening them into one generic schema.
- Add AI and integrations after reliable data exists.
- Treat migration, export, deletion, and error handling as product requirements.
- Distinguish planned, implemented, and verified work honestly.

## 2. Phase overview

| Phase | Focus | Outcome |
|---|---|---|
| 0 | Product and technical decisions | Coherent specification and known open decisions |
| 1 | Android foundation | Stable package, dependency wiring, build and test setup |
| 2 | Core local data | Profile, character, attributes, goals, milestones, tasks |
| 3 | Event and progression engine | Validated events, XP ledger, levels and attribute history |
| 4 | First vertical slice and Today | Goal-to-task-to-event-to-progression journey |
| 5 | Daily planning | Plans, schedules, rescheduling, plan-versus-actual |
| 6 | Foundational tracking | Manual Body, Nutrition, Sleep and shared patterns |
| 7 | Remaining tracking | Academic, Coding/Skills, Music, Finance, Time, Discipline |
| 8 | Analytics | Historical summaries, trends, records, careful correlations |
| 9 | Challenges | Missions, tests, streaks, experiments, later boss challenges |
| 10 | Recommendations and AI | Evidence-aware recommendations and reviews |
| 11 | Integrations | Health, usage, calendar, GitHub, optional finance/wearables |
| 12 | Reliability and release | Migrations, export/delete, accessibility, performance, beta |
| 13 | Advanced extensions | AI memory, local AI, prediction, visual evolution, optional cloud |

Phases are dependency guidance, not a claim that each phase has equal size or must be completed in one uninterrupted block.

## Phase 0 — Product and technical decisions

Tasks:
- review all five documents together
- choose one application namespace/package root
- define the first data model and progression invariants
- choose initial manual tracking workflows
- establish repository conventions and definition of done
- identify sensitive data and future permission boundaries

Acceptance:
- the core user journey is clear
- unresolved decisions are documented
- the five documents agree on scope and terminology

## Phase 1 — Android foundation

Tasks:
1. Verify the Gradle project and build configuration.
2. Choose one package namespace and reconcile conflicting package paths.
3. Confirm compatibility of Kotlin, Android Gradle Plugin, Compose, Room, KSP, coroutines, and lifecycle dependencies.
4. Establish Application/dependency wiring appropriate to project size.
5. Set up navigation and a minimal app shell.
6. Configure unit and instrumented tests.
7. Add lint/static checks where practical.
8. Verify a clean debug build.

Acceptance:
- clean checkout builds
- app launches to a real shell rather than only a starter greeting
- package and namespace references are consistent
- tests can run
- no external API key is required to launch

Do not rewrite the whole project to match a folder diagram. Inspect existing code and make the smallest reliable foundation changes.

## Phase 2 — Core local data

Implement incrementally:
1. Room database and converters
2. User and UserPreference
3. Character and Attribute
4. Goal and GoalMilestone
5. Task
6. DAO queries and repository implementations
7. migrations and database tests

Acceptance:
- create/read/update/delete behavior works
- relationships and uniqueness constraints are enforced
- goal hierarchies cannot cycle
- invalid schedule ranges are rejected
- data survives app restarts
- migrations preserve representative existing records

Do not create every future tracking, AI, and integration table at this stage. Add those with their features.

## Phase 3 — Event and progression engine

Tasks:
1. Define stable event types, categories, sources, and validation outcomes.
2. Implement event creation and domain validation.
3. Add duplicate detection and idempotency keys.
4. Implement deterministic XP rules and versioning.
5. Implement level-threshold calculations.
6. Map eligible events to attributes.
7. Record immutable XP transactions and progression history.
8. Update current projections transactionally.
9. Add reconciliation checks.

Tests:
- valid input produces the expected event
- invalid units/durations are rejected or flagged by policy
- repeated processing does not duplicate XP
- suspicious events remain inspectable but are not rewarded improperly
- known inputs produce expected XP
- level boundaries behave correctly
- ledger totals reconcile with current state
- failed transactions leave no partial progression

Acceptance: a user can record one supported activity and inspect exactly how it changed progression and why.

## Phase 4 — First vertical slice and Today

Build a narrow but complete journey:
- local profile
- create a goal
- create a task linked to the goal
- show tasks on Today
- complete a task
- create one event idempotently
- apply eligible progression
- show updated character/attribute state
- display empty, loading, and error states

Acceptance: the journey works on a device or emulator without network access. The interface is usable enough to validate the product loop before extensive visual polish.

## Phase 5 — Daily planning and task lifecycle

Tasks:
- daily plan and plan items
- task estimates and actual duration
- scheduling/rescheduling
- explainable priority rules
- deadlines and conflict detection
- realistic time budgeting and breaks
- end-of-day review
- plan-versus-actual history

Tests:
- conflicts are identified
- insufficient available time is handled
- completed/cancelled tasks are not accidentally rescheduled
- changed circumstances produce a proposal
- user edits remain authoritative
- date/time-zone boundaries work correctly

Acceptance: PersonalOS can create a useful daily plan and adapt without silently overwriting user choices.

## Phase 6 — Foundational tracking

Implement manual tracking flows for:
1. Body and workouts
2. Nutrition daily summaries
3. Sleep

For each domain: define data/units, validate inputs, persist records, connect relevant activity to normalized events, define progression eligibility, add basic history, and test invalid/missing values, date boundaries, and duplicate operations.

Acceptance: each domain works independently and offline, and records remain useful without AI.

## Phase 7 — Remaining tracking domains

Implement:
1. Academic: assignments, exams, study sessions, progress and optional scores.
2. Coding and skills: skill identity, practice history, projects, learning goals, optional GitHub import later.
3. Music: practice sessions, pieces, techniques and progression.
4. Finance: income, expenses, budgets, subscriptions, savings and financial goals.
5. Time and Discipline: planning adherence, consistency and clearly defined metrics.

Reuse shared patterns without flattening domain data. Apply extra care to financial information.

Acceptance:
- records can be created, corrected, queried and summarized
- units/calculations are consistent
- the same achievement is not double-counted
- missing data is represented honestly
- history survives edits and restarts

## Phase 8 — Analytics and “You vs Old You”

Tasks:
- daily, weekly, monthly and longer-period summaries
- goal and attribute progression charts
- consistency and personal records
- plan-versus-actual analysis
- comparisons for yesterday, 7 days, 30 days, 90 days, year, and custom ranges
- data coverage indicators
- optional correlations and bottleneck analysis

Tests:
- known datasets produce expected summaries
- empty periods and missing observations are handled
- period length is normalized where appropriate
- sample size and limitations accompany correlations
- sparse data does not produce strong conclusions
- correlation is not presented as causation

Acceptance: the app answers “Am I making progress?” with traceable measures and honest uncertainty.

## Phase 9 — Challenges and advanced progression

Tasks:
- daily and weekly missions
- domain-specific skill tests
- streaks and consistency challenges
- prerequisites and rewards
- failure and recovery handling
- adaptive difficulty after a stable baseline
- experiments with explicit hypotheses and outcome measures
- boss-style challenges as a later extension

Acceptance:
- state transitions are deterministic
- rewards cannot be claimed repeatedly
- failure does not erase history
- difficulty changes are explainable
- rest is not automatically treated as failure

## Phase 10 — Recommendation engine and AI coach

Start with deterministic recommendations, then add AI behind a defined interface.

Tasks:
1. Build a relevant-context selector.
2. Implement deterministic rules for deadlines, overload, and next actions.
3. Define recommendation data and statuses.
4. Add AI explanations and weekly summaries where useful.
5. Label confidence and distinguish fact, likely pattern, and hypothesis.
6. Record acceptance, modification, rejection, and outcomes.
7. Require confirmation for consequential changes.
8. Add provider failure, timeout, and offline fallback behavior.

Tests:
- context excludes unrelated sensitive data
- reasons refer to available evidence
- insufficient data produces cautious output
- overloaded users are not given impossible plans
- important targets are not silently changed
- provider failure does not break core tracking

Acceptance: recommendations can be inspected, dismissed, and evaluated later; AI is useful but never required for core behavior.

## Phase 11 — Integrations and automation

Potential order:
1. Health Connect
2. Calendar
3. UsageStatsManager
4. GitHub
5. Finance providers and wearables when justified

For every connector:
- explain the data and purpose
- request permission only when needed
- handle denial and revocation
- normalize units and timestamps
- retain source identifiers
- prevent duplicate imports
- support partial and repeated sync
- expose last-sync and disconnect behavior
- define deletion of imported data

WorkManager can run deferrable imports and summaries. Do not promise exact execution times or rely on background work for immediate actions.

Acceptance: repeated imports are safe, manual records remain intact, and core features work without the integration.

## Phase 12 — Reliability, privacy, and release hardening

Tasks:
- migration coverage
- export/import validation
- deletion behavior
- secure handling of sensitive information
- accessibility and adaptive layouts
- loading/error/empty states
- crash/performance checks
- battery-impact review
- offline testing
- notification controls
- privacy review and clear data explanations
- beta feedback and fixes

Acceptance: users can understand stored data, recover/export it, delete it, and use core functions reliably.

## Phase 13 — Advanced extensions

Potential work:
- structured AI memory
- encrypted backup and multi-device sync
- local/on-device AI
- predictive models
- character visual evolution
- richer experiments and adaptive challenges
- advanced integrations
- optional social/public features after separate privacy and abuse review

Each extension needs a concrete user benefit, privacy assessment, fallback behavior, and measurable acceptance criteria. Do not add cloud infrastructure merely because a remote layer appears in an architecture diagram.

## 3. Cross-phase quality gates

Every phase addresses persistence and integrity, offline behavior, error recovery, tests, migration implications, accessibility, privacy/permissions, and updated documentation/status.

## 4. Definition of done

A phase is complete only when:
1. behavior is implemented
2. acceptance criteria pass
3. edge cases are handled
4. data persists correctly
5. errors are visible and recoverable
6. automated tests cover important rules
7. privacy/permission behavior is correct
8. promised offline/network behavior works
9. the next phase can safely build on it
10. documentation and repository status match reality

## 5. Recommended immediate target

After reviewing these documents, inspect the existing Android project before structural changes.

First implementation slice:
1. standardize namespace/package structure
2. verify clean build and test setup
3. create minimal Room foundation
4. implement User, Character, Attribute, Goal, and Task
5. build a usable Today-to-task-completion journey
6. add Event and XP processing with tests before broadening tracking

This is the first coding slice, not a limit on PersonalOS's eventual scope.
