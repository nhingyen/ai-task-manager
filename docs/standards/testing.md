# Testing Standards

Use the testing tools already supplied by Flutter. TASK-001 adds no Flutter
dependencies. `bloc_test` may be adopted later if the project explicitly
chooses to add it; until then, test Cubits with ordinary Dart tests by
constructing them with fakes and observing emitted states.

All test files belong under the root `test/` directory and should mirror the
corresponding `lib/` path when useful. Never add `*_test.dart` files under
`lib/`.

Test conventions:

- Unit-test domain rules, mappers, repositories, and Cubit state transitions.
- Use fake repository implementations for Cubit tests; do not use real storage.
- Assert the complete meaningful state sequence for loading, success, empty,
  and failure paths.
- With standard Dart/Flutter stream tools, attach the listener or configure the
  stream expectation before triggering an asynchronous Cubit action. This
  ensures early loading and error states are observed rather than missed.
- Widget-test user-visible rendering and listener side effects with
  `flutter_test`.
- Test routes with stable IDs and verify that screens can restore data through
  their repository dependencies.

Keep tests close to their feature when that improves discoverability, and use
`test/` for app-wide or integration coverage. Tests should not require a
service locator or generated mocks.
