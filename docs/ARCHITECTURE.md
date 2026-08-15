# Architecture

## Scope

AI Task Manager is a local-first Flutter application. The architecture is
feature-first and intentionally small: code is easy to locate, dependencies
are explicit, and new abstractions require a concrete reason.

## Feature boundaries

Each feature owns its presentation, domain, and data code:

```text
lib/
  features/
    <feature>/
      presentation/   pages, widgets, cubits, sealed states
      domain/         pure Dart models and repository interfaces
      data/           persistence entities, data sources, mappings, implementations
  core/               genuinely shared primitives and infrastructure
  app/                composition root, app-wide routing and theme
```

Feature code may depend inward from presentation to domain and from data to
domain. A feature may depend on another feature's domain model or domain
interface only when that dependency is necessary. Features must never import
another feature's presentation or data layer. Domain must not depend on
Flutter, persistence, or serialization. Do not move a feature-owned domain
model into `core/` merely to make sharing easier. Shared code belongs in
`core/` only when it is truly feature-neutral.

## Business logic and dependency injection

For simple CRUD, a Cubit may call a repository interface directly. Add a Use
Case or Domain Service only for meaningful business/AI operations, logic that
spans repositories, or logic that deserves independent reuse and testing.
Start with constructor injection and compose dependencies at the application
boundary. Do not add service locators, code generation, or DI annotations
without demonstrated dependency-graph complexity.

## Persistence boundary

Domain models are pure Dart. Data entities/DTOs contain storage or wire
concerns and explicitly map to and from domain models. Hive, Drift, Isar, JSON
annotations, and serialization code stay in `data/`.

Networking architecture is deferred until networking is required; no Dio,
Retrofit, or network-specific folders are part of the MVP baseline.

## Navigation and restoration

Routes use typed path and query parameters where supported. Primary identity is
represented by stable values such as a task ID. `GoRouter.extra` is not the
source of truth for required screen state. A screen receiving an ID must be
able to reload its data from a repository after recreation or deep linking.

## Readability rules

Prefer small focused files, direct constructors, predictable names, and
explicit interfaces. Avoid legacy `BaseState`, `BaseCubit`,
`BaseCallDataHandler`, `ViewStatus`, and `Nullable<T>` patterns.
