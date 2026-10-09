# PersonalOS

**A local-first personal development system for planning, tracking, and understanding progress.**

PersonalOS is an Android application project built around the idea of bringing daily planning, goals, tasks, activity tracking, and long-term self-improvement into one coherent workspace. Its product direction combines game-like progression with evidence-based measurement, so progress can feel motivating without pretending that a single score defines a person.

> **Project status:** Early Android foundation with product and architecture specifications. The documentation describes the intended system; it does not mean every planned feature is implemented yet.

## Product vision

Personal development data is often scattered across separate task managers, habit trackers, fitness apps, notes, calendars, and spreadsheets. PersonalOS aims to connect intentions, actions, and outcomes so users can answer:

- What matters today?
- What have I actually completed?
- Am I moving toward my goals?
- What patterns or constraints are affecting my progress?
- What is a useful next step, given my time and priorities?

The core loop is:

**Plan → Act → Record → Validate → Reflect → Adjust**

## Planned capabilities

The roadmap is staged. These are product goals, not a claim that every capability is already available.

| Area | Direction |
| --- | --- |
| Today and daily planning | Review priorities, schedule tasks, track planned versus actual time, and reflect on the day |
| Goals and milestones | Break longer-term goals into manageable steps and link them to relevant tasks or activities |
| Character and progression | Represent progress through attributes, levels, and explainable XP rules |
| Activity history | Keep a traceable record of meaningful actions and outcomes |
| Personal tracking | Gradually support fitness, nutrition, sleep, academics, coding and skills, music, finance, time, and discipline |
| Analytics | Review trends, consistency, goal progress, and comparisons with earlier periods |
| Recommendations | Begin with deterministic suggestions; consider an optional AI coach with clear evidence and uncertainty |
| Data ownership | Prioritize local storage, offline use, export, correction, and deletion |

## Design principles

- **Local-first:** Core workflows should work without a network connection.
- **Evidence over invented certainty:** Separate stored facts, deterministic calculations, patterns, and hypotheses.
- **User control:** Suggestions remain proposals; important changes require confirmation.
- **Explainable progression:** XP and levels should come from traceable rules and validated activity, not arbitrary AI output.
- **Incremental delivery:** Establish reliable persistence and core workflows before advanced tracking or AI features.
- **Privacy by default:** Minimize sensitive data and make integrations optional.

## Technical direction

The current repository contains an Android application foundation using:

- **Kotlin**
- **Android SDK**
- **Jetpack Compose**
- **Material 3**
- **Gradle Kotlin DSL**

The architecture documents propose **Room over SQLite** for local persistence, a ViewModel-oriented presentation layer, domain use cases, validated event processing, and a deterministic progression engine. These are target design decisions and should be introduced as the implementation grows. Cloud sync, external integrations, and AI are not prerequisites for the core product.

## Getting started

### Requirements

- Android Studio
- A compatible Android SDK
- An Android emulator or physical device

### Open the project

1. Clone the repository:

   ```bash
   git clone https://github.com/Jofil-Joby/PersonalOS.git
   cd PersonalOS
   ```

2. Open the project directory in Android Studio.
3. Allow Gradle to sync.
4. Select an emulator or connected Android device.
5. Run the `app` configuration.

Build availability depends on the installed Android SDK and Gradle environment. The repository's documented product roadmap is not a guarantee that every planned workflow is currently runnable.

## Documentation

The `docs/` directory contains the detailed product and engineering plan:

1. [MVP Definition](docs/01_MVP_Definition.md)  
   Product vision, principles, user journeys, feature scope, and success criteria.
2. [Database Architecture](docs/02_Database_Architecture.md)  
   Target data model, relationships, integrity rules, progression ledger, and migration strategy.
3. [System Architecture](docs/03_System_Architecture.md)  
   Proposed presentation, domain, data, event-processing, planning, analytics, and AI responsibilities.
4. [Feature Implementation Map](docs/04_Feature_Implementation_Map.md)  
   Feature dependencies, delivery stages, and readiness criteria.
5. [Development Roadmap](docs/05_Development_Roadmap.md)  
   Phased implementation plan, testing expectations, and definition of done.

These documents are specifications and planning references. As implementation changes, the README and documentation should be updated to distinguish shipped functionality from planned work.

## Current implementation focus

The recommended first implementation slice is deliberately small:

1. Verify a clean Android build and test setup.
2. Establish local persistence and schema migration tests.
3. Implement the profile, character, attributes, goals, and tasks needed for a basic workflow.
4. Connect task completion to a validated event and an explainable XP transaction.
5. Build a usable Today-to-task-completion journey before expanding into every tracking domain.

## Privacy and safety

PersonalOS is intended to keep core personal records under the user's control. Sensitive health and financial information should not be sent to external services without a clear purpose and explicit user control. Any future AI coach should be advisory, explain its evidence, and avoid presenting correlations as causes or replacing professional advice.

## Roadmap

- [ ] Verify the Android foundation and test setup
- [ ] Implement local persistence and migrations
- [ ] Build core profile, goals, milestones, and tasks
- [ ] Add validated events and deterministic XP processing
- [ ] Implement Today and daily planning
- [ ] Add foundational tracking and history
- [ ] Expand analytics and challenges
- [ ] Evaluate optional integrations and AI recommendations
- [ ] Complete privacy, accessibility, reliability, and release checks

## About

PersonalOS is developed by [Jofil Joby](https://github.com/Jofil-Joby).

- [GitHub profile and other projects](https://github.com/Jofil-Joby?tab=repositories)
- [Aster](https://github.com/Jofil-Joby/Aster)
- [Junex](https://github.com/Jofil-Joby/Junex)
- [Real-Time Leaderboard](https://github.com/Jofil-Joby/Real-Time-Leaderboard)

## License

Check the repository for the applicable license before redistributing or reusing the project.
