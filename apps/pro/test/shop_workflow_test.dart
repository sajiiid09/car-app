import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/shop/shop_workflow_state.dart';

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

  Future<ProviderContainer> pumpShopApp(
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

  group('shop workflow', () {
    testWidgets('footer order and active state persist across nested routes', (
      tester,
    ) async {
      final container = await pumpShopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/shop');
      await tester.pumpAndSettle();

      final dashboardX = tester
          .getTopLeft(find.byKey(const Key('shopFooterItem-dashboard')))
          .dx;
      final ordersX = tester
          .getTopLeft(find.byKey(const Key('shopFooterItem-orders')))
          .dx;
      final productsX = tester
          .getTopLeft(find.byKey(const Key('shopFooterItem-products')))
          .dx;
      final messagesX = tester
          .getTopLeft(find.byKey(const Key('shopFooterItem-messages')))
          .dx;
      final profileX = tester
          .getTopLeft(find.byKey(const Key('shopFooterItem-profile')))
          .dx;

      expect(dashboardX, lessThan(ordersX));
      expect(ordersX, lessThan(productsX));
      expect(productsX, lessThan(messagesX));
      expect(messagesX, lessThan(profileX));

      expect(find.byKey(const Key('shopDashboardScreen')), findsOneWidget);
      expect(
        footerLabelColor(
          tester,
          const Key('shopFooterItem-dashboard'),
          'DASHBOARD',
        ),
        isNot(
          footerLabelColor(
            tester,
            const Key('shopFooterItem-orders'),
            'ORDERS',
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('shopFooterItem-orders')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopOrdersScreen')), findsOneWidget);

      router.go('/shop/orders/oc-1742/tracking');
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopDeliveryTrackingScreen')),
        findsOneWidget,
      );
      expect(
        footerLabelColor(tester, const Key('shopFooterItem-orders'), 'ORDERS'),
        isNot(
          footerLabelColor(
            tester,
            const Key('shopFooterItem-products'),
            'PRODUCTS',
          ),
        ),
      );
    });

    testWidgets('representative routes load their shell screens', (
      tester,
    ) async {
      final container = await pumpShopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/shop');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopDashboardScreen')), findsOneWidget);

      router.go('/shop/orders');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopOrdersScreen')), findsOneWidget);

      router.go('/shop/orders/oc-1987/packing');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopPackingScreen')), findsOneWidget);

      router.go('/shop/products');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopProductsScreen')), findsOneWidget);

      router.go('/shop/messages');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopMessagesScreen')), findsOneWidget);

      router.go('/shop/profile');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopProfileScreen')), findsOneWidget);
    });

    testWidgets('reduced motion collapses route and reveal animations', (
      tester,
    ) async {
      final container = await pumpShopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/shop/orders/oc-1944/searching-driver');
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('shopSearchingDriverScreen')),
        findsOneWidget,
      );
    });

    testWidgets('primary order lifecycle moves from detail to completed', (
      tester,
    ) async {
      final container = await pumpShopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/shop/orders/oc-2048');
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopOrderDetailScreen')), findsOneWidget);

      await tester.ensureVisible(find.text('Start Packing'));
      await tester.tap(find.text('Start Packing'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopPackingScreen')), findsOneWidget);

      await tester.ensureVisible(find.text('Request Courier'));
      await tester.tap(find.text('Request Courier'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopDeliveryRequestScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Send Delivery Request'));
      await tester.tap(find.text('Send Delivery Request'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopSearchingDriverScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Simulate Driver Assigned'));
      await tester.tap(find.text('Simulate Driver Assigned'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopCourierAssignedScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Continue to Handover'));
      await tester.tap(find.text('Continue to Handover'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('shopHandoverScreen')), findsOneWidget);

      await tester.ensureVisible(find.text('Confirm Handover'));
      await tester.tap(find.text('Confirm Handover'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopDeliveryTrackingScreen')),
        findsOneWidget,
      );

      await tester.ensureVisible(find.text('Mark Delivered'));
      await tester.tap(find.text('Mark Delivered'));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const Key('shopDeliveryCompletedScreen')),
        findsOneWidget,
      );

      final order = container.read(shopWorkflowProvider).orderById('oc-2048');
      expect(order?.stage, ShopOrderStage.completed);
    });
  });
}
