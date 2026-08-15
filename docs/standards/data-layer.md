# Data Layer Standards

The data layer implements repository interfaces declared in the feature's
domain layer. It owns local data sources, persistence entities/DTOs, adapters,
and explicit mapping code.

Domain models remain pure Dart: no Flutter imports, Hive/Drift/Isar types,
serialization methods, JSON annotations, or persistence metadata. Mappers
convert data entities to domain models and convert domain values back before
storage.

The initial product is local-first. Select a persistence technology when the
feature requires it and keep its details behind the repository interface.
Defer Dio, Retrofit, networking clients, and network-specific abstractions
until a real remote integration exists.

Use constructor injection for repositories and data sources. Keep interfaces
small and feature-owned; avoid a global repository registry.
