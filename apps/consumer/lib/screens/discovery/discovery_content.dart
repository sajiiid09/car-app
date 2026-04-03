import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

enum WorkshopExploreView { map, list }

extension WorkshopExploreViewX on WorkshopExploreView {
  static WorkshopExploreView fromQuery(String? value) {
    switch (value) {
      case 'list':
        return WorkshopExploreView.list;
      case 'map':
      default:
        return WorkshopExploreView.map;
    }
  }

  String get queryValue => this == WorkshopExploreView.list ? 'list' : 'map';
}

enum DiscoveryRouteTab { services, parts }

enum OrdersHistoryTab { active, completed, cancelled }

extension OrdersHistoryTabX on OrdersHistoryTab {
  static OrdersHistoryTab fromQuery(String? value) {
    switch (value) {
      case 'completed':
        return OrdersHistoryTab.completed;
      case 'cancelled':
        return OrdersHistoryTab.cancelled;
      case 'active':
      default:
        return OrdersHistoryTab.active;
    }
  }

  String get queryValue => switch (this) {
    OrdersHistoryTab.active => 'active',
    OrdersHistoryTab.completed => 'completed',
    OrdersHistoryTab.cancelled => 'cancelled',
  };
}

enum RoadsideRequestContext { roadside, home, workshop, office }

extension RoadsideRequestContextX on RoadsideRequestContext {
  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      RoadsideRequestContext.roadside => l10n.discoveryRoadside,
      RoadsideRequestContext.home => l10n.discoveryHomeContext,
      RoadsideRequestContext.workshop => l10n.discoveryWorkshopContext,
      RoadsideRequestContext.office => l10n.discoveryOfficeContext,
    };
  }
}

class DiscoveryHeroItem {
  const DiscoveryHeroItem({
    required this.eyebrow,
    required this.title,
    required this.buttonLabel,
    this.assetPath,
  });

  final String eyebrow;
  final String title;
  final String buttonLabel;
  final String? assetPath;
}

class DiscoveryShortcutItem {
  const DiscoveryShortcutItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class DiscoveryServiceCategory {
  const DiscoveryServiceCategory({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

class DiscoveryPartCategory {
  const DiscoveryPartCategory({
    required this.id,
    required this.icon,
    required this.label,
    required this.matchTerms,
  });

  final String id;
  final IconData icon;
  final String label;
  final List<String> matchTerms;
}

List<DiscoveryHeroItem> discoveryHeroItems(AppLocalizations l10n) => [
  DiscoveryHeroItem(
    eyebrow: l10n.discoverySummerEssentials,
    title: l10n.discoveryHeroTitle,
    buttonLabel: l10n.discoveryShopCollection,
    assetPath: 'assets/images/ad_banner_1.png',
  ),
  DiscoveryHeroItem(
    eyebrow: l10n.discoveryPremiumCare,
    title: l10n.discoveryHeroSecondaryTitle,
    buttonLabel: l10n.discoveryBookNow,
    assetPath: 'assets/images/ad_banner_1.png',
  ),
];

List<DiscoveryShortcutItem> discoveryShortcutItems(AppLocalizations l10n) => [
  DiscoveryShortcutItem(
    icon: Icons.build_circle_outlined,
    label: l10n.discoveryServicesLabel,
    route: '/map',
  ),
  DiscoveryShortcutItem(
    icon: Icons.shopping_bag_outlined,
    label: l10n.discoveryPartsLabel,
    route: '/marketplace',
  ),
  DiscoveryShortcutItem(
    icon: Icons.directions_car_filled_outlined,
    label: l10n.myCars,
    route: '/vehicle/add',
  ),
];

List<DiscoveryServiceCategory> discoveryServiceCategories(
  AppLocalizations l10n,
) => [
  DiscoveryServiceCategory(
    icon: Icons.oil_barrel_outlined,
    label: l10n.discoveryOilChange,
  ),
  DiscoveryServiceCategory(
    icon: Icons.album_outlined,
    label: l10n.discoveryBrakeService,
  ),
  DiscoveryServiceCategory(
    icon: Icons.ac_unit_outlined,
    label: l10n.discoveryAcRepair,
  ),
  DiscoveryServiceCategory(
    icon: Icons.verified_outlined,
    label: l10n.discoveryRegularCheckup,
  ),
];

List<DiscoveryPartCategory> discoveryPartCategories(AppLocalizations l10n) => [
  DiscoveryPartCategory(
    id: 'engine',
    icon: Icons.tune_rounded,
    label: l10n.discoveryEngine,
    matchTerms: const ['engine', 'oil', 'filter', 'محرك', 'فلتر', 'زيت'],
  ),
  DiscoveryPartCategory(
    id: 'exterior',
    icon: Icons.directions_car_filled_outlined,
    label: l10n.discoveryExterior,
    matchTerms: const ['exterior', 'body', 'خارجي', 'هيكل'],
  ),
  DiscoveryPartCategory(
    id: 'lighting',
    icon: Icons.lightbulb_outline_rounded,
    label: l10n.discoveryLighting,
    matchTerms: const ['light', 'lighting', 'lamp', 'إضاءة', 'مصباح'],
  ),
  DiscoveryPartCategory(
    id: 'tires',
    icon: Icons.trip_origin_rounded,
    label: l10n.discoveryTires,
    matchTerms: const ['tire', 'wheel', 'brake', 'إطار', 'عجلة', 'فرامل'],
  ),
  DiscoveryPartCategory(
    id: 'electrical',
    icon: Icons.electrical_services_outlined,
    label: l10n.discoveryElectrical,
    matchTerms: const ['electrical', 'battery', 'electric', 'كهرباء', 'بطارية'],
  ),
];
