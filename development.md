# Development

## Current Direction
- Front-end reset in progress for the consumer mobile app.
- Current implemented slice: first-run flow only.
- Backend integration is intentionally deferred.

## Implemented
- White splash with blue `OnlyCars` wordmark.
- Three-screen onboarding flow with skip/next/get-started behavior.
- Inline language selection sheet for `en` and `ar`.
- Local first-run persistence via `shared_preferences`.
- App locale initialization from stored value, then supported device locale, then English fallback.

## Notes
- Onboarding expects these assets if exact photography is added later:
  - `assets/images/onboarding_find_workshops.png`
  - `assets/images/onboarding_shop_parts.png`
  - `assets/images/onboarding_track_orders.png`
- Until those files exist, the flow renders code-driven fallback artwork.

## Validation
- Focused first-run widget/state tests pass in `apps/consumer/test/first_run_flow_test.dart`.
- Targeted analyze passes for the new consumer first-run files and `packages/oc_ui/lib`.
