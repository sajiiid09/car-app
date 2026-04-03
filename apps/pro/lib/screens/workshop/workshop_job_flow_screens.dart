import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'workshop_shared.dart';
import 'workshop_workflow_state.dart';

class WorkshopJobsScreen extends ConsumerWidget {
  const WorkshopJobsScreen({
    super.key,
    required this.filter,
  });

  final WorkshopJobsFilter filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final jobs = ref.watch(workshopFilteredJobsProvider(filter));
    final workflow = ref.watch(workshopWorkflowProvider);
    final newCount = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.newRequest)
        .length;
    final approvalCount = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.approvalPending)
        .length;
    final handoverCount = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.handoverPrep)
        .length;

    return WorkshopScrollView(
      children: [
        const WorkshopReveal(child: WorkshopTopChrome()),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 30,
          child: WorkshopHeader(
            eyebrow: l10n.workshopOperationsEyebrow,
            title: l10n.workshopServiceRequestsTitle,
            subtitle: l10n.workshopJobsSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 70,
          child: Row(
            children: [
              Expanded(
                child: WorkshopMiniStat(
                  label: l10n.workshopMetricPending,
                  value: '$newCount',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WorkshopMiniStat(
                  label: l10n.workshopMetricApprovalShort,
                  value: '$approvalCount',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WorkshopMiniStat(
                  label: l10n.workshopMetricHandoverShort,
                  value: '$handoverCount',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 110,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _FilterChip(
                key: const Key('workshopJobsFilter-all'),
                label: l10n.workshopJobsFilterAll,
                active: filter == WorkshopJobsFilter.all,
                onTap: () => context.go('/workshop/jobs?filter=all'),
              ),
              _FilterChip(
                key: const Key('workshopJobsFilter-new'),
                label: l10n.workshopJobsFilterNew,
                active: filter == WorkshopJobsFilter.newRequests,
                onTap: () => context.go('/workshop/jobs?filter=new'),
              ),
              _FilterChip(
                key: const Key('workshopJobsFilter-approval'),
                label: l10n.workshopJobsFilterApproval,
                active: filter == WorkshopJobsFilter.approval,
                onTap: () => context.go('/workshop/jobs?filter=approval'),
              ),
              _FilterChip(
                key: const Key('workshopJobsFilter-handover'),
                label: l10n.workshopJobsFilterHandover,
                active: filter == WorkshopJobsFilter.handover,
                onTap: () => context.go('/workshop/jobs?filter=handover'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: MediaQuery.maybeOf(context)?.disableAnimations ?? false
              ? Duration.zero
              : const Duration(milliseconds: 240),
          child: Column(
            key: ValueKey(filter),
            children: [
              for (final (index, job) in jobs.indexed)
                Padding(
                  padding: EdgeInsets.only(bottom: index == jobs.length - 1 ? 0 : 16),
                  child: WorkshopReveal(
                    delay: 130 + (index * 30),
                    child: _JobsListCard(job: job),
                  ),
                ),
              if (jobs.isEmpty)
                WorkshopSurfaceCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 34),
                    child: Center(
                      child: Text(
                        l10n.workshopNoJobsForFilter,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: PartnerFlowPalette.textSecondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkshopRequestDetailScreen extends ConsumerWidget {
  const WorkshopRequestDetailScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(requestId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopRequestNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopRoadsideRequestEyebrow,
            title: l10n.workshopRequestDetailTitle,
            subtitle: l10n.workshopRequestDetailSubtitle,
            trailing: WorkshopStatusChip(
              label: l10n.workshopStageNewRequest,
            ),
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(url: job.imageUrl, height: 210),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.vehicleName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${job.customerName} • ${job.customerPhone}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: PartnerFlowPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: PartnerFlowPalette.primarySoft,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${job.pickupEstimateMinutes} mins',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: PartnerFlowPalette.primaryEnd,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _DetailBlock(
                  label: l10n.workshopRequestIssueLabel,
                  child: Text(
                    job.issueSummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PartnerFlowPalette.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _DetailBlock(
                        label: l10n.workshopRequestLocationLabel,
                        child: Text(
                          job.location,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _DetailBlock(
                        label: l10n.workshopRequestVehicleLabel,
                        child: Text(
                          job.licensePlate,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    WorkshopTag(label: job.requestTypeLabel),
                    WorkshopTag(label: job.specialtyLabel),
                    WorkshopTag(label: job.distanceLabel),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopSecondaryButton(
                        label: l10n.workshopRejectRequest,
                        onPressed: () => context.go('/workshop/jobs?filter=new'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopPrimaryButton(
                        key: const Key('workshopAcceptRequestButton'),
                        label: l10n.workshopAcceptRequest,
                        onPressed: () {
                          ref
                              .read(workshopWorkflowProvider.notifier)
                              .acceptRequest(job.id);
                          context.go('/workshop/jobs/request/${job.id}/driver');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopRequestDriverScreen extends ConsumerWidget {
  const WorkshopRequestDriverScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(requestId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopRequestNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopPickupAcceptedEyebrow,
            title: l10n.workshopAssignDriverTitle,
            subtitle: l10n.workshopAssignDriverSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(icon: Icons.pin_drop_outlined, label: job.location),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: job.issueSummary,
                ),
                const SizedBox(height: 14),
                _InfoRow(
                  icon: Icons.call_outlined,
                  label: job.customerPhone,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 210,
                  child: WorkshopRemoteImage(
                    url:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB9dwXQgwfyJEJ9eESBBRezfbFIlwdeXY_av0uAyTJM5YuJm_SxYYHH5mPuQgdMqG1Xjx05q84YC9oxHOBoUUGVZswDwD810oCV64S5c0GTDliH0b7L6EF9R8XmJBfdHd729pYSGzIWyFjrgSNQzFQo-zukCWj7O1c-eWigVgpCDu3s7i9uVGMAnoQtfpgZJwJt5eNV6Ni4LlCuMvpli65U8lVW1pBCrAiLx1tvl8K1WrI_GNUaH33dh1OHslxo27nLuqgLOmwm5R1t',
                    height: 210,
                  ),
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopRequestDriverButton'),
                  label: l10n.workshopRequestWorkshopDriver,
                  onPressed: () {
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .assignDriver(job.id);
                    context.go('/workshop/jobs/request/${job.id}/incoming');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopIncomingTrackingScreen extends ConsumerWidget {
  const WorkshopIncomingTrackingScreen({
    super.key,
    required this.requestId,
  });

  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(requestId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopRequestNotFound);
    }
    final driver = job.driverAssignment;
    if (driver == null) {
      return WorkshopMissingJobView(title: l10n.workshopDriverUnavailable);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopIncomingEyebrow,
            title: l10n.workshopIncomingVehicleTitle,
            subtitle: l10n.workshopIncomingVehicleSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    WorkshopRemoteImage(
                      url:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBqtz6LLMp9tLFhSj4zeV7OtzRhZjm_pJ7agkIDG1ROIxj8NFFWwdl9pDPkIkh87rXJ87FxIO-F9iEHkXyV3_LRkJBshw-z9Dm2Ig1PUtNR8Ya0Emg0bVhowCD-dUUMEDK4xEiCr7LZe8XwMw_lgAs0ItGSWUoEQTYJ4N-MdJq05ckactDcvu-gkOuiWwOLxeRpsCuUnmw2pmcNnWD63be9r6S3vs4FfwKEO_vkwFEiOQoRq0BRtp2i3e5ClM39KWEZrhhOjWKgSfqT',
                      height: 248,
                    ),
                    Positioned(
                      top: 18,
                      left: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const WorkshopPulseDot(),
                            const SizedBox(width: 10),
                            Text(
                              '${driver.etaMinutes} mins • ${l10n.workshopEtaToWorkshop}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    WorkshopAvatarImage(url: driver.avatarUrl!, size: 60),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${driver.vehicleLabel} • ${driver.phone}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: PartnerFlowPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _TimelineStep(
                  title: 'Driver Assigned',
                  subtitle: 'Dispatch team confirmed the workshop carrier.',
                  active: true,
                ),
                const _TimelineStep(
                  title: 'On the Way',
                  subtitle: 'Carrier is approaching the customer location.',
                  active: true,
                ),
                const _TimelineStep(
                  title: 'Arriving Workshop',
                  subtitle: 'Vehicle check-in will start as soon as it arrives.',
                  active: false,
                ),
                const SizedBox(height: 18),
                WorkshopPrimaryButton(
                  key: const Key('workshopMarkIncomingArrivedButton'),
                  label: l10n.workshopMarkVehicleArrived,
                  onPressed: () {
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .markIncomingArrived(job.id);
                    context.go('/workshop/jobs/job/${job.id}');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopActiveJobDetailScreen extends ConsumerWidget {
  const WorkshopActiveJobDetailScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopActiveJobEyebrow,
            title: l10n.workshopActiveJobTitle,
            subtitle: l10n.workshopActiveJobSubtitle,
            trailing: WorkshopStatusChip(
              label: _activeStageLabel(l10n, job.stage),
              color: _jobStageAccent(job.stage),
            ),
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(url: job.imageUrl, height: 230),
                const SizedBox(height: 18),
                Text(
                  job.vehicleName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  '${job.customerName} • ${job.licensePlate}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopPickupEstimateShort,
                        value: '${job.pickupEstimateMinutes} mins',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopSpecialtyLabel,
                        value: job.specialtyLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailBlock(
                  label: l10n.workshopRequestIssueLabel,
                  child: Text(
                    job.issueSummary,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PartnerFlowPalette.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopStartDiagnosisButton'),
                  label: l10n.workshopStartDiagnosis,
                  onPressed: () => context.go('/workshop/jobs/job/${job.id}/diagnosis'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopDiagnosisApprovalPendingScreen extends ConsumerWidget {
  const WorkshopDiagnosisApprovalPendingScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopApprovalEyebrow,
            title: l10n.workshopApprovalPendingTitle,
            subtitle: l10n.workshopApprovalPendingSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const WorkshopPulseDot(color: PartnerFlowPalette.warning),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.workshopWaitingForCustomer,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailBlock(
                  label: l10n.workshopDiagnosisSummaryLabel,
                  child: Text(
                    job.diagnosisDraft.summary,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopLaborEstimateLabel,
                        value: 'QAR ${job.diagnosisDraft.laborCost.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopPartsEstimateLabel,
                        value: 'QAR ${job.diagnosisDraft.partsCost.toStringAsFixed(0)}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopSecondaryButton(
                        label: l10n.workshopEditReport,
                        onPressed: () => context.go('/workshop/jobs/job/${job.id}/diagnosis'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopPrimaryButton(
                        key: const Key('workshopMarkApprovedButton'),
                        label: l10n.workshopMarkApproved,
                        onPressed: () {
                          ref.read(workshopWorkflowProvider.notifier).markApproved(job.id);
                          context.go('/workshop/jobs/job/${job.id}/in-progress');
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopServiceInProgressScreen extends ConsumerWidget {
  const WorkshopServiceInProgressScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopServiceEyebrow,
            title: l10n.workshopServiceInProgressTitle,
            subtitle: l10n.workshopServiceInProgressSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(url: job.imageUrl, height: 224),
                const SizedBox(height: 18),
                Text(
                  job.vehicleName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.workshopServiceChecklistTitle,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: PartnerFlowPalette.primaryEnd,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                const WorkshopProgressBar(progress: 0.72),
                const SizedBox(height: 18),
                const _ChecklistTile(
                  title: 'Cooling lines installed',
                  subtitle: 'Bay 2 technician completed hardware fitment.',
                  done: true,
                ),
                const SizedBox(height: 12),
                const _ChecklistTile(
                  title: 'Pressure test running',
                  subtitle: 'Cooling system is being tested at operating temperature.',
                  done: true,
                ),
                const SizedBox(height: 12),
                const _ChecklistTile(
                  title: 'Road test pending',
                  subtitle: 'Final verification after workshop quality check.',
                  done: false,
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopMarkServiceCompleteButton'),
                  label: l10n.workshopMarkServiceComplete,
                  onPressed: () {
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .markServiceComplete(job.id);
                    context.go('/workshop/jobs/job/${job.id}/handover');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopHandoverPrepScreen extends ConsumerStatefulWidget {
  const WorkshopHandoverPrepScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  ConsumerState<WorkshopHandoverPrepScreen> createState() =>
      _WorkshopHandoverPrepScreenState();
}

class _WorkshopHandoverPrepScreenState
    extends ConsumerState<WorkshopHandoverPrepScreen> {
  WorkshopHandoverMode _selected = WorkshopHandoverMode.workshopDriver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final job = ref.read(workshopJobProvider(widget.jobId));
    if (job?.handoverMode != null) {
      _selected = job!.handoverMode!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(widget.jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopHandoverEyebrow,
            title: l10n.workshopHandoverTitle,
            subtitle: l10n.workshopHandoverSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(
                  url:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAmySn-2kONn30LfOEG3yMiqozz8XDzCwCldxFlu2_BAM_Wt-Hh4ZBO7_zrkgn-665pLMXLAWww_q7476jFnqPX9_xj6SCD3QokmRMdNNwKY35YWEzxLM38-MnDFc9TR1ZmZSvinGqkkDKFDO-b3RRBjnPUiUXT4vdaTcSEYWks4gU3Itl_UgyuFL22pVm2oz5DWJeBT9W5yNQO3iTVYYiit9KJBD78j9XRXYInG4MLxeGTKaJhMdoFQLHXSjdL3v59QIqvGz25fmIV',
                  height: 214,
                ),
                const SizedBox(height: 18),
                _ModeTile(
                  key: const Key('workshopHandoverMode-driver'),
                  title: l10n.workshopReturnViaDriver,
                  subtitle: l10n.workshopReturnViaDriverSubtitle,
                  selected: _selected == WorkshopHandoverMode.workshopDriver,
                  onTap: () {
                    setState(() => _selected = WorkshopHandoverMode.workshopDriver);
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .chooseHandoverMode(job.id, WorkshopHandoverMode.workshopDriver);
                  },
                ),
                const SizedBox(height: 14),
                _ModeTile(
                  key: const Key('workshopHandoverMode-customer'),
                  title: l10n.workshopCustomerPickup,
                  subtitle: l10n.workshopCustomerPickupSubtitle,
                  selected: _selected == WorkshopHandoverMode.customerPickup,
                  onTap: () {
                    setState(() => _selected = WorkshopHandoverMode.customerPickup);
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .chooseHandoverMode(job.id, WorkshopHandoverMode.customerPickup);
                  },
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopHandoverContinueButton'),
                  label: _selected == WorkshopHandoverMode.workshopDriver
                      ? l10n.workshopRequestReturnDelivery
                      : l10n.workshopCompleteHandover,
                  onPressed: () {
                    if (_selected == WorkshopHandoverMode.workshopDriver) {
                      ref
                          .read(workshopWorkflowProvider.notifier)
                          .requestReturnDelivery(job.id);
                      context.go('/workshop/jobs/job/${job.id}/request-return');
                    } else {
                      ref
                          .read(workshopWorkflowProvider.notifier)
                          .markCustomerPickupComplete(job.id);
                      context.go('/workshop/jobs/job/${job.id}/completed');
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopRequestReturnDeliveryScreen extends ConsumerWidget {
  const WorkshopRequestReturnDeliveryScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopReturnEyebrow,
            title: l10n.workshopRequestReturnTitle,
            subtitle: l10n.workshopRequestReturnSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(
                  url:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuB7L8cdUGGRN4BJGK9_jIaEIYED_O7gCM7tz_xjEFK-s6K33c-f-vzqjhSS0f2C08HhKm3W6T4XG4dcSllTWr_yNsom-m29gYC2T4iaJ3gskA7xmcUSJwbmz2n91UcpSH3UvB73Ore8aLR_kQwi2T4iY4Mu8clDFwWbAOjtTeHiEQE-i88p_pItgyy7UZMsLVzOSc9Y9VVhSpXLj4ukDoo6k56ZvdY4M4JrhnawLw5mhFRqHTXBov_HRYq6jQxxw7_8WQsYI5khDPPH',
                  height: 214,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopPickupEstimateShort,
                        value: '${job.pickupEstimateMinutes + 12} mins',
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: WorkshopMiniStat(
                        label: 'Distance',
                        value: '14 km',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _DetailBlock(
                  label: l10n.workshopReturnDriverNote,
                  child: Text(
                    l10n.workshopReturnDriverNoteBody,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: PartnerFlowPalette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopRequestReturnDriverButton'),
                  label: l10n.workshopRequestDriverForReturn,
                  onPressed: () {
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .startReturnTracking(job.id);
                    context.go('/workshop/jobs/job/${job.id}/return-tracking');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopReturnDeliveryTrackingScreen extends ConsumerWidget {
  const WorkshopReturnDeliveryTrackingScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }
    final driver = job.driverAssignment;
    if (driver == null) {
      return WorkshopMissingJobView(title: l10n.workshopDriverUnavailable);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopReturnTrackingEyebrow,
            title: l10n.workshopReturnTrackingTitle,
            subtitle: l10n.workshopReturnTrackingSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    WorkshopRemoteImage(
                      url:
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuCHEBdsh5F-vFqi1hQ0ZJ01av7PVjd5LsFmEXkKq9SJm7G5VcgaXtlxpUu6zVWtvTztG0n4PbUQOhlpj7MATGg04T2wGIHWcdwD5Rn-YluSbA8q1Wg9Qhd0vzmkXxBJoXJGeseg8JRiZ9zBv0LP_xvtcO5S9V7S3KGofH6SGp1iOlaH6_Fblw0xb2e3BWXnuXKNkzf9qs-0DCRZN1Q1ZFeS5InpMVMwlkJDaZ-sM-KQfxGGqma_-_34HzSEasrXfKrQ_cmTf2h06Mi_',
                      height: 246,
                    ),
                    Positioned(
                      bottom: 18,
                      left: 18,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const WorkshopPulseDot(),
                            const SizedBox(width: 10),
                            Text(
                              l10n.workshopVehicleOutbound,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    WorkshopAvatarImage(url: driver.avatarUrl!, size: 60),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver.name,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${driver.vehicleLabel} • ${driver.phone}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: PartnerFlowPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const _TimelineStep(
                  title: 'Driver Collected Vehicle',
                  subtitle: 'Workshop sign-off complete and en route to customer.',
                  active: true,
                ),
                const _TimelineStep(
                  title: 'Delivery In Progress',
                  subtitle: 'Vehicle is moving through the return route.',
                  active: true,
                ),
                const _TimelineStep(
                  title: 'Customer Handover',
                  subtitle: 'Final keys handoff at the customer location.',
                  active: false,
                ),
                const SizedBox(height: 18),
                WorkshopPrimaryButton(
                  key: const Key('workshopMarkReturnDeliveredButton'),
                  label: l10n.workshopMarkDelivered,
                  onPressed: () {
                    ref
                        .read(workshopWorkflowProvider.notifier)
                        .markReturnDelivered(job.id);
                    context.go('/workshop/jobs/job/${job.id}/completed');
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopJobCompletedScreen extends ConsumerWidget {
  const WorkshopJobCompletedScreen({
    super.key,
    required this.jobId,
  });

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final job = ref.watch(workshopJobProvider(jobId));
    if (job == null) {
      return WorkshopMissingJobView(title: l10n.workshopJobNotFound);
    }

    return WorkshopScrollView(
      children: [
        WorkshopReveal(
          child: WorkshopHeader(
            showBack: true,
            eyebrow: l10n.workshopCompletedEyebrow,
            title: l10n.workshopCompletedTitle,
            subtitle: l10n.workshopCompletedSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: PartnerFlowPalette.primaryGradient,
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 20),
                Text(
                  job.vehicleName,
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                Text(
                  job.statusBody,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopRevenueBreakdown,
                        value: 'QAR ${job.diagnosisDraft.totalCost.toStringAsFixed(0)}',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopCompletionTime,
                        value: '3 hrs 24 mins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                WorkshopPrimaryButton(
                  key: const Key('workshopBackToDashboardButton'),
                  label: l10n.workshopBackToDashboard,
                  onPressed: () => context.go('/workshop'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _JobsListCard extends StatelessWidget {
  const _JobsListCard({required this.job});

  final WorkshopJobRecord job;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('workshopJobCard-${job.id}'),
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.go(_routeForJob(job)),
        child: WorkshopSurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.requestTypeLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PartnerFlowPalette.primaryEnd,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  WorkshopStatusChip(
                    label: _jobStageLabel(context, job.stage),
                    color: _jobStageAccent(job.stage),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    height: 96,
                    child: WorkshopRemoteImage(
                      url: job.imageUrl,
                      height: 96,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.customerName,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          job.vehicleName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: PartnerFlowPalette.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          job.issueSummary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: PartnerFlowPalette.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  WorkshopTag(label: job.distanceLabel),
                  WorkshopTag(label: job.specialtyLabel),
                  WorkshopTag(label: job.capacityLabel),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                job.statusBody,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistTile extends StatelessWidget {
  const _ChecklistTile({
    required this.title,
    required this.subtitle,
    required this.done,
  });

  final String title;
  final String subtitle;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: MediaQuery.maybeOf(context)?.disableAnimations ?? false
          ? Duration.zero
          : const Duration(milliseconds: 220),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: done
            ? PartnerFlowPalette.primarySoft.withValues(alpha: 0.65)
            : PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            done ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: done ? PartnerFlowPalette.primaryEnd : PartnerFlowPalette.textMuted,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: MediaQuery.maybeOf(context)?.disableAnimations ?? false
              ? Duration.zero
              : const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: selected
                ? PartnerFlowPalette.primarySoft.withValues(alpha: 0.72)
                : PartnerFlowPalette.surfaceSoft,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected
                  ? PartnerFlowPalette.primaryEnd
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: selected
                    ? PartnerFlowPalette.primaryEnd
                    : PartnerFlowPalette.textMuted,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  const _TimelineStep({
    required this.title,
    required this.subtitle,
    required this.active,
  });

  final String title;
  final String subtitle;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active
                  ? PartnerFlowPalette.primaryEnd
                  : PartnerFlowPalette.surfaceSoft,
              border: Border.all(
                color: active
                    ? PartnerFlowPalette.primaryEnd
                    : PartnerFlowPalette.textMuted,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: MediaQuery.maybeOf(context)?.disableAnimations ?? false
              ? Duration.zero
              : const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            gradient: active ? PartnerFlowPalette.primaryGradient : null,
            color: active ? null : PartnerFlowPalette.surfaceSoft,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: active ? Colors.white : PartnerFlowPalette.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: PartnerFlowPalette.primaryEnd),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WorkshopMissingJobView extends StatelessWidget {
  const WorkshopMissingJobView({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return WorkshopScrollView(
      children: [
        WorkshopHeader(
          showBack: true,
          eyebrow: 'OnlyCars Workshop',
          title: title,
          subtitle: 'The requested record could not be found in the local workshop workflow.',
        ),
      ],
    );
  }
}

String _routeForJob(WorkshopJobRecord job) {
  return switch (job.stage) {
    WorkshopJobStage.newRequest => '/workshop/jobs/request/${job.id}',
    WorkshopJobStage.driverAssignment => '/workshop/jobs/request/${job.id}/driver',
    WorkshopJobStage.incomingTracking => '/workshop/jobs/request/${job.id}/incoming',
    WorkshopJobStage.activeJob => '/workshop/jobs/job/${job.id}',
    WorkshopJobStage.approvalPending => '/workshop/jobs/job/${job.id}/approval-pending',
    WorkshopJobStage.serviceInProgress => '/workshop/jobs/job/${job.id}/in-progress',
    WorkshopJobStage.handoverPrep => '/workshop/jobs/job/${job.id}/handover',
    WorkshopJobStage.requestReturnDelivery => '/workshop/jobs/job/${job.id}/request-return',
    WorkshopJobStage.returnTracking => '/workshop/jobs/job/${job.id}/return-tracking',
    WorkshopJobStage.completed => '/workshop/jobs/job/${job.id}/completed',
  };
}

String _jobStageLabel(BuildContext context, WorkshopJobStage stage) {
  final l10n = AppLocalizations.of(context)!;
  return switch (stage) {
    WorkshopJobStage.newRequest => l10n.workshopStageNewRequest,
    WorkshopJobStage.driverAssignment => l10n.workshopStageDriverAssignment,
    WorkshopJobStage.incomingTracking => l10n.workshopStageIncomingTracking,
    WorkshopJobStage.activeJob => l10n.workshopStageActive,
    WorkshopJobStage.approvalPending => l10n.workshopStageApprovalPending,
    WorkshopJobStage.serviceInProgress => l10n.workshopStageServiceInProgress,
    WorkshopJobStage.handoverPrep => l10n.workshopStageHandover,
    WorkshopJobStage.requestReturnDelivery => l10n.workshopStageReturnRequested,
    WorkshopJobStage.returnTracking => l10n.workshopStageReturnTracking,
    WorkshopJobStage.completed => l10n.workshopStageCompleted,
  };
}

String _activeStageLabel(AppLocalizations l10n, WorkshopJobStage stage) {
  return switch (stage) {
    WorkshopJobStage.activeJob => l10n.workshopStageActive,
    WorkshopJobStage.serviceInProgress => l10n.workshopStageServiceInProgress,
    _ => l10n.workshopStageIncomingTracking,
  };
}

Color _jobStageAccent(WorkshopJobStage stage) {
  return switch (stage) {
    WorkshopJobStage.newRequest => PartnerFlowPalette.primaryEnd,
    WorkshopJobStage.driverAssignment => const Color(0xFF5B7CF0),
    WorkshopJobStage.incomingTracking => const Color(0xFF4D8FE8),
    WorkshopJobStage.activeJob => const Color(0xFF4D8FE8),
    WorkshopJobStage.approvalPending => PartnerFlowPalette.warning,
    WorkshopJobStage.serviceInProgress => PartnerFlowPalette.primaryEnd,
    WorkshopJobStage.handoverPrep => PartnerFlowPalette.success,
    WorkshopJobStage.requestReturnDelivery => const Color(0xFF4D8FE8),
    WorkshopJobStage.returnTracking => const Color(0xFF4D8FE8),
    WorkshopJobStage.completed => PartnerFlowPalette.textSecondary,
  };
}
