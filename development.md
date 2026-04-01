# Development

## Current Direction
- Front-end reset in progress for the consumer mobile app.
- Current implemented slice: first-run flow plus customer auth and car-setup flow.
- Backend integration is intentionally deferred.

## Implemented
- White splash with blue `OnlyCars` wordmark.
- Three-screen onboarding flow with skip/next/get-started behavior.
- Inline language selection sheet for `en` and `ar`.
- Local first-run persistence via `shared_preferences`.
- App locale initialization from stored value, then supported device locale, then English fallback.
- Auth welcome screen on `/login` with full-bleed background and role-selection sheet.
- Customer-only sign-up path with privacy consent sheet.
- Sign-in screen with local validation and visual-only Google/Apple buttons.
- Frontend-only password recovery flow on `/auth/forgot-password`, `/auth/verify-reset`, and `/auth/reset-password`.
- Frontend-only add-car flow with local pickers for brand, model, year, and engine type.
- Confirmation screen that hands off to `/home` through a local preview session.

## Notes
- Onboarding expects these assets if exact photography is added later:
  - `assets/images/onboarding_find_workshops.png`
  - `assets/images/onboarding_shop_parts.png`
  - `assets/images/onboarding_track_orders.png`
- Auth and add-car still expect exact source images for full parity:
  - `assets/images/onboarding_track_orders.png` for auth welcome
  - `assets/images/add_car_hero.png`
- Until those files exist, the flow renders code-driven fallback artwork.
- Password recovery is local-only for now and does not call the legacy OTP backend.

## Validation
- Focused first-run widget/state tests pass in `apps/consumer/test/first_run_flow_test.dart`.
- Focused auth flow widget tests pass in `apps/consumer/test/auth_flow_test.dart`.
- Focused password recovery widget tests pass in `apps/consumer/test/password_recovery_test.dart`.
- Smoke widget test passes in `apps/consumer/test/widget_test.dart`.
- Targeted analyze passes for the new consumer flow files and `packages/oc_ui/lib`.
