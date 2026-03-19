# Repo Audit

## Snapshot

- Audit date: 2026-03-19
- Working assumption frozen in Phase 1: `apps/consumer` is the only near-production app.
- Screen counts:
  - consumer: 35 screen files
  - pro: 12 screen files
  - admin: 6 screen files
- Shared package source counts:
  - `oc_api`: 12 source files
  - `oc_models`: 14 source files
  - `oc_ui`: 3 source files
- Supabase footprint:
  - 7 edge functions
  - 21 migration files
  - 1 CI workflow

## Apps

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `apps/consumer` | usable | Uses Riverpod providers, `oc_api`, `oc_models`, `oc_ui`, `GoRouter`, Firebase init, and Supabase init. Routes cover auth, marketplace, orders, chat, profile, and utilities. | This is the only app with meaningful backend/state wiring, even though it currently fails analysis because model interfaces and generated files are broken. | Freeze as the primary app and use it as the reference surface for later cleanup phases. |
| `apps/consumer` route breadth | partial | Primary shell still exposes 6 top-level destinations, including `/chat`, while the frozen target is 5 primary tabs. | The route graph is broader than the target sitemap and mixes core navigation with secondary utilities. | Keep all current routes in Phase 1, but document `chat` as secondary and use the frozen sitemap for follow-up cleanup. |
| `apps/pro` | partial | Uses `GoRouter` and shared theme, but almost all flows are local UI only. `find_customer`, `create_diagnosis`, `submit_bill`, onboarding, and delivery flows use mock/demo patterns such as `Future.delayed`. | The app has structure, but very little real data/state integration. | Keep in repo, classify as prototype, and prevent it from driving architectural decisions. |
| `apps/pro` role dashboards | placeholder | Dashboard cards and role flows are populated with hardcoded stats, jobs, and orders. | These screens demonstrate intended UX, not reliable product behavior. | Contain as placeholders until dedicated backend integration work starts. |
| `apps/admin` | placeholder | No router layer, single `AdminShell`, static tables/cards, no provider-backed data usage beyond app bootstrap. | The shell is useful as a future container, but current sections are demo UI. | Keep shell and sections, but classify the whole app as prototype-only. |

## Packages

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `packages/oc_ui` | usable | Provides theme, tokens, and a large shared widget surface used by all three apps. | It is the current design-system source of truth, but it is concentrated in a small number of large files. | Keep as the shared UI boundary; defer decomposition to a later cleanup phase. |
| `packages/oc_models` | partial | Freezed/json-serializable source files exist, but generated `.freezed.dart` and `.g.dart` outputs are absent. Analyze and tests fail immediately. | The package is structurally correct as a boundary, but currently not buildable. | Treat generated model outputs as P0 stabilization work in a later phase. |
| `packages/oc_api` | partial | Service layer exists for auth, user, workshops, parts, orders, chat, notifications, diagnosis, payments, bills, and favorites. | The boundary is right, but the implementation drifts from both `oc_models` field names and Supabase schema/function naming. | Keep as the only data-access layer and normalize drift inside it later. |
| Package README files | obsolete | `apps/*/README.md` and `packages/*/README.md` still contain new-project/template text and TODOs. | These documents do not describe the actual repo state. | Replace or trim template README files in a later narrow cleanup PR. |
| Package LICENSE/CHANGELOG templates | obsolete | `oc_api`, `oc_models`, and `oc_ui` still ship template LICENSE/CHANGELOG content. | Template metadata makes package maturity look higher than it is. | Clean up package metadata after functional blockers are addressed. |

## Supabase

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `supabase/config.toml` and local config | usable | Local ports and auth/storage/realtime configuration are present and coherent. | The local environment definition is present and understandable. | Keep as the baseline local backend config. |
| Migrations overall | partial | Migrations cover users, roles, providers, vehicles, diagnosis, parts, orders, payments, chat, reviews, config, triggers, favorites, and notifications. | Coverage is broad, but naming and lifecycle drift exists across later migrations and edge functions. | Freeze as schema baseline and document drift before changing tables. |
| Edge functions overall | partial | Functions exist for `place-order`, `process-payment`, `payment-callback`, `update-order-status`, `assign-driver`, `release-escrow`, and `send-push`. | The function set is meaningful, but table/field expectations are inconsistent with migrations and client services. | Keep functions in repo, but treat them as partially trustworthy until naming/schema drift is resolved. |
| Order status history naming | partial | Migrations define `order_status_log` and later add `order_status_history`; `oc_api` reads `order_status_log`; edge functions write `order_status_history`. | Two parallel history concepts create real backend ambiguity. | Consolidate to one order-history source in a later backend cleanup phase. |
| Provider table naming | partial | Client code and migrations use `shop_profiles` / `driver_profiles`, but `assign-driver` reads from `shops`, `drivers`, and writes `deliveries`. | This is a concrete schema mismatch, not just style drift. | Audit every function and service against actual schema before expanding provider features. |
| Payment field naming | partial | `oc_api` `PaymentService` uses `type`; later migrations use `method`; edge functions and order updates also use `payment_status` fields not present in early order schema. | Payment lifecycle logic is split across incompatible assumptions. | Normalize payment naming and order-payment ownership in a later narrow backend pass. |
| Notification payload naming | partial | `oc_models` notification shape expects `title_ar` / `body_ar`; edge functions often insert `title` / `body`. | This creates direct client/backend mismatches. | Unify notification field names inside the backend/client boundary before adding more notification flows. |
| `ALL_MIGRATIONS_COMBINED.sql` | duplicate | A combined migration file exists alongside ordered migrations. | It duplicates schema definition and increases risk of divergent truth. | Keep it out of cleanup source-of-truth decisions; ordered migrations should remain canonical. |

## Assets

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `apps/consumer/assets/images` | usable | Consumer has named product/brand/banner image assets referenced by screens. | These are actively used by the only near-production app. | Keep and audit only when unused-asset cleanup becomes a dedicated task. |
| App platform assets (`android`, `ios`, `macos`, `web`, `windows`, `linux`) | partial | Consumer and pro include standard Flutter platform scaffolding and launcher assets. | Required for platform builds, but not a sign of product completeness. | Leave intact; do not count platform scaffolding as feature completeness. |
| Root `onlycars_logo_concept.png` | partial | Design artifact exists at repo root, outside app asset ownership. | It may be useful reference material, but it is not integrated into a documented asset pipeline. | Keep for now and classify during later asset cleanup. |
| Shared asset strategy | partial | No shared asset package exists; consumer owns real assets while pro/admin mostly rely on platform defaults. | Asset ownership is not yet normalized across apps. | Do not invent a shared asset layer in Phase 1; document current ownership only. |

## Generated Files

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `packages/oc_models/lib/src/*.freezed.dart` and `*.g.dart` | partial | Required by source files but absent from the package. | Missing generated outputs currently block analyze/test across multiple packages. | Treat as a P0 fix in a later cleanup phase. |
| `apps/*/lib/firebase_options.dart` | usable | Consumer and pro include generated Firebase option files used at app bootstrap. | These generated files are present and actively referenced. | Keep and regenerate only through the standard Firebase tooling flow. |
| Flutter generated plugin registrants and platform generated files | usable | Standard generated files exist under platform folders. | These are normal Flutter build artifacts tied to platform targets. | Keep under normal Flutter ownership; do not hand-edit them. |
| Lockfiles and workspace metadata | partial | No committed `pubspec.lock` files are present, and root `flutter pub get` fails because workspace members lack `resolution: workspace`. | Dependency bootstrap is inconsistent across the repo. | Adopt and enforce the documented lockfile policy in a later tooling cleanup. |

## CI and Workflows

| Area | Status | Evidence | Why | Recommended action |
| --- | --- | --- | --- | --- |
| `.github/workflows/ci.yml` | partial | CI runs package-by-package `flutter pub get`, analyzes only shared packages, and tests only `oc_models` and `oc_ui`. | CI does not cover consumer/pro/admin analysis or most tests, and it assumes healthy package state that the repo does not currently have. | Expand CI only after the build/test baseline is repaired. |
| `melos.yaml` | partial | Melos scripts exist for analyze/test/build_runner/clean, but `melos` is not installed locally and root workspace bootstrap is broken. | The intended monorepo tooling exists, but local execution is not ready. | Treat melos as aspirational until workspace configuration is fixed. |

## Tooling Baseline

### Dependency bootstrap

| Command | Result | Notes |
| --- | --- | --- |
| `flutter pub get` at repo root | failed | Root workspace is misconfigured: members are included from `pubspec.yaml` but do not declare `resolution: workspace`. |
| `flutter pub get` in `apps/consumer` | passed | Per-package bootstrap works. |
| `flutter pub get` in `apps/pro` | passed | Per-package bootstrap works. |
| `flutter pub get` in `apps/admin` | passed | Per-package bootstrap works. |
| `flutter pub get` in `packages/oc_models` | passed | Package resolves, but generated code is still missing. |
| `flutter pub get` in `packages/oc_api` | passed | Resolves against local path packages. |
| `flutter pub get` in `packages/oc_ui` | passed | Resolves cleanly. |

### Analyze baseline

| Package/app | Result | Notes |
| --- | --- | --- |
| `apps/consumer` | failed | 314 issues. Primary failure mode is model/API drift after missing `oc_models` generated outputs; `cart_test.dart` also targets an outdated cart API. |
| `apps/pro` | failed | One deprecated API usage still causes a non-clean analyzer baseline. |
| `apps/admin` | passed | Analyzer is clean, but the app is still placeholder UI. |
| `packages/oc_models` | failed | 80 issues, almost entirely caused by missing generated files plus a template `Calculator` test. |
| `packages/oc_api` | failed | Depends on broken/mismatched model fields and still has a template test. |
| `packages/oc_ui` | failed | Fails due to a leftover template `Calculator` test. |

### Test baseline

| Package/app | Result | Notes |
| --- | --- | --- |
| `apps/consumer` | failed | `business_logic_test.dart` runs, but widget/test compilation is blocked by missing `oc_models` outputs and stale cart-test assumptions. |
| `apps/pro` | passed | Only a trivial smoke test exists. |
| `apps/admin` | passed | Only a trivial smoke test exists. |
| `packages/oc_models` | failed | Missing generated files and template test content. |
| `packages/oc_api` | failed | Blocked by `oc_models` generated-file failure and template test content. |
| `packages/oc_ui` | failed | Template `Calculator` test fails. |

## Cleanup Priorities Confirmed by Audit

- `P0`: root workspace/bootstrap drift, missing generated model files, consumer model/API mismatch, template/broken tests, backend naming/schema drift
- `P1`: route demotion/simplification follow-up, pro/admin placeholder containment, package metadata cleanup, generated-file policy enforcement
- `P2`: `oc_ui` decomposition, asset pruning, broader structural refactors
