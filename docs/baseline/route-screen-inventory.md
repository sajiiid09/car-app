# Route and Screen Inventory

## Consumer

| route/entry | screen/widget | purpose | backing source | status | action |
| --- | --- | --- | --- | --- | --- |
| `/splash` | `SplashScreen` | Bootstrap auth/profile routing | Supabase/Riverpod | partial | Keep; validate against final auth strategy later |
| `/force-update` | `ForceUpdateScreen` | Block outdated app versions | local UI only | partial | Keep as secondary utility; wire store links later |
| `/about` | `AboutScreen` | Static app/about info | local UI only | partial | Keep as secondary utility |
| `/payment/success` | `PaymentSuccessScreen` | Payment completion handoff | local UI only | partial | Keep; later align with real payment lifecycle |
| `/payment/failed` | `PaymentFailedScreen` | Payment failure handoff | local UI only | partial | Keep; later align with real payment lifecycle |
| `/login` | `LoginScreen` | Phone signup/login entry | local UI only | partial | Keep; later align with Supabase-auth target |
| `/otp` | `OtpScreen` | OTP verification | local UI only | partial | Keep; later align with Supabase-auth target |
| `/profile-setup` | `ProfileSetupScreen` | First-time profile completion | local UI only | partial | Keep |
| `/terms` | `TermsScreen` | Terms acceptance | local UI only | partial | Keep |
| `/home` | `HomeScreen` | Consumer dashboard and discovery entry | Supabase/Riverpod | real | Keep as primary tab |
| `/workshops` | `WorkshopListScreen` | Workshop discovery list | Supabase/Riverpod | partial | Keep as primary tab |
| `/marketplace` | `MarketplaceScreen` | Parts browsing and category filtering | Supabase/Riverpod | real | Keep as primary tab |
| `/orders` | `OrdersScreen` | Order history and status tracking entry | Supabase/Riverpod | real | Keep as primary tab |
| `/chat` | `ChatListScreen` | Chat room list | Supabase/Riverpod | partial | Demote from primary nav; keep as secondary route |
| `/profile` | `ProfileScreen` | Account hub and utility entry | Supabase/Riverpod | real | Keep as primary tab |
| `/workshop/:id` | `WorkshopDetailScreen` | Workshop detail, reviews, chat entry | Supabase/Riverpod | partial | Keep as service detail route |
| `/notifications` | `NotificationsScreen` | In-app notifications list | Supabase/Riverpod | real | Keep as secondary account route |
| `/cart` | `CartScreen` | Local cart review | Supabase/Riverpod | real | Keep as commerce detail route |
| `/checkout` | `CheckoutScreen` | Address/payment selection before order placement | Supabase/Riverpod | partial | Keep; later align with payment/backend truth |
| `/vehicle/add` | `VehicleAddScreen` | Add consumer vehicle | Supabase/Riverpod | partial | Keep as service detail route |
| `/order/:id` | `OrderTrackingScreen` | Order tracking and follow-up actions | Supabase/Riverpod | partial | Keep as commerce detail route |
| `/rate/:id` | `RateWorkshopScreen` | Post-order workshop review | Supabase/Riverpod | partial | Keep |
| `/part/:id` | `PartDetailScreen` | Part detail and add-to-cart flow | Supabase/Riverpod | partial | Keep as commerce detail route |
| `/shop/:id` | `ShopProfileScreen` | Shop detail and parts listing | Supabase/Riverpod | partial | Keep |
| `/bill/:id` | `WorkshopBillScreen` | Workshop bill review/approval | Supabase/Riverpod | partial | Keep |
| `/diagnosis/:id` | `DiagnosisReportScreen` | Diagnosis report review | Supabase/Riverpod | partial | Keep |
| `/chat/:id` | `ChatDetailScreen` | Chat conversation detail | Supabase/Riverpod | partial | Keep |
| `/profile/edit` | `EditProfileScreen` | Edit account profile | Supabase/Riverpod | partial | Keep as profile utility |
| `/addresses` | `AddressesScreen` | CRUD for delivery addresses | Supabase/Riverpod | real | Keep as profile utility |
| `/favorites` | `FavoritesScreen` | Favorite parts/workshops | Supabase/Riverpod | real | Keep as profile utility |
| `/maintenance-log` | `MaintenanceLogScreen` | Vehicle maintenance timeline | Supabase/Riverpod | partial | Keep as profile utility |
| `/my-reviews` | `MyReviewsScreen` | Review history | Supabase/Riverpod | partial | Keep as profile utility |
| `/notification-settings` | `NotificationSettingsScreen` | Notification preference toggles | local UI only | placeholder | Keep route, but classify as non-backed settings UI |
| `/settings/language` | `LanguageScreen` | Language selection | local UI only | partial | Keep as profile utility |

## Pro

| route/entry | screen/widget | purpose | backing source | status | action |
| --- | --- | --- | --- | --- | --- |
| `/roles` | `RoleSelectorScreen` | Choose provider role | local UI only | partial | Keep as primary entry |
| `/onboarding/:role` | `ProviderOnboardingScreen` | Role-specific onboarding request flow | mock/demo | placeholder | Keep, but treat as prototype only |
| `/workshop` | `WorkshopDashboard` | Workshop home dashboard | local UI only | placeholder | Keep as primary workshop shell |
| `/workshop/find-customer` | `FindCustomerScreen` | Find customer by phone before diagnosis | mock/demo | placeholder | Keep as prototype flow |
| `/workshop/diagnosis` | `CreateDiagnosisScreen` | Draft diagnosis report | mock/demo | placeholder | Keep as prototype flow |
| `/workshop/bill` | `SubmitBillScreen` | Draft workshop bill | mock/demo | placeholder | Keep as prototype flow |
| `/driver` | `DriverDashboard` | Driver home dashboard | local UI only | placeholder | Keep as primary driver shell |
| `/driver/delivery/:id` | `DeliveryFlowScreen` | Delivery progress flow | mock/demo | placeholder | Keep as prototype flow |
| `/shop` | `ShopDashboard` | Shop home dashboard | local UI only | placeholder | Keep as primary shop shell |
| `/shop/add-part` | `AddPartScreen` | Add inventory item | mock/demo | placeholder | Keep as prototype flow |
| `/earnings` | `EarningsScreen` | Provider earnings summary | local UI only | placeholder | Keep as secondary provider route |
| `/provider-profile` | `ProviderProfileScreen` | Provider account/profile view | local UI only | partial | Keep as secondary provider route |

## Admin

| route/entry | screen/widget | purpose | backing source | status | action |
| --- | --- | --- | --- | --- | --- |
| `app root` | `AdminShell` | Sidebar shell that hosts all admin sections | shell only | partial | Keep as the admin container |
| `dashboard` | `DashboardPage` | KPI and latest-order overview | local UI only | placeholder | Keep section, but do not treat metrics as real data |
| `users` | `UsersPage` | User list and account actions | local UI only | placeholder | Keep section, later back with real admin data |
| `orders` | `OrdersPage` | Order monitoring table | local UI only | placeholder | Keep section |
| `approvals` | `ApprovalsPage` | Provider approval queue | local UI only | placeholder | Keep section |
| `settings` | `SettingsPage` | Platform/admin settings | local UI only | placeholder | Keep section |
