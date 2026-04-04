import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/chat/pro_chat_state.dart';

void main() {
  Widget buildApp({bool disableAnimations = false}) {
    final container = ProviderContainer();
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

  Future<ProviderContainer> pumpApp(
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

  group('pro chat workflow', () {
    testWidgets(
      'workshop, shop, and courier inbox routes render shared chats UI with active footer state',
      (tester) async {
        final container = await pumpApp(tester, disableAnimations: true);
        final router = container.read(proRouterProvider);

        router.go('/workshop/messages');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('workshopMessagesScreen')), findsOneWidget);
        expect(find.text('Chats'), findsOneWidget);
        expect(
          footerLabelColor(
            tester,
            const Key('workshopFooterItem-messages'),
            'MESSAGES',
          ),
          isNot(
            footerLabelColor(
              tester,
              const Key('workshopFooterItem-dashboard'),
              'DASHBOARD',
            ),
          ),
        );

        router.go('/shop/messages');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('shopMessagesScreen')), findsOneWidget);
        expect(find.text('Chats'), findsOneWidget);
        expect(
          footerLabelColor(
            tester,
            const Key('shopFooterItem-messages'),
            'MESSAGES',
          ),
          isNot(
            footerLabelColor(
              tester,
              const Key('shopFooterItem-dashboard'),
              'DASHBOARD',
            ),
          ),
        );

        router.go('/driver/messages');
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('driverMessagesScreen')), findsOneWidget);
        expect(find.text('Chats'), findsOneWidget);
        expect(
          footerLabelColor(
            tester,
            const Key('driverFooterItem-messages'),
            'MESSAGES',
          ),
          isNot(
            footerLabelColor(
              tester,
              const Key('driverFooterItem-dashboard'),
              'DASHBOARD',
            ),
          ),
        );
      },
    );

    testWidgets(
      'role thread routes render outside shell with back control and no footer',
      (tester) async {
        final container = await pumpApp(tester, disableAnimations: true);
        final router = container.read(proRouterProvider);

        router.go('/workshop/messages/workshop-thread-ava');
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('workshopMessageThreadScreen')),
          findsOneWidget,
        );
        expect(find.byIcon(Icons.arrow_back_ios_new_rounded), findsOneWidget);
        expect(
          find.byKey(const Key('workshopFooterItem-messages')),
          findsNothing,
        );

        router.go('/shop/messages/shop-thread-trendz');
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('shopMessageThreadScreen')),
          findsOneWidget,
        );
        expect(find.byKey(const Key('shopFooterItem-messages')), findsNothing);

        router.go('/driver/messages/driver-thread-dispatch');
        await tester.pumpAndSettle();
        expect(
          find.byKey(const Key('driverMessageThreadScreen')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('driverFooterItem-messages')),
          findsNothing,
        );
      },
    );

    testWidgets('mock inbox opens a thread and returns back to the shell tab', (
      tester,
    ) async {
      final container = await pumpApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/shop/messages');
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('shopThread-shop-thread-trendz')),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopMessageThreadScreen')), findsOneWidget);
      expect(find.byKey(const Key('shopFooterItem-messages')), findsNothing);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopMessagesScreen')), findsOneWidget);
      expect(find.byKey(const Key('shopFooterItem-messages')), findsOneWidget);
    });

    testWidgets('sending a message updates the mock thread state', (
      tester,
    ) async {
      final container = await pumpApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/driver/messages/driver-thread-shop');
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'At the gate now');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.send_rounded));
      await tester.pumpAndSettle();

      final thread = container
          .read(proChatProvider)
          .roleState(ProChatRole.driver)
          .threadById('driver-thread-shop');
      expect(thread?.lastMessage?.text, 'At the gate now');
      expect(thread?.unreadCount, 0);
    });

    testWidgets('reduced motion thread route still renders cleanly', (
      tester,
    ) async {
      final container = await pumpApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/driver/messages/driver-thread-workshop');
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('driverMessageThreadScreen')),
        findsOneWidget,
      );
      expect(find.byType(OcChatComposer), findsOneWidget);
    });
  });
}
