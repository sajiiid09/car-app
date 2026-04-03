import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_models/oc_models.dart';

import '../../l10n/app_localizations.dart';
import '../../providers.dart';
import '../discovery/discovery_palette.dart';
import '../discovery/discovery_widgets.dart';
import 'roadside_request_state.dart';

class PickupDetailsScreen extends ConsumerStatefulWidget {
  const PickupDetailsScreen({super.key});

  @override
  ConsumerState<PickupDetailsScreen> createState() => _PickupDetailsScreenState();
}

class _PickupDetailsScreenState extends ConsumerState<PickupDetailsScreen> {
  late final TextEditingController _locationController;
  late final TextEditingController _issueController;
  bool _prefilledAddress = false;
  bool _prefilledVehicle = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(roadsideRequestProvider).draft;
    _locationController = TextEditingController(text: draft.breakdownLocation);
    _issueController = TextEditingController(text: draft.issueNote);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userAsync = ref.watch(userProfileProvider);
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final addressesAsync = ref.watch(addressesProvider);
    final workshopsAsync = ref.watch(workshopsProvider);
    final requestState = ref.watch(roadsideRequestProvider);
    final draft = requestState.draft;
    final notifier = ref.read(roadsideRequestProvider.notifier);

    final vehicles = vehiclesAsync.valueOrNull ?? const <Vehicle>[];
    final addresses = addressesAsync.valueOrNull ?? const <Address>[];
    final workshops = workshopsAsync.valueOrNull ?? const <WorkshopProfile>[];
    final selectedVehicle = vehicles.where((item) => item.id == draft.selectedVehicleId).firstOrNull;
    final selectedWorkshop = workshops.where((item) => item.id == draft.selectedWorkshopId).firstOrNull;

    if (!_prefilledAddress && _locationController.text.trim().isEmpty && addresses.isNotEmpty) {
      final address = addresses.where((item) => item.isDefault).firstOrNull ?? addresses.first;
      final location = _formatAddress(address, l10n);
      if (location.isNotEmpty) {
        _prefilledAddress = true;
        _locationController.text = location;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          notifier.prefillBreakdownLocation(location);
        });
      }
    }

    if (!_prefilledVehicle && draft.selectedVehicleId == null && vehicles.isNotEmpty) {
      _prefilledVehicle = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        notifier.prefillVehicle(vehicles.first.id);
      });
    }

    final canProceed =
        draft.canSubmit && selectedVehicle != null && selectedWorkshop != null;

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
                ref.invalidate(vehiclesProvider);
                ref.invalidate(addressesProvider);
                ref.invalidate(workshopsProvider);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 250),
                child: Column(
                  key: const ValueKey('customerPickupDetailsPage'),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiscoveryBackBar(
                      avatarUrl: userAsync.valueOrNull?.avatarUrl,
                      onBackTap: () => context.go('/orders/request/workshops'),
                      onAvatarTap: () => context.go('/profile'),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.discoveryServiceRequest.toUpperCase(),
                        style: const TextStyle(
                          color: DiscoveryPalette.primaryEnd,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.discoveryPickupDetails,
                        style: const TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w800,
                          color: DiscoveryPalette.primaryStart,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _VehicleSummaryCard(
                      vehicle: selectedVehicle,
                      onSelectTap: vehicles.isEmpty
                          ? () => context.push('/vehicle/add')
                          : () => _showVehiclePicker(context, vehicles, draft.selectedVehicleId),
                    ),
                    const SizedBox(height: 24),
                    _InputGroupLabel(label: l10n.discoveryBreakdownLocation),
                    const SizedBox(height: 10),
                    _InfoTextField(
                      controller: _locationController,
                      icon: Icons.location_on_outlined,
                      hint: l10n.discoveryEnterLocation,
                      trailing: const Icon(
                        Icons.map_outlined,
                        color: DiscoveryPalette.textMuted,
                        size: 22,
                      ),
                      onChanged: notifier.setBreakdownLocation,
                    ),
                    const SizedBox(height: 24),
                    _InputGroupLabel(label: l10n.discoveryPreferredWorkshop),
                    const SizedBox(height: 10),
                    _InfoActionField(
                      icon: Icons.precision_manufacturing_outlined,
                      value: selectedWorkshop?.nameAr ?? l10n.discoverySelectWorkshop,
                      trailingIcon: Icons.keyboard_arrow_down_rounded,
                      onTap: () => context.go('/orders/request/workshops'),
                    ),
                    const SizedBox(height: 24),
                    _InputGroupLabel(label: l10n.discoveryIssueNote),
                    const SizedBox(height: 10),
                    _InfoTextField(
                      controller: _issueController,
                      icon: Icons.description_outlined,
                      hint: l10n.discoveryIssueNoteHint,
                      trailing: const Icon(
                        Icons.edit_outlined,
                        color: DiscoveryPalette.textMuted,
                        size: 22,
                      ),
                      onChanged: notifier.setIssueNote,
                    ),
                    const SizedBox(height: 24),
                    _ReturnDropOffCard(
                      title: l10n.discoveryPickupReturnTitle,
                      subtitle: l10n.discoveryPickupReturnSubtitle,
                      value: draft.returnDropOff,
                      onChanged: notifier.setReturnDropOff,
                    ),
                    const SizedBox(height: 24),
                    _FeeSummaryCard(
                      title: l10n.discoveryEstimatedTowingFee,
                      amount: draft.estimatedTowingFee,
                      caption: l10n.discoveryGuaranteedWithinDoha,
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
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 108),
                child: DiscoveryGradientButton(
                  label: l10n.discoveryProceed,
                  icon: Icons.arrow_forward_rounded,
                  height: 62,
                  onTap: canProceed
                      ? () => _submitRequest(
                            selectedVehicle: selectedVehicle,
                            selectedWorkshop: selectedWorkshop,
                          )
                      : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showVehiclePicker(
    BuildContext context,
    List<Vehicle> vehicles,
    String? selectedVehicleId,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: DiscoveryPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.discoverySelectVehicle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: DiscoveryPalette.primaryStart,
                  ),
                ),
                const SizedBox(height: 16),
                ...vehicles.map((vehicle) {
                  final selected = vehicle.id == selectedVehicleId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          ref.read(roadsideRequestProvider.notifier).selectVehicle(vehicle.id);
                          Navigator.of(context).pop();
                        },
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: selected
                                ? DiscoveryPalette.primarySoft
                                : DiscoveryPalette.surfaceSoft,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  _vehicleName(vehicle),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: DiscoveryPalette.primaryStart,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: DiscoveryPalette.primaryEnd,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submitRequest({
    required Vehicle selectedVehicle,
    required WorkshopProfile selectedWorkshop,
  }) {
    final index = ref
        .read(workshopsProvider)
        .valueOrNull
        ?.indexWhere((item) => item.id == selectedWorkshop.id);
    final fallbackIndex = index != null && index >= 0 ? index : 0;

    ref.read(roadsideRequestProvider.notifier).submit(
          workshopId: selectedWorkshop.id,
          workshopName: selectedWorkshop.nameAr,
          vehicleName: _vehicleName(selectedVehicle),
          plateNumber: selectedVehicle.plateNumber ?? '',
          pickupEstimateMinutes: _pickupEstimate(fallbackIndex),
          capacityLabel: selectedWorkshop.isOpenNow
              ? AppLocalizations.of(context)!.discoveryAvailableNow
              : AppLocalizations.of(context)!.discoverySlotsOpen(2),
          specialtyLabel: selectedWorkshop.specialties.firstOrNull ??
              AppLocalizations.of(context)!.discoveryGeneralService,
          imageUrl: selectedWorkshop.coverPhotoUrl,
        );

    context.go('/orders?tab=active');
  }

  static int _pickupEstimate(int index) {
    const values = [20, 35, 28, 42];
    return values[index % values.length];
  }

  static String _vehicleName(Vehicle vehicle) {
    return '${vehicle.make} ${vehicle.model} ${vehicle.year}';
  }

  static String _formatAddress(Address address, AppLocalizations l10n) {
    final segments = <String>[
      if (address.zone?.trim().isNotEmpty == true) address.zone!.trim(),
      if (address.building?.trim().isNotEmpty == true) address.building!.trim(),
      if (address.street?.trim().isNotEmpty == true) address.street!.trim(),
    ];
    if (segments.isEmpty) {
      return l10n.discoveryDefaultBreakdownLocation;
    }
    return segments.join(', ');
  }
}

class _VehicleSummaryCard extends StatelessWidget {
  const _VehicleSummaryCard({
    required this.vehicle,
    required this.onSelectTap,
  });

  final Vehicle? vehicle;
  final VoidCallback onSelectTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DiscoveryPalette.textSecondary.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onSelectTap,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: DiscoveryPalette.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: DiscoveryPalette.primaryEnd,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: vehicle == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.discoveryNoVehicleTitle,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: DiscoveryPalette.primaryStart,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.discoveryAddVehicleToContinue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: DiscoveryPalette.textSecondary,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${vehicle!.make} ${vehicle!.model}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: DiscoveryPalette.primaryStart,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        vehicle!.plateNumber?.trim().isNotEmpty == true
                            ? '${l10n.discoveryPlatePrefix} ${vehicle!.plateNumber!}'
                            : '${vehicle!.year}',
                        style: const TextStyle(
                          fontSize: 15,
                          color: DiscoveryPalette.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: DiscoveryPalette.primarySoft,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.discoveryReadyForService.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: DiscoveryPalette.primaryEnd,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 118,
            height: 118,
            decoration: BoxDecoration(
              color: DiscoveryPalette.imagePlaceholder,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.directions_car_filled_rounded,
              size: 54,
              color: DiscoveryPalette.primarySolid,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputGroupLabel extends StatelessWidget {
  const _InputGroupLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: DiscoveryPalette.textSecondary,
        letterSpacing: 1.8,
      ),
    );
  }
}

class _InfoTextField extends StatelessWidget {
  const _InfoTextField({
    required this.controller,
    required this.icon,
    required this.hint,
    required this.onChanged,
    this.trailing,
  });

  final TextEditingController controller;
  final IconData icon;
  final String hint;
  final Widget? trailing;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, color: DiscoveryPalette.primaryEnd, size: 26),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: const TextStyle(color: DiscoveryPalette.textMuted),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DiscoveryPalette.primaryStart,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 10),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _InfoActionField extends StatelessWidget {
  const _InfoActionField({
    required this.icon,
    required this.value,
    required this.trailingIcon,
    required this.onTap,
  });

  final IconData icon;
  final String value;
  final IconData trailingIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          decoration: BoxDecoration(
            color: DiscoveryPalette.surfaceSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Icon(icon, color: DiscoveryPalette.primaryEnd, size: 26),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: DiscoveryPalette.primaryStart,
                  ),
                ),
              ),
              Icon(
                trailingIcon,
                color: DiscoveryPalette.textSecondary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReturnDropOffCard extends StatelessWidget {
  const _ReturnDropOffCard({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: DiscoveryPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: DiscoveryPalette.navActiveBackground),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: DiscoveryPalette.navActiveBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.sync_alt_rounded,
              color: DiscoveryPalette.primaryEnd,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: DiscoveryPalette.primaryStart,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: DiscoveryPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: DiscoveryPalette.primaryEnd,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FeeSummaryCard extends StatelessWidget {
  const _FeeSummaryCard({
    required this.title,
    required this.amount,
    required this.caption,
  });

  final String title;
  final double amount;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF2F2F30),
        borderRadius: BorderRadius.circular(28),
        boxShadow: DiscoveryPalette.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),
              ),
              const Icon(
                Icons.info_outline_rounded,
                color: DiscoveryPalette.primaryEnd,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            '${amount.toStringAsFixed(0)} QAR',
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.white.withValues(alpha: 0.12)),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.verified_rounded,
                color: Color(0xFF6BD490),
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  caption.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
