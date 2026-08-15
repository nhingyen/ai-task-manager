# Project Structure Standards

Use `snake_case` file and directory names and `PascalCase` types. Organize
new application code by feature, not by a global type directory.

```text
lib/features/tasks/
  presentation/
  domain/
  data/
```

Keep app composition in `lib/app/` and only genuinely cross-feature concerns
in `lib/core/`. Do not create feature folders for future functionality before
that functionality is implemented. All tests live under the root `test/`
directory; never place `*_test.dart` files inside `lib/`. When useful, mirror
the production feature path, for example:

```text
lib/features/tasks/presentation/task_cubit.dart
test/features/tasks/presentation/task_cubit_test.dart
```

Shared integration/widget coverage may remain under `test/`.

Cross-feature imports are limited to necessary domain models or domain
interfaces. Never import another feature's presentation or data layer, and do
not move feature-owned domain models into `core/` merely to share them.

Avoid generic `common`, `utility`, or `service` dumping grounds. A shared file
must have multiple current consumers and no feature-specific ownership.
