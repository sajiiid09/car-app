import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';
import 'package:pro/router.dart';
import 'package:pro/screens/workshop/workshop_dashboard.dart';
import 'package:pro/screens/workshop/workshop_workflow_state.dart';

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

  Future<ProviderContainer> pumpWorkshopApp(
    WidgetTester tester, {
    bool disableAnimations = false,
  }) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(buildApp(disableAnimations: disableAnimations));
    await tester.pumpAndSettle();
    final container = ProviderScope.containerOf(
      tester.element(find.byType(UncontrolledProviderScope)),
    );
    return container;
  }

  Color footerLabelColor(WidgetTester tester, Key key, String label) {
    final text = tester.widget<Text>(
      find.descendant(of: find.byKey(key), matching: find.text(label)),
    );
    return text.style?.color ?? Colors.transparent;
  }

  group('workshop workflow', () {
    testWidgets('footer order and active states switch across shell tabs', (
      tester,
    ) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/workshop');
      await tester.pumpAndSettle();

      final dashboardX = tester
          .getTopLeft(find.byKey(const Key('workshopFooterItem-dashboard')))
          .dx;
      final jobsX = tester
          .getTopLeft(find.byKey(const Key('workshopFooterItem-jobs')))
          .dx;
      final messagesX = tester
          .getTopLeft(find.byKey(const Key('workshopFooterItem-messages')))
          .dx;
      final profileX = tester
          .getTopLeft(find.byKey(const Key('workshopFooterItem-profile')))
          .dx;

      expect(dashboardX, lessThan(jobsX));
      expect(jobsX, lessThan(messagesX));
      expect(messagesX, lessThan(profileX));

      expect(find.byType(WorkshopDashboard), findsOneWidget);
      expect(
        footerLabelColor(
          tester,
          const Key('workshopFooterItem-dashboard'),
          'DASHBOARD',
        ),
        isNot(
          footerLabelColor(
            tester,
            const Key('workshopFooterItem-jobs'),
            'JOBS',
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('workshopFooterItem-jobs')));
      await tester.pumpAndSettle();
      expect(find.text('Service Requests'), findsOneWidget);

      await tester.tap(find.byKey(const Key('workshopFooterItem-messages')));
      await tester.pumpAndSettle();
      expect(find.text('Messages'), findsWidgets);

      await tester.tap(find.byKey(const Key('workshopFooterItem-profile')));
      await tester.pumpAndSettle();
      expect(find.text('Workshop Profile'), findsWidgets);
    });

    testWidgets('legacy routes redirect into the new workshop shell', (
      tester,
    ) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);

      router.go('/workshop/find-customer');
      await tester.pumpAndSettle();
      expect(find.text('Service Requests'), findsOneWidget);

      router.go('/provider-profile');
      await tester.pumpAndSettle();
      expect(find.text('Workshop Profile'), findsWidgets);
    });

    testWidgets('dashboard cards route into the correct jobs filters', (
      tester,
    ) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/workshop');
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('workshopMetricTile-new')));
      await tester.pumpAndSettle();
      expect(find.text('Marcus Sterling'), findsOneWidget);
      expect(find.text('BMW M4 Competition'), findsNothing);

      router.go('/workshop');
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('workshopMetricTile-approval')));
      await tester.pumpAndSettle();
      expect(find.text('BMW M4 Competition'), findsOneWidget);
      expect(find.text('Audi RS6 Avant'), findsNothing);
    });

    testWidgets('connected lifecycle moves from new request to completed', (
      tester,
    ) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/workshop/jobs/request/request-911');
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('workshopAcceptRequestButton')),
      );
      await tester.tap(find.byKey(const Key('workshopAcceptRequestButton')));
      await tester.pumpAndSettle();
      expect(find.text('Assign a Driver'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopRequestDriverButton')),
      );
      await tester.tap(find.byKey(const Key('workshopRequestDriverButton')));
      await tester.pumpAndSettle();
      expect(find.text('Incoming Vehicle'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopMarkIncomingArrivedButton')),
      );
      await tester.tap(
        find.byKey(const Key('workshopMarkIncomingArrivedButton')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Active Job Detail'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopStartDiagnosisButton')),
      );
      await tester.tap(find.byKey(const Key('workshopStartDiagnosisButton')));
      await tester.pumpAndSettle();
      expect(find.text('Create Diagnosis'), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('workshopDiagnosisSummaryField')),
        'Rack end damage confirmed with steering assist fault.',
      );
      await tester.enterText(
        find.byKey(const Key('workshopDiagnosisLaborField')),
        '850',
      );
      await tester.enterText(
        find.byKey(const Key('workshopDiagnosisPartsField')),
        '2100',
      );
      await tester.enterText(
        find.byKey(const Key('workshopDiagnosisNotesField')),
        'Replace tie rod assembly, recalibrate steering angle sensor.',
      );
      await tester.ensureVisible(
        find.byKey(const Key('workshopSubmitDiagnosisButton')),
      );
      await tester.tap(find.byKey(const Key('workshopSubmitDiagnosisButton')));
      await tester.pumpAndSettle();
      expect(find.text('Approval Pending'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopMarkApprovedButton')),
      );
      await tester.tap(find.byKey(const Key('workshopMarkApprovedButton')));
      await tester.pumpAndSettle();
      expect(find.text('Service Started'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopMarkServiceCompleteButton')),
      );
      await tester.tap(
        find.byKey(const Key('workshopMarkServiceCompleteButton')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Handover Selection'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopHandoverContinueButton')),
      );
      await tester.tap(find.byKey(const Key('workshopHandoverContinueButton')));
      await tester.pumpAndSettle();
      expect(find.text('Request Return Delivery'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopRequestReturnDriverButton')),
      );
      await tester.tap(
        find.byKey(const Key('workshopRequestReturnDriverButton')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Return Delivery Tracking'), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(const Key('workshopMarkReturnDeliveredButton')),
      );
      await tester.tap(
        find.byKey(const Key('workshopMarkReturnDeliveredButton')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Job Successfully Completed'), findsOneWidget);

      final job = container
          .read(workshopWorkflowProvider)
          .jobById('request-911');
      expect(job?.stage, WorkshopJobStage.completed);
    });

    testWidgets('customer pickup path completes directly from handover prep', (
      tester,
    ) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      final router = container.read(proRouterProvider);
      router.go('/workshop/jobs/job/request-audi/handover');
      await tester.pumpAndSettle();

      await tester.ensureVisible(
        find.byKey(const Key('workshopHandoverMode-customer')),
      );
      await tester.tap(find.byKey(const Key('workshopHandoverMode-customer')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(
        find.byKey(const Key('workshopHandoverContinueButton')),
      );
      await tester.tap(find.byKey(const Key('workshopHandoverContinueButton')));
      await tester.pumpAndSettle();

      expect(find.text('Job Successfully Completed'), findsOneWidget);
      final job = container
          .read(workshopWorkflowProvider)
          .jobById('request-audi');
      expect(job?.handoverMode, WorkshopHandoverMode.customerPickup);
      expect(job?.stage, WorkshopJobStage.completed);
    });
  });

  group('workshop goldens', () {
    testWidgets('dashboard', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container.read(proRouterProvider).go('/workshop');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_dashboard.png'),
      );
    });

    testWidgets('jobs', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container.read(proRouterProvider).go('/workshop/jobs');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_jobs.png'),
      );
    });

    testWidgets('request detail', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/request/request-911');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_request_detail.png'),
      );
    });

    testWidgets('request driver', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .acceptRequest('request-911');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/request/request-911/driver');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_request_driver.png'),
      );
    });

    testWidgets('incoming tracking', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .acceptRequest('request-911');
      container
          .read(workshopWorkflowProvider.notifier)
          .assignDriver('request-911');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/request/request-911/incoming');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_incoming_tracking.png'),
      );
    });

    testWidgets('create diagnosis', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .acceptRequest('request-911');
      container
          .read(workshopWorkflowProvider.notifier)
          .assignDriver('request-911');
      container
          .read(workshopWorkflowProvider.notifier)
          .markIncomingArrived('request-911');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-911/diagnosis');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_create_diagnosis.png'),
      );
    });

    testWidgets('approval pending', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-bmw/approval-pending');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_approval_pending.png'),
      );
    });

    testWidgets('service in progress', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-gt3/in-progress');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_service_in_progress.png'),
      );
    });

    testWidgets('handover prep', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-audi/handover');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_handover_prep.png'),
      );
    });

    testWidgets('request return delivery', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .requestReturnDelivery('request-audi');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-audi/request-return');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_request_return.png'),
      );
    });

    testWidgets('return tracking', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .requestReturnDelivery('request-audi');
      container
          .read(workshopWorkflowProvider.notifier)
          .startReturnTracking('request-audi');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-audi/return-tracking');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_return_tracking.png'),
      );
    });

    testWidgets('job completed', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container
          .read(workshopWorkflowProvider.notifier)
          .markCustomerPickupComplete('request-audi');
      container
          .read(proRouterProvider)
          .go('/workshop/jobs/job/request-audi/completed');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_job_completed.png'),
      );
    });

    testWidgets('messages', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container.read(proRouterProvider).go('/workshop/messages');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_messages.png'),
      );
    });

    testWidgets('profile', (tester) async {
      final container = await pumpWorkshopApp(tester, disableAnimations: true);
      container.read(proRouterProvider).go('/workshop/profile');
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/workshop_profile.png'),
      );
    });
  });
}
