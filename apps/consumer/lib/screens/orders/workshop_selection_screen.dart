import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_palette.dart';
import '../discovery/discovery_widgets.dart';
import 'roadside_request_state.dart';

class WorkshopSelectionScreen extends ConsumerWidget {
  const WorkshopSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider);
    final workshopsAsync = ref.watch(workshopsProvider);
    final selectedWorkshopId = ref.watch(
      roadsideRequestProvider.select((value) => value.draft.selectedWorkshopId),
    );

    return Scaffold(
      backgroundColor: DiscoveryPalette.background,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: RefreshIndicator(
              color: DiscoveryPalette.primaryEnd,
              onRefresh: () async {
                ref.invalidate(userProfileProvider);
                ref.invalidate(workshopsProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 214),
                child: Column(
                  key: const ValueKey('customerWorkshopSelectionPage'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiscoveryBackBar(
                      avatarUrl: userAsync.valueOrNull?.avatarUrl,
                      onBackTap: () => context.go('/map'),
                      onAvatarTap: () => context.go('/profile'),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: _PremiumBadge(label: l10n.discoveryPremiumService),
                    ),
                    const SizedBox(height: 22),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.discoveryServiceNetwork,
                            style: const TextStyle(
                              color: DiscoveryPalette.primaryEnd,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.6,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.discoveryChooseWorkshop,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 31,
                              height: 1.05,
                              fontWeight: FontWeight.w800,
                              color: DiscoveryPalette.primaryStart,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            l10n.discoveryChooseWorkshopSubtitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.7,
                              color: DiscoveryPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    workshopsAsync.when(
                      data: (workshops) {
                        if (workshops.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final ordered = _orderedWorkshops(
                          workshops: workshops,
                          selectedWorkshopId: selectedWorkshopId,
                        );

                        return Column(
                          children: List.generate(ordered.length.clamp(0, 4), (index) {
                            final workshop = ordered[index];
                            final isSelected = workshop.id == selectedWorkshopId || (selectedWorkshopId == null && index == 0);
                            return Padding(
                              padding: EdgeInsets.only(bottom: index == 3 ? 0 : 24),
                              child: _WorkshopChoiceCard(
                                workshop: workshop,
                                rating: workshop.avgRating == 0
                                    ? _fallbackRating(index)
                                    : workshop.avgRating.toStringAsFixed(1),
                                distanceLabel: _distanceLabel(index, workshop.zone),
                                pickupEstimate: _pickupEstimate(index),
                                capacityLabel: _capacityLabel(l10n, index, workshop),
                                specialtyLabel: _specialtyLabel(l10n, index, workshop),
                                recommended: index == 0,
                                selected: isSelected,
                                buttonLabel: l10n.discoverySelectWorkshop,
                                onPressed: () {
                                  ref
                                      .read(roadsideRequestProvider.notifier)
                                      .selectWorkshop(
                                        workshopId: workshop.id,
                                        workshopName: workshop.nameAr,
                                      );
                                  context.go('/orders/request/pickup');
                                },
                              ),
                            );
                          }),
                        );
                      },
                      loading: () => const _WorkshopSelectionLoading(),
                      error: (error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 108),
                child: _MapPillButton(
                  label: l10n.discoveryViewMap,
                  onTap: () => context.go('/map'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<WorkshopProfile> _orderedWorkshops({
    required List<WorkshopProfile> workshops,
    required String? selectedWorkshopId,
  }) {
    final sorted = [...workshops]
      ..sort((a, b) => b.avgRating.compareTo(a.avgRating));
    if (selectedWorkshopId == null) {
      return sorted;
    }

    sorted.sort((a, b) {
      if (a.id == selectedWorkshopId) {
        return -1;
      }
      if (b.id == selectedWorkshopId) {
        return 1;
      }
      return 0;
    });
    return sorted;
  }

  static String _fallbackRating(int index) {
    const ratings = ['4.9', '4.7', '4.8', '4.6'];
    return ratings[index % ratings.length];
  }

  static String _distanceLabel(int index, String? zone) {
    const distances = ['1.2km away', '2.8km away', '3.4km away', '4.0km away'];
    final location = zone?.trim().isNotEmpty == true ? zone!.trim() : 'Doha';
    return '${distances[index % distances.length]} • $location';
  }

  static int _pickupEstimate(int index) {
    const values = [20, 35, 28, 42];
    return values[index % values.length];
  }

  static String _capacityLabel(
    AppLocalizations l10n,
    int index,
    WorkshopProfile workshop,
  ) {
    if (workshop.isOpenNow) {
      return l10n.discoveryAvailableNow;
    }
    if (index == 1) {
      return l10n.discoverySlotsOpen(2);
    }
    return l10n.discoverySameDayReady;
  }

  static String _specialtyLabel(
    AppLocalizations l10n,
    int index,
    WorkshopProfile workshop,
  ) {
    if (workshop.specialties.isNotEmpty) {
      return workshop.specialties.first;
    }
    const fallback = ['German Engineering', 'General Service', 'Diagnostics', 'Luxury Cars'];
    return switch (index) {
      0 => l10n.discoveryGermanEngineering,
      1 => l10n.discoveryGeneralService,
      2 => l10n.discoveryDiagnostics,
      _ => fallback[index % fallback.length],
    };
  }
}

class _WorkshopChoiceCard extends StatelessWidget {
  const _WorkshopChoiceCard({
    required this.workshop,
    required this.rating,
    required this.distanceLabel,
    required this.pickupEstimate,
    required this.capacityLabel,
    required this.specialtyLabel,
    required this.recommended,
    required this.selected,
    required this.buttonLabel,
    required this.onPressed,
  });

  final WorkshopProfile workshop;
  final String rating;
  final String distanceLabel;
  final int pickupEstimate;
  final String capacityLabel;
  final String specialtyLabel;
  final bool recommended;
  final bool selected;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: selected
              ? DiscoveryPalette.primaryEnd.withValues(alpha: 0.35)
              : DiscoveryPalette.borderSubtle,
        ),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                child: _WorkshopImage(imageUrl: workshop.coverPhotoUrl),
              ),
              if (recommended)
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: DiscoveryPalette.primaryEnd,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.discoveryRecommended.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(16),
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
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: DiscoveryPalette.primaryStart,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
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
                            workshop.nameAr,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: DiscoveryPalette.primaryStart,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            distanceLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              color: DiscoveryPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.discoveryPickupEstimateLabel,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: DiscoveryPalette.textSecondary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.discoveryMinutesValue(pickupEstimate),
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: DiscoveryPalette.primaryEnd,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        label: AppLocalizations.of(context)!.discoveryCapacityLabel,
                        value: capacityLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MetricTile(
                        label: AppLocalizations.of(context)!.discoverySpecialtyLabel,
                        value: specialtyLabel,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                _WorkshopSelectButton(
                  label: buttonLabel,
                  primary: selected || recommended,
                  onTap: onPressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.textSecondary,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.primaryStart,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkshopSelectButton extends StatelessWidget {
  const _WorkshopSelectButton({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: primary ? DiscoveryPalette.primaryGradient : null,
            color: primary ? null : DiscoveryPalette.primarySoft,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: primary ? Colors.white : DiscoveryPalette.primaryEnd,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapPillButton extends StatelessWidget {
  const _MapPillButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: DiscoveryPalette.primaryGradient,
          borderRadius: BorderRadius.circular(999),
          boxShadow: DiscoveryPalette.cardShadow,
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.map_outlined,
                  size: 18,
                  color: Colors.white,
                ),
                const SizedBox(width: 10),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.8,
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

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: DiscoveryPalette.primarySoft,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.stars_rounded,
            size: 16,
            color: DiscoveryPalette.primaryEnd,
          ),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DiscoveryPalette.primaryEnd,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkshopSelectionLoading extends StatelessWidget {
  const _WorkshopSelectionLoading();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        2,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index == 1 ? 0 : 24),
          child: Container(
            height: 410,
            decoration: BoxDecoration(
              color: DiscoveryPalette.surface,
              borderRadius: BorderRadius.circular(26),
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkshopImage extends StatelessWidget {
  const _WorkshopImage({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: 256,
      color: DiscoveryPalette.imagePlaceholder,
      child: const Center(
        child: Icon(
          Icons.build_circle_outlined,
          size: 48,
          color: DiscoveryPalette.primarySolid,
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder;
    }

    return Image.network(
      imageUrl!,
      height: 256,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => placeholder,
      loadingBuilder: (context, child, progress) {
        if (progress == null) {
          return child;
        }
        return placeholder;
      },
    );
  }
}
