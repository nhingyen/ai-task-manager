# State Management Standards

Use Cubits for feature presentation state. A Cubit receives its dependencies
through its constructor and calls domain repository interfaces directly for
simple CRUD.

Represent state with small Dart 3 sealed hierarchies when states are mutually
exclusive, for example `initial`, `loading`, `success`, and `failure`. Keep
state specific to the feature and include the data needed to render it.

Do not introduce or carry forward `BaseState`, `BaseCubit`,
`BaseCallDataHandler`, `ViewStatus`, `Nullable<T>`, or broad result wrappers
just to remove a small amount of repetition. Handle errors explicitly at the
operation boundary and preserve useful error information.

Extract a Use Case or Domain Service only when business logic is complex,
cross-repository, reusable, or a meaningful AI/domain operation.
