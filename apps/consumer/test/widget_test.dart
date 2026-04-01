import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:consumer/screens/auth/login_screen.dart';

void main() {
  group('LoginScreen', () {
    testWidgets('renders welcome actions', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: LoginScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Welcome to OnlyCars'), findsOneWidget);
      expect(find.byKey(const Key('authWelcomeCreateAccountButton')), findsOneWidget);
      expect(find.byKey(const Key('authWelcomeSignInButton')), findsOneWidget);
    });
  });
}
