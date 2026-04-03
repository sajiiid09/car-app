import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'workshop_shared.dart';
import 'workshop_workflow_state.dart';

class WorkshopMessagesScreen extends StatelessWidget {
  const WorkshopMessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return WorkshopScrollView(
      children: [
        const WorkshopReveal(child: WorkshopTopChrome()),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 30,
          child: WorkshopHeader(
            eyebrow: l10n.workshopMessagesEyebrow,
            title: l10n.workshopMessagesTitle,
            subtitle: l10n.workshopMessagesSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 60,
          child: WorkshopSurfaceCard(
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: PartnerFlowPalette.primarySoft,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.forum_outlined,
                    size: 42,
                    color: PartnerFlowPalette.primaryEnd,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.workshopMessagesEmptyTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.workshopMessagesEmptySubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class WorkshopProfileScreen extends ConsumerWidget {
  const WorkshopProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(workshopWorkflowProvider).profile;

    return WorkshopScrollView(
      children: [
        const WorkshopReveal(child: WorkshopTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 30,
          child: WorkshopHeader(
            eyebrow: l10n.workshopProfileEyebrow,
            title: l10n.workshopProfileTitle,
            subtitle: l10n.workshopProfileSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        WorkshopReveal(
          delay: 60,
          child: WorkshopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkshopRemoteImage(url: profile.coverImageUrl, height: 220),
                const SizedBox(height: 18),
                Row(
                  children: [
                    WorkshopAvatarImage(url: profile.avatarUrl, size: 68),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile.workshopName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            profile.ownerName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(color: PartnerFlowPalette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const WorkshopStatusChip(
                      label: 'Verified',
                      color: PartnerFlowPalette.primaryEnd,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopProfileCurrentBalance,
                        value: profile.currentBalanceLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopProfilePendingPayout,
                        value: profile.pendingPayoutLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopProfileMonthlyRevenue,
                        value: profile.monthlyRevenueLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: WorkshopMiniStat(
                        label: l10n.workshopProfileCompletionRate,
                        value: profile.completionRateLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ProfileBlock(
                  label: l10n.workshopProfileContactTitle,
                  items: [
                    profile.email,
                    profile.phone,
                    profile.address,
                    profile.operatingHours,
                  ],
                ),
                const SizedBox(height: 14),
                _ProfileBlock(
                  label: l10n.workshopProfileSpecialtiesTitle,
                  items: profile.specialties,
                ),
                const SizedBox(height: 14),
                _ProfileBlock(
                  label: l10n.workshopProfilePayoutTitle,
                  items: [
                    profile.bankLabel,
                    profile.ibanLabel,
                    '${l10n.workshopProfileResponseTime}: ${profile.responseTimeLabel}',
                  ],
                ),
                const SizedBox(height: 18),
                SizedBox(
                  height: 170,
                  child: WorkshopRemoteImage(
                    url: profile.mapImageUrl,
                    height: 170,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileBlock extends StatelessWidget {
  const _ProfileBlock({
    required this.label,
    required this.items,
  });

  final String label;
  final List<String> items;

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
          const SizedBox(height: 12),
          for (final (index, item) in items.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : 10),
              child: Text(
                item,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PartnerFlowPalette.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
