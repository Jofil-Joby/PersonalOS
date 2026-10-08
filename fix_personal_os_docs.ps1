$ErrorActionPreference = "Stop"

New-Item -ItemType Directory -Force docs | Out-Null

@'
# PersonalOS — MVP Definition
Version: 1.0
Status: Baseline specification

## 1. Product definition

PersonalOS is a personal operating system for measurable self-improvement.

Core philosophy:
> Build yourself like a character, but measure yourself like a scientist.

Core loop:
Track → Analyze → Diagnose → Recommend → Act → Measure → Reward → Adapt → Repeat

Primary questions:
1. What am I doing?
2. Am I improving?
3. What is limiting me?
4. What should I do next?
5. Is the recommendation actually helping?

## 2. MVP success criteria

Version 1 is successful when a user can:
- create a profile
- see a character and attributes
- create goals and tasks
- record meaningful activities as events
- receive calculated XP
- level attributes and the overall character
- plan a day
- record core life data
- see historical progress
- compare current performance with past performance
- receive evidence-based basic AI recommendations
- export/delete local data

## 3. V1 scope

### Foundation
- Local-first Room database
- Repository layer
- Domain/use-case layer
- ViewModels
- Compose presentation
- Coroutines
- WorkManager foundation
- deterministic core business logic

### Character
Main attributes:
- Body
- Knowledge
- Skills
- Academic
- Music
- Finance
- Time
- Discipline
- Overall

Each attribute:
- level
- XP
- score
- trend
- history

### XP
Types:
- Action XP
- Consistency XP
- Growth XP
- Challenge XP
- Recovery XP
- Discipline XP

Rules:
- XP comes from validated events/results.
- Repetitive easy activity has diminishing value.
- Duplicate/suspicious events do not generate normal XP.
- Failure can generate learning XP only when the system detects genuine effort plus adaptation.
- Recovery can generate Recovery XP when recovery is appropriate.

Level curve:
- 1–10: fast
- 11–25: moderate
- 26–50: difficult
- 51–75: very difficult
- 76–100: elite
- 100+: prestige/mastery

### Goals
Hierarchy:
Long-term → Yearly → Monthly → Weekly → Daily

Goal capabilities:
- create/edit/archive
- parent/child hierarchy
- category
- linked attribute
- priority
- difficulty
- deadline
- progress
- milestones
- XP reward
- status

Important-goal workflow:
AI suggests → explains → user edits/accepts → user confirms → system executes.

### Tasks
- create
- prioritize
- schedule
- complete
- postpone
- cancel
- estimate duration
- record actual duration
- link to goal
- generate event on meaningful completion

### Events
Every meaningful action is an event.

Examples:
- study
- workout
- coding
- piano
- sleep
- nutrition update
- expense
- task completion
- challenge progress

Event pipeline:
Event → validation → XP → attributes → character → analytics → AI context

### Daily Operating System
V1:
- today view
- task list
- basic timeline
- priorities
- planned vs actual
- current task
- “What should I do right now?”
- end-of-day review

Daily planning inputs:
- goals
- deadlines
- task priority
- current time
- available time
- workload
- recovery
- historical behavior

### Body
V1:
- weight
- steps
- workout
- exercise
- sets
- reps
- weight used
- duration
- optional energy/recovery

### Nutrition
V1 intentionally avoids detailed meal journaling.

Track:
- calories
- protein
- carbohydrates
- fats
- daily targets
- weekly consistency

Postpone:
- meal-by-meal diary
- food photos
- restaurant logging
- automatic meal recommendations

### Sleep
V1:
- bedtime
- wake time
- duration
- consistency
- optional quality
- optional naps

### Academic
- assignments
- deadlines
- exams
- preparation
- study sessions
- progress
- weak areas
- optional test scores

### Coding / Skills
- coding time
- languages/skills
- projects
- courses
- certificates
- practice
- GitHub activity placeholder
- skill level
- learning goals
- progress

### Music
- practice time
- pieces
- techniques
- skill level
- practice goals
- progress
- consistency

### Finance
- income
- expenses
- categories
- budgets
- actual spending
- subscriptions
- savings
- financial goals
- spending trends

V1 may start with manual entry.

### Analytics
- daily/weekly/monthly scores
- attribute progression
- goal progress
- consistency
- personal records
- best/worst periods
- basic trends
- basic correlations
- You vs Old You

Comparison windows:
- yesterday
- 7 days
- 30 days
- 90 days
- custom range

### Basic AI Coach
V1:
- recent-data analysis
- weakness detection
- opportunity detection
- recommendations
- daily plan suggestions
- weekly review
- “What should I do right now?”
- explain why
- basic overload detection

AI confidence:
- Known
- Likely
- Hypothesis

AI must not silently change important targets.

### Privacy
V1:
- local-first
- explicit permissions
- export
- import
- delete
- no sale of personal data

## 4. Explicitly postponed

### V2
- Health Connect automatic imports
- Android Usage Stats automation
- Calendar integration
- GitHub integration
- automatic activity detection
- advanced AI memory
- advanced correlations
- advanced notifications
- widgets
- barcode nutrition scanning
- encrypted cloud backup
- advanced finance integrations
- wearable integrations

### Later
- boss battles
- advanced experiments
- local AI models
- predictive ML
- character visual evolution
- advanced gamification
- public/social features
- large-scale cloud infrastructure

## 5. V1 non-goals

Do not build:
- social network
- comparison leaderboard
- detailed manual journaling system
- class attendance system
- complicated meal diary
- decorative gamification before core functionality
- silent AI goal changes
- unnecessary metrics
'@ | Set-Content -Encoding UTF8 docs/01_MVP_Definition.md

@'
# PersonalOS — Database Architecture
Version: 1.0

## 1. Storage strategy

Primary storage:
- Room
- SQLite
- local-first

Rules:
- Stable IDs.
- Store historical events rather than overwriting history.
- Derived scores can be recalculated.
- XP transactions are immutable.
- Timestamps are stored consistently as epoch milliseconds.
- Sensitive data remains local unless the user explicitly enables an integration/cloud feature.

## 2. Shared conventions

All primary IDs:
- String UUID

Time:
- Long epoch milliseconds

Percentages/scores:
- Double

Counters:
- Int/Long as appropriate

Nullable fields:
- only when the value genuinely may not exist

## 3. User

Purpose: owner/profile.

Fields:
- id: String PK
- name: String
- birthDate: Long?
- createdAt: Long
- updatedAt: Long

Relationships:
- User 1:1 Character
- User 1:N Goal
- User 1:N Task
- User 1:N Event
- User 1:N XPTransaction
- User 1:N Challenge
- User 1:N tracking records

Example:
id=user_uuid
name=Jofil
birthDate=null

## 4. Character

Purpose: overall progression state.

Fields:
- id: String PK
- userId: String FK User
- level: Int
- totalXp: Long
- overallScore: Double
- rank: String
- createdAt: Long
- updatedAt: Long

Constraint:
- one Character per User

## 5. Attribute

Purpose: major progression categories.

Fields:
- id: String PK
- characterId: String FK Character
- type: String/enum
- level: Int
- xp: Long
- score: Double
- createdAt: Long
- updatedAt: Long

Types:
BODY
KNOWLEDGE
SKILLS
ACADEMIC
MUSIC
FINANCE
TIME
DISCIPLINE

Overall is calculated from the character/attributes rather than stored as a separate attribute row.

## 6. AttributeHistory

Purpose: historical snapshots for trend analysis.

Fields:
- id: String PK
- attributeId: String FK Attribute
- timestamp: Long
- level: Int
- xp: Long
- score: Double
- reason: String?

Why:
Current Attribute is state; AttributeHistory preserves the past.

## 7. Goal

Fields:
- id: String PK
- userId: String FK User
- parentGoalId: String? self FK
- name: String
- description: String
- level: String/enum
- category: String
- linkedAttributeType: String?
- priority: Int
- difficulty: Int
- importance: Double
- urgency: Double
- impact: Double
- deadline: Long?
- progress: Double
- status: String/enum
- xpReward: Int
- createdAt: Long
- updatedAt: Long
- completedAt: Long?

Levels:
LONG_TERM
YEARLY
MONTHLY
WEEKLY
DAILY

Statuses:
ACTIVE
COMPLETED
PAUSED
CANCELLED
ARCHIVED

## 8. GoalMilestone

Fields:
- id: String PK
- goalId: String FK Goal
- name: String
- targetValue: Double?
- currentValue: Double?
- orderIndex: Int
- completed: Boolean
- xpReward: Int
- completedAt: Long?

Relationship:
Goal 1:N GoalMilestone

## 9. Task

Fields:
- id: String PK
- userId: String FK User
- goalId: String? FK Goal
- name: String
- description: String?
- category: String
- priority: Int
- difficulty: Int
- estimatedMinutes: Int?
- actualMinutes: Int?
- scheduledStart: Long?
- scheduledEnd: Long?
- deadline: Long?
- status: String/enum
- createdAt: Long
- updatedAt: Long
- completedAt: Long?

Statuses:
PENDING
IN_PROGRESS
COMPLETED
POSTPONED
CANCELLED

## 10. Event

Central normalized activity record.

Fields:
- id: String PK
- userId: String FK User
- type: String/enum
- category: String/enum
- source: String/enum
- timestamp: Long
- durationMinutes: Int?
- difficulty: Double?
- quality: Double?
- result: Double?
- goalId: String? FK Goal
- taskId: String? FK Task
- relatedEntityId: String?
- metadataJson: String?
- validationStatus: String/enum
- createdAt: Long

Types may include:
STUDY
WORKOUT
EXERCISE_SET
CODING
PIANO
SLEEP
NUTRITION
EXPENSE
INCOME
TASK_COMPLETION
GOAL_MILESTONE
CHALLENGE_PROGRESS
RECOVERY
MANUAL_ACTIVITY

Sources:
MANUAL
SYSTEM
HEALTH_CONNECT
USAGE_STATS
CALENDAR
GITHUB
IMPORT
AI

Validation:
VALID
SUSPICIOUS
DUPLICATE
REJECTED

Important:
Raw event remains stored even if later classified as suspicious/rejected.

## 11. XPTransaction

Immutable explanation of XP changes.

Fields:
- id: String PK
- userId: String FK User
- eventId: String? FK Event
- attributeId: String? FK Attribute
- type: String/enum
- baseXp: Double
- difficultyMultiplier: Double
- importanceMultiplier: Double
- qualityMultiplier: Double
- improvementMultiplier: Double
- consistencyMultiplier: Double
- resultMultiplier: Double
- aiAdjustment: Double
- finalXp: Double
- reason: String
- timestamp: Long

Types:
ACTION
CONSISTENCY
GROWTH
CHALLENGE
RECOVERY
DISCIPLINE
LEARNING

## 12. Challenge

Fields:
- id: String PK
- userId: String FK User
- name: String
- description: String
- type: String
- difficulty: Int
- targetJson: String
- startDate: Long
- endDate: Long
- progress: Double
- status: String
- xpReward: Int
- createdAt: Long
- completedAt: Long?

Types:
DAILY
WEEKLY
MONTHLY
SKILL_TEST
PHYSICAL
ACADEMIC
FINANCE
TIME
STREAK
EXPERIMENT
BOSS

Statuses:
AVAILABLE
ACTIVE
COMPLETED
FAILED
EXPIRED
LOCKED

## 13. BodyRecord

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- weightKg: Double?
- steps: Int?
- walkingDistanceKm: Double?
- energy: Double?
- recovery: Double?

## 14. Workout

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- type: String
- durationMinutes: Int
- difficulty: Double?
- performanceScore: Double?
- notes: String?

## 15. ExerciseSet

Fields:
- id: String PK
- workoutId: String FK Workout
- exerciseName: String
- setNumber: Int
- reps: Int
- weightKg: Double?
- durationSeconds: Int?
- completed: Boolean

Workout 1:N ExerciseSet

## 16. NutritionRecord

Fields:
- id: String PK
- userId: String FK User
- date: Long
- calories: Double
- proteinGrams: Double
- carbsGrams: Double
- fatGrams: Double
- waterMl: Double?
- targetCalories: Double?
- targetProteinGrams: Double?
- targetCarbsGrams: Double?
- targetFatGrams: Double?

No individual meal entity in MVP.

## 17. SleepRecord

Fields:
- id: String PK
- userId: String FK User
- sleepStart: Long
- sleepEnd: Long
- durationMinutes: Int
- quality: Double?
- nap: Boolean
- source: String

## 18. AcademicRecord

Fields:
- id: String PK
- userId: String FK User
- type: String
- title: String
- subject: String?
- deadline: Long?
- progress: Double
- score: Double?
- weakAreasJson: String?
- completedAt: Long?

Types:
ASSIGNMENT
EXAM
STUDY_SESSION
PRACTICAL
PROJECT
TEST

## 19. SkillRecord

Fields:
- id: String PK
- userId: String FK User
- skillName: String
- category: String
- level: Double
- practiceMinutes: Int
- projectName: String?
- result: Double?
- timestamp: Long

## 20. MusicRecord

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- practiceMinutes: Int
- piece: String?
- technique: String?
- skillLevel: Double?
- performanceScore: Double?

## 21. FinanceRecord

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- type: String
- category: String
- amount: Double
- description: String?
- source: String
- linkedGoalId: String?

Types:
INCOME
EXPENSE
SAVING
TRANSFER

## 22. Budget

Fields:
- id: String PK
- userId: String FK User
- category: String
- periodStart: Long
- periodEnd: Long
- limitAmount: Double
- createdAt: Long

## 23. DigitalLifeRecord

V2 entity.

Fields:
- id: String PK
- userId: String FK User
- date: Long
- totalScreenMinutes: Int
- productiveMinutes: Int
- unproductiveMinutes: Int
- pickups: Int
- notifications: Int
- appDataJson: String

## 24. AIInteraction

V1/V2 foundation for traceability.

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- type: String
- userMessage: String?
- responseSummary: String?
- recommendationId: String?
- confidence: String?
- accepted: Boolean?
- feedback: String?

## 25. AIRecommendation

Fields:
- id: String PK
- userId: String FK User
- timestamp: Long
- type: String
- title: String
- explanation: String
- priority: Int
- impactScore: Double
- urgencyScore: Double
- confidenceScore: Double
- relevanceScore: Double
- readinessScore: Double
- finalDecisionScore: Double
- status: String
- relatedGoalId: String?
- relatedTaskId: String?

Statuses:
PROPOSED
ACCEPTED
MODIFIED
REJECTED
COMPLETED
EXPIRED

## 26. DailyPlan

Fields:
- id: String PK
- userId: String FK User
- date: Long
- generatedAt: Long
- version: Int
- status: String
- reasoningSummary: String?

## 27. DailyPlanItem

Fields:
- id: String PK
- dailyPlanId: String FK DailyPlan
- taskId: String? FK Task
- startTime: Long?
- endTime: Long?
- orderIndex: Int
- status: String
- plannedMinutes: Int?

## 28. UserPreference

Fields:
- id: String PK
- userId: String FK User
- key: String
- value: String
- updatedAt: Long

Examples:
coach_mode=normal
notifications_enabled=true

## 29. IntegrationConnection

Fields:
- id: String PK
- userId: String FK User
- provider: String
- enabled: Boolean
- permissionState: String
- lastSyncAt: Long?
- metadataJson: String?

## 30. CorrelationResult

Derived/replaceable analytical result.

Fields:
- id: String PK
- userId: String FK User
- metricA: String
- metricB: String
- correlationValue: Double
- sampleSize: Int
- confidence: Double
- generatedAt: Long
- interpretation: String

Must never be treated as causal proof.

## 31. Relationships

User:
├── Character
├── Goals
├── Tasks
├── Events
├── XP Transactions
├── Challenges
├── Tracking records
├── AI interactions
├── AI recommendations
├── Daily plans
├── Preferences
└── Integrations

Character:
└── Attributes

Attribute:
└── AttributeHistory

Goal:
├── child Goals
├── Milestones
└── Tasks

Task:
└── Events

Event:
└── XPTransactions

Workout:
└── ExerciseSets

DailyPlan:
└── DailyPlanItems

## 32. Indexes

Recommended indexes:
- Event(userId, timestamp)
- Event(userId, type, timestamp)
- Goal(userId, status, deadline)
- Task(userId, status, deadline)
- XPTransaction(userId, timestamp)
- AttributeHistory(attributeId, timestamp)
- FinanceRecord(userId, timestamp)
- SleepRecord(userId, sleepStart)
- DailyPlan(userId, date)

## 33. Data lifecycle

Input:
manual/integration

→ normalization

→ raw record/event

→ validation

→ domain processing

→ XP/state updates

→ analytics

→ AI context

Derived values must be recalculable from stored source data.

## 34. Example workout event

type=WORKOUT
category=BODY
source=MANUAL
durationMinutes=80
difficulty=0.8
quality=0.9
result=0.85

Pipeline:
Workout → Event → XP Engine → Body Attribute → Character → Analytics → AI
'@ | Set-Content -Encoding UTF8 docs/02_Database_Architecture.md

@'
# PersonalOS — System Architecture
Version: 1.0

## 1. High-level architecture

Compose UI
→ ViewModel
→ Use Case
→ Repository
→ Local/Remote Data Source

Cross-cutting engines:
- Event Engine
- XP Engine
- Attribute Engine
- Goal Engine
- Planning Engine
- Analytics Engine
- Recommendation Engine
- AI Coach
- Sync/Integration Layer

## 2. Android package architecture

app
├── core
│   ├── AppContainer
│   ├── di
│   ├── common
│   └── result
├── data
│   ├── local
│   │   ├── entity
│   │   ├── dao
│   │   ├── database
│   │   └── converters
│   ├── repository
│   └── remote
├── domain
│   ├── model
│   ├── repository
│   └── usecase
├── features
│   ├── home
│   ├── character
│   ├── goals
│   ├── today
│   ├── tracking
│   ├── progress
│   └── challenges
├── ai
├── integrations
└── workers

## 3. Presentation layer

Responsibilities:
- Compose UI
- screen state
- navigation
- user interaction

Rule:
UI does not directly query Room.

## 4. ViewModel layer

Responsibilities:
- expose StateFlow/UI state
- receive UI actions
- invoke use cases
- handle loading/error/success states

Rule:
ViewModels do not contain large business algorithms.

## 5. Domain layer

Use cases contain business actions.

Core use cases:
- CreateGoal
- CompleteTask
- RecordEvent
- CalculateXp
- ApplyXp
- UpdateAttribute
- UpdateCharacter
- GenerateDailyPlan
- GetNextBestAction
- AnalyzeProgress
- CompareWithOldSelf
- GenerateWeeklyReview
- CreateRecommendation
- ValidateEvent

## 6. Data layer

Room entities represent persistence.

Repositories expose domain-friendly operations.

Example:
UI → CompleteTaskUseCase → TaskRepository + EventEngine → Room

## 7. Event Engine

Purpose:
convert meaningful activity into normalized events.

Input:
activity data

Steps:
1. create event
2. validate event
3. detect duplicate
4. detect suspicious values
5. persist raw event
6. calculate XP eligibility
7. send event to analytics
8. update AI context

## 8. XP Engine

Base model:

Final XP =
Base XP
× Difficulty
× Importance
× Quality
× Improvement
× Consistency
× Result
× AI Adjustment

The multipliers are bounded to avoid extreme inflation.

Anti-farming:
- diminishing returns
- duplicate detection
- suspicious-volume detection
- minimum meaningful result
- daily/category caps where justified

XP must be attributable to an Event or explicit system action.

## 9. Attribute Engine

Event category determines relevant attribute.

Examples:
WORKOUT → BODY
STUDY → ACADEMIC/KNOWLEDGE
CODING → SKILLS
PIANO → MUSIC
EXPENSE/SAVING → FINANCE
FOCUS/TIME MANAGEMENT → TIME/DISCIPLINE

Some events may affect multiple attributes, but this must be explicitly configured.

## 10. Goal Engine

Goal hierarchy:
Long-term → Yearly → Monthly → Weekly → Daily

Goal progress should be derived from:
- completed tasks
- milestones
- measurable results
- events where applicable

Priority:
Importance × Urgency × Impact × Deadline factor × Difficulty/readiness factor

## 11. Daily Planning Engine

Inputs:
- current time
- available time
- active goals
- deadlines
- tasks
- priority
- estimated duration
- workload
- recovery
- historical behavior
- user preferences

Output:
ordered DailyPlanItems.

When the day changes:
1. detect conflict
2. recalculate
3. generate proposal
4. user confirms/modifies
5. update plan

## 12. "What should I do right now?"

Candidate actions:
- due tasks
- high-impact goals
- scheduled tasks
- recovery actions
- important habits/activities

Decision:
Impact × Urgency × Confidence × Relevance × Readiness

High:
interrupt/strong recommendation

Medium:
home recommendation

Low:
silent/background

Principle:
Interrupt only when expected benefit > annoyance.

## 13. Analytics Engine

Inputs:
- events
- goals
- tasks
- tracking records
- XP history
- attribute history

Outputs:
- trends
- averages
- consistency
- records
- progress
- comparisons
- correlations
- bottlenecks

Analytics must preserve distinction between:
- measurement
- association
- hypothesis
- causal claim

## 14. You vs Old You

Comparison windows:
- yesterday
- 7 days
- 30 days
- 90 days
- 1 year
- custom

Metrics:
- study
- coding
- sleep
- exercise
- nutrition consistency
- savings
- screen time when available
- attribute scores
- goal completion
- challenge performance

Output:
- biggest improvement
- biggest decline
- current weakness
- opportunity
- next highest-impact action

## 15. AI Context Builder

AI should not receive an uncontrolled database dump.

Context builder selects:
- profile/preferences
- active goals
- deadlines
- recent events
- relevant historical trends
- current workload
- recovery state
- previous recommendations
- recommendation outcomes

Then creates structured context.

## 16. AI Coach

Capabilities:
- diagnose
- recommend
- plan
- review
- challenge
- experiment
- re-plan

Decision process:
1. Does it matter?
2. Will it improve something important?
3. Is there enough evidence?
4. Is it realistic?
5. Is user overloaded?
6. Has this failed before?
7. Is there a higher-impact action?

AI confidence:
KNOWN / LIKELY / HYPOTHESIS

Important target workflow:
AI suggests → explains → user confirms → execute.

## 17. AI Memory

Store:
- preferences
- successful strategies
- failed strategies
- recurring patterns
- correlations
- strengths
- weaknesses
- experiments
- feedback
- recommendation outcomes

Memory must be structured and auditable rather than blindly storing every conversation.

## 18. Background Work

WorkManager later handles:
- scheduled synchronization
- analytics refresh
- daily review preparation
- weekly review preparation
- imports
- notifications

Workers must be idempotent where possible.

## 19. Integrations

Architecture:
Permission
→ connector
→ raw imported data
→ normalization
→ local storage
→ event creation
→ analytics

Potential:
- Health Connect
- UsageStatsManager
- Calendar Provider
- GitHub API
- finance providers
- wearables

## 20. Privacy

Local-first.

Permission Center should eventually show:
- source
- collected data
- reason
- last sync
- disconnect
- delete imported data

No personal-data sale.

## 21. Error strategy

Each layer should expose controlled errors.

Examples:
- DatabaseError
- ValidationError
- PermissionError
- IntegrationError
- AIError
- NetworkError

Core tracking must continue offline.

## 22. Core data flow

Manual:
User action
→ ViewModel
→ Use Case
→ Event Engine
→ Repository
→ Room
→ XP/Attribute
→ Analytics
→ AI Context

Automatic:
Phone/API
→ Integration
→ Normalizer
→ Event/Record
→ same pipeline

## 23. Architecture rule

The UI is replaceable.
The data, domain and event-processing system is the foundation.
'@ | Set-Content -Encoding UTF8 docs/03_System_Architecture.md

@'
# PersonalOS — Feature → Implementation Map
Version: 1.0

| Feature | Required Data | Android/API | Difficulty | Version | Dependencies |
|---|---|---|---|---|---|
| User profile | User | Room | Easy | MVP | DB |
| Character | Character | Room | Easy | MVP | User |
| Attributes | Attribute/History | Room | Medium | MVP | Character |
| XP | Event/XPTransaction | Kotlin + Room | Medium | MVP | Events |
| Levels | XP | Kotlin | Easy | MVP | XP |
| Goals | Goal/Milestone | Room | Medium | MVP | DB |
| Tasks | Task | Room | Easy | MVP | Goals |
| Event engine | Event | Kotlin + Room | Hard | MVP | DB |
| Daily plan | DailyPlan/Items | Kotlin | Hard | MVP | Tasks/Goals |
| Next action | Tasks/Goals/Analytics | Kotlin + AI | Hard | MVP | Daily plan |
| Body | BodyRecord/Workout/ExerciseSet | Room; Health Connect later | Medium | MVP | Events |
| Nutrition | NutritionRecord | Room | Easy | MVP | Events |
| Sleep | SleepRecord | Room; Health Connect later | Easy | MVP | Events |
| Academic | AcademicRecord | Room | Medium | MVP | Goals/Events |
| Coding | SkillRecord | Room; GitHub later | Medium | MVP | Events |
| Music | MusicRecord | Room | Easy | MVP | Events |
| Finance | FinanceRecord/Budget | Room; provider later | Medium | MVP | Events |
| Analytics | history/events | Kotlin | Hard | MVP | all tracking |
| You vs Old You | history | Kotlin | Medium | MVP | Analytics |
| Weekly review | analytics | Kotlin + AI | Medium | MVP | Analytics |
| Basic AI coach | context/recommendations | AI provider | Hard | MVP | Analytics |
| AI memory | AIInteraction/preferences | Room + AI | Hard | V2 | AI |
| Anti-cheating | Events/history | Kotlin | Hard | MVP | Events |
| Challenges | Challenge/events | Room + AI | Medium | MVP | XP/Goals |
| Notifications | tasks/recommendations | Android Notifications | Medium | V2 | Daily plan |
| Widgets | app state | AppWidget/Glance | Medium | V2 | stable state |
| Health import | health records | Health Connect | Hard | V2 | integration layer |
| Screen time | DigitalLifeRecord | UsageStatsManager | Hard | V2 | permissions |
| Calendar | events | Calendar Provider | Medium | V2 | integration |
| GitHub | coding events | GitHub API | Medium | V2 | integration |
| Barcode nutrition | nutrition | Camera + nutrition API | Hard | V2 | nutrition |
| Cloud backup | DB export | backend/cloud | Hard | Later | security |
| Local AI | AI context | on-device model | Very Hard | Later | AI abstraction |
| Boss battles | Challenge/prerequisites | AI | Hard | Later | challenges |
| Experiments | goals/events/results | AI | Hard | Later | analytics |
| Character evolution | character state | Compose | Medium | Later | character |
| Advanced prediction | history | ML/AI | Very Hard | Later | analytics |

## Feature implementation order

### Core
1. User
2. Character
3. Attribute
4. Event
5. XP
6. Goal
7. Task

### Operating system
8. DailyPlan
9. Next action
10. Tracking
11. Analytics

### Intelligence
12. AI context
13. AI recommendation
14. Weekly review
15. AI memory

### Automation
16. Health
17. Usage Stats
18. Calendar
19. GitHub
20. Notifications
21. Widgets

### Advanced
22. Challenges
23. Experiments
24. Boss battles
25. Cloud
26. Local AI
27. Prediction
28. Visual evolution

## Definition of implementation readiness

A feature is ready to code only when:
- its data is defined
- dependencies are defined
- input/output are known
- failure behavior is known
- test cases are known
- version is assigned
'@ | Set-Content -Encoding UTF8 docs/04_Feature_Implementation_Map.md

@'
# PersonalOS — Development Roadmap
Version: 1.0

## Development rule

Build in dependency order.

Database
→ Events
→ XP
→ Attributes
→ Goals/Tasks
→ Daily OS
→ Tracking
→ Analytics
→ AI
→ Automation
→ Gamification
→ UI polish

Do not build a higher layer on an unstable lower layer.

---

# Phase 0 — Product and technical specification

Status:
COMPLETE after these documents are reviewed.

Deliverables:
- MVP definition
- database architecture
- system architecture
- implementation map
- roadmap

Checkpoint:
No unresolved core data-model decisions.

---

# Phase 1 — Android foundation

Tasks:
1. Android project
2. Application class
3. AppContainer
4. dependency configuration
5. Room
6. KSP
7. Coroutines
8. Lifecycle/ViewModel
9. repository interfaces
10. build verification

Depends on:
Phase 0

Test:
Clean debug build.

Definition of Done:
App compiles with foundation dependencies and no architecture-breaking warnings/errors.

---

# Phase 2 — Room database

Tasks:
1. converters/enums
2. User
3. Character
4. Attribute
5. AttributeHistory
6. Goal
7. GoalMilestone
8. Task
9. Event
10. XPTransaction
11. Challenge
12. DailyPlan
13. DailyPlanItem
14. tracking entities
15. AI entities
16. DAOs
17. AppDatabase
18. database tests

Depends on:
Phase 1

Tests:
- insert/read/update/delete
- foreign keys
- unique constraints
- event history preservation
- XP immutability
- migrations

Checkpoint:
All core entities can be persisted and queried.

---

# Phase 3 — Repository layer

Tasks:
- UserRepository
- CharacterRepository
- AttributeRepository
- GoalRepository
- TaskRepository
- EventRepository
- XPRepository
- ChallengeRepository

Tests:
Repository tests against Room test database.

Checkpoint:
Domain layer can operate without knowing Room details.

---

# Phase 4 — Event engine

Tasks:
1. Event creation
2. validation
3. duplicate detection
4. suspicious-value detection
5. persistence
6. event-to-attribute mapping
7. processing result

Test examples:
- valid workout creates event
- duplicate event is detected
- invalid duration is rejected/flagged
- historical event remains stored

Checkpoint:
A valid event enters the complete processing pipeline.

---

# Phase 5 — XP and character engine

Tasks:
1. base XP
2. multipliers
3. bounded multiplier rules
4. diminishing returns
5. XP transaction
6. level calculation
7. attribute update
8. character update
9. rank

Tests:
- known input produces expected XP
- duplicate event cannot double reward
- level changes at expected thresholds
- XP transaction explains result

Checkpoint:
Event → XP → Attribute → Character works end-to-end.

---

# Phase 6 — Goals and tasks

Tasks:
- goal CRUD
- hierarchy
- milestones
- task CRUD
- priority
- deadline
- completion
- postponement
- goal progress
- task event generation

Tests:
Goal → Task → Completion → Event → XP → Progress

Checkpoint:
A real goal can be broken into actions and measured.

---

# Phase 7 — Daily OS

Tasks:
- Today
- task ordering
- daily plan
- timeline
- planned vs actual
- next action
- rescheduling
- end-of-day review

Tests:
- overdue task
- conflicting tasks
- insufficient available time
- completed task
- changed schedule

Checkpoint:
App can generate and update a useful day.

---

# Phase 8 — Tracking modules

Order:
1. Body
2. Nutrition
3. Sleep
4. Academic
5. Coding
6. Music
7. Finance

For every module:
- data model
- repository
- use case
- event mapping
- validation
- basic analytics

Checkpoint:
Every module produces valid normalized data/events.

---

# Phase 9 — Analytics

Tasks:
- daily aggregates
- weekly aggregates
- monthly aggregates
- attribute history
- trends
- consistency
- personal records
- You vs Old You
- correlation engine
- bottleneck detection

Tests:
- known dataset produces expected aggregate
- empty periods handled
- custom ranges work
- correlations show sample size/confidence
- no causal claims from correlation alone

Checkpoint:
System can answer "Am I becoming better?"

---

# Phase 10 — AI Coach

Tasks:
1. Context builder
2. recommendation model
3. confidence classification
4. prioritization
5. daily recommendation
6. weekly review
7. weakness detection
8. overload detection
9. user confirmation
10. recommendation outcome tracking

Tests:
- AI gets relevant context
- recommendation explains evidence
- important targets require confirmation
- overloaded user is not given an unrealistic plan
- failed recommendation can be learned from

Checkpoint:
AI recommendations are traceable to stored data.

---

# Phase 11 — Automation

Tasks:
- Health Connect
- Usage Stats
- Calendar
- GitHub
- background sync
- normalization
- permission center

For every integration:
Permission → Import → Normalize → Store → Event → Analyze

Tests:
- permission denied
- permission revoked
- duplicate imports
- partial import
- offline mode
- repeated sync

Checkpoint:
Automatic data does not corrupt manual data or duplicate events.

---

# Phase 12 — Challenges and advanced progression

Tasks:
- daily missions
- weekly challenges
- tests
- streaks
- experiments
- boss prerequisites
- failure analysis
- recovery progression
- adaptive difficulty

Checkpoint:
Gamification rewards meaningful improvement rather than raw activity.

---

# Phase 13 — Widgets and notifications

Tasks:
- character
- XP
- goals
- today
- AI recommendation
- challenges
- spending
- sleep
- screen time

Notifications:
- critical
- important
- useful
- silent

Rule:
Interrupt only when expected benefit > annoyance.

Checkpoint:
Widgets and notifications accurately reflect current state.

---

# Phase 14 — Security and reliability

Tasks:
- permission handling
- data export
- data import
- deletion
- encryption where needed
- offline behavior
- crash recovery
- database migration
- backup strategy
- privacy review

Checkpoint:
User can control and recover their data.

---

# Phase 15 — Testing

Unit:
- XP
- levels
- priority
- event validation
- analytics
- recommendation scoring

Integration:
- Room
- repositories
- event pipeline
- WorkManager
- integrations

UI:
- core screens
- navigation
- state restoration
- accessibility

Scenario:
- new user
- normal day
- missed tasks
- overloaded day
- goal completion
- failed challenge
- data import
- permission removal

Checkpoint:
Core system passes automated and manual testing.

---

# Phase 16 — UI/UX polish

Only after functionality is stable.

Tasks:
- visual system
- navigation polish
- charts
- character visuals
- animations
- micro-interactions
- accessibility
- responsive layouts
- dark/light mode

Checkpoint:
Visual polish does not change core business logic.

---

# Phase 17 — Personal beta

Use personally first.

Measure:
- logging friction
- recommendation usefulness
- false recommendations
- XP inflation
- missing data
- crashes
- battery impact
- actual improvement

Then:
Fix → retest → expand beta.

---

# Definition of Done

A phase is not complete because the code compiles.

It is complete when:
1. implementation exists
2. expected behavior works
3. edge cases are handled
4. tests exist
5. data is persistent where required
6. errors are handled
7. dependencies are documented
8. the next phase can safely build on it

---

# Current coding target

After approval of these five documents:

Phase 1:
Room + KSP + Coroutines + ViewModel foundation

Then Phase 2:
Core database schema and DAOs

Do not build feature UI before the core engine is functional.
'@ | Set-Content -Encoding UTF8 docs/05_Development_Roadmap.md

Write-Host ""
Write-Host "PersonalOS specification fixed."
Get-ChildItem docs | Select-Object Name, Length
