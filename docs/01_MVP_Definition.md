# PersonalOS — Product Definition and MVP Specification

**Version:** 2.0  
**Status:** Product specification

> This document defines the intended product. It does not claim that these features already exist in the Android codebase.

## 1. Product vision

PersonalOS is a personal operating system for intentional living and measurable self-improvement. It connects daily planning, goals, meaningful activity, personal tracking, progression, analytics, and evidence-aware recommendations in one private workspace.

Its defining philosophy is:

> Build yourself like a character, but measure yourself like a scientist.

The character system makes progress visible and motivating. The measurement system keeps that progress honest. XP, levels, scores, streaks, and AI insights should help users understand their behavior, not become substitutes for real outcomes.

The long-term vision includes body and fitness, nutrition, sleep, academics, coding and skills, music, finance, time management, discipline, goals, challenges, experiments, and intelligent recommendations. These domains should share a common foundation while retaining the specific data and workflows each needs.

## 2. The problem

Personal development is fragmented across task managers, calendars, fitness apps, habit trackers, finance tools, notes, spreadsheets, and learning platforms. These tools record isolated pieces of life but rarely connect intentions to behavior or help users understand progress across time.

PersonalOS aims to help users answer:
1. What matters today?
2. What have I actually done?
3. Am I progressing toward what I care about?
4. What is limiting that progress?
5. What should I do next, given my priorities, time, energy, and evidence?
6. Are recommendations helping, or merely sounding convincing?

The app must reduce maintenance effort. If recording life becomes a second job, the design has failed.

## 3. Product principles

### Action before administration
Common activities should be quick to record. Collect only information that supports a feature, calculation, or useful review.

### Local-first by default
Core planning, tracking, progression, and history should work offline. Cloud services and integrations are optional capabilities, not prerequisites.

### Evidence over invented certainty
Distinguish stored facts, deterministic calculations, statistical associations, and hypotheses. Correlation is not causation. Missing data is not proof of failure.

### User control
The user owns their goals, priorities, schedule, and data. Recommendations are proposals. The app must not silently change important goals, targets, budgets, or plans.

### Meaningful progression
XP should reward meaningful actions, improvement, consistency, learning, and appropriate recovery, not repeated low-value activity or logging volume.

### One coherent system
Tracking modules share common patterns for events, validation, history, progression, and analytics. Domain-specific data must still be modeled properly.

### Build incrementally without shrinking the vision
Delivery is staged so the foundation can be tested before advanced modules depend on it. Deferring a feature does not remove it from the long-term product.

## 4. The core loop

**Plan → Act → Record → Validate → Reflect → Adjust → Repeat**

1. Plan realistic actions around goals and constraints.
2. Act on a task, practice a skill, or complete another meaningful activity.
3. Record the result manually or through an explicitly enabled integration.
4. Validate completeness, duplicates, and implausible values without silently erasing user data.
5. Update relevant history, goal progress, and progression.
6. Recommend a useful next action or plan change, explaining the reason.
7. Learn from outcomes and user feedback.

AI, imports, challenges, and character visuals build on this loop rather than replacing it.

## 5. Primary user journeys

### Plan and complete a day
Open Today, review priorities, select tasks, schedule work, complete or reschedule tasks, record actual duration, and review the day.

### Progress toward a long-term goal
Create a goal, break it into milestones, link tasks and relevant activities, record outcomes, inspect progress, and adjust the plan.

### Record an activity
Choose a domain, enter relevant details, validate and save, create or link a normalized event, update eligible progression, and show what changed and why.

### Understand progress
Choose a date range, view activity and outcome trends, compare with an appropriate earlier period, inspect data coverage, and identify possible bottlenecks.

### Use the coach responsibly
Review a recommendation, inspect evidence and confidence, accept/edit/reject it, confirm consequential changes, and later evaluate whether it helped.

## 6. Product areas

### 6.1 Home and Today
The main workspace should show the date, daily overview, priority tasks, deadlines, task list, optional timeline, planned versus actual duration, current task, progress summary, next-action suggestion when justified, and end-of-day review. It must remain useful without AI or network access.

### 6.2 Profile and character
The profile stores preferences and optional personal settings. The character presents overall progression and configured attributes.

Initial attributes:
- Body
- Knowledge
- Skills
- Academic
- Music
- Finance
- Time
- Discipline

Overall progression is derived from the configured rules rather than duplicated as another attribute. Each attribute may show level, XP, a score where defensible, trend, history, and contributing activity categories. A level is a motivational metric, not a scientific claim about a person's worth or ability.

### 6.3 Goals and milestones
Planning horizons: **Long-term → Yearly → Monthly → Weekly → Daily**.

Goals support parent/child relationships, category, linked attribute, priority, difficulty, deadline, measurable progress, milestones, optional XP rewards, and lifecycle states. The hierarchy is flexible; every goal does not need every intermediate level.

Progress may be manual, milestone-based, task-based, or linked to a measured outcome. Its source must be clear, and the same achievement must not be counted more than once.

### 6.4 Tasks and planning
Tasks support creation, editing, prioritization, scheduling, starting, completion, postponement, cancellation, estimates, actual duration, goal links, and history. Completing a task is not automatically proof that the intended real-world outcome occurred.

### 6.5 Events and activity history
An event is a normalized record of a meaningful action or occurrence. Examples include study sessions, coding, workouts, exercise sets, music practice, sleep, nutrition summaries, expenses, income, task completion, milestones, and recovery.

Events retain source, occurrence time, category, validation state, and relevant details. Domain-specific tables store details that do not belong in the shared event. Corrections must preserve enough history to explain changes in progression.

### 6.6 Tracking domains

| Domain | Intended capabilities |
|---|---|
| Body and fitness | Weight, steps, walking distance, workouts, exercises, sets, reps, load, duration, optional energy and recovery |
| Nutrition | Calories, protein, carbohydrates, fats, optional water, daily targets, weekly consistency; no detailed meal diary initially |
| Sleep | Bedtime, wake time, duration, consistency, optional quality and naps |
| Academic | Assignments, exams, deadlines, preparation, study sessions, progress, weak areas, optional test scores |
| Coding and skills | Practice time, languages, skills, projects, courses, certificates, learning goals, outcomes, optional GitHub activity |
| Music | Practice time, pieces, techniques, skill level, practice goals, consistency, progress |
| Finance | Income, expenses, categories, budgets, subscriptions, savings, financial goals, spending trends |
| Time and discipline | Planned versus actual time, consistency, schedule adherence, focus-related records where supported |
| Challenges and experiments | Time-bounded goals, practice tests, streaks, experiments, adaptive difficulty in later stages |

Modules share entry, validation, history, and analytics patterns without being forced into a generic form that loses domain detail.

### 6.7 Analytics and self-comparison
Support daily, weekly, monthly, 90-day, yearly, and custom intervals when enough data exists. Outputs may include goal progress, attribute history, activity totals, consistency, personal records, improvement/decline, overload, comparisons with prior periods, possible relationships, and data-coverage indicators.

Comparisons must account for different period lengths and missing observations. The app should not shame users for gaps or imply one score captures an entire life.

### 6.8 Recommendation engine and AI coach
Recommendations must remain useful without a remote model. Deterministic rules can identify deadlines, scheduling conflicts, and overload. AI may later summarize context, propose plans, and explain possible patterns.

Planned capabilities include next-action suggestions, daily plans, weekly reviews, bottleneck analysis, workload/recovery awareness, and recommendation feedback.

Confidence labels:
- **Known:** directly supported by stored facts or deterministic calculations.
- **Likely:** supported by a reasonable pattern and sufficient evidence.
- **Hypothesis:** tentative interpretation requiring more evidence.

AI is advisory. Consequential changes require confirmation. It must not invent records or present correlation as causation.

### 6.9 Challenges and progression
Challenges may include daily/weekly missions, skill tests, physical or academic targets, finance goals, streaks, experiments, and later boss-style challenges. Rewards reinforce meaningful effort and improvement. Failure must not erase history or punish legitimate rest.

## 7. XP and progression requirements

XP categories: Action, Consistency, Growth, Challenge, Recovery, Discipline, and Learning.

Rules:
1. XP originates from a validated event or explicit auditable system action.
2. The same event cannot grant the same reward twice.
3. Repeated low-value actions may receive diminishing returns under transparent rules.
4. Suspicious records are flagged or excluded by policy, not silently deleted.
5. Recovery may be rewarded when appropriate to a legitimate plan.
6. Learning XP requires a defined, explainable rule; failure alone does not earn it automatically.
7. Each transaction records source, calculation inputs, rule version, result, and explanation.
8. Level thresholds are versioned and tested.
9. AI cannot freely invent or adjust XP; core progression remains deterministic.

The level curve may become harder over time and later include prestige/mastery. Exact thresholds should be tuned through simulation and real use rather than arbitrary labels.

## 8. Privacy and ownership

- Core features work locally and offline.
- Users can inspect, export, import, and delete data.
- Sensitive integrations are opt-in and explain what is read and why.
- External AI requests disclose what data is sent and include only relevant context.
- Users can disconnect integrations and remove imported data where supported.
- Health and financial details are excluded from unnecessary logs.
- Personal data is not sold.
- Recommendations do not replace professional medical, psychological, or financial advice.

## 9. Delivery stages

The full product vision includes all domains above. Delivery is staged for reliability, not to remove scope.

### Stage 1 — Core usable system
Local profile, Room persistence, character and attributes, goals/milestones/tasks, event validation, deterministic XP and levels, Today, basic planning, initial manual tracking, history/summaries, export/delete, and tests for core rules.

### Stage 2 — Full tracking and analytics
Complete Body, Nutrition, Sleep, Academic, Coding/Skills, Music, Finance, Time, and Discipline workflows; domain-specific history; richer goal progress; comparisons; trends; challenges once progression is validated.

### Stage 3 — Intelligence and automation
Recommendation history, evidence-aware AI coach, weekly reviews, optional Health Connect/calendar/GitHub/screen-time integrations, background work, notifications, widgets, encrypted backup, and advanced intelligence.

## 10. Success criteria

A release must support this journey without data loss:
1. Create a local profile.
2. Create a goal and break it into tasks.
3. Plan a realistic day.
4. Record an activity or complete a task.
5. Inspect the event and any eligible XP transaction.
6. Understand which progression value changed and why.
7. Review progress over time.
8. Correct a record without corrupting history.
9. Export and delete local data.

Quality measures include logging friction, offline capability, calculation correctness, duplicate prevention, migration reliability, crash-free use, recommendation usefulness, and user control over stored data.

## 11. Non-goals

PersonalOS is not initially a social network, public leaderboard, medical diagnostic system, replacement for professional financial advice, detailed meal-by-meal diary, silent goal-changing agent, or a product that requires integrations for basic functionality.

## 12. Related documents

- **02 — Database Architecture:** persistent entities, relationships, and integrity.
- **03 — System Architecture:** runtime responsibilities and data flow.
- **04 — Feature Implementation Map:** feature scope, dependencies, and stages.
- **05 — Development Roadmap:** implementation sequence and acceptance criteria.
