import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../chat/pro_chat_screens.dart';
import '../chat/pro_chat_state.dart';
import '../shared/partner_flow_palette.dart';
import 'courier_flow_helpers.dart';
import 'courier_shared.dart';
import 'courier_workflow_state.dart';

enum _CourierOrdersFilter { newRequests, active, completed }

class DriverOrdersScreen extends ConsumerStatefulWidget {
  const DriverOrdersScreen({super.key});

  @override
  ConsumerState<DriverOrdersScreen> createState() => _DriverOrdersScreenState();
}

class _DriverOrdersScreenState extends ConsumerState<DriverOrdersScreen> {
  _CourierOrdersFilter _filter = _CourierOrdersFilter.active;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allDeliveries = ref.watch(courierWorkflowProvider).deliveries;
    final visibleDeliveries = switch (_filter) {
      _CourierOrdersFilter.newRequests => List<CourierDeliveryRecord>.from(
        allDeliveries.where(
          (delivery) => delivery.stage == CourierDeliveryStage.newRequest,
        ),
      ),
      _CourierOrdersFilter.active => List<CourierDeliveryRecord>.from(
        allDeliveries.where(
          (delivery) =>
              delivery.stage == CourierDeliveryStage.navigation ||
              delivery.stage == CourierDeliveryStage.confirm,
        ),
      ),
      _CourierOrdersFilter.completed => List<CourierDeliveryRecord>.from(
        allDeliveries.where(
          (delivery) => delivery.stage == CourierDeliveryStage.completed,
        ),
      ),
    }..sort((a, b) => a.stage.index.compareTo(b.stage.index));

    return CourierScrollView(
      children: [
        const KeyedSubtree(
          key: Key('driverOrdersScreen'),
          child: SizedBox.shrink(),
        ),
        const CourierReveal(child: CourierTopChrome()),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 30,
          child: CourierHeader(
            eyebrow: l10n.driverOrdersEyebrow,
            title: l10n.driverOrdersTitle,
            subtitle: l10n.driverOrdersSubtitle,
          ),
        ),
        const SizedBox(height: 20),
        CourierReveal(
          delay: 60,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _OrdersFilterChip(
                key: const Key('driverOrdersFilter-new'),
                label: l10n.driverOrdersFilterNew,
                active: _filter == _CourierOrdersFilter.newRequests,
                onTap: () =>
                    setState(() => _filter = _CourierOrdersFilter.newRequests),
              ),
              _OrdersFilterChip(
                key: const Key('driverOrdersFilter-active'),
                label: l10n.driverOrdersFilterActive,
                active: _filter == _CourierOrdersFilter.active,
                onTap: () =>
                    setState(() => _filter = _CourierOrdersFilter.active),
              ),
              _OrdersFilterChip(
                key: const Key('driverOrdersFilter-completed'),
                label: l10n.driverOrdersFilterCompleted,
                active: _filter == _CourierOrdersFilter.completed,
                onTap: () =>
                    setState(() => _filter = _CourierOrdersFilter.completed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (visibleDeliveries.isEmpty)
          CourierReveal(
            delay: 90,
            child: CourierSurfaceCard(
              child: Text(
                l10n.driverOrdersEmpty,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                ),
              ),
            ),
          ),
        ...[
          for (final (index, delivery) in visibleDeliveries.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == visibleDeliveries.length - 1 ? 0 : 14,
              ),
              child: CourierReveal(
                delay: 90 + (index * 25),
                child: _DeliveryListCard(delivery: delivery),
              ),
            ),
        ],
      ],
    );
  }
}

class DriverEarningsScreen extends ConsumerWidget {
  const DriverEarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final earnings = ref.watch(courierWorkflowProvider).earnings;

    return CourierScrollView(
      children: [
        const KeyedSubtree(
          key: Key('driverEarningsScreen'),
          child: SizedBox.shrink(),
        ),
        const CourierReveal(child: CourierTopChrome()),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 30,
          child: CourierHeader(
            eyebrow: l10n.driverEarningsEyebrow,
            title: l10n.driverEarningsTitle,
            subtitle: l10n.driverEarningsSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 60,
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: PartnerFlowPalette.primaryGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: PartnerFlowPalette.primaryEnd.withValues(alpha: 0.16),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driverEarningsToday,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.84),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'QAR 185',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _LightMetric(
                        label: l10n.driverEarningsPending,
                        value: 'QAR 74',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _LightMetric(
                        label: l10n.driverEarningsThisWeek,
                        value: 'QAR 1.2K',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 90,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.22,
            children: [
              CourierMetricTile(
                title: l10n.driverEarningsCompletion,
                value: '98%',
                icon: Icons.task_alt_rounded,
                accentColor: PartnerFlowPalette.success,
              ),
              CourierMetricTile(
                title: l10n.driverMetricTodayTrips,
                value: '7',
                icon: Icons.route_outlined,
                accentColor: PartnerFlowPalette.primaryEnd,
              ),
              CourierMetricTile(
                title: l10n.driverMetricActiveDeliveries,
                value: '2',
                icon: Icons.delivery_dining_rounded,
                accentColor: PartnerFlowPalette.secondaryStart,
              ),
              CourierMetricTile(
                title: l10n.driverMetricPendingRequests,
                value: '3',
                icon: Icons.notifications_active_outlined,
                accentColor: PartnerFlowPalette.warning,
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        CourierReveal(
          delay: 120,
          child: CourierSectionTitle(title: l10n.driverTransactionsTitle),
        ),
        const SizedBox(height: 16),
        ...[
          for (final (index, entry) in earnings.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == earnings.length - 1 ? 0 : 14,
              ),
              child: CourierReveal(
                delay: 150 + (index * 25),
                child: _EarningTile(entry: entry),
              ),
            ),
        ],
      ],
    );
  }
}

class DriverMessagesScreen extends ConsumerWidget {
  const DriverMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProChatInboxScreen(
      role: ProChatRole.driver,
      screenKey: Key('driverMessagesScreen'),
    );
  }
}

class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(courierWorkflowProvider).profile;

    return CourierScrollView(
      children: [
        const KeyedSubtree(
          key: Key('driverProfileScreen'),
          child: SizedBox.shrink(),
        ),
        const CourierReveal(child: CourierTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 30,
          child: CourierHeader(
            eyebrow: l10n.driverProfileEyebrow,
            title: l10n.driverProfileTitle,
            subtitle: l10n.driverProfileSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 60,
          child: CourierSurfaceCard(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CourierRemoteImage(
                  url: profile.coverImageUrl,
                  height: 180,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  placeholderIcon: Icons.delivery_dining_rounded,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: PartnerFlowPalette.primarySoft,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              size: 34,
                              color: PartnerFlowPalette.primaryEnd,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  profile.memberSinceLabel,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: PartnerFlowPalette.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final badge in profile.badges)
                            CourierStatusChip(label: badge),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        CourierReveal(
          delay: 90,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.18,
            children: [
              CourierMetricTile(
                title: l10n.driverProfileTrips,
                value: profile.totalTripsLabel,
                icon: Icons.route_outlined,
                accentColor: PartnerFlowPalette.primaryEnd,
              ),
              CourierMetricTile(
                title: l10n.driverProfileRating,
                value: profile.ratingLabel,
                icon: Icons.star_outline_rounded,
                accentColor: PartnerFlowPalette.warning,
              ),
              CourierMetricTile(
                title: l10n.driverProfileCompletion,
                value: profile.completionRateLabel,
                icon: Icons.task_alt_rounded,
                accentColor: PartnerFlowPalette.success,
              ),
              CourierMetricTile(
                title: l10n.driverProfileMonthlyPayout,
                value: profile.monthlyPayoutLabel,
                icon: Icons.payments_outlined,
                accentColor: PartnerFlowPalette.secondaryStart,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        CourierReveal(
          delay: 120,
          child: CourierSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.driverProfileContactTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 16),
                _ProfileInfoRow(
                  label: l10n.driverPhoneLabel,
                  value: profile.phone,
                ),
                const SizedBox(height: 12),
                _ProfileInfoRow(
                  label: l10n.driverEmailLabel,
                  value: profile.email,
                ),
                const SizedBox(height: 12),
                _ProfileInfoRow(
                  label: l10n.driverProfileCoverageTitle,
                  value: profile.serviceArea,
                ),
                const SizedBox(height: 12),
                _ProfileInfoRow(
                  label: l10n.driverProfileVehicleTitle,
                  value: profile.vehicleLabel,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OrdersFilterChip extends StatelessWidget {
  const _OrdersFilterChip({
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
          duration: courierMotionDuration(context),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: active
                ? PartnerFlowPalette.primarySoft
                : PartnerFlowPalette.surface,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: PartnerFlowPalette.borderSubtle),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: active
                  ? PartnerFlowPalette.primaryEnd
                  : PartnerFlowPalette.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _DeliveryListCard extends StatelessWidget {
  const _DeliveryListCard({required this.delivery});

  final CourierDeliveryRecord delivery;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('driverOrderCard-${delivery.id}'),
        borderRadius: BorderRadius.circular(26),
        onTap: () => context.go(courierDeliveryRoute(delivery)),
        child: CourierSurfaceCard(
          child: Row(
            children: [
              SizedBox(
                width: 96,
                height: 96,
                child: CourierRemoteImage(
                  url: delivery.heroImageUrl,
                  height: 96,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  placeholderIcon: Icons.delivery_dining_rounded,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                delivery.shopName,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                delivery.workshopName,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: PartnerFlowPalette.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        CourierStatusChip(
                          label: courierStageLabel(context, delivery.stage),
                          color: courierStageColor(delivery.stage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      delivery.packageSummary,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${delivery.itemCount} items • ${delivery.distanceLabel}',
                            style: Theme.of(context).textTheme.labelLarge
                                ?.copyWith(
                                  color: PartnerFlowPalette.textSecondary,
                                ),
                          ),
                        ),
                        Text(
                          delivery.payoutLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: PartnerFlowPalette.primaryEnd,
                                fontWeight: FontWeight.w900,
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

class _LightMetric extends StatelessWidget {
  const _LightMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _EarningTile extends StatelessWidget {
  const _EarningTile({required this.entry});

  final CourierEarningEntry entry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final paid =
        entry.statusLabel == l10n.driverTransactionPaid ||
        entry.statusLabel == 'Paid';

    return CourierSurfaceCard(
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color:
                  (paid
                          ? PartnerFlowPalette.success
                          : PartnerFlowPalette.primaryEnd)
                      .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              paid ? Icons.task_alt_rounded : Icons.schedule_rounded,
              color: paid
                  ? PartnerFlowPalette.success
                  : PartnerFlowPalette.primaryEnd,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  entry.subtitle,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.dateLabel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.amountLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: PartnerFlowPalette.primaryEnd,
                ),
              ),
              const SizedBox(height: 8),
              CourierStatusChip(
                label: paid
                    ? l10n.driverTransactionPaid
                    : l10n.driverTransactionProcessing,
                color: paid
                    ? PartnerFlowPalette.success
                    : PartnerFlowPalette.secondaryStart,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  const _ProfileInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
