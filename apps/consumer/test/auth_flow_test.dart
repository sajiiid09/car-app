import 'package:consumer/screens/auth/auth_complete_screen.dart';
import 'package:consumer/screens/auth/login_screen.dart';
import 'package:consumer/screens/auth/sign_in_screen.dart';
import 'package:consumer/screens/auth/sign_up_screen.dart';
import 'package:consumer/screens/vehicles/vehicle_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('auth welcome flow', () {
    testWidgets(
      'create account opens role sheet and only customer can continue',
      (tester) async {
        await _setMobileSurface(tester);
        await tester.pumpWidget(const _FlowHarness(initialLocation: '/login'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('authWelcomeCreateAccountButton')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('roleSelectionSheet')), findsOneWidget);

        final enabledContinue = tester.widget<FilledButton>(
          find.descendant(
            of: find.byKey(const Key('roleContinueButton')),
            matching: find.byType(FilledButton),
          ),
        );
        expect(enabledContinue.onPressed, isNotNull);

        await tester.ensureVisible(find.byKey(const Key('roleOption-driver')));
        await tester.tap(find.byKey(const Key('roleOption-driver')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('roleComingSoonHelper')), findsOneWidget);

        final continueButton = tester.widget<FilledButton>(
          find.descendant(
            of: find.byKey(const Key('roleContinueButton')),
            matching: find.byType(FilledButton),
          ),
        );
        expect(continueButton.onPressed, isNull);

        await tester.ensureVisible(find.byKey(const Key('roleSkipButton')));
        await tester.tap(find.byKey(const Key('roleSkipButton')));
        await tester.pumpAndSettle();

        expect(find.text('Create Account'), findsOneWidget);
        expect(find.byType(SignUpScreen), findsOneWidget);
        await _clearMobileSurface(tester);
      },
    );

    testWidgets('sign in footer link routes to sign up', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(const _FlowHarness(initialLocation: '/auth/sign-in'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('signInToSignUpLink')));
      await tester.tap(find.byKey(const Key('signInToSignUpLink')));
      await tester.pumpAndSettle();

      expect(find.byType(SignUpScreen), findsOneWidget);
      await _clearMobileSurface(tester);
    });
  });

  group('sign up flow', () {
    testWidgets(
      'valid sign up opens privacy sheet and requires consent before continuing',
      (tester) async {
        await _setMobileSurface(tester);
        await tester.pumpWidget(const _FlowHarness(initialLocation: '/auth/sign-up'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.byKey(const Key('signUpNameField')).byType(TextFormField),
          'Asma Islam',
        );
        await tester.enterText(
          find.byKey(const Key('signUpEmailField')).byType(TextFormField),
          'asma@example.com',
        );
        await tester.enterText(
          find.byKey(const Key('signUpPasswordField')).byType(TextFormField),
          'password123',
        );
        await tester.enterText(
          find.byKey(const Key('signUpConfirmPasswordField')).byType(TextFormField),
          'password123',
        );
        await tester.ensureVisible(find.byKey(const Key('signUpSubmitButton')));
        await tester.tap(find.byKey(const Key('signUpSubmitButton')));
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('privacySheet')), findsOneWidget);

        final continueButton = tester.widget<FilledButton>(
          find.descendant(
            of: find.byKey(const Key('privacyContinueButton')),
            matching: find.byType(FilledButton),
          ),
        );
        expect(continueButton.onPressed, isNull);

        await tester.ensureVisible(find.byKey(const Key('privacyCheckbox')));
        await tester.tap(find.byKey(const Key('privacyCheckbox')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('privacyContinueButton')));
        await tester.tap(find.byKey(const Key('privacyContinueButton')));
        await tester.pumpAndSettle();

        expect(find.byType(VehicleAddScreen), findsOneWidget);
        await _clearMobileSurface(tester);
      },
    );
  });

  group('vehicle setup flow', () {
    testWidgets('skip for now routes to completion and then home', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(const _FlowHarness(initialLocation: '/vehicle/add'));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('vehicleSkipButton')));
      await tester.tap(find.byKey(const Key('vehicleSkipButton')));
      await tester.pumpAndSettle();

      expect(find.byType(AuthCompleteScreen), findsOneWidget);
      await tester.tap(find.byKey(const Key('authCompleteStartButton')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('homeTarget')), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets('valid vehicle details route to completion', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(const _FlowHarness(initialLocation: '/vehicle/add'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('vehicleBrandField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('BMW').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('vehicleModelField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3 Series').last);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('vehicleYearField')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('${DateTime.now().year}').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Petrol'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('vehiclePlateField')).byType(TextFormField),
        'DOHA-1321',
      );
      await tester.ensureVisible(find.byKey(const Key('vehicleAddSubmitButton')));
      await tester.tap(find.byKey(const Key('vehicleAddSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byType(AuthCompleteScreen), findsOneWidget);
      await _clearMobileSurface(tester);
    });
  });

  group('sign in flow', () {
    testWidgets('valid local sign in routes to home', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(const _FlowHarness(initialLocation: '/auth/sign-in'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('signInEmailField')).byType(TextFormField),
        'asma@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('signInPasswordField')).byType(TextFormField),
        'password123',
      );
      await tester.tap(find.byKey(const Key('signInSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('homeTarget')), findsOneWidget);
      await _clearMobileSurface(tester);
    });
  });
}

extension on Finder {
  Finder byType(Type type) => find.descendant(of: this, matching: find.byType(type));
}

Future<void> _setMobileSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
}

Future<void> _clearMobileSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(null);
}

class _FlowHarness extends StatelessWidget {
  const _FlowHarness({required this.initialLocation});

  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
        GoRoute(path: '/auth/sign-in', builder: (_, _) => const SignInScreen()),
        GoRoute(path: '/auth/sign-up', builder: (_, _) => const SignUpScreen()),
        GoRoute(
          path: '/vehicle/add',
          builder: (_, _) => const VehicleAddScreen(),
        ),
        GoRoute(
          path: '/auth/complete',
          builder: (_, _) => const AuthCompleteScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const SizedBox(key: Key('homeTarget')),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
