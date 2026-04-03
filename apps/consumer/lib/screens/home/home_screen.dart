import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_content.dart';
import '../discovery/discovery_palette.dart';
import '../discovery/discovery_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final shortcuts = discoveryShortcutItems(l10n);
    final userAsync = ref.watch(userProfileProvider);
    final workshopsAsync = ref.watch(workshopsProvider);
    final partsAsync = ref.watch(partsProvider(null));
    final ordersAsync = ref.watch(myOrdersProvider);
    final unreadCount = ref.watch(unreadNotifCountProvider).valueOrNull ?? 0;

    return Scaffold(
      backgroundColor: DiscoveryPalette.background,
      body: DiscoveryScreenBody(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(workshopsProvider);
          ref.invalidate(partsProvider(null));
          ref.invalidate(myOrdersProvider);
          ref.invalidate(unreadNotifCountProvider);
        },
        child: Column(
          key: const ValueKey('customerHomePage'),
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
            DiscoveryTitleBlock(
              title: l10n.discoveryWelcomeBack(
                userAsync.valueOrNull?.name?.trim().isNotEmpty == true
                    ? userAsync.valueOrNull!.name!.trim()
                    : 'OnlyCars',
              ),
            ),
            const SizedBox(height: 18),
            DiscoveryHeroCarousel(
              items: discoveryHeroItems(l10n),
              onPrimaryActionTap: () => context.go('/marketplace'),
            ),
            const SizedBox(height: 18),
            DiscoverySearchBar(
              searchKey: const ValueKey('customerHomeSearchBar'),
              hint: l10n.discoverySearchHint,
              onTap: () => context.go('/map'),
            ),
            const SizedBox(height: 16),
            DiscoveryViewToggle(
              currentView: WorkshopExploreView.map,
              mapLabel: l10n.discoveryMapLabel,
              listLabel: l10n.discoveryListLabel,
              onMapTap: () => context.go('/map'),
              onListTap: () => context.go('/map'),
            ),
            const SizedBox(height: 14),
            DiscoveryRouteTabs(
              activeTab: DiscoveryRouteTab.services,
              servicesLabel: l10n.discoveryServicesLabel,
              partsLabel: l10n.discoveryPartsLabel,
              onServicesTap: () => context.go('/map'),
              onPartsTap: () => context.go('/marketplace'),
            ),
            const SizedBox(height: 12),
            ordersAsync.when(
              data: (orders) {
                final activeOrder = _firstTrackableOrder(orders);
                if (activeOrder == null) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _InTransitCard(
                    label: _activeOrderLabel(activeOrder),
                    title: l10n.discoveryOrderInTransitTitle(
                      _activeOrderTitle(activeOrder),
                    ),
                    onTap: () => context.push('/order/${activeOrder.id}'),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            const _FeaturedPromoCard(),
            const SizedBox(height: 14),
            Row(
              children: shortcuts.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == shortcuts.length - 1 ? 0 : 12,
                    ),
                    child: DiscoveryShortcutTile(
                      icon: item.icon,
                      label: item.label,
                      onTap: () => context.go(item.route),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            DiscoveryUploadCard(label: l10n.discoveryUploadImage),
            const SizedBox(height: 18),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  DiscoveryFilterPill(
                    label: l10n.discoveryRecommended,
                    selected: true,
                  ),
                  const SizedBox(width: 10),
                  DiscoveryFilterPill(
                    label: l10n.discoveryRatingFilter,
                    trailingIcon: Icons.keyboard_arrow_down_rounded,
                  ),
                  const SizedBox(width: 10),
                  DiscoveryFilterPill(
                    label: l10n.discoveryDistanceFilter,
                    trailingIcon: Icons.keyboard_arrow_down_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            DiscoverySectionHeader(
              title: l10n.discoveryTopRatedWorkshop,
              actionLabel: l10n.discoveryViewAll,
              onActionTap: () => context.go('/orders/request/workshops'),
            ),
            const SizedBox(height: 14),
            workshopsAsync.when(
              data: (workshops) {
                if (workshops.isEmpty) {
                  return const SizedBox.shrink();
                }

                final sorted = [...workshops]
                  ..sort((a, b) => b.avgRating.compareTo(a.avgRating));
                final workshop = sorted.first;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: DiscoveryWorkshopCard(
                    name: workshop.nameAr,
                    location: workshop.zone ?? l10n.discoveryWorkshopFallbackLocation,
                    distance: _workshopDistanceLabel(0),
                    priceLabel: _workshopPriceLabel(0),
                    rating: workshop.avgRating == 0
                        ? '4.9'
                        : workshop.avgRating.toStringAsFixed(1),
                    tags: _workshopTags(workshop, l10n),
                    ctaLabel: l10n.discoveryBookService,
                    imageUrl: workshop.coverPhotoUrl,
                    onTap: () => context.push('/workshop/${workshop.id}'),
                    onCtaTap: () => context.push('/workshop/${workshop.id}'),
                  ),
                );
              },
              loading: () => const _BlockPlaceholder(height: 350),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
            DiscoverySectionHeader(
              title: l10n.discoveryPopularParts,
              actionLabel: l10n.discoveryExploreStore,
              onActionTap: () => context.go('/marketplace'),
            ),
            const SizedBox(height: 14),
            partsAsync.when(
              data: (parts) {
                final featured = parts.take(4).toList();
                if (featured.isEmpty) {
                  return const SizedBox.shrink();
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: featured.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.69,
                  ),
                  itemBuilder: (context, index) {
                    final part = featured[index];
                    return DiscoveryPartsGridCard(
                      title: part.nameEn?.trim().isNotEmpty == true
                          ? part.nameEn!
                          : part.nameAr,
                      subtitle: _partSubtitle(part),
                      price: _currencyLabel(part.price),
                      imageUrl: part.imageUrls.isNotEmpty ? part.imageUrls.first : null,
                      assetPath: _partFallbackAsset(index),
                      onTap: () => context.push('/part/${part.id}'),
                      onAddTap: () => _addToCart(context, ref, part),
                    );
                  },
                );
              },
              loading: () => const _BlockPlaceholder(height: 360),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Order? _firstTrackableOrder(List<Order> orders) {
    for (final order in orders) {
      if (order.status == 'in_transit' ||
          order.status == 'confirmed' ||
          order.status == 'pending') {
        return order;
      }
    }
    return null;
  }

  String _activeOrderLabel(Order order) {
    return 'Order #${order.id.substring(0, 7).toUpperCase()}';
  }

  String _activeOrderTitle(Order order) {
    final item = order.items?.firstOrNull;
    if (item == null) {
      return 'OnlyCars Order';
    }
    final name = item.part?['name_en'] ?? item.part?['name_ar'];
    if (name is String && name.trim().isNotEmpty) {
      return name.trim();
    }
    return 'OnlyCars Order';
  }

  List<String> _workshopTags(WorkshopProfile workshop, AppLocalizations l10n) {
    if (workshop.specialties.isNotEmpty) {
      return workshop.specialties.take(2).map((tag) => tag.toUpperCase()).toList();
    }

    return [
      l10n.discoveryLuxuryExpert.toUpperCase(),
      l10n.discoveryAuthorizedDealer.toUpperCase(),
    ];
  }

  String _workshopDistanceLabel(int index) {
    final distances = ['1.2 miles away', '2.8 miles away', '3.5 miles away'];
    return distances[index % distances.length];
  }

  String _workshopPriceLabel(int index) {
    final prices = ['\$80/hr', '\$65/hr', '\$110/hr'];
    return prices[index % prices.length];
  }

  String _partSubtitle(Part part) {
    final category = part.category?['name_en'] ?? part.category?['name_ar'];
    if (category is String && category.trim().isNotEmpty) {
      return category.trim();
    }
    return part.condition;
  }

  String _currencyLabel(double price) {
    if (price == price.roundToDouble()) {
      return '\$${price.toStringAsFixed(2)}';
    }
    return '\$${price.toStringAsFixed(2)}';
  }

  String _partFallbackAsset(int index) {
    const assets = [
      'assets/images/part_brakes.png',
      'assets/images/part_battery.png',
      'assets/images/part_filter.png',
      'assets/images/part_oil.png',
    ];
    return assets[index % assets.length];
  }

  void _addToCart(BuildContext context, WidgetRef ref, Part part) {
    ref.read(cartProvider.notifier).add(part);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }
}

class _InTransitCard extends StatelessWidget {
  const _InTransitCard({
    required this.label,
    required this.title,
    required this.onTap,
  });

  final String label;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: DiscoveryPalette.secondaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: DiscoveryPalette.cardShadow,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedPromoCard extends StatelessWidget {
  const _FeaturedPromoCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: DiscoveryPalette.secondaryGradient,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.discoveryDiagnosticTitle,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            l10n.discoveryDiagnosticSubtitle,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.discoveryLearnMore,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/images/part_filter.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockPlaceholder extends StatelessWidget {
  const _BlockPlaceholder({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(22),
      ),
    );
  }
}
