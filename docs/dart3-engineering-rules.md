# Dart 3 engineering rules

These are the working rules for Dart and Flutter changes in this repository.

## Language

- Use Dart 3 features when they clarify intent: records for local tuples,
  pattern matching for typed branching, enhanced enums for closed option sets,
  and sealed/freezed unions for state and events.
- Keep nullability explicit. Do not use `!` unless the invariant is local and
  obvious from the previous lines.
- Prefer exhaustive `switch` expressions over open `if` chains for enums and
  known variants.
- Keep public APIs typed. Avoid `dynamic` except at external boundaries such as
  JSON/RPC responses, then normalize immediately.
- Prefer immutable values and `final` locals. Mutability must be local,
  intentional, and easy to reason about.
- Use collection `if`, `for`, spreads, destructuring and switch expressions when
  they reduce boilerplate without hiding control flow.
- Prefer named parameters for non-obvious arguments and domain operations.
- Avoid stringly typed logic inside app code. Convert raw strings from external
  APIs into enums/value objects as close to the boundary as possible.

## Decomposition

- Keep widgets small enough that each one owns one visual or behavioral concern.
- Do not let screen files become dumping grounds. A page file should own route
  state, bloc listeners and navigation; sizeable visual sections belong in
  focused widgets/files.
- Put data access in repositories, state transitions in blocs/cubits, and pure
  formatting/parsing in private helpers or domain packages.
- Do not solve a narrow bug by rewriting unrelated surfaces.
- Add abstractions only when they remove real duplication or encode a stable
  domain concept.
- Extract private widgets first when behavior is still local to one page. Promote
  to shared `widgets` or `app_ui` only after the API is stable and reused.
- Keep dependencies flowing one way: UI depends on bloc/domain/repositories;
  repositories must not depend on Flutter UI.
- Keep constructors small and explicit. Pass dependencies and callbacks instead
  of reading global state from leaf widgets.

## Refactoring

- Refactor as part of feature work when the touched file is already too large or
  the change would make it harder to navigate.
- Preserve behavior while decomposing. Move code first, then make behavioral
  changes in a separate, reviewable step when practical.
- Prefer mechanical extraction over broad redesign. A refactor should reduce
  cognitive load, not introduce a new architecture for its own sake.
- Keep refactors scoped to the ownership boundary being changed. Do not churn
  unrelated modules, formatting, generated files, or persisted state.
- After moving code, run formatter and targeted analyzer on every touched Dart
  entry point.

## Async And Errors

- Treat network, Supabase RPC, file IO and parsing as failure boundaries.
- Preserve stack traces with `Error.throwWithStackTrace` inside repositories.
- Prefer bounded fallbacks: primary contract first, fallback second, no silent
  infinite retry loops.
- Do not let optional live fallback paths replace the canonical Supabase path.
- Never erase useful cached state because a refresh failed or an upstream source
  returned an empty transient response.
- Keep retries explicit, bounded and observable. Do not retry inside UI build
  methods.

## Flutter UI

- Use the existing `app_ui` tokens, typography, icons and spacing before adding
  local styling.
- Keep layout dimensions stable for repeated items, toolbars, tabs and chips.
- Avoid text overflow by constraining, wrapping or fading intentionally.
- Verify changed screens with `flutter analyze`; run targeted tests when logic
  or parsing changes.
- Avoid expensive work in `build`. Precompute, memoize locally, or move work into
  bloc/repository/domain helpers when repeated across frames.
- Keep scrollable UX intentional. If a control used to scroll or swipe, preserve
  that behavior unless the design explicitly removes it.
- Prefer stable item sizes for horizontal strips, tabs, chips and calendars so
  selection and loading states do not shift layout.

## Data Contracts

- Supabase reads go through public RPC/app API contracts, not raw `core.*`
  tables.
- Normalize external JSON into typed domain models immediately.
- Keep legacy compatibility paths additive and removable later; do not break
  persisted hydrated state without migration.
- Organization/source identifiers are configuration, not universal constants.
  Runtime code must receive them from env/config/tenant setup.
- Query only the data needed for the current workflow. Avoid unbounded RPC calls
  when a bounded date range, target endpoint or paged contract exists.

## Verification

- Run `dart format` on touched Dart files before analysis.
- Run targeted `flutter analyze` for every changed package/app surface.
- Add or update focused tests when behavior, parsing, state transitions or data
  contracts change.
- When Supabase behavior is involved, verify the relevant RPC/table contract with
  MCP or an equivalent direct query.
