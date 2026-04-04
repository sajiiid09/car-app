import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/driver/driver_sign_up_complete_screen.dart';
import 'package:pro/screens/driver/driver_sign_up_state.dart';
import 'package:pro/screens/shared/partner_flow_widgets.dart';

class _FakeDriverLicensePicker implements DriverLicensePicker {
  _FakeDriverLicensePicker({this.path});

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
      find.byKey(const Key('driverFullNameField')),
      'John Driver',
    );
    await tester.enterText(
      find.byKey(const Key('driverPhoneField')),
      '+1 555 000 9999',
    );
    await tester.ensureVisible(find.byKey(const Key('driverVehicleType-car')));
    await tester.tap(find.byKey(const Key('driverVehicleType-car')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('driverServiceAreaField')));
    await tester.tap(find.byKey(const Key('driverServiceAreaField')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Downtown District').last);
    await tester.pumpAndSettle();
  }

  group('driver sign-up flow', () {
    testWidgets('driver role card opens the sign-up route', (tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('driverRoleCard')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('driverSignUpScreen')), findsOneWidget);
    });

    testWidgets('draft values restore when reopening the sign-up route', (
      tester,
    ) async {
      final draft = DriverRegistrationDraft(
        fullName: 'Stored Driver',
        phone: '+1 555 101 2020',
        vehicleType: DriverVehicleType.van,
        serviceArea: DriverServiceArea.airportZone,
        driversLicenseImagePath: '/tmp/license.png',
      );

      await tester.pumpWidget(
        buildApp(
          overrides: [
            driverRegistrationDraftProvider.overrideWith(
              DriverRegistrationDraftNotifier.new,
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      final element = tester.element(find.byType(UncontrolledProviderScope));
      final container = ProviderScope.containerOf(element);
      container.read(driverRegistrationDraftProvider.notifier).saveDraft(draft);

      container.read(proRouterProvider).go('/driver/sign-up');
      await tester.pumpAndSettle();

      expect(find.text('Stored Driver'), findsOneWidget);
      expect(find.text('+1 555 101 2020'), findsOneWidget);
      expect(find.text('Airport Zone'), findsOneWidget);
      expect(find.text('/tmp/license.png'.split('/').last), findsOneWidget);
    });

    testWidgets(
      'submit stays blocked until vehicle type service area and upload are added',
      (tester) async {
        await tester.pumpWidget(buildApp());
        await tester.pumpAndSettle();
        final router = ProviderScope.containerOf(
          tester.element(find.byType(UncontrolledProviderScope)),
        ).read(proRouterProvider);
        router.go('/driver/sign-up');
        await tester.pumpAndSettle();

        expect(
          tester
              .widget<PartnerFlowGradientButton>(
                find.byKey(const Key('driverSignUpSubmitButton')),
              )
              .onPressed,
          isNull,
        );

        await fillRequiredFields(tester);

        expect(
          tester
              .widget<PartnerFlowGradientButton>(
                find.byKey(const Key('driverSignUpSubmitButton')),
              )
              .onPressed,
          isNull,
        );
        expect(find.byKey(const Key('driverPrivacySheet')), findsNothing);
      },
    );

    testWidgets('save as draft stores state and returns to roles', (
      tester,
    ) async {
      final picker = _FakeDriverLicensePicker(path: '/tmp/draft-license.png');
      await tester.pumpWidget(
        buildApp(
          overrides: [driverLicensePickerProvider.overrideWithValue(picker)],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/driver/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('driverLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('driverLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('driverLicenseGalleryOption')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('driverSignUpSaveDraftButton')),
      );
      await tester.tap(find.byKey(const Key('driverSignUpSaveDraftButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('driverRoleCard')), findsOneWidget);
      final draft = container.read(driverRegistrationDraftProvider);
      expect(draft.fullName, 'John Driver');
      expect(draft.driversLicenseImagePath, '/tmp/draft-license.png');
      expect(draft.vehicleType, DriverVehicleType.car);
      expect(draft.serviceArea, DriverServiceArea.downtownDistrict);
    });

    testWidgets('privacy sheet requires consent before continuing', (
      tester,
    ) async {
      final picker = _FakeDriverLicensePicker(path: '/tmp/license.png');
      await tester.pumpWidget(
        buildApp(
          overrides: [driverLicensePickerProvider.overrideWithValue(picker)],
        ),
      );
      await tester.pumpAndSettle();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(UncontrolledProviderScope)),
      );
      container.read(proRouterProvider).go('/driver/sign-up');
      await tester.pumpAndSettle();

      await fillRequiredFields(tester);
      await tester.ensureVisible(
        find.byKey(const Key('driverLicenseUploadCard')),
      );
      await tester.tap(find.byKey(const Key('driverLicenseUploadCard')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('driverLicenseGalleryOption')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('driverSignUpSubmitButton')),
            )
            .onPressed,
        isNotNull,
      );

      await tester.ensureVisible(
        find.byKey(const Key('driverSignUpSubmitButton')),
      );
      await tester.tap(find.byKey(const Key('driverSignUpSubmitButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('driverPrivacySheet')), findsOneWidget);
      expect(
        tester
            .widget<PartnerFlowGradientButton>(
              find.byKey(const Key('driverPrivacyContinueButton')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const Key('driverPrivacyCheckbox')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('driverPrivacyContinueButton')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('driverSignUpCompleteScreen')),
        findsOneWidget,
      );
      final draft = container.read(driverRegistrationDraftProvider);
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
          .read(driverRegistrationDraftProvider.notifier)
          .saveDraft(
            const DriverRegistrationDraft(
              fullName: 'John Driver',
              acceptedPrivacy: true,
            ),
          );
      container.read(proRouterProvider).go('/driver/sign-up/complete');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('driverSignUpStartButton')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('driverDashboardScreen')), findsOneWidget);
      expect(container.read(driverRegistrationDraftProvider).hasDraft, isFalse);
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
              home: DriverSignUpCompleteScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('You’re All Set'), findsOneWidget);
      expect(find.byKey(const Key('driverSignUpStartButton')), findsOneWidget);
    });
  });
}
