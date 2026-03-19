# OnlyCars State and Data Rules

## Default Stack

- Riverpod is the default state layer.
- `go_router` is the default navigation layer for routed Flutter apps.
- `oc_api` is the only app-side data-access boundary.
- `oc_models` is the typed model boundary.

## Backend Source of Truth

- Supabase is the backend source of truth.
- Supabase schema, policies, and functions define the intended platform behavior, even when current client code drifts from it.
- Firebase is limited to messaging, crash reporting, analytics, and other supporting concerns until auth is consolidated.

## Auth Rule

- Long-term target: Supabase auth owns application identity.
- Current Firebase phone-auth flow is temporary technical debt.
- New cleanup work must not deepen the Firebase/Supabase auth split.

## App Rules

- Screens should read state from providers, not instantiate service logic ad hoc beyond provider boundaries.
- Screens should not map raw Supabase payloads directly when `oc_api` and `oc_models` can own translation.
- Temporary mock/demo state is allowed only in prototype surfaces (`pro`, `admin`) and should be called out explicitly.

## Package Rules

- `oc_models` owns entity shapes and serialization contracts.
- `oc_api` owns query details, field-name adaptation, RPC/function calls, and backend integration.
- `oc_ui` owns reusable UI primitives and tokens.
- App packages own composition, route wiring, and screen-level provider use.

## Stabilization Priorities

- Fix missing/generated model artifacts before large consumer cleanup.
- Normalize backend naming drift inside shared layers before adding more screens.
- Replace template tests with boundary-aware tests before claiming package stability.
