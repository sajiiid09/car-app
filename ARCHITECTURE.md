# OnlyCars Architecture

## Purpose

This document freezes the repo shape for stabilization work. Phase 1 is documentation and inventory only. Do not use this phase to redesign flows, move large file trees, or start feature work.

## Frozen Decisions

- `apps/consumer` is the only near-production app and the primary product source of truth.
- Consumer target navigation is a 5-tab core: `Home`, `Workshops`, `Marketplace`, `Orders`, `Profile`.
- `apps/pro` and `apps/admin` remain in the repo, but are treated as prototype/partial surfaces until they have real backend-backed flows.
- Supabase is the long-term backend and auth source of truth.
- The current Firebase phone-auth split is technical debt to unwind later, not the desired steady state.

## Monorepo Boundaries

| Area | Role | Current phase expectation |
| --- | --- | --- |
| `apps/consumer` | Primary customer-facing app | Stabilize and use as the reference app |
| `apps/pro` | Workshop / driver / shop app | Keep, classify, and contain placeholder/demo flows |
| `apps/admin` | Internal admin dashboard | Keep as shell-level prototype only |
| `packages/oc_ui` | Shared design system, theme, widgets | Default UI source of truth |
| `packages/oc_models` | Shared typed models | Keep as the typed data boundary |
| `packages/oc_api` | Shared data-access layer over Supabase | Keep as the only app-side backend access layer |
| `supabase/` | Schema, policies, functions, local config | Backend source of truth, but currently inconsistent in places |

## Ownership Rules

- App code must not query Supabase directly when `oc_api` can own the call.
- App code must not define duplicate domain models when `oc_models` should own the type.
- App-local themes, tokens, and reusable UI primitives are discouraged unless `oc_ui` cannot express the need.
- Shared package changes should be made only when at least one app benefits and the boundary is clear.
- `apps/consumer` drives architectural decisions first. `apps/pro` and `apps/admin` should adapt to those boundaries instead of inventing parallel ones.

## State and Data Boundaries

- Use Riverpod for app state.
- Use `go_router` for routed apps.
- Use `oc_api` for backend access.
- Use `oc_models` for typed entities.
- Keep backend-specific field drift and temporary adapters inside `oc_api`, not spread across screens.

## Lockfile and Tooling Policy

- App packages should commit `pubspec.lock`.
- Shared packages should not commit `pubspec.lock`.
- The root workspace must not be treated as healthy until all workspace members are configured consistently for Dart workspaces.
- Generated model outputs in `packages/oc_models` are required build artifacts, not optional files.

## Refactor Discipline

- No big-bang refactors.
- No broad cleanup branches that mix routing, state, UI, and backend repair together.
- Every cleanup PR must have one narrow purpose and a short rollback path.
- If a cleanup task changes architecture, document it first in these root docs or a follow-up baseline doc.
