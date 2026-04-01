import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/workshop/workshop_sign_up_complete_screen.dart';
import 'package:pro/screens/workshop/workshop_dashboard.dart';
import 'package:pro/screens/workshop/workshop_sign_up_screen.dart';
import 'package:pro/screens/workshop/workshop_sign_up_state.dart';

class _FakeTradeLicensePicker implements WorkshopTradeLicensePicker {
  _FakeTradeLicensePicker({this.path});

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
      find.byKey(const Key('workshopNameField')),
      'Apex Performance',
    );
    await tester.enterText(
      find.byKey(const Key('workshopOwnerField')),
      'Jane Workshop',
    );
    await tester.enterText(
      find.byKey(const Key('workshopPhoneField')),
      '+1 555 000 9999',
    );
    await tester.enterText(
      find.byKey(const Key('workshopLocationField')),
      '122 Industrial Way',
    );
    await tester.ensureVisible(
      find.byKey(const Key('workshopSpecialty-engine')),
    );
    await tester.tap(find.byKey(const Key('workshopSpecialty-engine')));
    await tester.pumpAndSettle();
  }

  group('workshop sign-up flow', () {
    testWidgets('workshop role card opens the sign-up route', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('workshopRoleCard')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workshopSignUpScreen')), findsOneWidget);
    });

    testWidgets('draft values restore when reopening the sign-up route', (
      tester,
    ) async {
      final draft = WorkshopRegistrationDraft(
        workshopName: 'Stored Workshop',
        ownerName: 'Stored Owner',
        phone: '+1 555 101 2020',
        location: 'Stored Address',
        selectedSpecialties: const {WorkshopSpecialty.paint},
        tradeLicenseImagePath: '/tmp/license.png',
      );

      await tester.pumpWidget(
        buildApp(
          overrides: [
            workshopRegistrationDraftProvider.overrideWith(
              WorkshopRegistrationDraftNotifier.new,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(UncontrolledProviderScope));
      final container = ProviderScope.containerOf(element);
      container
          .read(workshopRegistrationDraftProvider.notifier)
          .saveDraft(draft);

      container.read(proRouterProvider).go('/workshop/sign-up');
      await tester.pumpAndSettle();

      expect(find.text('Stored Workshop'), findsOneWidget);
      expect(find.text('Stored Owner'), findsOneWidget);
      expect(find.text('+1 555 101 2020'), findsOneWidget);
      expect(find.text('/tmp/license.png'.split('/').last), findsOneWidget);
    });

    testWidgets('submit stays blocked until specialty and upload are added', (
      tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();
      final router = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      ).read(proRouterProvider);
      router.go('/workshop/sign-up');
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<WorkshopGradientButton>(
              find.byKey(const Key('workshopSignUpSubmitButton')),
            )
            .onPressed,
        isNull,
      );

      await fillRequiredFields(tester);

      expect(
        tester
            .widget<WorkshopGradientButton>(
              find.byKey(const Key('workshopSignUpSubmitButton')),
            )
            .onPressed,
        isNull,
      );
      expect(find.byKey(const Key('workshopPrivacySheet')), findsNothing);
    });

    testWidgets('save as draft stores state and returns to roles', (
      tester,
    ) async {
      final picker = _FakeTradeLicensePicker(path: '/tmp/draft-license.png');
      await tester.pumpWidget(
        buildApp(
          overrides: [
            workshopTradeLicensePickerProvider.overrideWithValue(picker),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/workshop/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('tradeLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('tradeLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tradeLicenseGalleryOption')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('workshopSignUpSaveDraftButton')),
      );
      await tester.tap(find.byKey(const Key('workshopSignUpSaveDraftButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workshopRoleCard')), findsOneWidget);
      final draft = container.read(workshopRegistrationDraftProvider);
      expect(draft.workshopName, 'Apex Performance');
      expect(draft.tradeLicenseImagePath, '/tmp/draft-license.png');
      expect(draft.selectedSpecialties, contains(WorkshopSpecialty.engine));
    });

    testWidgets('privacy sheet requires consent before continuing', (
      tester,
    ) async {
      final picker = _FakeTradeLicensePicker(path: '/tmp/license.png');
      await tester.pumpWidget(
        buildApp(
          overrides: [
            workshopTradeLicensePickerProvider.overrideWithValue(picker),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/workshop/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('tradeLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('tradeLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tradeLicenseGalleryOption')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<WorkshopGradientButton>(
              find.byKey(const Key('workshopSignUpSubmitButton')),
            )
            .onPressed,
        isNotNull,
      );

      await tester.ensureVisible(
        find.byKey(const Key('workshopSignUpSubmitButton')),
      );
      await tester.tap(find.byKey(const Key('workshopSignUpSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('workshopPrivacySheet')), findsOneWidget);
      expect(
        tester
            .widget<WorkshopGradientButton>(
              find.byKey(const Key('workshopPrivacyContinueButton')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('workshopPrivacyCheckbox')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workshopPrivacyContinueButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('workshopSignUpCompleteScreen')),
        findsOneWidget,
      );
      final draft = container.read(workshopRegistrationDraftProvider);
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
          .read(workshopRegistrationDraftProvider.notifier)
          .saveDraft(
            const WorkshopRegistrationDraft(
              workshopName: 'Apex',
              acceptedPrivacy: true,
            ),
          );
      container.read(proRouterProvider).go('/workshop/sign-up/complete');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('workshopSignUpStartButton')));
      await tester.pumpAndSettle();

      expect(find.byType(WorkshopDashboard), findsOneWidget);
      expect(
        container.read(workshopRegistrationDraftProvider).hasDraft,
        isFalse,
      );
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
              home: WorkshopSignUpCompleteScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('You’re All Set'), findsOneWidget);
      expect(
        find.byKey(const Key('workshopSignUpStartButton')),
        findsOneWidget,
      );
    });
  });
}
