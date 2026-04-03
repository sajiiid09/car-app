import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'screens/driver/delivery_flow_screen.dart';
import 'screens/driver/driver_dashboard.dart';
import 'screens/driver/driver_sign_up_complete_screen.dart';
import 'screens/driver/driver_sign_up_screen.dart';
import 'screens/onboarding/provider_onboarding_screen.dart';
import 'screens/role_selector_screen.dart';
import 'screens/shop/shop_dashboard.dart';
import 'screens/shop/shop_order_flow_screens.dart';
import 'screens/shop/shop_secondary_screens.dart';
import 'screens/shop/shop_shared.dart';
import 'screens/shop/shop_sign_up_complete_screen.dart';
import 'screens/shop/shop_sign_up_screen.dart';
import 'screens/workshop/create_diagnosis_screen.dart';
import 'screens/workshop/workshop_dashboard.dart';
import 'screens/workshop/workshop_job_flow_screens.dart';
import 'screens/workshop/workshop_secondary_screens.dart';
import 'screens/workshop/workshop_shared.dart';
import 'screens/workshop/workshop_sign_up_complete_screen.dart';
import 'screens/workshop/workshop_sign_up_screen.dart';
import 'screens/workshop/workshop_workflow_state.dart';

final proRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/roles',
    routes: [
      GoRoute(path: '/roles', builder: (_, _) => const RoleSelectorScreen()),
      GoRoute(
        path: '/onboarding/:role',
        builder: (_, state) =>
            ProviderOnboardingScreen(role: state.pathParameters['role']!),
      ),

      GoRoute(
        path: '/workshop/sign-up',
        builder: (_, _) => const WorkshopSignUpScreen(),
      ),
      GoRoute(
        path: '/workshop/sign-up/complete',
        builder: (_, _) => const WorkshopSignUpCompleteScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) =>
            WorkshopShellScaffold(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/workshop',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const WorkshopDashboard()),
          ),
          GoRoute(
            path: '/workshop/jobs',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopJobsScreen(
                filter: WorkshopJobsFilter.fromQuery(
                  state.uri.queryParameters['filter'],
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/messages',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const WorkshopMessagesScreen()),
          ),
          GoRoute(
            path: '/workshop/profile',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const WorkshopProfileScreen()),
          ),
          GoRoute(
            path: '/workshop/jobs/request/:requestId',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopRequestDetailScreen(
                requestId: state.pathParameters['requestId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/request/:requestId/driver',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopRequestDriverScreen(
                requestId: state.pathParameters['requestId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/request/:requestId/incoming',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopIncomingTrackingScreen(
                requestId: state.pathParameters['requestId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopActiveJobDetailScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/diagnosis',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: CreateDiagnosisScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/approval-pending',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopDiagnosisApprovalPendingScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/in-progress',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopServiceInProgressScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/handover',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopHandoverPrepScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/request-return',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopRequestReturnDeliveryScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/return-tracking',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopReturnDeliveryTrackingScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/workshop/jobs/job/:jobId/completed',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: WorkshopJobCompletedScreen(
                jobId: state.pathParameters['jobId']!,
              ),
            ),
          ),
        ],
      ),

      GoRoute(
        path: '/workshop/find-customer',
        redirect: (_, _) => '/workshop/jobs?filter=all',
      ),
      GoRoute(
        path: '/workshop/diagnosis',
        redirect: (_, _) => '/workshop/jobs?filter=all',
      ),
      GoRoute(
        path: '/workshop/bill',
        redirect: (_, _) => '/workshop/jobs?filter=all',
      ),
      GoRoute(
        path: '/provider-profile',
        redirect: (_, _) => '/workshop/profile',
      ),
      GoRoute(path: '/earnings', redirect: (_, _) => '/workshop/profile'),

      GoRoute(
        path: '/driver/sign-up',
        builder: (_, _) => const DriverSignUpScreen(),
      ),
      GoRoute(
        path: '/driver/sign-up/complete',
        builder: (_, _) => const DriverSignUpCompleteScreen(),
      ),
      GoRoute(path: '/driver', builder: (_, _) => const DriverDashboard()),
      GoRoute(
        path: '/driver/delivery/:id',
        builder: (_, state) =>
            DeliveryFlowScreen(deliveryId: state.pathParameters['id']!),
      ),

      GoRoute(
        path: '/shop/sign-up',
        builder: (_, _) => const ShopSignUpScreen(),
      ),
      GoRoute(
        path: '/shop/sign-up/complete',
        builder: (_, _) => const ShopSignUpCompleteScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            ShopShellScaffold(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/shop',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const ShopDashboard()),
          ),
          GoRoute(
            path: '/shop/orders',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const ShopOrdersScreen()),
          ),
          GoRoute(
            path: '/shop/orders/:orderId',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopOrderDetailScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/packing',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopPackingScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/delivery-request',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopDeliveryRequestScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/searching-driver',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopSearchingDriverScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/courier-assigned',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopCourierAssignedScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/handover',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopHandoverScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/tracking',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopDeliveryTrackingScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/orders/:orderId/completed',
            pageBuilder: (_, state) => _shellPage(
              state: state,
              child: ShopDeliveryCompletedScreen(
                orderId: state.pathParameters['orderId']!,
              ),
            ),
          ),
          GoRoute(
            path: '/shop/products',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const ShopProductsScreen()),
          ),
          GoRoute(
            path: '/shop/messages',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const ShopMessagesScreen()),
          ),
          GoRoute(
            path: '/shop/profile',
            pageBuilder: (_, state) =>
                _shellPage(state: state, child: const ShopProfileScreen()),
          ),
        ],
      ),
      GoRoute(path: '/shop/add-part', redirect: (_, _) => '/shop/products'),
    ],
  );
});

CustomTransitionPage<void> _shellPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final reducedMotion =
          MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (reducedMotion) {
        return child;
      }
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.03, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
