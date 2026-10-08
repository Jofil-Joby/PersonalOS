# PersonalOS â€” System Architecture
Version: 1.0

## 1. High-level architecture

Compose UI
â†’ ViewModel
â†’ Use Case
â†’ Repository
â†’ Local/Remote Data Source

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
â”œâ”€â”€ core
â”‚   â”œâ”€â”€ AppContainer
â”‚   â”œâ”€â”€ di
â”‚   â”œâ”€â”€ common
â”‚   â””â”€â”€ result
â”œâ”€â”€ data
â”‚   â”œâ”€â”€ local
â”‚   â”‚   â”œâ”€â”€ entity
â”‚   â”‚   â”œâ”€â”€ dao
â”‚   â”‚   â”œâ”€â”€ database
â”‚   â”‚   â””â”€â”€ converters
â”‚   â”œâ”€â”€ repository
â”‚   â””â”€â”€ remote
â”œâ”€â”€ domain
â”‚   â”œâ”€â”€ model
â”‚   â”œâ”€â”€ repository
â”‚   â””â”€â”€ usecase
â”œâ”€â”€ features
â”‚   â”œâ”€â”€ home
â”‚   â”œâ”€â”€ character
â”‚   â”œâ”€â”€ goals
â”‚   â”œâ”€â”€ today
â”‚   â”œâ”€â”€ tracking
â”‚   â”œâ”€â”€ progress
â”‚   â””â”€â”€ challenges
â”œâ”€â”€ ai
â”œâ”€â”€ integrations
â””â”€â”€ workers

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
UI â†’ CompleteTaskUseCase â†’ TaskRepository + EventEngine â†’ Room

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
Ã— Difficulty
Ã— Importance
Ã— Quality
Ã— Improvement
Ã— Consistency
Ã— Result
Ã— AI Adjustment

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
WORKOUT â†’ BODY
STUDY â†’ ACADEMIC/KNOWLEDGE
CODING â†’ SKILLS
PIANO â†’ MUSIC
EXPENSE/SAVING â†’ FINANCE
FOCUS/TIME MANAGEMENT â†’ TIME/DISCIPLINE

Some events may affect multiple attributes, but this must be explicitly configured.

## 10. Goal Engine

Goal hierarchy:
Long-term â†’ Yearly â†’ Monthly â†’ Weekly â†’ Daily

Goal progress should be derived from:
- completed tasks
- milestones
- measurable results
- events where applicable

Priority:
Importance Ã— Urgency Ã— Impact Ã— Deadline factor Ã— Difficulty/readiness factor

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
Impact Ã— Urgency Ã— Confidence Ã— Relevance Ã— Readiness

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
AI suggests â†’ explains â†’ user confirms â†’ execute.

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
â†’ connector
â†’ raw imported data
â†’ normalization
â†’ local storage
â†’ event creation
â†’ analytics

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
â†’ ViewModel
â†’ Use Case
â†’ Event Engine
â†’ Repository
â†’ Room
â†’ XP/Attribute
â†’ Analytics
â†’ AI Context

Automatic:
Phone/API
â†’ Integration
â†’ Normalizer
â†’ Event/Record
â†’ same pipeline

## 23. Architecture rule

The UI is replaceable.
The data, domain and event-processing system is the foundation.
