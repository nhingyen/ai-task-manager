# Widget and UI Standards

Pages compose feature widgets and provide the feature Cubit through an
explicitly constructed `BlocProvider` (or the project's selected Flutter Bloc
equivalent). The page should not hide dependencies behind a service locator.

Keep rendering and interaction in focused widgets. Use builders for state
rendering and listeners for one-time effects such as navigation, dialogs, and
snackbars. Split a widget when it has a distinct responsibility or its rebuild
scope would otherwise become unnecessarily broad.

Widgets should receive stable identifiers or domain values through typed
parameters, rather than opaque navigation objects. Shared widgets belong in
`core/` only when they are feature-neutral.
