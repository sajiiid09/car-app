import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_content.dart';
import '../discovery/discovery_palette.dart';
import '../orders/roadside_request_state.dart';

class WorkshopListScreen extends ConsumerStatefulWidget {
  const WorkshopListScreen({super.key});

  @override
  ConsumerState<WorkshopListScreen> createState() => _WorkshopListScreenState();
}

class _WorkshopListScreenState extends ConsumerState<WorkshopListScreen> {
  String? _selectedWorkshopId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final workshopsAsync = ref.watch(workshopsProvider);
    final selectedContext = ref.watch(
      roadsideRequestProvider.select((value) => value.draft.context),
    );

    return Scaffold(
      backgroundColor: DiscoveryPalette.background,
      body: RefreshIndicator(
        color: DiscoveryPalette.primaryEnd,
        onRefresh: () async => ref.invalidate(workshopsProvider),
        child: ListView(
          key: const ValueKey('customerMapPage'),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 620,
              child: workshopsAsync.when(
                data: (workshops) {
                  if (workshops.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final selectedId = _selectedWorkshopId ?? workshops.first.id;
                  return _MapHero(
                    workshops: workshops,
                    selectedWorkshopId: selectedId,
                    selectedContext: selectedContext,
                    onBackTap: () => context.go('/home'),
                    onContextTap: (value) {
                      ref.read(roadsideRequestProvider.notifier).setContext(value);
                    },
                    onMarkerTap: (workshop) {
                      ref.read(roadsideRequestProvider.notifier).selectWorkshop(
                            workshopId: workshop.id,
                            workshopName: workshop.nameAr,
                          );
                      setState(() => _selectedWorkshopId = workshop.id);
                      context.go('/orders/request/workshops');
                    },
                  );
                },
                loading: () => const _MapPlaceholder(),
                error: (error, stackTrace) => const _MapPlaceholder(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 140),
              child: workshopsAsync.when(
                data: (workshops) {
                  if (workshops.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final nearby = [...workshops]
                    ..sort((a, b) => b.avgRating.compareTo(a.avgRating));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l10n.discoveryNearbyWorkshops,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: DiscoveryPalette.primaryStart,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.go('/orders/request/workshops'),
                            child: Text(
                              l10n.discoverySeeAll,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: DiscoveryPalette.primaryEnd,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      SizedBox(
                        height: 486,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: nearby.length.clamp(0, 4),
                          separatorBuilder: (context, index) => const SizedBox(width: 18),
                          itemBuilder: (context, index) {
                            final workshop = nearby[index];
                            return _NearbyWorkshopCard(
                              workshop: workshop,
                              rating: workshop.avgRating == 0
                                  ? _fallbackRatings[index % _fallbackRatings.length]
                                  : workshop.avgRating.toStringAsFixed(1),
                              distance: _distanceLabels[index % _distanceLabels.length],
                              discountLabel: _discountLabels[index % _discountLabels.length],
                              tags: workshop.specialties.isNotEmpty
                                  ? workshop.specialties.take(2).toList()
                                  : _fallbackTags[index % _fallbackTags.length],
                              onTap: () {
                                ref.read(roadsideRequestProvider.notifier).selectWorkshop(
                                      workshopId: workshop.id,
                                      workshopName: workshop.nameAr,
                                    );
                                context.go('/orders/request/workshops');
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _distanceLabels = ['1.2 km away', '2.6 km away', '3.1 km away', '4.4 km away'];
  static const _discountLabels = ['14%', '8%', '12%', '10%'];
  static const _fallbackRatings = ['4.9', '4.8', '4.7', '4.6'];
  static const _fallbackTags = [
    ['LUXURY CARS', 'DIAGNOSTICS'],
    ['ROADSIDE', 'SUSPENSION'],
    ['GERMAN CARS', 'ELECTRICAL'],
    ['BRAKES', 'GENERAL SERVICE'],
  ];
}

class _MapHero extends StatelessWidget {
  const _MapHero({
    required this.workshops,
    required this.selectedWorkshopId,
    required this.selectedContext,
    required this.onBackTap,
    required this.onContextTap,
    required this.onMarkerTap,
  });

  final List<WorkshopProfile> workshops;
  final String selectedWorkshopId;
  final RoadsideRequestContext selectedContext;
  final VoidCallback onBackTap;
  final ValueChanged<RoadsideRequestContext> onContextTap;
  final ValueChanged<WorkshopProfile> onMarkerTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: const BoxDecoration(color: Color(0xFFF1F0EE)),
            child: CustomPaint(painter: _MapBackgroundPainter()),
          ),
        ),
        _WorkshopMarkersLayer(
          workshops: workshops,
          selectedWorkshopId: selectedWorkshopId,
          onMarkerTap: onMarkerTap,
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: DiscoveryPalette.cardShadow,
                  ),
                  child: Text(
                    l10n.discoveryMapSector,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: DiscoveryPalette.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    GestureDetector(
                      onTap: onBackTap,
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 26,
                        color: DiscoveryPalette.primaryStart,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.discoveryFindNearbyWorkshops,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: DiscoveryPalette.primaryStart,
                        ),
                      ),
                    ),
                    const SizedBox(width: 38),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 58,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: DiscoveryPalette.primaryStart),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: DiscoveryPalette.textSecondary,
                              size: 30,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.discoverySearchWorkshopsAndParts,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: DiscoveryPalette.primaryStart,
                                ),
                              ),
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: DiscoveryPalette.primaryEnd,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.my_location_rounded,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.96),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: DiscoveryPalette.textSecondary.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: DiscoveryPalette.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: RoadsideRequestContext.values.map((value) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: _ContextChip(
                          label: value.localizedLabel(l10n),
                          selected: value == selectedContext,
                          onTap: () => onContextTap(value),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width - 48,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: DiscoveryPalette.cardShadow,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: DiscoveryPalette.primaryEnd,
                            border: Border.all(color: const Color(0xFFFFD0D0), width: 3),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            l10n.discoveryYourNearbyWorkshops,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: DiscoveryPalette.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({
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
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? DiscoveryPalette.navActiveBackground : Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: DiscoveryPalette.cardShadow,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: selected
                  ? DiscoveryPalette.primaryEnd
                  : DiscoveryPalette.primaryStart,
            ),
          ),
        ),
      ),
    );
  }
}

class _NearbyWorkshopCard extends StatelessWidget {
  const _NearbyWorkshopCard({
    required this.workshop,
    required this.rating,
    required this.distance,
    required this.discountLabel,
    required this.tags,
    required this.onTap,
  });

  final WorkshopProfile workshop;
  final String rating;
  final String distance;
  final String discountLabel;
  final List<String> tags;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 336,
      child: Container(
        decoration: BoxDecoration(
          color: DiscoveryPalette.surface,
          borderRadius: BorderRadius.circular(26),
          boxShadow: DiscoveryPalette.cardShadow,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                      child: _WorkshopPreviewImage(imageUrl: workshop.coverPhotoUrl),
                    ),
                    Positioned(
                      left: 14,
                      top: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: DiscoveryPalette.navActiveBackground,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          discountLabel,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: DiscoveryPalette.primaryStart,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      right: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.96),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 18,
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
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 78,
                        child: Text(
                          distance,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.35,
                            color: DiscoveryPalette.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              workshop.nameAr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: DiscoveryPalette.primaryStart,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 10,
                              runSpacing: 10,
                              children: tags.take(2).map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: DiscoveryPalette.surfaceSoft,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: DiscoveryPalette.textSecondary,
                                    ),
                                  ),
                                );
                              }).toList(),
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
      ),
    );
  }
}

class _WorkshopMarkersLayer extends StatelessWidget {
  const _WorkshopMarkersLayer({
    required this.workshops,
    required this.selectedWorkshopId,
    required this.onMarkerTap,
  });

  final List<WorkshopProfile> workshops;
  final String selectedWorkshopId;
  final ValueChanged<WorkshopProfile> onMarkerTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final minLat = workshops.map((item) => item.lat).reduce(math.min);
        final maxLat = workshops.map((item) => item.lat).reduce(math.max);
        final minLng = workshops.map((item) => item.lng).reduce(math.min);
        final maxLng = workshops.map((item) => item.lng).reduce(math.max);
        final latRange = (maxLat - minLat).abs() < 0.0001 ? 0.01 : maxLat - minLat;
        final lngRange = (maxLng - minLng).abs() < 0.0001 ? 0.01 : maxLng - minLng;

        return Stack(
          children: List.generate(workshops.length.clamp(0, 10), (index) {
            final workshop = workshops[index];
            final dx = 24 +
                ((workshop.lng - minLng) / lngRange) *
                    (constraints.maxWidth - 72);
            final dy = 150 +
                (1 - ((workshop.lat - minLat) / latRange)) *
                    (constraints.maxHeight - 320);
            final selected = workshop.id == selectedWorkshopId || index == 0;

            return Positioned(
              left: dx,
              top: dy,
              child: GestureDetector(
                onTap: () => onMarkerTap(workshop),
                child: SizedBox(
                  width: 54,
                  height: 54,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (selected)
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF7C7C).withValues(alpha: 0.18),
                          ),
                        ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: DiscoveryPalette.primaryEnd, width: 7),
                        ),
                      ),
                      const Icon(
                        Icons.place_rounded,
                        size: 28,
                        color: DiscoveryPalette.primaryEnd,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final broadStreet = Paint()
      ..color = Colors.white.withValues(alpha: 0.72)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    final sideStreet = Paint()
      ..color = Colors.white.withValues(alpha: 0.82)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final broadLines = [
      [Offset(size.width * 0.05, size.height * 0.12), Offset(size.width * 0.95, size.height * 0.05)],
      [Offset(size.width * 0.12, size.height * 0.02), Offset(size.width * 0.68, size.height * 0.92)],
      [Offset(size.width * 0.02, size.height * 0.64), Offset(size.width * 0.98, size.height * 0.54)],
      [Offset(size.width * 0.78, size.height * 0.14), Offset(size.width * 0.86, size.height * 0.96)],
    ];

    for (final line in broadLines) {
      canvas.drawLine(line[0], line[1], broadStreet);
    }

    for (int i = 0; i < 6; i++) {
      final y = size.height * (0.14 + i * 0.12);
      canvas.drawLine(
        Offset(size.width * 0.04, y),
        Offset(size.width * 0.96, y + (i.isEven ? 22 : -18)),
        sideStreet,
      );
    }
    for (int i = 0; i < 5; i++) {
      final x = size.width * (0.14 + i * 0.18);
      canvas.drawLine(
        Offset(x, size.height * 0.02),
        Offset(x + (i.isEven ? 40 : -28), size.height * 0.94),
        sideStreet,
      );
    }

    final labelStyle = const TextStyle(
      color: DiscoveryPalette.textSecondary,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    final sectorStyle = labelStyle.copyWith(fontSize: 12);

    _paintText(canvas, size, 'Doha', const Offset(26, 284), labelStyle);
    _paintText(canvas, size, 'Doha', Offset(size.width - 96, 334), labelStyle);
    _paintText(canvas, size, 'Sector 23', Offset(size.width - 174, 358), sectorStyle);
    _paintText(canvas, size, 'QUEENS', Offset(size.width - 132, size.height - 94), sectorStyle);
  }

  void _paintText(Canvas canvas, Size size, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: size.width);
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPlaceholder extends StatelessWidget {
  const _MapPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(color: Color(0xFFF1F0EE)),
      child: Center(
        child: CircularProgressIndicator(color: DiscoveryPalette.primaryEnd),
      ),
    );
  }
}

class _WorkshopPreviewImage extends StatelessWidget {
  const _WorkshopPreviewImage({
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: 260,
      color: DiscoveryPalette.imagePlaceholder,
      child: const Center(
        child: Icon(
          Icons.directions_car_filled_outlined,
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
      height: 260,
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
