import 'package:consumer/first_run.dart';
import 'package:consumer/screens/auth/onboarding_screen.dart';
import 'package:consumer/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('locale resolution', () {
    test('stored locale wins over device locale', () {
      final locale = resolveOnlyCarsLocale(
        storedLocaleCode: 'ar',
        deviceLocales: const [Locale('en'), Locale('ar')],
      );

      expect(locale.languageCode, 'ar');
    });

    test('unsupported device locale falls back to english', () {
      final locale = resolveOnlyCarsLocale(
        deviceLocales: const [Locale('fr'), Locale('bn')],
      );

      expect(locale.languageCode, 'en');
    });
  });

  group('splash routing', () {
    testWidgets('fresh launch routes to onboarding', (tester) async {
      await _setMobileSurface(tester);
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        _TestHarness(
          sharedPreferences: prefs,
          initialLocation: '/splash',
          routes: [
            GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
            GoRoute(
              path: '/onboarding',
              builder: (_, _) => const SizedBox(key: Key('onboardingTarget')),
            ),
            GoRoute(
              path: '/login',
              builder: (_, _) => const SizedBox(key: Key('loginTarget')),
            ),
          ],
        ),
      );

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('onboardingTarget')), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets('returning launch routes to login', (tester) async {
      await _setMobileSurface(tester);
      SharedPreferences.setMockInitialValues({'hasCompletedOnboarding': true});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        _TestHarness(
          sharedPreferences: prefs,
          initialLocation: '/splash',
          routes: [
            GoRoute(path: '/splash', builder: (_, _) => const SplashScreen()),
            GoRoute(
              path: '/onboarding',
              builder: (_, _) => const SizedBox(key: Key('onboardingTarget')),
            ),
            GoRoute(
              path: '/login',
              builder: (_, _) => const SizedBox(key: Key('loginTarget')),
            ),
          ],
        ),
      );

      await tester.pump(const Duration(milliseconds: 1500));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('loginTarget')), findsOneWidget);
      await _clearMobileSurface(tester);
    });
  });

  group('onboarding flow', () {
    testWidgets(
      'skip jumps to the third onboarding page and opens language sheet',
      (tester) async {
        await _setMobileSurface(tester);
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          _TestHarness(
            sharedPreferences: prefs,
            initialLocation: '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (_, _) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, _) => const SizedBox(key: Key('loginTarget')),
              ),
            ],
          ),
        );

        expect(find.text('Find Nearby Workshops'), findsOneWidget);
        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Stay updated with your service and delivery status in real time',
          ),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('onboardingIndicator-2-active')),
          findsOneWidget,
        );

        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('languageSelectionSheet')), findsOneWidget);
        await _clearMobileSurface(tester);
      },
    );

    testWidgets(
      'continue persists locale and onboarding completion, then navigates to login',
      (tester) async {
        await _setMobileSurface(tester);
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          _TestHarness(
            sharedPreferences: prefs,
            initialLocation: '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (_, _) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, _) => const SizedBox(key: Key('loginTarget')),
              ),
            ],
          ),
        );

        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();

        await tester.ensureVisible(find.byKey(const Key('languageOption-ar')));
        await tester.tap(find.byKey(const Key('languageOption-ar')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(
          find.byKey(const Key('languageContinueButton')),
        );
        await tester.tap(find.byKey(const Key('languageContinueButton')));
        await tester.pumpAndSettle();

        expect(prefs.getBool('hasCompletedOnboarding'), isTrue);
        expect(prefs.getString('preferredLocaleCode'), 'ar');
        expect(find.byKey(const Key('loginTarget')), findsOneWidget);
        await _clearMobileSurface(tester);
      },
    );

    testWidgets('skip for now completes onboarding without overriding locale', (
      tester,
    ) async {
      await _setMobileSurface(tester);
      SharedPreferences.setMockInitialValues({'preferredLocaleCode': 'en'});
      final prefs = await SharedPreferences.getInstance();

      await tester.pumpWidget(
        _TestHarness(
          sharedPreferences: prefs,
          initialLocation: '/onboarding',
          routes: [
            GoRoute(
              path: '/onboarding',
              builder: (_, _) => const OnboardingScreen(),
            ),
            GoRoute(
              path: '/login',
              builder: (_, _) => const SizedBox(key: Key('loginTarget')),
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(const Key('firstRunCtaButton')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('firstRunCtaButton')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('languageSkipButton')));
      await tester.tap(find.byKey(const Key('languageSkipButton')));
      await tester.pumpAndSettle();

      expect(prefs.getBool('hasCompletedOnboarding'), isTrue);
      expect(prefs.getString('preferredLocaleCode'), 'en');
      expect(find.byKey(const Key('loginTarget')), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets(
      'close button dismisses language sheet and stays on onboarding',
      (tester) async {
        await _setMobileSurface(tester);
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();

        await tester.pumpWidget(
          _TestHarness(
            sharedPreferences: prefs,
            initialLocation: '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (_, _) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/login',
                builder: (_, _) => const SizedBox(key: Key('loginTarget')),
              ),
            ],
          ),
        );

        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('firstRunCtaButton')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('languageSelectionSheet')), findsOneWidget);
        await tester.tap(find.byKey(const Key('languageSheetCloseButton')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('languageSelectionSheet')), findsNothing);
        expect(find.text('Track Your Orders'), findsOneWidget);
        expect(find.byKey(const Key('loginTarget')), findsNothing);
        await _clearMobileSurface(tester);
      },
    );
  });
}

Future<void> _setMobileSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
}

Future<void> _clearMobileSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(null);
}

class _TestHarness extends StatelessWidget {
  const _TestHarness({
    required this.sharedPreferences,
    required this.initialLocation,
    required this.routes,
  });

  final SharedPreferences sharedPreferences;
  final String initialLocation;
  final List<RouteBase> routes;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(initialLocation: initialLocation, routes: routes);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: Consumer(
        builder: (context, ref, _) {
          return MaterialApp.router(
            locale: ref.watch(appLocaleProvider),
            supportedLocales: supportedFirstRunLocales,
            routerConfig: router,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
