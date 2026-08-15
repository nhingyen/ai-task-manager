# Theme Standards

Keep app-wide theme configuration and design tokens in `lib/app/` or `lib/core/`
according to ownership. Define colors, typography, spacing, and component
defaults as named tokens instead of scattering literal values through feature
widgets.

Features may compose the shared theme but must not redefine global tokens for a
single screen. Feature-specific visual constants stay with that feature until
they are intentionally promoted to a shared design token.

Prefer Material 3 theme APIs and semantic theme properties. Keep theme code
free of repository, persistence, and feature business logic.
