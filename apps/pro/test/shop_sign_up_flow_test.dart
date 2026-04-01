import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/shared/partner_flow_widgets.dart';
import 'package:pro/screens/shop/shop_dashboard.dart';
import 'package:pro/screens/shop/shop_sign_up_complete_screen.dart';
import 'package:pro/screens/shop/shop_sign_up_state.dart';

class _FakeShopBusinessLicensePicker implements ShopBusinessLicensePicker {
  _FakeShopBusinessLicensePicker({this.path});

  final String? path;
  ImageSource? lastSource;

  @override
  Future<String?> pickImage({required ImageSource source}) async {
    lastSource = source;
    return path;
  }
}

void main() {
  Widget buildApp({
    Locale locale = const Locale('en'),
    List<Override> overrides = const [],
  }) {
    final container = ProviderContainer(overrides: overrides);
    final router = container.read(proRouterProvider);
    addTearDown(container.dispose);

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: OcTheme.light,
        darkTheme: OcTheme.dark,
        themeMode: ThemeMode.dark,
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  Future<void> fillRequiredFields(WidgetTester tester) async {
    await tester.enterText(
      find.byKey(const Key('shopNameField')),
      'Apex Performance Parts',
    );
    await tester.enterText(
      find.byKey(const Key('shopContactNameField')),
      'Jane Parts',
    );
    await tester.enterText(
      find.byKey(const Key('shopPhoneField')),
      '+1 555 000 9999',
    );
    await tester.enterText(
      find.byKey(const Key('shopLocationField')),
      '122 Industrial Way',
    );
    await tester.ensureVisible(find.byKey(const Key('shopCategory-engine')));
    await tester.tap(find.byKey(const Key('shopCategory-engine')));
    await tester.pumpAndSettle();
  }

  group('shop sign-up flow', () {
    testWidgets('shop role card opens the sign-up route', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shopRoleCard')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopSignUpScreen')), findsOneWidget);
    });

    testWidgets('draft values restore when reopening the sign-up route', (
      tester,
    ) async {
      final draft = ShopRegistrationDraft(
        shopName: 'Stored Shop',
        contactName: 'Stored Contact',
        phone: '+1 555 101 2020',
        location: 'Stored Address',
        selectedCategories: const {ShopInventoryCategory.body},
        businessLicenseImagePath: '/tmp/license.png',
      );

      await tester.pumpWidget(
        buildApp(
          overrides: [
            shopRegistrationDraftProvider.overrideWith(
              ShopRegistrationDraftNotifier.new,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(UncontrolledProviderScope));
      final container = ProviderScope.containerOf(element);
      container.read(shopRegistrationDraftProvider.notifier).saveDraft(draft);

      container.read(proRouterProvider).go('/shop/sign-up');
      await tester.pumpAndSettle();

      expect(find.text('Stored Shop'), findsOneWidget);
      expect(find.text('Stored Contact'), findsOneWidget);
      expect(find.text('+1 555 101 2020'), findsOneWidget);
      expect(find.text('/tmp/license.png'.split('/').last), findsOneWidget);
    });

    testWidgets('submit stays blocked until category and upload are added', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final router = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      ).read(proRouterProvider);
      router.go('/shop/sign-up');
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('shopSignUpSubmitButton')),
            )
            .onPressed,
        isNull,
      );

      await fillRequiredFields(tester);

      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('shopSignUpSubmitButton')),
            )
            .onPressed,
        isNull,
      );
      expect(find.byKey(const Key('shopPrivacySheet')), findsNothing);
    });

    testWidgets('save as draft stores state and returns to roles', (
      tester,
    ) async {
      final picker = _FakeShopBusinessLicensePicker(
        path: '/tmp/draft-license.png',
      );
      await tester.pumpWidget(
        buildApp(
          overrides: [
            shopBusinessLicensePickerProvider.overrideWithValue(picker),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/shop/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('shopBusinessLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('shopBusinessLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('shopBusinessLicenseGalleryOption')),
      );
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('shopSignUpSaveDraftButton')),
      );
      await tester.tap(find.byKey(const Key('shopSignUpSaveDraftButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopRoleCard')), findsOneWidget);
      final draft = container.read(shopRegistrationDraftProvider);
      expect(draft.shopName, 'Apex Performance Parts');
      expect(draft.businessLicenseImagePath, '/tmp/draft-license.png');
      expect(draft.selectedCategories, contains(ShopInventoryCategory.engine));
    });

    testWidgets('privacy sheet requires consent before continuing', (
      tester,
    ) async {
      final picker = _FakeShopBusinessLicensePicker(path: '/tmp/license.png');
      await tester.pumpWidget(
        buildApp(
          overrides: [
            shopBusinessLicensePickerProvider.overrideWithValue(picker),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/shop/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('shopBusinessLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('shopBusinessLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const Key('shopBusinessLicenseGalleryOption')),
      );
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('shopSignUpSubmitButton')),
            )
            .onPressed,
        isNotNull,
      );

      await tester.ensureVisible(
        find.byKey(const Key('shopSignUpSubmitButton')),
      );
      await tester.tap(find.byKey(const Key('shopSignUpSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopPrivacySheet')), findsOneWidget);
      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('shopPrivacyContinueButton')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('shopPrivacyCheckbox')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('shopPrivacyContinueButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('shopSignUpCompleteScreen')), findsOneWidget);
      final draft = container.read(shopRegistrationDraftProvider);
      expect(draft.acceptedPrivacy, isTrue);
    });

    testWidgets('start routes to dashboard and clears the draft', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container
          .read(shopRegistrationDraftProvider.notifier)
          .saveDraft(
            const ShopRegistrationDraft(
              shopName: 'Apex',
              acceptedPrivacy: true,
            ),
          );
      container.read(proRouterProvider).go('/shop/sign-up/complete');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('shopSignUpStartButton')));
      await tester.pumpAndSettle();

      expect(find.byType(ShopDashboard), findsOneWidget);
      expect(container.read(shopRegistrationDraftProvider).hasDraft, isFalse);
    });

    testWidgets('reduced motion path still renders completion content', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: const MaterialApp(
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: ShopSignUpCompleteScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('You’re All Set'), findsOneWidget);
      expect(find.byKey(const Key('shopSignUpStartButton')), findsOneWidget);
    });
  });
}
