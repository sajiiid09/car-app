import 'dart:ui';

import 'package:flutter/material.dart';

import 'discovery_content.dart';
import 'discovery_palette.dart';

class DiscoveryScreenBody extends StatelessWidget {
  const DiscoveryScreenBody({
    super.key,
    required this.child,
    this.onRefresh,
  });

  final Widget child;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final content = SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 148),
        child: child,
      ),
    );

    if (onRefresh == null) {
      return content;
    }

    return RefreshIndicator(
      color: DiscoveryPalette.primaryEnd,
      onRefresh: onRefresh!,
      child: content,
    );
  }
}

class DiscoveryTopBar extends StatelessWidget {
  const DiscoveryTopBar({
    super.key,
    required this.avatarUrl,
    required this.notificationCount,
    required this.onAvatarTap,
    required this.onCartTap,
    required this.onNotificationTap,
  });

  final String? avatarUrl;
  final int notificationCount;
  final VoidCallback onAvatarTap;
  final VoidCallback onCartTap;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          _UtilityIconButton(
            icon: Icons.notifications_none_rounded,
            badgeCount: notificationCount,
            onTap: onNotificationTap,
          ),
          const SizedBox(width: 12),
          _UtilityIconButton(
            icon: Icons.shopping_cart_outlined,
            onTap: onCartTap,
          ),
          const Spacer(),
          const Text(
            'OnlyCars',
            style: TextStyle(
              color: DiscoveryPalette.primaryStart,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Spacer(),
          GestureDetector(
            key: const ValueKey('customerTopAvatar'),
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFFF3B88D),
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: DiscoveryPalette.textSecondary,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryBackBar extends StatelessWidget {
  const DiscoveryBackBar({
    super.key,
    required this.avatarUrl,
    required this.onBackTap,
    required this.onAvatarTap,
  });

  final String? avatarUrl;
  final VoidCallback onBackTap;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            child: const SizedBox(
              width: 32,
              height: 32,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: DiscoveryPalette.primaryStart,
                size: 22,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'OnlyCars',
            style: TextStyle(
              color: DiscoveryPalette.primaryStart,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: onAvatarTap,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF3B88D),
              backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
              child: avatarUrl == null || avatarUrl!.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 18,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryTitleBlock extends StatelessWidget {
  const DiscoveryTitleBlock({
    super.key,
    this.eyebrow,
    required this.title,
    this.subtitle,
  });

  final String? eyebrow;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.primaryEnd,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
        ],
        Text(
          title,
          style: const TextStyle(
            fontSize: 21,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: DiscoveryPalette.textPrimary,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: DiscoveryPalette.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class DiscoverySearchBar extends StatelessWidget {
  const DiscoverySearchBar({
    super.key,
    required this.hint,
    this.onTap,
    this.controller,
    this.onChanged,
    this.searchKey,
  });

  final String hint;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final Key? searchKey;

  bool get _editable => controller != null || onChanged != null;

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: const Color(0xFFF3F4FE),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: DiscoveryPalette.borderSubtle),
    );

    if (!_editable) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          key: searchKey,
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: decoration,
            child: Row(
              children: [
                const Icon(
                  Icons.tune_rounded,
                  color: DiscoveryPalette.primaryEnd,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    hint,
                    style: const TextStyle(
                      fontSize: 15,
                      color: DiscoveryPalette.primaryEnd,
                    ),
                  ),
                ),
                const Icon(
                  Icons.search_rounded,
                  color: DiscoveryPalette.primaryEnd,
                  size: 22,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 58,
      decoration: decoration,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(
            Icons.tune_rounded,
            color: DiscoveryPalette.primaryEnd,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              key: searchKey,
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration.collapsed(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 15,
                  color: DiscoveryPalette.primaryEnd,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                color: DiscoveryPalette.textPrimary,
              ),
            ),
          ),
          const Icon(
            Icons.search_rounded,
            color: DiscoveryPalette.primaryEnd,
            size: 22,
          ),
        ],
      ),
    );
  }
}

class DiscoveryViewToggle extends StatelessWidget {
  const DiscoveryViewToggle({
    super.key,
    required this.currentView,
    required this.mapLabel,
    required this.listLabel,
    required this.onMapTap,
    required this.onListTap,
  });

  final WorkshopExploreView currentView;
  final String mapLabel;
  final String listLabel;
  final VoidCallback onMapTap;
  final VoidCallback onListTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: DiscoveryPalette.primarySoft,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleSegment(
              key: const ValueKey('customerViewToggle-map'),
              label: mapLabel,
              selected: currentView == WorkshopExploreView.map,
              onTap: onMapTap,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ToggleSegment(
              key: const ValueKey('customerViewToggle-list'),
              label: listLabel,
              selected: currentView == WorkshopExploreView.list,
              onTap: onListTap,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryRouteTabs extends StatelessWidget {
  const DiscoveryRouteTabs({
    super.key,
    required this.activeTab,
    required this.servicesLabel,
    required this.partsLabel,
    required this.onServicesTap,
    required this.onPartsTap,
  });

  final DiscoveryRouteTab activeTab;
  final String servicesLabel;
  final String partsLabel;
  final VoidCallback onServicesTap;
  final VoidCallback onPartsTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _RouteTab(
          key: const ValueKey('customerRouteTab-services'),
          label: servicesLabel,
          selected: activeTab == DiscoveryRouteTab.services,
          onTap: onServicesTap,
        ),
        const SizedBox(width: 24),
        _RouteTab(
          key: const ValueKey('customerRouteTab-parts'),
          label: partsLabel,
          selected: activeTab == DiscoveryRouteTab.parts,
          onTap: onPartsTap,
        ),
      ],
    );
  }
}

class DiscoverySectionHeader extends StatelessWidget {
  const DiscoverySectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: DiscoveryPalette.textPrimary,
            ),
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: DiscoveryPalette.primaryEnd,
              ),
            ),
          ),
      ],
    );
  }
}

class DiscoveryFilterPill extends StatelessWidget {
  const DiscoveryFilterPill({
    super.key,
    required this.label,
    this.selected = false,
    this.trailingIcon,
  });

  final String label;
  final bool selected;
  final IconData? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? DiscoveryPalette.primaryEnd
        : DiscoveryPalette.surfaceSoft;
    final foreground = selected
        ? Colors.white
        : DiscoveryPalette.textSecondary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
          if (trailingIcon != null) ...[
            const SizedBox(width: 4),
            Icon(trailingIcon, size: 15, color: foreground),
          ],
        ],
      ),
    );
  }
}

class DiscoveryHeroCarousel extends StatefulWidget {
  const DiscoveryHeroCarousel({
    super.key,
    required this.items,
    required this.onPrimaryActionTap,
  });

  final List<DiscoveryHeroItem> items;
  final VoidCallback onPrimaryActionTap;

  @override
  State<DiscoveryHeroCarousel> createState() => _DiscoveryHeroCarouselState();
}

class _DiscoveryHeroCarouselState extends State<DiscoveryHeroCarousel> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 178,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final item = widget.items[index];
          return Padding(
            padding: EdgeInsets.only(right: index == widget.items.length - 1 ? 0 : 10),
            child: _HeroCard(
              item: item,
              onTap: widget.onPrimaryActionTap,
            ),
          );
        },
      ),
    );
  }
}

class DiscoveryShortcutTile extends StatelessWidget {
  const DiscoveryShortcutTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4FF),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DiscoveryPalette.borderSubtle),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  color: DiscoveryPalette.primaryEnd,
                  size: 22,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
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

class DiscoveryUploadCard extends StatelessWidget {
  const DiscoveryUploadCard({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('customerUploadCard'),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DiscoveryPalette.borderSubtle),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.add_circle_outline_rounded,
              color: DiscoveryPalette.primaryEnd,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: DiscoveryPalette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveryGradientButton extends StatelessWidget {
  const DiscoveryGradientButton({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.height = 50,
    this.width,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: onTap == null ? null : DiscoveryPalette.primaryGradient,
            color: onTap == null ? DiscoveryPalette.surfaceMuted : null,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: onTap == null ? DiscoveryPalette.textMuted : Colors.white,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoveryWorkshopCard extends StatelessWidget {
  const DiscoveryWorkshopCard({
    super.key,
    required this.name,
    required this.location,
    required this.distance,
    required this.priceLabel,
    required this.rating,
    required this.tags,
    required this.ctaLabel,
    this.imageUrl,
    this.onTap,
    this.onCtaTap,
  });

  final String name;
  final String location;
  final String distance;
  final String priceLabel;
  final String rating;
  final List<String> tags;
  final String ctaLabel;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onCtaTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4FE),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: DiscoveryPalette.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: _DiscoveryImage(
                      imageUrl: imageUrl,
                      assetPath: 'assets/images/ad_banner_1.png',
                      height: 190,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: DiscoveryPalette.primaryEnd,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: DiscoveryPalette.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      priceLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: DiscoveryPalette.primaryEnd,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: DiscoveryPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$distance • $location',
                      style: const TextStyle(
                        fontSize: 14,
                        color: DiscoveryPalette.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.take(2).map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: DiscoveryPalette.textPrimary,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    DiscoveryGradientButton(
                      label: ctaLabel,
                      onTap: onCtaTap,
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

class DiscoveryPartsGridCard extends StatelessWidget {
  const DiscoveryPartsGridCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.price,
    this.imageUrl,
    this.assetPath,
    this.onTap,
    this.onAddTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final String? imageUrl;
  final String? assetPath;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: _DiscoveryImage(
                      imageUrl: imageUrl,
                      assetPath: assetPath ?? 'assets/images/part_filter.png',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DiscoveryPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: DiscoveryPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: DiscoveryPalette.primaryEnd,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onAddTap,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: const BoxDecoration(
                          color: DiscoveryPalette.primaryEnd,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiscoveryFeatureProductCard extends StatelessWidget {
  const DiscoveryFeatureProductCard({
    super.key,
    required this.badgeLabel,
    required this.shopName,
    required this.title,
    required this.subtitle,
    required this.price,
    this.imageUrl,
    this.assetPath,
    this.onTap,
    this.onAddTap,
  });

  final String badgeLabel;
  final String shopName;
  final String title;
  final String subtitle;
  final String price;
  final String? imageUrl;
  final String? assetPath;
  final VoidCallback? onTap;
  final VoidCallback? onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4FE),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: DiscoveryPalette.borderSubtle),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: _DiscoveryImage(
                      imageUrl: imageUrl,
                      assetPath: assetPath ?? 'assets/images/part_brakes.png',
                      height: 232,
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: const BoxDecoration(
                        color: DiscoveryPalette.primaryEnd,
                        borderRadius: BorderRadius.all(Radius.circular(999)),
                      ),
                      child: Text(
                        badgeLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: onAddTap,
                      child: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: DiscoveryPalette.primaryEnd,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            shopName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: DiscoveryPalette.textSecondary,
                              letterSpacing: 1.1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            title,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: DiscoveryPalette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            textAlign: TextAlign.end,
                            style: const TextStyle(
                              fontSize: 14,
                              color: DiscoveryPalette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: DiscoveryPalette.primaryEnd,
                            ),
                          ),
                        ],
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

class DiscoveryBottomNavItemData {
  const DiscoveryBottomNavItemData({
    required this.path,
    required this.label,
    required this.icon,
    required this.activeIcon,
  });

  final String path;
  final String label;
  final IconData icon;
  final IconData activeIcon;
}

class DiscoveryBottomNavBar extends StatelessWidget {
  const DiscoveryBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<DiscoveryBottomNavItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: DiscoveryPalette.surface.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: DiscoveryPalette.primaryEnd.withValues(alpha: 0.65),
                ),
                boxShadow: DiscoveryPalette.navShadow,
              ),
              child: Row(
                children: [
                  for (int i = 0; i < items.length; i++)
                    Expanded(
                      child: _BottomNavItem(
                        key: ValueKey('customerNav-${items[i].path}'),
                        item: items[i],
                        selected: currentIndex == i,
                        onTap: () => onTap(i),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UtilityIconButton extends StatelessWidget {
  const _UtilityIconButton({
    required this.icon,
    required this.onTap,
    this.badgeCount = 0,
  });

  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 26,
        height: 26,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Icon(icon, size: 22, color: DiscoveryPalette.navInactive),
            ),
            if (badgeCount > 0)
              Positioned(
                top: 0,
                right: -1,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: DiscoveryPalette.primaryEnd,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ToggleSegment extends StatelessWidget {
  const _ToggleSegment({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
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

class _RouteTab extends StatelessWidget {
  const _RouteTab({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: selected
                      ? DiscoveryPalette.primaryEnd
                      : DiscoveryPalette.textSecondary,
                ),
              ),
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                height: 3,
                width: 58,
                decoration: BoxDecoration(
                  color: selected
                      ? DiscoveryPalette.primaryEnd
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.item,
    required this.onTap,
  });

  final DiscoveryHeroItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: DiscoveryPalette.primaryGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: item.assetPath != null
                  ? Opacity(
                      opacity: 0.22,
                      child: Image.asset(item.assetPath!, fit: BoxFit.cover),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.10),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.12),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.eyebrow,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(999),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(999),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 11,
                      ),
                      child: Text(
                        item.buttonLabel,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DiscoveryPalette.primaryEnd,
                        ),
                      ),
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

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DiscoveryBottomNavItemData item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? DiscoveryPalette.primaryEnd
        : DiscoveryPalette.navInactive;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
            decoration: BoxDecoration(
              color: selected
                  ? DiscoveryPalette.navActiveBackground
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? item.activeIcon : item.icon,
                  size: 21,
                  color: color,
                ),
                const SizedBox(height: 6),
                Text(
                  item.label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: color,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DiscoveryImage extends StatelessWidget {
  const _DiscoveryImage({
    this.imageUrl,
    this.assetPath,
    this.height,
  });

  final String? imageUrl;
  final String? assetPath;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: height,
      color: DiscoveryPalette.imagePlaceholder,
      child: const Center(
        child: Icon(
          Icons.directions_car_filled_outlined,
          size: 42,
          color: DiscoveryPalette.primarySolid,
        ),
      ),
    );

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
        loadingBuilder: (context, child, progress) {
          if (progress == null) {
            return child;
          }
          return placeholder;
        },
      );
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => placeholder,
      );
    }

    return placeholder;
  }
}
