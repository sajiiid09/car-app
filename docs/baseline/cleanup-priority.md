# Cleanup Priority

## P0

- Restore a real build baseline for `packages/oc_models` by reintroducing required generated outputs and agreeing on generated-file policy.
- Fix root workspace/tooling drift so bootstrap expectations are consistent.
- Repair consumer compile drift between `oc_models`, `oc_api`, and consumer screens/providers.
- Remove or replace broken/template tests that currently hide real confidence gaps.
- Normalize backend naming/schema drift:
  - `order_status_log` vs `order_status_history`
  - `shop_profiles` / `driver_profiles` vs `shops` / `drivers`
  - payment field naming and notification payload naming

## P1

- Apply the frozen consumer sitemap by demoting `chat` from primary navigation without removing the feature.
- Contain `pro` and `admin` placeholder surfaces so they stop implying production readiness.
- Replace template package metadata and README files with real repo-specific content.
- Enforce lockfile and generated-file policy.

## P2

- Decompose `oc_ui` only after the baseline is stable.
- Audit and prune assets after screen ownership is clearer.
- Take on broader structural refactors only after P0 and P1 are complete.
