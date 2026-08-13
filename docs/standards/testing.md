# Testing Standards

Use the testing tools already supplied by Flutter. TASK-001 adds no Flutter
dependencies. `bloc_test` may be adopted later if the project explicitly
chooses to add it; until then, test Cubits with ordinary Dart tests by
constructing them with fakes and observing emitted states.

Test conventions:

- Unit-test domain rules, mappers, repositories, and Cubit state transitions.
- Use fake repository implementations for Cubit tests; do not use real storage.
- Assert the complete meaningful state sequence for loading, success, empty,
  and failure paths.
- Widget-test user-visible rendering and listener side effects with
  `flutter_test`.
- Test routes with stable IDs and verify that screens can restore data through
  their repository dependencies.

Keep tests close to their feature when that improves discoverability, and use
`test/` for app-wide or integration coverage. Tests should not require a
service locator or generated mocks.
