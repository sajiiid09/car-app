import 'package:consumer/l10n/app_localizations.dart';
import 'package:consumer/providers.dart';
import 'package:consumer/screens/discovery/discovery_content.dart';
import 'package:consumer/screens/discovery/discovery_palette.dart';
import 'package:consumer/screens/home/home_screen.dart';
import 'package:consumer/screens/home/home_shell.dart';
import 'package:consumer/screens/marketplace/marketplace_screen.dart';
import 'package:consumer/screens/orders/orders_screen.dart';
import 'package:consumer/screens/orders/pickup_details_screen.dart';
import 'package:consumer/screens/orders/workshop_selection_screen.dart';
import 'package:consumer/screens/workshops/workshop_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('customer discovery surfaces', () {
    testWidgets('bottom nav order matches the new footer and home is active', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(tester, initialLocation: '/home');

      final profile = find.byKey(const ValueKey('customerNav-/profile'));
      final chat = find.byKey(const ValueKey('customerNav-/chat'));
      final orders = find.byKey(const ValueKey('customerNav-/orders'));
      final map = find.byKey(const ValueKey('customerNav-/map'));
      final home = find.byKey(const ValueKey('customerNav-/home'));

      expect(profile, findsOneWidget);
      expect(chat, findsOneWidget);
      expect(orders, findsOneWidget);
      expect(map, findsOneWidget);
      expect(home, findsOneWidget);
      expect(find.byKey(const ValueKey('customerNav-/marketplace')), findsNothing);

      expect(tester.getTopLeft(profile).dx, lessThan(tester.getTopLeft(chat).dx));
      expect(tester.getTopLeft(chat).dx, lessThan(tester.getTopLeft(orders).dx));
      expect(tester.getTopLeft(orders).dx, lessThan(tester.getTopLeft(map).dx));
      expect(tester.getTopLeft(map).dx, lessThan(tester.getTopLeft(home).dx));

      final animatedContainer = tester.widget<AnimatedContainer>(
        find.descendant(of: home, matching: find.byType(AnimatedContainer)),
      );
      final decoration = animatedContainer.decoration! as BoxDecoration;
      expect(decoration.color, DiscoveryPalette.navActiveBackground);
      expect(router.routeInformationProvider.value.uri.path, '/home');
    });

    testWidgets('avatar opens profile tab and /workshops redirects to map', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(
        tester,
        initialLocation: '/workshops',
      );

      expect(find.byKey(const ValueKey('customerMapPage')), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/map');

      router.go('/home');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('customerTopAvatar')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('profileTarget')), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/profile');
    });

    testWidgets('home keeps discovery sections and routes map and parts correctly', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(tester, initialLocation: '/home');

      expect(find.text('Top Rated Workshop'), findsOneWidget);
      expect(find.text('Popular Parts'), findsOneWidget);
      expect(find.byKey(const ValueKey('customerUploadCard')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('customerViewToggle-list')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('customerMapPage')), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/map');

      router.go('/home');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('customerRouteTab-parts')));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('customerMarketplacePage')), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/marketplace');
    });

    testWidgets('map screen renders chips and routes into workshop selection', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(tester, initialLocation: '/map');

      expect(find.text('Find Nearby Workshops'), findsOneWidget);
      expect(find.text('Roadside'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Workshop'), findsOneWidget);
      expect(find.text('Office'), findsOneWidget);
      expect(find.text('Your Nearby Workshops'), findsOneWidget);

      await tester.tap(find.text('See All'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('customerWorkshopSelectionPage')), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/orders/request/workshops');
    });

    testWidgets('workshop selection leads to pickup details and prefills workshop', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/orders/request/workshops');

      expect(find.text('Choose Workshop'), findsOneWidget);
      await tester.ensureVisible(find.text('Select Workshop').first);
      await tester.tap(find.text('Select Workshop').first);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('customerPickupDetailsPage')), findsOneWidget);
      expect(find.text('Pickup Details'), findsOneWidget);
      expect(find.text('Apex Precision Auto'), findsOneWidget);
      expect(find.textContaining('Porsche 911'), findsOneWidget);
      expect(find.text('The Pearl, Tower 4'), findsOneWidget);
    });

    testWidgets('pickup proceed creates local request and routes to active orders', (
      tester,
    ) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(tester, initialLocation: '/orders/request/workshops');

      await tester.ensureVisible(find.text('Select Workshop').first);
      await tester.tap(find.text('Select Workshop').first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Proceed'));
      await tester.tap(find.text('Proceed'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('customerOrdersPage-active')), findsOneWidget);
      expect(find.text('Active Trackings'), findsOneWidget);
      expect(find.textContaining('Service Booking at Apex Precision Auto'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/orders');
      expect(router.routeInformationProvider.value.uri.queryParameters['tab'], 'active');
    });

    testWidgets('orders tabs switch and live order history renders', (tester) async {
      await _setPhoneViewport(tester);
      final router = await _pumpHarness(tester, initialLocation: '/orders?tab=active');

      expect(find.byKey(const ValueKey('customerOrdersPage-active')), findsOneWidget);
      expect(find.text('Track Package'), findsOneWidget);

      await tester.tap(find.text('Completed'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('customerOrdersPage-completed')), findsOneWidget);
      expect(find.text('Recent History'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.queryParameters['tab'], 'completed');

      await tester.tap(find.text('Cancelled'));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('customerOrdersPage-cancelled')), findsOneWidget);
      expect(find.text('Cancelled'), findsWidgets);
      expect(router.routeInformationProvider.value.uri.queryParameters['tab'], 'cancelled');
    });

    testWidgets('parts explorer still renders as in-flow destination', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/marketplace');

      expect(find.byKey(const ValueKey('customerMarketplacePage')), findsOneWidget);
      expect(find.text('Precision Parts'), findsOneWidget);
      expect(find.text('Engine'), findsWidgets);
      expect(find.text('Brand: Toyota'), findsOneWidget);
      expect(find.text('Front Brake Pads'), findsOneWidget);
    });

    testWidgets('map screenshot matches golden', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/map');

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/customer_map.png'),
      );
    });

    testWidgets('workshop selection screenshot matches golden', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/orders/request/workshops');

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/customer_workshop_selection.png'),
      );
    });

    testWidgets('pickup details screenshot matches golden', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/orders/request/workshops');
      await tester.ensureVisible(find.text('Select Workshop').first);
      await tester.tap(find.text('Select Workshop').first);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/customer_pickup_details.png'),
      );
    });

    testWidgets('orders active screenshot matches golden', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/orders/request/workshops');
      await tester.ensureVisible(find.text('Select Workshop').first);
      await tester.tap(find.text('Select Workshop').first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Proceed'));
      await tester.tap(find.text('Proceed'));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/customer_orders_active.png'),
      );
    });

    testWidgets('updated footer screenshot matches golden', (tester) async {
      await _setPhoneViewport(tester);
      await _pumpHarness(tester, initialLocation: '/map');

      await expectLater(
        find.byType(HomeShell),
        matchesGoldenFile('goldens/customer_footer_map.png'),
      );
    });
  });
}

Future<void> _setPhoneViewport(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Future<GoRouter> _pumpHarness(
  WidgetTester tester, {
  required String initialLocation,
}) async {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/workshops',
        redirect: (_, state) => '/map',
      ),
      GoRoute(
        path: '/cart',
        builder: (_, _) => const Scaffold(body: Text('Cart')),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, _) => const Scaffold(body: Text('Notifications')),
      ),
      GoRoute(
        path: '/vehicle/add',
        builder: (_, _) => const Scaffold(body: Text('Vehicle Add')),
      ),
      GoRoute(
        path: '/part/:id',
        builder: (_, state) => Scaffold(body: Text('Part ${state.pathParameters['id']}')),
      ),
      GoRoute(
        path: '/workshop/:id',
        builder: (_, state) => Scaffold(body: Text('Workshop ${state.pathParameters['id']}')),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (_, state) => Scaffold(body: Text('Order ${state.pathParameters['id']}')),
      ),
      ShellRoute(
        builder: (_, _, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: '/profile',
            builder: (_, _) => const Scaffold(
              body: Center(child: Text('Profile', key: ValueKey('profileTarget'))),
            ),
          ),
          GoRoute(
            path: '/chat',
            builder: (_, _) => const Scaffold(body: Text('Chat')),
          ),
          GoRoute(
            path: '/orders',
            builder: (_, state) => OrdersScreen(
              initialTab: OrdersHistoryTabX.fromQuery(
                state.uri.queryParameters['tab'],
              ),
            ),
          ),
          GoRoute(
            path: '/orders/request/workshops',
            builder: (_, _) => const WorkshopSelectionScreen(),
          ),
          GoRoute(
            path: '/orders/request/pickup',
            builder: (_, _) => const PickupDetailsScreen(),
          ),
          GoRoute(
            path: '/marketplace',
            builder: (_, _) => const MarketplaceScreen(),
          ),
          GoRoute(
            path: '/map',
            builder: (_, _) => const WorkshopListScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, _) => const HomeScreen(),
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userProfileProvider.overrideWith((ref) async => _fakeUser),
        workshopsProvider.overrideWith((ref) async => _fakeWorkshops),
        partsProvider.overrideWith((ref, categoryId) async => _fakeParts),
        myOrdersProvider.overrideWith((ref) async => _fakeOrders),
        unreadNotifCountProvider.overrideWith((ref) => Stream.value(2)),
        vehiclesProvider.overrideWith((ref) async => _fakeVehicles),
        addressesProvider.overrideWith((ref) async => _fakeAddresses),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
}

final _fakeUser = OcUser(
  id: 'user-1',
  phone: '+97450000000',
  name: 'John',
);

final _fakeWorkshops = [
  WorkshopProfile(
    id: 'workshop-1',
    userId: 'owner-1',
    nameAr: 'Apex Precision Auto',
    code: 'OC-001',
    lat: 25.2854,
    lng: 51.5310,
    zone: 'Silicon Oasis',
    avgRating: 4.9,
    specialties: const ['German Engineering', 'Diagnostics'],
  ),
  WorkshopProfile(
    id: 'workshop-2',
    userId: 'owner-2',
    nameAr: 'Velocity Garage',
    code: 'OC-002',
    lat: 25.2862,
    lng: 51.5322,
    zone: 'Al Quoz',
    avgRating: 4.7,
    specialties: const ['General Service', 'Roadside'],
  ),
  WorkshopProfile(
    id: 'workshop-3',
    userId: 'owner-3',
    nameAr: 'Elite Engine Labs',
    code: 'OC-003',
    lat: 25.2821,
    lng: 51.5284,
    zone: 'West End',
    avgRating: 4.8,
    specialties: const ['Engine Specialist', 'Dyno Tuning'],
  ),
];

final _fakeVehicles = [
  Vehicle(
    id: 'vehicle-1',
    userId: 'user-1',
    make: 'Porsche',
    model: '911 Carrera S',
    year: 2024,
    plateNumber: 'QA 91100',
  ),
];

final _fakeAddresses = [
  Address(
    id: 'address-1',
    userId: 'user-1',
    zone: 'The Pearl',
    building: 'Tower 4',
    isDefault: true,
  ),
];

final _fakeParts = [
  Part(
    id: 'part-1',
    shopId: 'shop-1',
    nameAr: 'بطانات فرامل أمامية',
    nameEn: 'Front Brake Pads',
    price: 450,
    imageUrls: const [],
    category: const {'name_en': 'Brake Pads'},
    shop: const {'name_en': 'Toyota Parts Co.'},
  ),
  Part(
    id: 'part-2',
    shopId: 'shop-1',
    nameAr: 'فلتر زيت بريميوم',
    nameEn: 'Premium Oil Filter',
    price: 85,
    imageUrls: const [],
    category: const {'name_en': 'Engine'},
    shop: const {'name_en': 'Denso Original'},
  ),
  Part(
    id: 'part-3',
    shopId: 'shop-2',
    nameAr: 'مصباح أمامي LED',
    nameEn: 'LED Headlight Assy',
    price: 2100,
    imageUrls: const [],
    category: const {'name_en': 'Lighting'},
    shop: const {'name_en': 'Hella Lighting'},
  ),
  Part(
    id: 'part-4',
    shopId: 'shop-3',
    nameAr: 'فلتر هواء عالي التدفق',
    nameEn: 'High-Flow Air Filter',
    price: 320,
    imageUrls: const [],
    category: const {'name_en': 'Engine'},
    shop: const {'name_en': 'K&N Performance'},
  ),
];

final _fakeOrders = [
  Order(
    id: 'order-1',
    consumerId: 'user-1',
    status: 'in_transit',
    total: 2450,
    createdAt: DateTime(2026, 10, 22, 9, 30),
    items: [
      const OrderItem(
        id: 'item-1',
        orderId: 'order-1',
        partId: 'part-1',
        shopId: 'shop-1',
        unitPrice: 2450,
        subtotal: 2450,
        part: {'name_en': 'Carbon Ceramic Brakes'},
      ),
    ],
  ),
  Order(
    id: 'order-2',
    consumerId: 'user-1',
    status: 'completed',
    total: 1450,
    createdAt: DateTime(2026, 10, 12),
    items: [
      const OrderItem(
        id: 'item-2',
        orderId: 'order-2',
        partId: 'part-2',
        shopId: 'shop-1',
        unitPrice: 1450,
        subtotal: 1450,
        part: {'name_en': 'Full Ceramic Coating Package'},
      ),
    ],
  ),
  Order(
    id: 'order-3',
    consumerId: 'user-1',
    status: 'cancelled',
    total: 320,
    createdAt: DateTime(2026, 9, 28),
    items: [
      const OrderItem(
        id: 'item-3',
        orderId: 'order-3',
        partId: 'part-4',
        shopId: 'shop-3',
        unitPrice: 320,
        subtotal: 320,
        part: {'name_en': 'Mobil 1 Advanced Full Synthetic'},
      ),
    ],
  ),
];
