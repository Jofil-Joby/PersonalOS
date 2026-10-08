# PersonalOS â€” Database Architecture
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
â”œâ”€â”€ Character
â”œâ”€â”€ Goals
â”œâ”€â”€ Tasks
â”œâ”€â”€ Events
â”œâ”€â”€ XP Transactions
â”œâ”€â”€ Challenges
â”œâ”€â”€ Tracking records
â”œâ”€â”€ AI interactions
â”œâ”€â”€ AI recommendations
â”œâ”€â”€ Daily plans
â”œâ”€â”€ Preferences
â””â”€â”€ Integrations

Character:
â””â”€â”€ Attributes

Attribute:
â””â”€â”€ AttributeHistory

Goal:
â”œâ”€â”€ child Goals
â”œâ”€â”€ Milestones
â””â”€â”€ Tasks

Task:
â””â”€â”€ Events

Event:
â””â”€â”€ XPTransactions

Workout:
â””â”€â”€ ExerciseSets

DailyPlan:
â””â”€â”€ DailyPlanItems

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

â†’ normalization

â†’ raw record/event

â†’ validation

â†’ domain processing

â†’ XP/state updates

â†’ analytics

â†’ AI context

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
Workout â†’ Event â†’ XP Engine â†’ Body Attribute â†’ Character â†’ Analytics â†’ AI
