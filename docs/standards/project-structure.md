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
that functionality is implemented. Tests mirror the production feature path
when useful; shared integration/widget coverage may remain under `test/`.

Avoid generic `common`, `utility`, or `service` dumping grounds. A shared file
must have multiple current consumers and no feature-specific ownership.
