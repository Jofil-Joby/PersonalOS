# PersonalOS â€” MVP Definition
Version: 1.0
Status: Baseline specification

## 1. Product definition

PersonalOS is a personal operating system for measurable self-improvement.

Core philosophy:
> Build yourself like a character, but measure yourself like a scientist.

Core loop:
Track â†’ Analyze â†’ Diagnose â†’ Recommend â†’ Act â†’ Measure â†’ Reward â†’ Adapt â†’ Repeat

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
- 1â€“10: fast
- 11â€“25: moderate
- 26â€“50: difficult
- 51â€“75: very difficult
- 76â€“100: elite
- 100+: prestige/mastery

### Goals
Hierarchy:
Long-term â†’ Yearly â†’ Monthly â†’ Weekly â†’ Daily

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
AI suggests â†’ explains â†’ user edits/accepts â†’ user confirms â†’ system executes.

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
Event â†’ validation â†’ XP â†’ attributes â†’ character â†’ analytics â†’ AI context

### Daily Operating System
V1:
- today view
- task list
- basic timeline
- priorities
- planned vs actual
- current task
- â€œWhat should I do right now?â€
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
- â€œWhat should I do right now?â€
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
