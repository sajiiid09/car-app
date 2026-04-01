import 'package:consumer/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_api/oc_api.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/sign_up_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/verify_reset_code_screen.dart';
import 'screens/auth/reset_password_screen.dart';
import 'screens/auth/auth_complete_screen.dart';
import 'screens/auth/otp_screen.dart';
import 'screens/auth/profile_setup_screen.dart';
import 'screens/auth/terms_screen.dart';
import 'screens/home/home_shell.dart';
import 'screens/home/home_screen.dart';
import 'screens/workshops/workshop_list_screen.dart';
import 'screens/workshops/workshop_detail_screen.dart';
import 'screens/orders/orders_screen.dart';
import 'screens/orders/order_tracking_screen.dart';
import 'screens/orders/rate_workshop_screen.dart';
import 'screens/marketplace/marketplace_screen.dart';
import 'screens/marketplace/cart_screen.dart';
import 'screens/marketplace/checkout_screen.dart';
import 'screens/marketplace/part_detail_screen.dart';
import 'screens/marketplace/shop_profile_screen.dart';
import 'screens/orders/workshop_bill_screen.dart';
import 'screens/vehicles/vehicle_add_screen.dart';
import 'screens/vehicles/maintenance_log_screen.dart';
import 'screens/chat/chat_detail_screen.dart';
import 'screens/chat/chat_list_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/addresses/addresses_screen.dart';
import 'screens/favorites/favorites_screen.dart';
import 'screens/reviews/my_reviews_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'screens/notifications/notification_settings_screen.dart';
import 'screens/settings/language_screen.dart';
import 'screens/diagnosis/diagnosis_report_screen.dart';
import 'screens/shared/force_update_screen.dart';
import 'screens/shared/about_screen.dart';
import 'screens/payment/payment_success_screen.dart';
import 'screens/payment/payment_failed_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final hasPreviewSession = ref.watch(authPreviewSessionProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, _) => const OnboardingScreen()),
      GoRoute(
        path: '/force-update',
        builder: (_, _) => const ForceUpdateScreen(),
      ),
      GoRoute(path: '/about', builder: (_, _) => const AboutScreen()),
      GoRoute(
        path: '/payment/success',
        builder: (_, state) =>
            PaymentSuccessScreen(orderId: state.uri.queryParameters['order']),
      ),
      GoRoute(
        path: '/payment/failed',
        builder: (_, state) =>
            PaymentFailedScreen(orderId: state.uri.queryParameters['order']),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (_, state) => _fadePage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/sign-in',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const SignInScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/sign-up',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const SignUpScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/verify-reset',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const VerifyResetCodeScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/reset-password',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const ResetPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/auth/complete',
        pageBuilder: (_, state) => _fadePage(
          state: state,
          child: const AuthCompleteScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        builder: (_, state) =>
            OtpScreen(phone: state.uri.queryParameters['phone'] ?? ''),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(path: '/terms', builder: (_, _) => const TermsScreen()),

      // Detail screens (outside shell — no bottom nav)
      GoRoute(
        path: '/workshop/:id',
        builder: (_, state) =>
            WorkshopDetailScreen(workshopId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(path: '/cart', builder: (_, _) => const CartScreen()),
      GoRoute(path: '/checkout', builder: (_, _) => const CheckoutScreen()),
      GoRoute(
        path: '/vehicle/add',
        pageBuilder: (_, state) => _slidePage(
          state: state,
          child: const VehicleAddScreen(),
        ),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (_, state) =>
            OrderTrackingScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/rate/:id',
        builder: (_, state) =>
            RateWorkshopScreen(orderId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/part/:id',
        builder: (_, state) =>
            PartDetailScreen(partId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/shop/:id',
        builder: (_, state) =>
            ShopProfileScreen(shopId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/bill/:id',
        builder: (_, state) =>
            WorkshopBillScreen(billId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/diagnosis/:id',
        builder: (_, state) =>
            DiagnosisReportScreen(reportId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (_, state) =>
            ChatDetailScreen(roomId: state.pathParameters['id']!),
      ),

      // New screens (outside shell)
      GoRoute(
        path: '/profile/edit',
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(path: '/addresses', builder: (_, _) => const AddressesScreen()),
      GoRoute(path: '/favorites', builder: (_, _) => const FavoritesScreen()),
      GoRoute(
        path: '/maintenance-log',
        builder: (_, _) => const MaintenanceLogScreen(),
      ),
      GoRoute(path: '/my-reviews', builder: (_, _) => const MyReviewsScreen()),
      GoRoute(
        path: '/notification-settings',
        builder: (_, _) => const NotificationSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/language',
        builder: (_, _) => const LanguageScreen(),
      ),

      // Main shell (with bottom nav)
      ShellRoute(
        builder: (_, _, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
          GoRoute(
            path: '/workshops',
            builder: (_, _) => const WorkshopListScreen(),
          ),
          GoRoute(
            path: '/marketplace',
            builder: (_, _) => const MarketplaceScreen(),
          ),
          GoRoute(path: '/orders', builder: (_, _) => const OrdersScreen()),
          GoRoute(path: '/chat', builder: (_, _) => const ChatListScreen()),
          GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
    redirect: (context, state) {
      final isAuth = AuthService().isAuthenticated || hasPreviewSession;
      final publicRoutes = [
        '/login',
        '/auth/sign-in',
        '/auth/sign-up',
        '/auth/forgot-password',
        '/auth/verify-reset',
        '/auth/reset-password',
        '/auth/complete',
        '/otp',
        '/splash',
        '/onboarding',
        '/profile-setup',
        '/terms',
        '/force-update',
        '/about',
        '/payment/success',
        '/payment/failed',
        '/vehicle/add',
      ];
      if (!isAuth && !publicRoutes.contains(state.matchedLocation)) {
        return '/login';
      }
      return null;
    },
  );
});

CustomTransitionPage<void> _slidePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 220),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (reduceMotion) {
        return FadeTransition(opacity: animation, child: child);
      }

      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

CustomTransitionPage<void> _fadePage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 280),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (reduceMotion) {
        return child;
      }

      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(opacity: curved, child: child);
    },
  );
}
