import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'shop_shared.dart';
import 'shop_workflow_state.dart';

class ShopOrderDetailScreen extends ConsumerWidget {
  const ShopOrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;

    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopOrderDetailScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome()),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 20,
          child: ShopHeader(
            showBack: true,
            eyebrow: l10n.shopOrderDetailEyebrow,
            title: l10n.shopOrderDetailTitle,
            subtitle: l10n.shopOrderDetailSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(delay: 50, child: _OrderHeroCard(order: order)),
        const SizedBox(height: 20),
        ShopReveal(
          delay: 80,
          child: _OrderSectionCard(
            title: l10n.shopOrderItemsTitle,
            child: Column(
              children: [
                for (final (index, item) in order.items.indexed)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == order.items.length - 1 ? 0 : 14,
                    ),
                    child: _OrderLineTile(item: item),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShopReveal(
          delay: 110,
          child: _OrderSectionCard(
            title: l10n.shopCustomerDetailsTitle,
            child: Column(
              children: [
                _InfoRow(
                  label: l10n.shopPrimaryAddressLabel,
                  value: order.customerAddress,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: l10n.shopDeliveryWindowLabel,
                  value: order.deliveryWindowLabel,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: l10n.shopVehicleLabel,
                  value: '${order.vehicleLabel} • ${order.plateLabel}',
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: l10n.shopTrackingCodeLabel,
                  value: order.trackingCode,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShopReveal(
          delay: 140,
          child: _OrderSectionCard(
            title: l10n.shopOrderTimelineTitle,
            child: _ProgressDots(stage: order.stage),
          ),
        ),
        const SizedBox(height: 20),
        ShopReveal(
          delay: 170,
          child: Row(
            children: [
              Expanded(
                child: ShopPrimaryButton(
                  label: l10n.shopStartPacking,
                  icon: Icons.inventory_rounded,
                  onPressed: () {
                    ref
                        .read(shopWorkflowProvider.notifier)
                        .startPacking(order.id);
                    context.go('/shop/orders/${order.id}/packing');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShopSecondaryButton(
                  label: l10n.shopBackToOrders,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.go('/shop/orders'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ShopPackingScreen extends ConsumerWidget {
  const ShopPackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopPackingScreen'),
      eyebrow: l10n.shopPackingEyebrow,
      title: l10n.shopPackingTitle,
      subtitle: l10n.shopPackingSubtitle,
      order: order,
      accentColor: const Color(0xFF5B7CF0),
      infoCard: _ChecklistCard(
        entries: const [
          'Seal the parcel and attach the printed manifest.',
          'Confirm fragile handling notes for premium parts.',
          'Move the package to dispatch release zone.',
        ],
      ),
      primaryLabel: l10n.shopRequestCourier,
      primaryIcon: Icons.local_shipping_outlined,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).requestDelivery(order.id);
        context.go('/shop/orders/${order.id}/delivery-request');
      },
    );
  }
}

class ShopDeliveryRequestScreen extends ConsumerWidget {
  const ShopDeliveryRequestScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopDeliveryRequestScreen'),
      eyebrow: l10n.shopDeliveryRequestEyebrow,
      title: l10n.shopDeliveryRequestTitle,
      subtitle: l10n.shopDeliveryRequestSubtitle,
      order: order,
      accentColor: PartnerFlowPalette.secondaryStart,
      infoCard: _OrderSectionCard(
        title: l10n.shopCustomerDetailsTitle,
        child: Column(
          children: [
            _InfoRow(
              label: l10n.shopPrimaryAddressLabel,
              value: order.customerAddress,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.shopDeliveryWindowLabel,
              value: order.deliveryWindowLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.shopTrackingCodeLabel,
              value: order.trackingCode,
            ),
          ],
        ),
      ),
      primaryLabel: l10n.shopSendDeliveryRequest,
      primaryIcon: Icons.send_rounded,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).sendDeliveryRequest(order.id);
        context.go('/shop/orders/${order.id}/searching-driver');
      },
    );
  }
}

class ShopSearchingDriverScreen extends ConsumerWidget {
  const ShopSearchingDriverScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopSearchingDriverScreen'),
      eyebrow: l10n.shopSearchingDriverEyebrow,
      title: l10n.shopSearchingDriverTitle,
      subtitle: l10n.shopSearchingDriverSubtitle,
      order: order,
      accentColor: PartnerFlowPalette.secondaryEnd,
      heroChild: const _SearchingDriverPulse(),
      infoCard: _ChecklistCard(
        entries: const [
          'Dispatch is matching courier capacity to parcel size.',
          'Priority delivery lane is enabled for this order.',
          'Customer notifications are sent automatically on assignment.',
        ],
      ),
      primaryLabel: l10n.shopSimulateDriverAssigned,
      primaryIcon: Icons.person_search_rounded,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).assignCourier(order.id);
        context.go('/shop/orders/${order.id}/courier-assigned');
      },
    );
  }
}

class ShopCourierAssignedScreen extends ConsumerWidget {
  const ShopCourierAssignedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopCourierAssignedScreen'),
      eyebrow: l10n.shopCourierAssignedEyebrow,
      title: l10n.shopCourierAssignedTitle,
      subtitle: l10n.shopCourierAssignedSubtitle,
      order: order,
      accentColor: const Color(0xFF4F7DF7),
      infoCard: _CourierCard(order: order),
      primaryLabel: l10n.shopContinueToHandover,
      primaryIcon: Icons.inventory_outlined,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).prepareHandover(order.id);
        context.go('/shop/orders/${order.id}/handover');
      },
    );
  }
}

class ShopHandoverScreen extends ConsumerWidget {
  const ShopHandoverScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopHandoverScreen'),
      eyebrow: l10n.shopHandoverEyebrow,
      title: l10n.shopHandoverTitle,
      subtitle: l10n.shopHandoverSubtitle,
      order: order,
      accentColor: PartnerFlowPalette.warning,
      infoCard: _ChecklistCard(
        entries: const [
          'Scan parcel seal and courier handoff tag.',
          'Confirm the package photo in dispatch history.',
          'Release the parcel only after ETA confirmation.',
        ],
      ),
      primaryLabel: l10n.shopConfirmHandover,
      primaryIcon: Icons.check_circle_outline_rounded,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).confirmHandover(order.id);
        context.go('/shop/orders/${order.id}/tracking');
      },
    );
  }
}

class ShopDeliveryTrackingScreen extends ConsumerWidget {
  const ShopDeliveryTrackingScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('shopDeliveryTrackingScreen'),
      eyebrow: l10n.shopTrackingEyebrow,
      title: l10n.shopTrackingTitle,
      subtitle: l10n.shopTrackingSubtitle,
      order: order,
      accentColor: PartnerFlowPalette.primarySolid,
      infoCard: _CourierCard(order: order),
      primaryLabel: l10n.shopMarkDelivered,
      primaryIcon: Icons.task_alt_rounded,
      onPrimary: () {
        ref.read(shopWorkflowProvider.notifier).markDelivered(order.id);
        context.go('/shop/orders/${order.id}/completed');
      },
    );
  }
}

class ShopDeliveryCompletedScreen extends ConsumerWidget {
  const ShopDeliveryCompletedScreen({super.key, required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(shopOrderProvider(orderId));
    final l10n = AppLocalizations.of(context)!;
    if (order == null) {
      return _MissingOrderView(message: l10n.shopOrderNotFound);
    }

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopDeliveryCompletedScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 20,
          child: ShopHeader(
            showBack: true,
            eyebrow: l10n.shopCompletedEyebrow,
            title: l10n.shopCompletedTitle,
            subtitle: l10n.shopCompletedSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 50,
          child: ShopSurfaceCard(
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: PartnerFlowPalette.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    size: 44,
                    color: PartnerFlowPalette.success,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  order.orderNumber,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  order.statusBody,
                  textAlign: TextAlign.center,
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
                        label: 'total',
                        value: order.totalLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopMiniStat(
                        label: 'tracking',
                        value: order.trackingCode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        ShopReveal(
          delay: 80,
          child: Row(
            children: [
              Expanded(
                child: ShopPrimaryButton(
                  label: l10n.shopBackToOrders,
                  icon: Icons.receipt_long_rounded,
                  onPressed: () => context.go('/shop/orders'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShopSecondaryButton(
                  label: l10n.shopBackToDashboard,
                  icon: Icons.grid_view_rounded,
                  onPressed: () => context.go('/shop'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StageScaffold extends StatelessWidget {
  const _StageScaffold({
    required this.screenKey,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.order,
    required this.accentColor,
    required this.infoCard,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    this.heroChild,
  });

  final Key screenKey;
  final String eyebrow;
  final String title;
  final String subtitle;
  final ShopOrderRecord order;
  final Color accentColor;
  final Widget infoCard;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final Widget? heroChild;

  @override
  Widget build(BuildContext context) {
    return ShopScrollView(
      children: [
        KeyedSubtree(key: screenKey, child: const SizedBox.shrink()),
        const ShopReveal(child: ShopTopChrome()),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 20,
          child: ShopHeader(
            showBack: true,
            eyebrow: eyebrow,
            title: title,
            subtitle: subtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 50,
          child: _StageHeroCard(
            order: order,
            accentColor: accentColor,
            heroChild: heroChild,
          ),
        ),
        const SizedBox(height: 16),
        ShopReveal(delay: 80, child: infoCard),
        const SizedBox(height: 18),
        ShopReveal(
          delay: 110,
          child: Row(
            children: [
              Expanded(
                child: ShopPrimaryButton(
                  label: primaryLabel,
                  icon: primaryIcon,
                  onPressed: onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShopSecondaryButton(
                  label: AppLocalizations.of(context)!.shopBackToOrders,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.go('/shop/orders'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StageHeroCard extends StatelessWidget {
  const _StageHeroCard({
    required this.order,
    required this.accentColor,
    this.heroChild,
  });

  final ShopOrderRecord order;
  final Color accentColor;
  final Widget? heroChild;

  @override
  Widget build(BuildContext context) {
    return ShopSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heroChild == null)
            ShopRemoteImage(
              url: order.heroImageUrl,
              height: 200,
              placeholderIcon: Icons.local_shipping_outlined,
            )
          else
            heroChild!,
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.statusHeadline,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ShopStatusChip(
                label: _stageLabel(context, order.stage),
                color: accentColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            order.statusBody,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _ProgressDots(stage: order.stage),
        ],
      ),
    );
  }
}

class _OrderHeroCard extends StatelessWidget {
  const _OrderHeroCard({required this.order});

  final ShopOrderRecord order;

  @override
  Widget build(BuildContext context) {
    return ShopSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShopRemoteImage(url: order.heroImageUrl, height: 210),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.orderNumber,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              ShopStatusChip(
                label: _stageLabel(context, order.stage),
                color: _stageColor(order.stage),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '${order.customerName} • ${order.createdAtLabel}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: PartnerFlowPalette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ShopMiniStat(
                  label: 'items',
                  value: '${order.totalItems}',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ShopMiniStat(label: 'total', value: order.totalLabel),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderSectionCard extends StatelessWidget {
  const _OrderSectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShopSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _OrderLineTile extends StatelessWidget {
  const _OrderLineTile({required this.item});

  final ShopOrderLineItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          height: 72,
          child: ShopRemoteImage(
            url: item.imageUrl,
            height: 72,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                '${item.sku} • Qty ${item.quantity}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          item.priceLabel,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: PartnerFlowPalette.primaryStart,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
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
          child: Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return _OrderSectionCard(
      title: AppLocalizations.of(context)!.shopOrderTimelineTitle,
      child: Column(
        children: [
          for (final (index, entry) in entries.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == entries.length - 1 ? 0 : 12,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: PartnerFlowPalette.primarySoft,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: PartnerFlowPalette.primaryEnd,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        height: 1.45,
                      ),
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

class _CourierCard extends StatelessWidget {
  const _CourierCard({required this.order});

  final ShopOrderRecord order;

  @override
  Widget build(BuildContext context) {
    final courier = order.courier;
    return _OrderSectionCard(
      title: AppLocalizations.of(context)!.shopCourierCardTitle,
      child: courier == null
          ? Text(
              AppLocalizations.of(context)!.loading,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: PartnerFlowPalette.textSecondary,
              ),
            )
          : Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    width: 74,
                    height: 74,
                    child: Image.network(
                      courier.avatarUrl ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: PartnerFlowPalette.primarySoft,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: PartnerFlowPalette.primaryEnd,
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        courier.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        courier.vehicleLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PartnerFlowPalette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${courier.phone} • ${courier.etaLabel}',
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
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.stage});

  final ShopOrderStage stage;

  @override
  Widget build(BuildContext context) {
    final activeIndex = ShopOrderStage.values.indexOf(stage);
    return Row(
      children: List.generate(ShopOrderStage.values.length, (index) {
        final active = index <= activeIndex;
        return Expanded(
          child: AnimatedContainer(
            duration: shopMotionDuration(context),
            curve: Curves.easeOutCubic,
            height: 6,
            margin: EdgeInsets.only(
              right: index == ShopOrderStage.values.length - 1 ? 0 : 6,
            ),
            decoration: BoxDecoration(
              color: active
                  ? PartnerFlowPalette.primaryEnd
                  : PartnerFlowPalette.surfaceMuted,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        );
      }),
    );
  }
}

class _SearchingDriverPulse extends StatefulWidget {
  const _SearchingDriverPulse();

  @override
  State<_SearchingDriverPulse> createState() => _SearchingDriverPulseState();
}

class _SearchingDriverPulseState extends State<_SearchingDriverPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (WidgetsBinding
        .instance
        .platformDispatcher
        .accessibilityFeatures
        .disableAnimations) {
      _controller.value = 1;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      _controller.stop();
      _controller.value = 1;
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final phase = _controller.value;
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                for (final multiplier in [1.0, 0.7, 0.4])
                  Transform.scale(
                    scale: 0.8 + ((phase * multiplier) % 1) * 0.8,
                    child: Opacity(
                      opacity: 1 - ((phase * multiplier) % 1),
                      child: Container(
                        width: 170,
                        height: 170,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: PartnerFlowPalette.primaryEnd.withValues(
                              alpha: 0.24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  width: 104,
                  height: 104,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: PartnerFlowPalette.primaryGradient,
                    boxShadow: [
                      BoxShadow(
                        color: PartnerFlowPalette.primaryEnd.withValues(
                          alpha: 0.18,
                        ),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.person_search_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
                Transform.rotate(
                  angle: phase * math.pi * 2,
                  child: const SizedBox(
                    width: 146,
                    height: 146,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                          BorderSide(
                            color: PartnerFlowPalette.secondaryEnd,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MissingOrderView extends StatelessWidget {
  const _MissingOrderView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ShopScrollView(
      children: [
        const ShopReveal(child: ShopTopChrome(showNotification: false)),
        const SizedBox(height: 48),
        ShopSurfaceCard(
          child: Center(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
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
