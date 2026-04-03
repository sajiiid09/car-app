import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_content.dart';
import '../discovery/discovery_palette.dart';
import '../discovery/discovery_widgets.dart';
import 'roadside_request_state.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({
    super.key,
    this.initialTab = OrdersHistoryTab.active,
  });

  final OrdersHistoryTab initialTab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider);
    final ordersAsync = ref.watch(myOrdersProvider);
    final unreadCount = ref.watch(unreadNotifCountProvider).valueOrNull ?? 0;
    final roadsideRequests = ref.watch(
      roadsideRequestProvider.select((value) => value.submittedRequests),
    );

    return Scaffold(
      backgroundColor: DiscoveryPalette.background,
      body: RefreshIndicator(
        color: DiscoveryPalette.primaryEnd,
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(myOrdersProvider);
          ref.invalidate(unreadNotifCountProvider);
        },
        child: SingleChildScrollView(
          key: ValueKey('customerOrdersPage-${initialTab.queryValue}'),
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DiscoveryTopBar(
                  avatarUrl: userAsync.valueOrNull?.avatarUrl,
                  notificationCount: unreadCount,
                  onAvatarTap: () => context.go('/profile'),
                  onCartTap: () => context.push('/cart'),
                  onNotificationTap: () => context.push('/notifications'),
                ),
                const SizedBox(height: 18),
                _OrdersTabBar(
                  activeTab: initialTab,
                  onTabSelected: (tab) => context.go('/orders?tab=${tab.queryValue}'),
                ),
                const SizedBox(height: 28),
                ordersAsync.when(
                  data: (orders) {
                    final activeOrders = orders
                        .where((order) => !_isHistoryStatus(order.status))
                        .toList();
                    final completedOrders = orders
                        .where((order) => order.status == 'completed')
                        .toList();
                    final cancelledOrders = orders
                        .where((order) => order.status == 'cancelled')
                        .toList();

                    return switch (initialTab) {
                      OrdersHistoryTab.active => _ActiveOrdersView(
                          requests: roadsideRequests,
                          activeOrders: activeOrders,
                          completedOrders: completedOrders,
                        ),
                      OrdersHistoryTab.completed => _HistoryOrdersView(
                          title: l10n.discoveryRecentHistory,
                          orders: completedOrders,
                          emptyLabel: l10n.discoveryNoCompletedOrders,
                        ),
                      OrdersHistoryTab.cancelled => _HistoryOrdersView(
                          title: l10n.discoveryCancelledLabel,
                          orders: cancelledOrders,
                          emptyLabel: l10n.discoveryNoCancelledOrders,
                          cancelled: true,
                        ),
                    };
                  },
                  loading: () => const _OrdersLoading(),
                  error: (error, stackTrace) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isHistoryStatus(String status) {
    return status == 'completed' || status == 'cancelled';
  }
}

class _OrdersTabBar extends StatelessWidget {
  const _OrdersTabBar({
    required this.activeTab,
    required this.onTabSelected,
  });

  final OrdersHistoryTab activeTab;
  final ValueChanged<OrdersHistoryTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Row(
        children: [
          _TabButton(
            label: l10n.discoveryActiveLabel,
            selected: activeTab == OrdersHistoryTab.active,
            onTap: () => onTabSelected(OrdersHistoryTab.active),
          ),
          _TabButton(
            label: l10n.discoveryCompletedLabel,
            selected: activeTab == OrdersHistoryTab.completed,
            onTap: () => onTabSelected(OrdersHistoryTab.completed),
          ),
          _TabButton(
            label: l10n.discoveryCancelledLabel,
            selected: activeTab == OrdersHistoryTab.cancelled,
            onTap: () => onTabSelected(OrdersHistoryTab.cancelled),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: selected
                    ? DiscoveryPalette.primaryEnd
                    : DiscoveryPalette.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveOrdersView extends StatelessWidget {
  const _ActiveOrdersView({
    required this.requests,
    required this.activeOrders,
    required this.completedOrders,
  });

  final List<SubmittedRoadsideRequest> requests;
  final List<Order> activeOrders;
  final List<Order> completedOrders;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemCount = requests.length + activeOrders.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.discoveryActiveTrackings,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: DiscoveryPalette.primaryStart,
                ),
              ),
            ),
            Text(
              l10n.discoveryItemsCount(itemCount),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: DiscoveryPalette.primaryEnd,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        if (requests.isEmpty && activeOrders.isEmpty)
          _EmptyOrdersCard(label: l10n.discoveryNoActiveOrders)
        else ...[
          ...requests.map((request) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _RoadsideTrackingCard(request: request),
              )),
          ...activeOrders.map((order) => Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _LiveOrderCard(order: order),
              )),
        ],
        const SizedBox(height: 14),
        Text(
          l10n.discoveryRecentHistory,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: DiscoveryPalette.primaryStart,
          ),
        ),
        const SizedBox(height: 18),
        if (completedOrders.isEmpty)
          _EmptyOrdersCard(label: l10n.discoveryNoCompletedOrders)
        else
          ...completedOrders.take(2).toList().asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key == 1 ? 0 : 18),
              child: _HistoryOrderCard(order: entry.value),
            );
          }),
      ],
    );
  }
}

class _HistoryOrdersView extends StatelessWidget {
  const _HistoryOrdersView({
    required this.title,
    required this.orders,
    required this.emptyLabel,
    this.cancelled = false,
  });

  final String title;
  final List<Order> orders;
  final String emptyLabel;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: DiscoveryPalette.primaryStart,
          ),
        ),
        const SizedBox(height: 18),
        if (orders.isEmpty)
          _EmptyOrdersCard(label: emptyLabel)
        else
          ...orders.take(4).toList().asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(bottom: entry.key == orders.take(4).length - 1 ? 0 : 18),
              child: _HistoryOrderCard(order: entry.value, cancelled: cancelled),
            );
          }),
      ],
    );
  }
}

class _RoadsideTrackingCard extends StatelessWidget {
  const _RoadsideTrackingCard({
    required this.request,
  });

  final SubmittedRoadsideRequest request;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: DiscoveryPalette.primarySoft,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  l10n.discoveryInProgress.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: DiscoveryPalette.primaryEnd,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: DiscoveryPalette.surfaceSoft,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.build_circle_outlined,
                  color: DiscoveryPalette.primaryEnd,
                  size: 30,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            l10n.discoveryWorkshopService.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.discoveryServiceBookingAt(request.workshopName),
            style: const TextStyle(
              fontSize: 20,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.primaryStart,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.discoveryScheduledFor(_formatOrderDate(request.createdAt)),
            style: const TextStyle(
              fontSize: 15,
              color: DiscoveryPalette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatusLabel(label: l10n.discoveryDropOff),
              ),
              Expanded(
                child: _StatusLabel(
                  label: l10n.discoveryServicing,
                  active: true,
                ),
              ),
              Expanded(
                child: _StatusLabel(label: l10n.discoveryQualityCheck),
              ),
              Expanded(
                child: _StatusLabel(label: l10n.discoveryReadyLabel),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: 0.48,
              minHeight: 10,
              backgroundColor: DiscoveryPalette.surfaceSoft,
              valueColor: const AlwaysStoppedAnimation<Color>(DiscoveryPalette.primaryEnd),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatOrderDate(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${_monthShort(date.month)} ${date.day}, ${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }

  static String _monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1).clamp(0, 11)];
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({
    required this.label,
    this.active = false,
  });

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      maxLines: 2,
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: active ? DiscoveryPalette.primaryEnd : DiscoveryPalette.textSecondary,
      ),
    );
  }
}

class _LiveOrderCard extends StatelessWidget {
  const _LiveOrderCard({
    required this.order,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final price = 'QAR ${order.total.toStringAsFixed(0)}';
    final item = order.items?.firstOrNull;
    final title = _itemTitle(item) ?? l10n.discoveryOrderFallbackTitle;
    final imageUrl = _itemImage(item);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(26),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 96,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: DiscoveryPalette.primaryEnd,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.discoveryEstimatedDateLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: DiscoveryPalette.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _estimatedDate(order.createdAt),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: DiscoveryPalette.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ORDER #${_shortOrderId(order.id)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: DiscoveryPalette.textSecondary,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.discoveryPartsOrderTitle(title),
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.45,
                        fontWeight: FontWeight.w700,
                        color: DiscoveryPalette.primaryStart,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.discoveryDispatchedVia(_dispatchLabel(order)),
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: DiscoveryPalette.primaryEnd,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _OrderThumbnail(imageUrl: imageUrl),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _SecondaryActionButton(
                  label: l10n.discoveryDetails,
                  onTap: () => context.push('/order/${order.id}'),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: DiscoveryGradientButton(
                  label: l10n.discoveryTrackPackage,
                  onTap: () => context.push('/order/${order.id}'),
                  height: 54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String? _itemTitle(OrderItem? item) {
    final part = item?.part;
    if (part == null) {
      return null;
    }
    final name = part['name_en'] ?? part['name_ar'];
    return name is String && name.trim().isNotEmpty ? name.trim() : null;
  }

  static String? _itemImage(OrderItem? item) {
    final part = item?.part;
    if (part == null) {
      return null;
    }
    final images = part['image_urls'];
    if (images is List && images.isNotEmpty && images.first is String) {
      return images.first as String;
    }
    return null;
  }

  static String _dispatchLabel(Order order) {
    return switch (order.status) {
      'confirmed' => 'Priority Courier',
      'preparing' => 'Express Rail',
      'in_transit' => 'Express Rail',
      _ => 'Service Dispatch',
    };
  }

  static String _shortOrderId(String id) {
    final normalized = id.trim();
    if (normalized.isEmpty) {
      return '00000000';
    }
    final end = normalized.length < 8 ? normalized.length : 8;
    return normalized.substring(0, end).toUpperCase();
  }

  static String _estimatedDate(DateTime? date) {
    final base = (date ?? DateTime.now()).add(const Duration(days: 2));
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[base.month - 1]} ${base.day}';
  }
}

class _HistoryOrderCard extends StatelessWidget {
  const _HistoryOrderCard({
    required this.order,
    this.cancelled = false,
  });

  final Order order;
  final bool cancelled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isWorkshopService = order.workshopId != null && (order.items?.isEmpty ?? true);
    final actionLabel = cancelled
        ? l10n.discoveryDetails
        : (isWorkshopService ? l10n.discoveryReorderService : l10n.discoveryDownloadReceipt);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 54,
            child: Text(
              _historyDate(order.createdAt),
              style: const TextStyle(
                fontSize: 15,
                height: 1.45,
                color: DiscoveryPalette.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _historyTitle(order),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: DiscoveryPalette.primaryStart,
                  ),
                ),
                if (!cancelled) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < 4 ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 18,
                        color: DiscoveryPalette.primaryEnd,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                GestureDetector(
                  onTap: () {
                    if (isWorkshopService) {
                      context.go('/orders/request/workshops');
                    } else {
                      context.push('/order/${order.id}');
                    }
                  },
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: DiscoveryPalette.primaryEnd,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          _OrderThumbnail(imageUrl: _LiveOrderCard._itemImage(order.items?.firstOrNull)),
        ],
      ),
    );
  }

  static String _historyDate(DateTime? date) {
    final value = date ?? DateTime.now();
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[value.month - 1]}\n${value.day}';
  }

  static String _historyTitle(Order order) {
    return _LiveOrderCard._itemTitle(order.items?.firstOrNull) ??
        (order.workshop?['name_ar'] as String? ?? 'OnlyCars Service');
  }
}

class _OrderThumbnail extends StatelessWidget {
  const _OrderThumbnail({
    this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: 108,
      height: 108,
      decoration: BoxDecoration(
        color: DiscoveryPalette.imagePlaceholder,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(
        Icons.directions_car_filled_outlined,
        color: DiscoveryPalette.primarySolid,
        size: 42,
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        imageUrl!,
        width: 108,
        height: 108,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => placeholder,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return placeholder;
        },
      ),
    );
  }
}

class _SecondaryActionButton extends StatelessWidget {
  const _SecondaryActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: DiscoveryPalette.surfaceSoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: DiscoveryPalette.primaryStart,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyOrdersCard extends StatelessWidget {
  const _EmptyOrdersCard({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: DiscoveryPalette.textSecondary,
        ),
      ),
    );
  }
}

class _OrdersLoading extends StatelessWidget {
  const _OrdersLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 1 ? 0 : 18),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: DiscoveryPalette.surface,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }
}
