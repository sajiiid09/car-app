import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'workshop_shared.dart';
import 'workshop_workflow_state.dart';

class WorkshopDashboard extends ConsumerWidget {
  const WorkshopDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final workflow = ref.watch(workshopWorkflowProvider);
    final jobs = [...workflow.jobs]..sort((a, b) => a.stage.index.compareTo(b.stage.index));
    final newRequests = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.newRequest)
        .length;
    final activeJobs = workflow.jobs
        .where(
          (job) =>
              job.stage == WorkshopJobStage.driverAssignment ||
              job.stage == WorkshopJobStage.incomingTracking ||
              job.stage == WorkshopJobStage.activeJob ||
              job.stage == WorkshopJobStage.serviceInProgress ||
              job.stage == WorkshopJobStage.requestReturnDelivery ||
              job.stage == WorkshopJobStage.returnTracking,
        )
        .length;
    final waitingApproval = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.approvalPending)
        .length;
    final handoverPending = workflow.jobs
        .where((job) => job.stage == WorkshopJobStage.handoverPrep)
        .length;

    return WorkshopScrollView(
      children: [
        const WorkshopReveal(child: WorkshopTopChrome()),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 40,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: WorkshopHeader(
                  eyebrow: l10n.workshopOverviewEyebrow,
                  title: l10n.workshopWelcomeBackChief,
                  subtitle: l10n.workshopDashboardSubtitle,
                ),
              ),
              const SizedBox(width: 16),
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 190),
                  child: WorkshopPrimaryButton(
                    label: l10n.workshopCreateJob,
                    icon: Icons.add_rounded,
                    compact: true,
                    onPressed: () => context.go('/workshop/jobs?filter=new'),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        WorkshopReveal(
          delay: 80,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.18,
            children: [
              WorkshopMetricTile(
                key: const Key('workshopMetricTile-new'),
                title: l10n.workshopMetricNewRequests,
                value: '$newRequests',
                icon: Icons.pending_actions_rounded,
                accentColor: PartnerFlowPalette.primaryEnd,
                onTap: () => context.go('/workshop/jobs?filter=new'),
              ),
              WorkshopMetricTile(
                key: const Key('workshopMetricTile-active'),
                title: l10n.workshopMetricActiveJobs,
                value: '$activeJobs',
                icon: Icons.build_circle_outlined,
                accentColor: const Color(0xFF4F7DF7),
                onTap: () => context.go('/workshop/jobs?filter=all'),
              ),
              WorkshopMetricTile(
                key: const Key('workshopMetricTile-approval'),
                title: l10n.workshopMetricWaitingApproval,
                value: '$waitingApproval',
                icon: Icons.rule_rounded,
                accentColor: PartnerFlowPalette.warning,
                onTap: () => context.go('/workshop/jobs?filter=approval'),
              ),
              WorkshopMetricTile(
                key: const Key('workshopMetricTile-handover'),
                title: l10n.workshopMetricReadyPickup,
                value: '$handoverPending',
                icon: Icons.key_rounded,
                accentColor: PartnerFlowPalette.success,
                onTap: () => context.go('/workshop/jobs?filter=handover'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        WorkshopReveal(
          delay: 120,
          child: WorkshopSectionTitle(
            title: l10n.workshopRecentServiceJobs,
            actionLabel: l10n.workshopViewAll,
            onActionTap: () => context.go('/workshop/jobs?filter=all'),
          ),
        ),
        const SizedBox(height: 16),
        ...[
          for (final (index, job) in jobs.take(3).indexed)
            Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 14),
              child: WorkshopReveal(
                delay: 150 + (index * 35),
                child: _DashboardJobCard(job: job),
              ),
            ),
        ],
      ],
    );
  }
}

class _DashboardJobCard extends StatelessWidget {
  const _DashboardJobCard({required this.job});

  final WorkshopJobRecord job;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('workshopDashboardJob-${job.id}'),
        borderRadius: BorderRadius.circular(26),
        onTap: () {
          switch (job.stage) {
            case WorkshopJobStage.newRequest:
              context.go('/workshop/jobs/request/${job.id}');
            case WorkshopJobStage.driverAssignment:
              context.go('/workshop/jobs/request/${job.id}/driver');
            case WorkshopJobStage.incomingTracking:
              context.go('/workshop/jobs/request/${job.id}/incoming');
            case WorkshopJobStage.activeJob:
              context.go('/workshop/jobs/job/${job.id}');
            case WorkshopJobStage.approvalPending:
              context.go('/workshop/jobs/job/${job.id}/approval-pending');
            case WorkshopJobStage.serviceInProgress:
              context.go('/workshop/jobs/job/${job.id}/in-progress');
            case WorkshopJobStage.handoverPrep:
              context.go('/workshop/jobs/job/${job.id}/handover');
            case WorkshopJobStage.requestReturnDelivery:
              context.go('/workshop/jobs/job/${job.id}/request-return');
            case WorkshopJobStage.returnTracking:
              context.go('/workshop/jobs/job/${job.id}/return-tracking');
            case WorkshopJobStage.completed:
              context.go('/workshop/jobs/job/${job.id}/completed');
          }
        },
        child: WorkshopSurfaceCard(
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: WorkshopRemoteImage(
                  url: job.imageUrl,
                  height: 88,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.customerName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        WorkshopStatusChip(
                          label: _statusLabelForStage(context, job.stage),
                          color: _statusColor(job.stage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      job.vehicleName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${job.requestedAtLabel} • ${job.licensePlate}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        fontWeight: FontWeight.w700,
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

String _statusLabelForStage(BuildContext context, WorkshopJobStage stage) {
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

Color _statusColor(WorkshopJobStage stage) {
  return switch (stage) {
    WorkshopJobStage.newRequest => PartnerFlowPalette.primaryEnd,
    WorkshopJobStage.driverAssignment => const Color(0xFF5B7CF0),
    WorkshopJobStage.incomingTracking => const Color(0xFF4D8FE8),
    WorkshopJobStage.activeJob => PartnerFlowPalette.primaryEnd,
    WorkshopJobStage.approvalPending => PartnerFlowPalette.warning,
    WorkshopJobStage.serviceInProgress => const Color(0xFF4F7DF7),
    WorkshopJobStage.handoverPrep => PartnerFlowPalette.success,
    WorkshopJobStage.requestReturnDelivery => const Color(0xFF4D8FE8),
    WorkshopJobStage.returnTracking => const Color(0xFF4D8FE8),
    WorkshopJobStage.completed => PartnerFlowPalette.textSecondary,
  };
}
