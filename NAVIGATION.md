# OnlyCars Navigation

## Current State

Navigation currently exists in three shapes:

- `apps/consumer`: `GoRouter` with a shell route plus many standalone detail/account routes.
- `apps/pro`: `GoRouter` with role-based top-level routes and several mock/deep flows.
- `apps/admin`: no router abstraction; a single `AdminShell` swaps sections locally.

This document freezes the target structure for cleanup phases. Phase 1 does not delete or move routes.

## Consumer Current Route Map

### Primary shell routes

- `/home`
- `/workshops`
- `/marketplace`
- `/orders`
- `/chat`
- `/profile`

### Standalone routes

- `/splash`
- `/force-update`
- `/about`
- `/payment/success`
- `/payment/failed`
- `/login`
- `/otp`
- `/profile-setup`
- `/terms`
- `/workshop/:id`
- `/notifications`
- `/cart`
- `/checkout`
- `/vehicle/add`
- `/order/:id`
- `/rate/:id`
- `/part/:id`
- `/shop/:id`
- `/bill/:id`
- `/diagnosis/:id`
- `/chat/:id`
- `/profile/edit`
- `/addresses`
- `/favorites`
- `/maintenance-log`
- `/my-reviews`
- `/notification-settings`
- `/settings/language`

## Frozen Consumer Target

### Primary navigation

- `/home`
- `/workshops`
- `/marketplace`
- `/orders`
- `/profile`

### Secondary navigation

- Auth: `/splash`, `/login`, `/otp`, `/profile-setup`, `/terms`
- Messaging: `/chat`, `/chat/:id`
- Commerce/details: `/cart`, `/checkout`, `/payment/success`, `/payment/failed`, `/part/:id`, `/shop/:id`, `/order/:id`, `/bill/:id`, `/rate/:id`
- Service/details: `/workshop/:id`, `/diagnosis/:id`, `/vehicle/add`
- Account/utilities: `/notifications`, `/addresses`, `/favorites`, `/maintenance-log`, `/my-reviews`, `/notification-settings`, `/settings/language`, `/about`, `/force-update`, `/profile/edit`

### Consumer cleanup implications

- `/chat` is demoted from primary navigation but remains part of the product.
- Detail routes stay flat for now; they are not merged or nested in Phase 1.
- Account utility routes remain secondary and should not compete with the 5-tab core.

## Pro Frozen Target

### Primary

- `/roles`
- `/workshop`
- `/driver`
- `/shop`

### Secondary

- `/onboarding/:role`
- `/workshop/find-customer`
- `/workshop/diagnosis`
- `/workshop/bill`
- `/driver/delivery/:id`
- `/shop/add-part`
- `/earnings`
- `/provider-profile`

### Pro cleanup implications

- Keep one dashboard per role.
- Treat onboarding and role-specific flows as prototype surfaces until they use shared data/state boundaries.
- Do not expand role flows before placeholder/mock logic is contained.

## Admin Frozen Target

Admin remains a single shell with these sections:

- `dashboard`
- `users`
- `orders`
- `approvals`
- `settings`

### Admin cleanup implications

- Keep the shell layout.
- Do not add more sections in cleanup phases unless they replace an existing placeholder.
- Do not treat the current dashboard tables/cards as production-ready data views.
