# Routing Standards

Keep application-wide route configuration in `lib/app/`; feature-specific
route builders may live with their feature. Use named, readable routes and
typed path/query parameters where possible.

Stable identifiers, especially task IDs, are the primary navigation contract.
Detail screens must load required data from repositories using those values so
they can recover after recreation, deep links, or process restoration.

Do not use `GoRouter.extra` as the primary source of required navigation state.
It may carry optional, nonessential context, but routes must validate inputs
and provide a clear missing/invalid-identifier state.
