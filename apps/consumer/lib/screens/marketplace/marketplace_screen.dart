import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_content.dart';
import '../discovery/discovery_palette.dart';
import '../discovery/discovery_widgets.dart';

class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategoryId;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider);
    final partsAsync = ref.watch(partsProvider(null));
    final unreadCount = ref.watch(unreadNotifCountProvider).valueOrNull ?? 0;
    final categories = discoveryPartCategories(l10n);

    return Scaffold(
      backgroundColor: DiscoveryPalette.background,
      body: DiscoveryScreenBody(
        onRefresh: () async {
          ref.invalidate(userProfileProvider);
          ref.invalidate(partsProvider(null));
          ref.invalidate(unreadNotifCountProvider);
        },
        child: Column(
          key: const ValueKey('customerMarketplacePage'),
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
            DiscoveryTitleBlock(title: l10n.discoveryPrecisionParts),
            const SizedBox(height: 18),
            DiscoverySearchBar(
              searchKey: const ValueKey('customerPartsSearchBar'),
              hint: l10n.discoveryPartsSearchHint,
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            DiscoveryRouteTabs(
              activeTab: DiscoveryRouteTab.parts,
              servicesLabel: l10n.discoveryServicesLabel,
              partsLabel: l10n.discoveryPartsLabel,
              onServicesTap: () => context.go('/map'),
              onPartsTap: () => context.go('/marketplace'),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 96,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final selected = _selectedCategoryId == category.id;
                  return _PartsCategoryTile(
                    label: category.label,
                    icon: category.icon,
                    selected: selected,
                    onTap: () {
                      setState(() {
                        _selectedCategoryId =
                            selected ? null : category.id;
                      });
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                DiscoveryFilterPill(label: l10n.discoveryFilters),
                DiscoveryFilterPill(
                  label: l10n.discoveryBrandToyota,
                  selected: true,
                ),
                DiscoveryFilterPill(label: l10n.discoveryPriceRange),
                DiscoveryFilterPill(label: l10n.discoveryInStock),
              ],
            ),
            const SizedBox(height: 18),
            partsAsync.when(
              data: (parts) {
                final filtered = _filterParts(parts, categories);
                if (filtered.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: List.generate(filtered.length.clamp(0, 4), (index) {
                    final part = filtered[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == 3 ? 0 : 18),
                      child: DiscoveryFeatureProductCard(
                        badgeLabel: _badgeForIndex(l10n, index),
                        shopName: _shopName(part),
                        title: part.nameEn?.trim().isNotEmpty == true
                            ? part.nameEn!
                            : part.nameAr,
                        subtitle: _partSubtitle(part),
                        price: _qarPrice(part.price),
                        imageUrl: part.imageUrls.isNotEmpty ? part.imageUrls.first : null,
                        assetPath: _fallbackAsset(index),
                        onTap: () => context.push('/part/${part.id}'),
                        onAddTap: () => _addToCart(part),
                      ),
                    );
                  }),
                );
              },
              loading: () => const _MarketplaceLoadingColumn(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  List<Part> _filterParts(
    List<Part> parts,
    List<DiscoveryPartCategory> categories,
  ) {
    final selectedCategory = categories.where((item) => item.id == _selectedCategoryId).firstOrNull;

    return parts.where((part) {
      final searchMatches = _searchQuery.isEmpty ||
          part.nameAr.toLowerCase().contains(_searchQuery) ||
          (part.nameEn?.toLowerCase().contains(_searchQuery) ?? false) ||
          (part.descriptionAr?.toLowerCase().contains(_searchQuery) ?? false);

      if (!searchMatches) {
        return false;
      }

      if (selectedCategory == null) {
        return true;
      }

      final haystack = [
        part.nameAr,
        part.nameEn ?? '',
        part.descriptionAr ?? '',
        part.category?['name_ar']?.toString() ?? '',
        part.category?['name_en']?.toString() ?? '',
      ].join(' ').toLowerCase();

      return selectedCategory.matchTerms.any(
        (term) => haystack.contains(term.toLowerCase()),
      );
    }).toList();
  }

  String _badgeForIndex(AppLocalizations l10n, int index) {
    switch (index) {
      case 0:
        return l10n.discoveryGenuine.toUpperCase();
      case 1:
        return l10n.discoveryPopular.toUpperCase();
      case 2:
        return l10n.discoveryLighting.toUpperCase();
      default:
        return '13%';
    }
  }

  String _shopName(Part part) {
    final shopName = part.shop?['name_en'] ?? part.shop?['name_ar'];
    if (shopName is String && shopName.trim().isNotEmpty) {
      return shopName.trim();
    }

    return 'ONLYCARS PARTS CO.';
  }

  String _partSubtitle(Part part) {
    final category = part.category?['name_en'] ?? part.category?['name_ar'];
    if (category is String && category.trim().isNotEmpty) {
      return category.trim();
    }

    return part.condition;
  }

  String _qarPrice(double price) {
    return 'QAR ${price.toStringAsFixed(0)}';
  }

  String _fallbackAsset(int index) {
    const assets = [
      'assets/images/part_brakes.png',
      'assets/images/part_filter.png',
      'assets/images/part_battery.png',
      'assets/images/part_oil.png',
    ];
    return assets[index % assets.length];
  }

  void _addToCart(Part part) {
    ref.read(cartProvider.notifier).add(part);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Added to cart')),
    );
  }
}

class _PartsCategoryTile extends StatelessWidget {
  const _PartsCategoryTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 74,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? DiscoveryPalette.primarySoft : const Color(0xFFF4F4FF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? DiscoveryPalette.primaryEnd
                  : DiscoveryPalette.borderSubtle,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: DiscoveryPalette.primaryEnd, size: 22),
              const SizedBox(height: 10),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: DiscoveryPalette.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MarketplaceLoadingColumn extends StatelessWidget {
  const _MarketplaceLoadingColumn();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _MarketplaceLoadingBlock(),
        SizedBox(height: 18),
        _MarketplaceLoadingBlock(),
      ],
    );
  }
}

class _MarketplaceLoadingBlock extends StatelessWidget {
  const _MarketplaceLoadingBlock();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}
