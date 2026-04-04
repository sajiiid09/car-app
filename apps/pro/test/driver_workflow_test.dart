import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/driver/courier_workflow_state.dart';

void main() {
  Widget buildApp({
    List<Override> overrides = const [],
    bool disableAnimations = false,
  }) {
    final container = ProviderContainer(overrides: overrides);
    final router = container.read(proRouterProvider);
    addTearDown(container.dispose);

    return UncontrolledProviderScope(
      container: container,
      child: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: MaterialApp.router(
          theme: OcTheme.light,
          darkTheme: OcTheme.dark,
          themeMode: ThemeMode.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
  }

  Future<ProviderContainer> pumpDriverApp(
    WidgetTester tester, {
    bool disableAnimations = false,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildApp(disableAnimations: disableAnimations));
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(
      tester.element(find.byType(UncontrolledProviderScope)),
    );
  }

  Color footerLabelColor(WidgetTester tester, Key key, String label) {
    final text = tester.widget<Text>(
      find.descendant(of: find.byKey(key), matching: find.text(label)),
    );
    return text.style?.color ?? Colors.transparent;
  }

  group('driver workflow', () {
    testWidgets('footer order and active state persist across nested routes', (
      tester,
    ) async {
      final container = await pumpDriverApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/driver');
      await tester.pumpAndSettle();

      final dashboardX = tester
          .getTopLeft(find.byKey(const Key('driverFooterItem-dashboard')))
          .dx;
      final ordersX = tester
          .getTopLeft(find.byKey(const Key('driverFooterItem-orders')))
          .dx;
      final earningsX = tester
          .getTopLeft(find.byKey(const Key('driverFooterItem-earnings')))
          .dx;
      final messagesX = tester
          .getTopLeft(find.byKey(const Key('driverFooterItem-messages')))
          .dx;
      final profileX = tester
          .getTopLeft(find.byKey(const Key('driverFooterItem-profile')))
          .dx;

      expect(dashboardX, lessThan(ordersX));
      expect(ordersX, lessThan(earningsX));
      expect(earningsX, lessThan(messagesX));
      expect(messagesX, lessThan(profileX));

      expect(find.byKey(const Key('driverDashboardScreen')), findsOneWidget);
      expect(
        footerLabelColor(
          tester,
          const Key('driverFooterItem-dashboard'),
          'DASHBOARD',
        ),
        isNot(
          footerLabelColor(
            tester,
            const Key('driverFooterItem-orders'),
            'ORDERS',
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('driverFooterItem-orders')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverOrdersScreen')), findsOneWidget);

      router.go('/driver/orders/drv-1014/navigation');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverActiveDeliveryNavigationScreen')),
        findsOneWidget,
      );
      expect(
        footerLabelColor(
          tester,
          const Key('driverFooterItem-orders'),
          'ORDERS',
        ),
        isNot(
          footerLabelColor(
            tester,
            const Key('driverFooterItem-earnings'),
            'EARNINGS',
          ),
        ),
      );
    });

    testWidgets('representative routes load their shell screens', (
      tester,
    ) async {
      final container = await pumpDriverApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/driver');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverDashboardScreen')), findsOneWidget);

      router.go('/driver/orders');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverOrdersScreen')), findsOneWidget);

      router.go('/driver/orders/drv-1014/navigation');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverActiveDeliveryNavigationScreen')),
        findsOneWidget,
      );

      router.go('/driver/earnings');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverEarningsScreen')), findsOneWidget);

      router.go('/driver/messages');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverMessagesScreen')), findsOneWidget);

      router.go('/driver/profile');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('driverProfileScreen')), findsOneWidget);
    });

    testWidgets('reduced motion collapses route and reveal animations', (
      tester,
    ) async {
      final container = await pumpDriverApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/driver/orders/drv-1014/navigation');
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('driverActiveDeliveryNavigationScreen')),
        findsOneWidget,
      );
    });

    testWidgets('delivery lifecycle moves from request to completed', (
      tester,
    ) async {
      final container = await pumpDriverApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/driver/orders/drv-1001');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverNewDeliveryRequestScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const Key('driverAcceptDeliveryButton')),
      );
      await tester.tap(find.byKey(const Key('driverAcceptDeliveryButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverActiveDeliveryNavigationScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const Key('driverNavigationProceedButton')),
      );
      await tester.tap(find.byKey(const Key('driverNavigationProceedButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverConfirmDeliveryScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(
        find.byKey(const Key('driverCompleteDeliveryButton')),
      );
      await tester.tap(find.byKey(const Key('driverCompleteDeliveryButton')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('driverDeliveryCompletedScreen')),
        findsOneWidget,
      );

      final delivery = container
          .read(courierWorkflowProvider)
          .deliveryById('drv-1001');
      expect(delivery?.stage, CourierDeliveryStage.completed);
    });
  });
}
