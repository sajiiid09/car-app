import 'package:consumer/screens/auth/forgot_password_screen.dart';
import 'package:consumer/screens/auth/reset_password_screen.dart';
import 'package:consumer/screens/auth/sign_in_screen.dart';
import 'package:consumer/screens/auth/verify_reset_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('password recovery flow', () {
    testWidgets('forgot password entry routes from sign in', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/sign-in'),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('forgotPasswordButton')));
      await tester.tap(find.byKey(const Key('forgotPasswordButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets('valid email routes to verification code screen', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/forgot-password'),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('forgotPasswordEmailField')).byType(TextFormField),
        'asma@example.com',
      );
      await tester.tap(find.byKey(const Key('forgotPasswordSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byType(VerifyResetCodeScreen), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets('otp continues only after four digits and auto-advances', (
      tester,
    ) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/verify-reset'),
      );
      await tester.pumpAndSettle();

      FilledButton continueButton() => tester.widget<FilledButton>(
        find.descendant(
          of: find.byKey(const Key('verifyResetContinueButton')),
          matching: find.byType(FilledButton),
        ),
      );

      expect(continueButton().onPressed, isNull);

      await tester.tap(find.byKey(const Key('otpDigitField-0')));
      await tester.pump();

      tester.testTextInput.enterText('1');
      await tester.pump();

      final secondFieldAfterFirstDigit = tester.widget<TextField>(
        find.byKey(const Key('otpDigitField-1')),
      );
      expect(secondFieldAfterFirstDigit.focusNode?.hasFocus, isTrue);
      expect(continueButton().onPressed, isNull);

      tester.testTextInput.enterText('2');
      await tester.pump();
      tester.testTextInput.enterText('3');
      await tester.pump();
      tester.testTextInput.enterText('4');
      await tester.pumpAndSettle();

      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(continueButton().onPressed, isNotNull);
      await _clearMobileSurface(tester);
    });

    testWidgets('send again clears code and refocuses first cell', (
      tester,
    ) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/verify-reset'),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('otpDigitField-0')));
      await tester.pump();
      tester.testTextInput.enterText('1');
      await tester.pump();
      tester.testTextInput.enterText('2');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('verifyResetResendButton')));
      await tester.pumpAndSettle();

      final firstField = tester.widget<TextField>(
        find.byKey(const Key('otpDigitField-0')),
      );
      expect(firstField.focusNode?.hasFocus, isTrue);
      expect(find.text('1'), findsNothing);
      expect(find.text('2'), findsNothing);
      await _clearMobileSurface(tester);
    });

    testWidgets('valid reset password returns to sign in with success message', (
      tester,
    ) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/reset-password'),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('resetPasswordField')).byType(TextFormField),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('resetPasswordConfirmField')).byType(TextFormField),
        'password123',
      );
      await tester.tap(find.byKey(const Key('resetPasswordConfirmButton')));
      await tester.pumpAndSettle();

      expect(find.byType(SignInScreen), findsOneWidget);
      expect(find.text('Password updated. Sign in to continue.'), findsOneWidget);
      await _clearMobileSurface(tester);
    });

    testWidgets('mismatched passwords block reset', (tester) async {
      await _setMobileSurface(tester);
      await tester.pumpWidget(
        const _RecoveryHarness(initialLocation: '/auth/reset-password'),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('resetPasswordField')).byType(TextFormField),
        'password123',
      );
      await tester.enterText(
        find.byKey(const Key('resetPasswordConfirmField')).byType(TextFormField),
        'password124',
      );
      await tester.tap(find.byKey(const Key('resetPasswordConfirmButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ResetPasswordScreen), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
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

class _RecoveryHarness extends StatelessWidget {
  const _RecoveryHarness({required this.initialLocation});

  final String initialLocation;

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/auth/sign-in', builder: (_, _) => const SignInScreen()),
        GoRoute(
          path: '/auth/forgot-password',
          builder: (_, _) => const ForgotPasswordScreen(),
        ),
        GoRoute(
          path: '/auth/verify-reset',
          builder: (_, _) => const VerifyResetCodeScreen(),
        ),
        GoRoute(
          path: '/auth/reset-password',
          builder: (_, _) => const ResetPasswordScreen(),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
