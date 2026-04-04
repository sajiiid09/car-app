import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'courier_flow_helpers.dart';
import 'courier_shared.dart';
import 'courier_workflow_state.dart';

class DriverDashboard extends ConsumerWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final workflow = ref.watch(courierWorkflowProvider);
    final newRequests = workflow.deliveries
        .where((delivery) => delivery.stage == CourierDeliveryStage.newRequest)
        .take(2)
        .toList();
    final activeDelivery = workflow.activeDelivery;

    return CourierScrollView(
      children: [
        const KeyedSubtree(
          key: Key('driverDashboardScreen'),
          child: SizedBox.shrink(),
        ),
        const CourierReveal(child: CourierTopChrome()),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 30,
          child: CourierHeader(
            eyebrow: l10n.driverDashboardEyebrow,
            title: l10n.driverDashboardTitle,
            subtitle: l10n.driverDashboardSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 60,
          child: _AvailabilityHeroCard(
            isAvailable: workflow.isAvailable,
            onToggle: () =>
                ref.read(courierWorkflowProvider.notifier).toggleAvailability(),
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 90,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.18,
            children: [
              CourierMetricTile(
                key: const Key('driverMetricTile-todayTrips'),
                title: l10n.driverMetricTodayTrips,
                value:
                    '${workflow.completedCount + workflow.activeDeliveryCount}',
                icon: Icons.local_shipping_outlined,
                accentColor: PartnerFlowPalette.primaryEnd,
                onTap: () => context.go('/driver/orders'),
              ),
              CourierMetricTile(
                key: const Key('driverMetricTile-todayEarnings'),
                title: l10n.driverMetricTodayEarnings,
                value: 'QAR 185',
                icon: Icons.payments_outlined,
                accentColor: PartnerFlowPalette.success,
                onTap: () => context.go('/driver/earnings'),
              ),
              CourierMetricTile(
                key: const Key('driverMetricTile-pendingRequests'),
                title: l10n.driverMetricPendingRequests,
                value: '${workflow.newRequestCount}',
                icon: Icons.notifications_active_outlined,
                accentColor: PartnerFlowPalette.warning,
                onTap: () => context.go('/driver/orders'),
              ),
              CourierMetricTile(
                key: const Key('driverMetricTile-activeDeliveries'),
                title: l10n.driverMetricActiveDeliveries,
                value: '${workflow.activeDeliveryCount}',
                icon: Icons.route_outlined,
                accentColor: PartnerFlowPalette.secondaryStart,
                onTap: () => context.go('/driver/orders'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        CourierReveal(
          delay: 120,
          child: CourierSectionTitle(title: l10n.driverQuickActionsTitle),
        ),
        const SizedBox(height: 14),
        CourierReveal(
          delay: 150,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickActionChip(
                key: const Key('driverQuickAction-orders'),
                label: l10n.driverQuickActionOrders,
                icon: Icons.shopping_cart_outlined,
                onTap: () => context.go('/driver/orders'),
              ),
              _QuickActionChip(
                key: const Key('driverQuickAction-earnings'),
                label: l10n.driverQuickActionEarnings,
                icon: Icons.payments_outlined,
                onTap: () => context.go('/driver/earnings'),
              ),
              _QuickActionChip(
                key: const Key('driverQuickAction-profile'),
                label: l10n.driverQuickActionProfile,
                icon: Icons.person_outline_rounded,
                onTap: () => context.go('/driver/profile'),
              ),
            ],
          ),
        ),
        if (activeDelivery != null) ...[
          const SizedBox(height: 28),
          CourierReveal(
            delay: 180,
            child: CourierSectionTitle(
              title: l10n.driverLiveDeliveryTitle,
              actionLabel: l10n.driverSeeAll,
              onActionTap: () => context.go('/driver/orders'),
            ),
          ),
          const SizedBox(height: 16),
          CourierReveal(
            delay: 210,
            child: _ActiveDeliveryCard(delivery: activeDelivery),
          ),
        ],
        const SizedBox(height: 28),
        CourierReveal(
          delay: 240,
          child: CourierSectionTitle(
            title: l10n.driverNewRequestsTitle,
            actionLabel: l10n.driverSeeAll,
            onActionTap: () => context.go('/driver/orders'),
          ),
        ),
        const SizedBox(height: 16),
        ...[
          for (final (index, delivery) in newRequests.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == newRequests.length - 1 ? 0 : 14,
              ),
              child: CourierReveal(
                delay: 270 + (index * 30),
                child: _DashboardDeliveryCard(delivery: delivery),
              ),
            ),
        ],
      ],
    );
  }
}

class _AvailabilityHeroCard extends StatelessWidget {
  const _AvailabilityHeroCard({
    required this.isAvailable,
    required this.onToggle,
  });

  final bool isAvailable;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = isAvailable
        ? l10n.driverAvailabilityOnTitle
        : l10n.driverAvailabilityOffTitle;
    final subtitle = isAvailable
        ? l10n.driverAvailabilityOnSubtitle
        : l10n.driverAvailabilityOffSubtitle;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isAvailable
            ? PartnerFlowPalette.primaryGradient
            : const LinearGradient(
                colors: [
                  PartnerFlowPalette.primarySolid,
                  PartnerFlowPalette.textSecondary,
                ],
              ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: PartnerFlowPalette.primaryEnd.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _AnimatedAvailabilityToggle(
            isAvailable: isAvailable,
            onTap: onToggle,
          ),
        ],
      ),
    );
  }
}

class _AnimatedAvailabilityToggle extends StatelessWidget {
  const _AnimatedAvailabilityToggle({
    required this.isAvailable,
    required this.onTap,
  });

  final bool isAvailable;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: courierMotionDuration(context),
        curve: Curves.easeOutCubic,
        width: 76,
        height: 42,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: courierMotionDuration(context),
              curve: Curves.easeOutCubic,
              alignment: isAvailable
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isAvailable ? Icons.check_rounded : Icons.close_rounded,
                  size: 18,
                  color: isAvailable
                      ? PartnerFlowPalette.primaryEnd
                      : PartnerFlowPalette.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: PartnerFlowPalette.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: PartnerFlowPalette.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: PartnerFlowPalette.primaryEnd),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: PartnerFlowPalette.primaryStart,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActiveDeliveryCard extends StatelessWidget {
  const _ActiveDeliveryCard({required this.delivery});

  final CourierDeliveryRecord delivery;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('driverActiveDelivery-${delivery.id}'),
        borderRadius: BorderRadius.circular(28),
        onTap: () => context.go(courierDeliveryRoute(delivery)),
        child: CourierSurfaceCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CourierRemoteImage(
                url: delivery.heroImageUrl,
                height: 186,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                placeholderIcon: Icons.route_outlined,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            delivery.statusHeadline,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        CourierStatusChip(
                          label: courierStageLabel(context, delivery.stage),
                          color: courierStageColor(delivery.stage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      delivery.statusBody,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CourierMiniStat(
                            label: l10n.driverPayoutLabel,
                            value: delivery.payoutLabel,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CourierMiniStat(
                            label: l10n.driverDistanceLabel,
                            value: delivery.distanceLabel,
                          ),
                        ),
                      ],
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

class _DashboardDeliveryCard extends StatelessWidget {
  const _DashboardDeliveryCard({required this.delivery});

  final CourierDeliveryRecord delivery;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('driverDashboardRequest-${delivery.id}'),
        borderRadius: BorderRadius.circular(26),
        onTap: () => context.go(courierDeliveryRoute(delivery)),
        child: CourierSurfaceCard(
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: CourierRemoteImage(
                  url: delivery.heroImageUrl,
                  height: 88,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  placeholderIcon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            delivery.shopName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        if (delivery.priorityLabel != null)
                          CourierStatusChip(
                            label: delivery.priorityLabel!,
                            color: PartnerFlowPalette.warning,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      delivery.workshopName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${delivery.itemCount} items • ${delivery.distanceLabel}',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      delivery.payoutLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: PartnerFlowPalette.primaryEnd,
                        fontWeight: FontWeight.w900,
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
