import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'shop_shared.dart';
import 'shop_workflow_state.dart';

enum _ShopOrdersFilter { all, active, completed }

class ShopOrdersScreen extends ConsumerStatefulWidget {
  const ShopOrdersScreen({super.key});

  @override
  ConsumerState<ShopOrdersScreen> createState() => _ShopOrdersScreenState();
}

class _ShopOrdersScreenState extends ConsumerState<ShopOrdersScreen> {
  _ShopOrdersFilter _filter = _ShopOrdersFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final allOrders = ref.watch(shopWorkflowProvider).orders;
    final visibleOrders = switch (_filter) {
      _ShopOrdersFilter.all => List<ShopOrderRecord>.from(allOrders),
      _ShopOrdersFilter.active => List<ShopOrderRecord>.from(
        allOrders.where((order) => order.stage != ShopOrderStage.completed),
      ),
      _ShopOrdersFilter.completed => List<ShopOrderRecord>.from(
        allOrders.where((order) => order.stage == ShopOrderStage.completed),
      ),
    }..sort((a, b) => a.stage.index.compareTo(b.stage.index));

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopOrdersScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome()),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 30,
          child: ShopHeader(
            eyebrow: l10n.shopOrdersEyebrow,
            title: l10n.shopOrdersTitle,
            subtitle: l10n.shopOrdersSubtitle,
          ),
        ),
        const SizedBox(height: 20),
        ShopReveal(
          delay: 60,
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _OrdersFilterChip(
                key: const Key('shopOrdersFilter-all'),
                label: l10n.shopOrdersFilterAll,
                active: _filter == _ShopOrdersFilter.all,
                onTap: () => setState(() => _filter = _ShopOrdersFilter.all),
              ),
              _OrdersFilterChip(
                key: const Key('shopOrdersFilter-active'),
                label: l10n.shopOrdersFilterActive,
                active: _filter == _ShopOrdersFilter.active,
                onTap: () => setState(() => _filter = _ShopOrdersFilter.active),
              ),
              _OrdersFilterChip(
                key: const Key('shopOrdersFilter-completed'),
                label: l10n.shopOrdersFilterCompleted,
                active: _filter == _ShopOrdersFilter.completed,
                onTap: () =>
                    setState(() => _filter = _ShopOrdersFilter.completed),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ...[
          for (final (index, order) in visibleOrders.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == visibleOrders.length - 1 ? 0 : 14,
              ),
              child: ShopReveal(
                delay: 90 + (index * 25),
                child: _OrderListCard(order: order),
              ),
            ),
        ],
      ],
    );
  }
}

class ShopProductsScreen extends ConsumerWidget {
  const ShopProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final inventory = ref.watch(shopWorkflowProvider).inventory;

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopProductsScreen'),
          child: SizedBox.shrink(),
        ),
        ShopReveal(
          child: ShopTopChrome(
            title: 'OnlyCars Products',
            onNotificationTap: () {},
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 30,
          child: ShopHeader(
            eyebrow: l10n.shopProductsEyebrow,
            title: l10n.shopProductsTitle,
            subtitle: l10n.shopProductsSubtitle,
            trailing: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 160),
              child: ShopPrimaryButton(
                label: l10n.shopAddPart,
                icon: Icons.add_rounded,
                compact: true,
                onPressed: () => _showAddPartSheet(context, ref),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ...[
          for (final (index, item) in inventory.indexed)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == inventory.length - 1 ? 0 : 14,
              ),
              child: ShopReveal(
                delay: 60 + (index * 20),
                child: _InventoryListCard(item: item),
              ),
            ),
        ],
      ],
    );
  }
}

class ShopMessagesScreen extends ConsumerWidget {
  const ShopMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final threads = ref.watch(shopWorkflowProvider).messages;

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopMessagesScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 30,
          child: ShopHeader(
            eyebrow: l10n.shopMessagesEyebrow,
            title: l10n.shopMessagesTitle,
            subtitle: l10n.shopMessagesSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 60,
          child: ShopSurfaceCard(
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
                  l10n.shopMessagesEmptyTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.shopMessagesEmptySubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                for (final (index, thread) in threads.indexed)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: index == threads.length - 1 ? 0 : 12,
                    ),
                    child: _MessagePreviewTile(thread: thread),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class ShopProfileScreen extends ConsumerWidget {
  const ShopProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final profile = ref.watch(shopWorkflowProvider).profile;

    return ShopScrollView(
      children: [
        const KeyedSubtree(
          key: Key('shopProfileScreen'),
          child: SizedBox.shrink(),
        ),
        const ShopReveal(child: ShopTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 30,
          child: ShopHeader(
            eyebrow: l10n.shopProfileEyebrow,
            title: l10n.shopProfileTitle,
            subtitle: l10n.shopProfileSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        ShopReveal(
          delay: 60,
          child: ShopSurfaceCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShopRemoteImage(url: profile.coverImageUrl, height: 220),
                const SizedBox(height: 18),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: 68,
                        height: 68,
                        child: Image.network(
                          profile.avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: PartnerFlowPalette.primarySoft,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: const Icon(
                                  Icons.storefront_outlined,
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
                            profile.shopName,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            profile.ownerName,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: PartnerFlowPalette.textSecondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const ShopStatusChip(
                      label: 'Verified',
                      color: PartnerFlowPalette.primaryEnd,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ShopMiniStat(
                        label: l10n.shopProfileBalance,
                        value: profile.availableBalanceLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopMiniStat(
                        label: l10n.shopProfileOrders,
                        value: profile.ordersThisWeekLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ShopMiniStat(
                        label: l10n.shopProfileRating,
                        value: profile.shopRatingLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ShopMiniStat(
                        label: l10n.shopProfileResponseTime,
                        value: profile.responseTimeLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ProfileBlock(
                  label: l10n.shopProfileContactTitle,
                  items: [profile.email, profile.phone, profile.address],
                ),
                const SizedBox(height: 14),
                _ProfileBlock(
                  label: l10n.shopProfileCoverageTitle,
                  items: [profile.coverageLabel, ...profile.tags],
                ),
                const SizedBox(height: 14),
                _ProfileBlock(
                  label: l10n.shopProfileHoursTitle,
                  items: [profile.operatingHours],
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
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: shopMotionDuration(context),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
            fontWeight: FontWeight.w800,
            color: active
                ? PartnerFlowPalette.primaryEnd
                : PartnerFlowPalette.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _OrderListCard extends StatelessWidget {
  const _OrderListCard({required this.order});

  final ShopOrderRecord order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('shopOrderCard-${order.id}'),
        onTap: () => context.go(_stageRouteForOrder(order)),
        borderRadius: BorderRadius.circular(28),
        child: ShopSurfaceCard(
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
                          order.orderNumber,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          order.customerName,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: PartnerFlowPalette.textSecondary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  ShopStatusChip(
                    label: _stageLabel(context, order.stage),
                    color: _stageColor(order.stage),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                order.statusBody,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              _ProgressDots(stage: order.stage),
              const SizedBox(height: 16),
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
                      label: 'window',
                      value: order.deliveryWindowLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InventoryListCard extends StatelessWidget {
  const _InventoryListCard({required this.item});

  final ShopInventoryRecord item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ShopSurfaceCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 92,
            height: 92,
            child: ShopRemoteImage(
              url: item.imageUrl,
              height: 92,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                    ShopStatusChip(
                      label: item.isLowStock
                          ? l10n.shopLowStock
                          : l10n.shopInStock,
                      color: item.isLowStock
                          ? PartnerFlowPalette.warning
                          : PartnerFlowPalette.success,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.category} • ${item.sku}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.priceLabel,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: PartnerFlowPalette.primaryStart,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${item.stockCount} ${l10n.shopInStock.toLowerCase()}',
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
    );
  }
}

class _MessagePreviewTile extends StatelessWidget {
  const _MessagePreviewTile({required this.thread});

  final ShopMessagePreview thread;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: PartnerFlowPalette.primarySoft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.mark_chat_unread_outlined,
              color: PartnerFlowPalette.primaryEnd,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thread.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  thread.subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                thread.timestamp,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (thread.unreadCount > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: PartnerFlowPalette.primaryEnd,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${thread.unreadCount}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileBlock extends StatelessWidget {
  const _ProfileBlock({required this.label, required this.items});

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
              padding: EdgeInsets.only(
                bottom: index == items.length - 1 ? 0 : 10,
              ),
              child: Text(
                item,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(height: 1.4),
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

Future<void> _showAddPartSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _AddPartSheet(ref: ref),
  );
}

class _AddPartSheet extends StatefulWidget {
  const _AddPartSheet({required this.ref});

  final WidgetRef ref;

  @override
  State<_AddPartSheet> createState() => _AddPartSheetState();
}

class _AddPartSheetState extends State<_AddPartSheet> {
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 16,
      ),
      child: ShopSurfaceCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.shopInlineAddTitle,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.shopInlineAddSubtitle,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: PartnerFlowPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.shopFieldPartName),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _skuController,
              decoration: InputDecoration(labelText: l10n.shopFieldPartSku),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.shopFieldPartPrice,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _stockController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.shopFieldPartStock,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ShopPrimaryButton(
              label: l10n.shopSavePart,
              icon: Icons.save_rounded,
              onPressed: () {
                if (_nameController.text.trim().isEmpty ||
                    _skuController.text.trim().isEmpty ||
                    _priceController.text.trim().isEmpty) {
                  return;
                }
                widget.ref
                    .read(shopWorkflowProvider.notifier)
                    .addInventoryItem(
                      name: _nameController.text.trim(),
                      sku: _skuController.text.trim(),
                      priceLabel: 'QAR ${_priceController.text.trim()}',
                      stockCount:
                          int.tryParse(_stockController.text.trim()) ?? 0,
                    );
                Navigator.of(context).pop();
              },
            ),
          ],
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
