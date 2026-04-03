import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../discovery/discovery_widgets.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  static const _paths = [
    '/profile',
    '/chat',
    '/orders',
    '/map',
    '/home',
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final l10n = AppLocalizations.of(context)!;
    final items = [
      DiscoveryBottomNavItemData(
        path: '/profile',
        label: l10n.discoveryNavProfile,
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
      ),
      DiscoveryBottomNavItemData(
        path: '/chat',
        label: l10n.discoveryNavChat,
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
      ),
      DiscoveryBottomNavItemData(
        path: '/orders',
        label: l10n.discoveryNavOrders,
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag_rounded,
      ),
      DiscoveryBottomNavItemData(
        path: '/map',
        label: l10n.discoveryNavMap,
        icon: Icons.location_on_outlined,
        activeIcon: Icons.location_on_rounded,
      ),
      DiscoveryBottomNavItemData(
        path: '/home',
        label: l10n.discoveryNavHome,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
      ),
    ];

    final currentIndex = _resolveIndex(location);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: DiscoveryBottomNavBar(
        items: items,
        currentIndex: currentIndex,
        onTap: (index) => context.go(_paths[index]),
      ),
    );
  }

  int _resolveIndex(String location) {
    if (location.startsWith('/workshops') || location.startsWith('/map')) {
      return 3;
    }

    if (location.startsWith('/orders/request')) {
      return 2;
    }

    for (int i = 0; i < _paths.length; i++) {
      if (location.startsWith(_paths[i])) {
        return i;
      }
    }

    return 4;
  }
}
