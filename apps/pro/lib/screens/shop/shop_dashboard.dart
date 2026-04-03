import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'shop_shared.dart';
import 'shop_workflow_state.dart';

class ShopDashboard extends ConsumerWidget {
  const ShopDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final workflow = ref.watch(shopWorkflowProvider);
    final activeOrders =
        workflow.orders
            .where((order) => order.stage != ShopOrderStage.completed)
            .toList()
          ..sort((a, b) => a.stage.index.compareTo(b.stage.index));
    final featuredInventory = workflow.inventory.take(4).toList();
    final trackingOrder = workflow.orders.firstWhere(
      (order) => order.stage == ShopOrderStage.tracking,
      orElse: () => workflow.orders.first,
    );

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopDashboardScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome()),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 30,
          child: ShopHeader(
            eyebrow: l10n.shopDashboardEyebrow,
            title: l10n.shopDashboardTitle,
            subtitle: l10n.shopDashboardSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(delay: 60, child: _HeroDispatchCard(order: trackingOrder)),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 90,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.18,
            children: [
              ShopMetricTile(
                key: const Key('shopMetricTile-pendingOrders'),
                title: l10n.shopMetricPendingOrders,
                value:
                    '${workflow.countByStage(ShopOrderStage.newOrder) + workflow.countByStage(ShopOrderStage.packing)}',
                icon: Icons.receipt_long_rounded,
                accentColor: PartnerFlowPalette.primaryEnd,
                onTap: () => context.go('/shop/orders'),
              ),
              ShopMetricTile(
                key: const Key('shopMetricTile-outForDelivery'),
                title: l10n.shopMetricOutForDelivery,
                value:
                    '${workflow.countByStage(ShopOrderStage.searchingDriver) + workflow.countByStage(ShopOrderStage.courierAssigned) + workflow.countByStage(ShopOrderStage.tracking)}',
                icon: Icons.local_shipping_outlined,
                accentColor: const Color(0xFF5B7CF0),
                onTap: () => context.go('/shop/orders'),
              ),
              ShopMetricTile(
                key: const Key('shopMetricTile-lowStock'),
                title: l10n.shopMetricLowStock,
                value:
                    '${workflow.inventory.where((item) => item.isLowStock).length}',
                icon: Icons.inventory_2_outlined,
                accentColor: PartnerFlowPalette.warning,
                onTap: () => context.go('/shop/products'),
              ),
              ShopMetricTile(
                key: const Key('shopMetricTile-todayRevenue'),
                title: l10n.shopMetricTodayRevenue,
                value: 'QAR 9.8K',
                icon: Icons.show_chart_rounded,
                accentColor: PartnerFlowPalette.success,
                onTap: () => context.go('/shop/profile'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        ShopReveal(
          delay: 120,
          child: ShopSectionTitle(title: l10n.shopQuickActionsTitle),
        ),
        const SizedBox(height: 14),
        ShopReveal(
          delay: 150,
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _QuickActionChip(
                key: const Key('shopQuickAction-orders'),
                label: l10n.shopQuickActionOrders,
                icon: Icons.shopping_cart_outlined,
                onTap: () => context.go('/shop/orders'),
              ),
              _QuickActionChip(
                key: const Key('shopQuickAction-products'),
                label: l10n.shopQuickActionProducts,
                icon: Icons.inventory_2_outlined,
                onTap: () => context.go('/shop/products'),
              ),
              _QuickActionChip(
                key: const Key('shopQuickAction-tracking'),
                label: l10n.shopQuickActionDelivery,
                icon: Icons.route_outlined,
                onTap: () => context.go(_stageRouteForOrder(trackingOrder)),
              ),
              _QuickActionChip(
                key: const Key('shopQuickAction-profile'),
                label: l10n.shopQuickActionProfile,
                icon: Icons.person_outline_rounded,
                onTap: () => context.go('/shop/profile'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        ShopReveal(
          delay: 180,
          child: ShopSectionTitle(
            title: l10n.shopOperationalQueueTitle,
            actionLabel: l10n.shopSeeAll,
            onActionTap: () => context.go('/shop/orders'),
          ),
        ),
        const SizedBox(height: 16),
        ...[
          for (final (index, order) in activeOrders.take(3).indexed)
            Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 14),
              child: ShopReveal(
                delay: 210 + (index * 35),
                child: _DashboardOrderCard(order: order),
              ),
            ),
        ],
        const SizedBox(height: 28),
        ShopReveal(
          delay: 320,
          child: ShopSectionTitle(
            title: l10n.shopFeaturedPartsTitle,
            actionLabel: l10n.shopSeeAll,
            onActionTap: () => context.go('/shop/products'),
          ),
        ),
        const SizedBox(height: 16),
        ShopReveal(
          delay: 350,
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredInventory.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.66,
            ),
            itemBuilder: (context, index) {
              final item = featuredInventory[index];
              return _InventoryFeatureCard(item: item);
            },
          ),
        ),
      ],
    );
  }
}

class _HeroDispatchCard extends StatelessWidget {
  const _HeroDispatchCard({required this.order});

  final ShopOrderRecord order;

  @override
  Widget build(BuildContext context) {
    return ShopSurfaceCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ShopRemoteImage(
                url: order.heroImageUrl,
                height: 210,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                placeholderIcon: Icons.local_shipping_outlined,
              ),
              Positioned(
                left: 18,
                top: 18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    order.deliveryWindowLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: PartnerFlowPalette.primaryStart,
                    ),
                  ),
                ),
              ),
            ],
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
                        order.statusHeadline,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    ShopStatusChip(
                      label: _stageLabel(context, order.stage),
                      color: PartnerFlowPalette.secondaryStart,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  order.statusBody,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ShopMiniStat(
                        label: 'tracking',
                        value: order.trackingCode,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopMiniStat(
                        label: 'value',
                        value: order.totalLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: ShopPrimaryButton(
                        label: AppLocalizations.of(
                          context,
                        )!.shopQuickActionDelivery,
                        icon: Icons.arrow_forward_rounded,
                        compact: true,
                        onPressed: () => context.go(_stageRouteForOrder(order)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopSecondaryButton(
                        label: AppLocalizations.of(
                          context,
                        )!.shopQuickActionOrders,
                        icon: Icons.receipt_long_rounded,
                        onPressed: () => context.go('/shop/orders'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardOrderCard extends StatelessWidget {
  const _DashboardOrderCard({required this.order});

  final ShopOrderRecord order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('shopDashboardOrder-${order.id}'),
        borderRadius: BorderRadius.circular(26),
        onTap: () => context.go(_stageRouteForOrder(order)),
        child: ShopSurfaceCard(
          child: Row(
            children: [
              SizedBox(
                width: 88,
                height: 88,
                child: ShopRemoteImage(
                  url: order.heroImageUrl,
                  height: 88,
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  placeholderIcon: Icons.shopping_bag_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ShopStatusChip(
                      label: _stageLabel(context, order.stage),
                      color: _stageColor(order.stage),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${order.orderNumber} • ${order.totalItems} items',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      order.totalLabel,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: PartnerFlowPalette.primaryEnd,
                        fontWeight: FontWeight.w800,
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

class _InventoryFeatureCard extends StatelessWidget {
  const _InventoryFeatureCard({required this.item});

  final ShopInventoryRecord item;

  @override
  Widget build(BuildContext context) {
    return ShopSurfaceCard(
      padding: EdgeInsets.zero,
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopRemoteImage(
            url: item.imageUrl,
            height: 112,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            placeholderIcon: Icons.inventory_2_outlined,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 130;
                  final badgeColor = item.isLowStock
                      ? PartnerFlowPalette.warning
                      : PartnerFlowPalette.primaryEnd;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.highlightLabel != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.11),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            item.highlightLabel!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: badgeColor,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        SizedBox(height: compact ? 6 : 8),
                      ],
                      Text(
                        item.name,
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      if (compact)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                item.priceLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: PartnerFlowPalette.primaryStart,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                '${item.stockCount} in stock',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(
                                      color: PartnerFlowPalette.textSecondary,
                                    ),
                              ),
                            ),
                          ],
                        )
                      else ...[
                        Text(
                          item.priceLabel,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: PartnerFlowPalette.primaryStart,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${item.stockCount} in stock',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: PartnerFlowPalette.textSecondary,
                              ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ),
        ],
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

String _stageRouteForOrder(ShopOrderRecord order) {
  return switch (order.stage) {
    ShopOrderStage.newOrder => '/shop/orders/${order.id}',
    ShopOrderStage.packing => '/shop/orders/${order.id}/packing',
    ShopOrderStage.deliveryRequest =>
      '/shop/orders/${order.id}/delivery-request',
    ShopOrderStage.searchingDriver =>
      '/shop/orders/${order.id}/searching-driver',
    ShopOrderStage.courierAssigned =>
      '/shop/orders/${order.id}/courier-assigned',
    ShopOrderStage.handover => '/shop/orders/${order.id}/handover',
    ShopOrderStage.tracking => '/shop/orders/${order.id}/tracking',
    ShopOrderStage.completed => '/shop/orders/${order.id}/completed',
  };
}

String _stageLabel(BuildContext context, ShopOrderStage stage) {
  final l10n = AppLocalizations.of(context)!;
  return switch (stage) {
    ShopOrderStage.newOrder => l10n.shopStageNewOrder,
    ShopOrderStage.packing => l10n.shopStagePacking,
    ShopOrderStage.deliveryRequest => l10n.shopStageDeliveryRequest,
    ShopOrderStage.searchingDriver => l10n.shopStageSearchingDriver,
    ShopOrderStage.courierAssigned => l10n.shopStageCourierAssigned,
    ShopOrderStage.handover => l10n.shopStageHandover,
    ShopOrderStage.tracking => l10n.shopStageTracking,
    ShopOrderStage.completed => l10n.shopStageCompleted,
  };
}

Color _stageColor(ShopOrderStage stage) {
  return switch (stage) {
    ShopOrderStage.newOrder => PartnerFlowPalette.primaryEnd,
    ShopOrderStage.packing => const Color(0xFF5B7CF0),
    ShopOrderStage.deliveryRequest => PartnerFlowPalette.secondaryStart,
    ShopOrderStage.searchingDriver => PartnerFlowPalette.secondaryEnd,
    ShopOrderStage.courierAssigned => const Color(0xFF4F7DF7),
    ShopOrderStage.handover => PartnerFlowPalette.warning,
    ShopOrderStage.tracking => PartnerFlowPalette.primarySolid,
    ShopOrderStage.completed => PartnerFlowPalette.success,
  };
}
