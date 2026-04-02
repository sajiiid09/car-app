import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../l10n/app_localizations.dart';
import '../shared/partner_flow_palette.dart';
import '../shared/partner_flow_widgets.dart';
import 'driver_sign_up_state.dart';

class DriverSignUpScreen extends ConsumerStatefulWidget {
  const DriverSignUpScreen({super.key});

  @override
  ConsumerState<DriverSignUpScreen> createState() => _DriverSignUpScreenState();
}

class _DriverSignUpScreenState extends ConsumerState<DriverSignUpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final AnimationController _controller;
  DriverVehicleType? _vehicleType;
  DriverServiceArea? _serviceArea;
  String? _driversLicenseImagePath;
  bool _showSupplementaryErrors = false;

  final _formKey = GlobalKey<FormState>();

  bool get _canSubmit =>
      _fullNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _vehicleType != null &&
      _serviceArea != null &&
      _driversLicenseImagePath != null;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(driverRegistrationDraftProvider);
    _fullNameController = TextEditingController(text: draft.fullName)
      ..addListener(_handleFieldChanged);
    _phoneController = TextEditingController(text: draft.phone)
      ..addListener(_handleFieldChanged);
    _vehicleType = draft.vehicleType;
    _serviceArea = draft.serviceArea;
    _driversLicenseImagePath = draft.driversLicenseImagePath;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFieldChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  DriverRegistrationDraft _currentDraft({bool acceptedPrivacy = false}) {
    return DriverRegistrationDraft(
      fullName: _fullNameController.text.trim(),
      phone: _phoneController.text.trim(),
      vehicleType: _vehicleType,
      serviceArea: _serviceArea,
      driversLicenseImagePath: _driversLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy,
    );
  }

  Future<void> _pickDriversLicense() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: PartnerFlowPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 68,
                    height: 5,
                    decoration: BoxDecoration(
                      color: PartnerFlowPalette.textMuted.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.driverChooseImageSource,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: PartnerFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  key: const Key('driverLicenseCameraOption'),
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.driverCamera),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  key: const Key('driverLicenseGalleryOption'),
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.driverGallery),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null || !mounted) {
      return;
    }

    final picker = ref.read(driverLicensePickerProvider);
    final path = await picker.pickImage(source: source);
    if (!mounted || path == null) {
      return;
    }

    setState(() {
      _driversLicenseImagePath = path;
      _showSupplementaryErrors = false;
    });
  }

  void _toggleVehicleType(DriverVehicleType vehicleType) {
    setState(() {
      _vehicleType = vehicleType;
      _showSupplementaryErrors = false;
    });
  }

  void _saveDraft() {
    ref
        .read(driverRegistrationDraftProvider.notifier)
        .saveDraft(_currentDraft());
    context.go('/roles');
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final supplementaryValid =
        _vehicleType != null &&
        _serviceArea != null &&
        _driversLicenseImagePath != null;

    if (!formValid || !supplementaryValid) {
      setState(() => _showSupplementaryErrors = true);
      return;
    }

    final agreed = await showDriverPrivacySheet(context);
    if (agreed != true || !mounted) {
      return;
    }

    ref
        .read(driverRegistrationDraftProvider.notifier)
        .saveDraft(_currentDraft(acceptedPrivacy: true));
    context.go('/driver/sign-up/complete');
  }

  String _vehicleTypeLabel(AppLocalizations l10n, DriverVehicleType type) {
    switch (type) {
      case DriverVehicleType.car:
        return l10n.driverVehicleTypeCar;
      case DriverVehicleType.motorcycle:
        return l10n.driverVehicleTypeMotorcycle;
      case DriverVehicleType.van:
        return l10n.driverVehicleTypeVan;
    }
  }

  String _serviceAreaLabel(
    AppLocalizations l10n,
    DriverServiceArea serviceArea,
  ) {
    switch (serviceArea) {
      case DriverServiceArea.downtownDistrict:
        return l10n.driverServiceAreaDowntownDistrict;
      case DriverServiceArea.industrialArea:
        return l10n.driverServiceAreaIndustrialArea;
      case DriverServiceArea.westBay:
        return l10n.driverServiceAreaWestBay;
      case DriverServiceArea.alSadd:
        return l10n.driverServiceAreaAlSadd;
      case DriverServiceArea.airportZone:
        return l10n.driverServiceAreaAirportZone;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: disableAnimations ? Curves.linear : Curves.easeOutCubic,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: PartnerFlowPalette.background,
      ),
      child: Scaffold(
        backgroundColor: PartnerFlowPalette.background,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final value = contentAnimation.value.clamp(0.0, 1.0);
                return Transform.translate(
                  offset: Offset(0, disableAnimations ? 0 : 20 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Form(
                key: _formKey,
                child: Column(
                  key: const Key('driverSignUpScreen'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: PartnerFlowPalette.primarySolid,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            key: const Key('driverBackButton'),
                            onPressed: () => context.go('/roles'),
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Text(
                            l10n.driverRegistrationTitle,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  color: PartnerFlowPalette.textPrimary,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      l10n.driverRegistrationEyebrow.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PartnerFlowPalette.primarySolid,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      l10n.driverRegistrationSubtitle,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: PartnerFlowPalette.textSecondary,
                            height: 1.45,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    const SizedBox(height: 28),
                    _DriverInputField(
                      key: const Key('driverFullNameField'),
                      label: l10n.driverFullNameLabel,
                      hintText: l10n.driverFullNameHint,
                      controller: _fullNameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return l10n.driverFullNameValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _DriverInputField(
                      key: const Key('driverPhoneField'),
                      label: l10n.driverPhoneLabel,
                      hintText: l10n.driverPhoneHint,
                      controller: _phoneController,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        final digits = (value ?? '').replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        if (digits.length < 8) {
                          return l10n.driverPhoneValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.driverVehicleTypeLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: DriverVehicleType.values
                          .map((type) {
                            final isSelected = _vehicleType == type;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: type == DriverVehicleType.van ? 0 : 10,
                                ),
                                child: _DriverVehicleTypeCard(
                                  key: Key('driverVehicleType-${type.name}'),
                                  label: _vehicleTypeLabel(l10n, type),
                                  icon: type.icon,
                                  isSelected: isSelected,
                                  onTap: () => _toggleVehicleType(type),
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                    if (_showSupplementaryErrors && _vehicleType == null) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.driverVehicleTypeValidation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PartnerFlowPalette.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text(
                      l10n.driverServiceAreaLabel.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<DriverServiceArea>(
                      key: const Key('driverServiceAreaField'),
                      initialValue: _serviceArea,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: PartnerFlowPalette.surfaceSoft,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: PartnerFlowPalette.primarySolid,
                            width: 1.5,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: PartnerFlowPalette.error,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(
                            color: PartnerFlowPalette.error,
                            width: 1.5,
                          ),
                        ),
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: PartnerFlowPalette.textSecondary,
                      ),
                      dropdownColor: PartnerFlowPalette.surface,
                      borderRadius: BorderRadius.circular(18),
                      hint: Text(
                        l10n.driverServiceAreaHint,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: PartnerFlowPalette.textMuted,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: PartnerFlowPalette.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                      items: DriverServiceArea.values
                          .map(
                            (area) => DropdownMenuItem(
                              value: area,
                              child: Text(_serviceAreaLabel(l10n, area)),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: (value) {
                        setState(() {
                          _serviceArea = value;
                          _showSupplementaryErrors = false;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return l10n.driverServiceAreaValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.driverLicenseTitle.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _DriverLicenseUploadCard(
                      key: const Key('driverLicenseUploadCard'),
                      title: l10n.driverLicenseUploadTitle,
                      subtitle: _driversLicenseImagePath == null
                          ? l10n.driverLicenseUploadHint
                          : _fileNameFromPath(_driversLicenseImagePath!),
                      isUploaded: _driversLicenseImagePath != null,
                      onTap: _pickDriversLicense,
                    ),
                    if (_showSupplementaryErrors &&
                        _driversLicenseImagePath == null) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.driverLicenseValidation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: PartnerFlowPalette.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                    PartnerFlowGradientButton(
                      key: const Key('driverSignUpSubmitButton'),
                      label: l10n.driverSubmitApplication,
                      onPressed: _canSubmit ? _submit : null,
                    ),
                    const SizedBox(height: 14),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: PartnerFlowPalette.textSecondary,
                          height: 1.45,
                        ),
                        children: [
                          TextSpan(text: l10n.driverLegalLead),
                          TextSpan(
                            text: l10n.driverLegalTerms,
                            style: const TextStyle(
                              color: PartnerFlowPalette.primarySolid,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: l10n.driverLegalBridge),
                          TextSpan(
                            text: l10n.driverLegalPrivacy,
                            style: const TextStyle(
                              color: PartnerFlowPalette.primarySolid,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: l10n.driverLegalTail),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      key: const Key('driverSignUpSaveDraftButton'),
                      onPressed: _saveDraft,
                      style: TextButton.styleFrom(
                        foregroundColor: PartnerFlowPalette.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        l10n.driverSaveDraft,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: PartnerFlowPalette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool?> showDriverPrivacySheet(BuildContext context) {
  final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  return showGeneralDialog<bool?>(
    context: context,
    barrierLabel: 'Dismiss',
    barrierDismissible: true,
    barrierColor: Colors.transparent,
    transitionDuration: reduceMotion
        ? const Duration(milliseconds: 140)
        : const Duration(milliseconds: 320),
    pageBuilder: (dialogContext, _, _) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).maybePop(false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.18),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            MediaQuery.of(dialogContext).size.height * 0.82,
                      ),
                      child: const _DriverPrivacySheet(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, _, child) {
      if (reduceMotion) {
        return FadeTransition(opacity: animation, child: child);
      }

      final fade = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      final slide =
          Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
              reverseCurve: Curves.easeInCubic,
            ),
          );

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
  );
}

class _DriverPrivacySheet extends StatefulWidget {
  const _DriverPrivacySheet();

  @override
  State<_DriverPrivacySheet> createState() => _DriverPrivacySheetState();
}

class _DriverPrivacySheetState extends State<_DriverPrivacySheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OcModalSheetShell(
      closeButtonKey: const Key('driverPrivacySheetCloseButton'),
      onClose: () => Navigator.of(context).pop(false),
      child: SingleChildScrollView(
        key: const Key('driverPrivacySheet'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.driverPrivacyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: PartnerFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.driverPrivacySummaryTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PartnerFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            ...[
              l10n.driverPrivacyBulletEncryption,
              l10n.driverPrivacyBulletAccess,
              l10n.driverPrivacyBulletControl,
            ].map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '• $bullet',
                  style: const TextStyle(
                    color: PartnerFlowPalette.textSecondary,
                    fontSize: 17,
                    height: 1.32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            InkWell(
              key: const Key('driverPrivacyCheckbox'),
              onTap: () => setState(() => _agreed = !_agreed),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _agreed
                          ? PartnerFlowPalette.primarySolid
                          : PartnerFlowPalette.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _agreed
                            ? PartnerFlowPalette.primarySolid
                            : PartnerFlowPalette.borderSubtle,
                        width: 2,
                      ),
                    ),
                    child: _agreed
                        ? const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 24,
                          )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: PartnerFlowPalette.textSecondary,
                                height: 1.35,
                              ),
                          children: [
                            TextSpan(text: l10n.driverPrivacyAgreementLead),
                            TextSpan(
                              text: l10n.driverPrivacyAgreementTerms,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: PartnerFlowPalette.primarySolid,
                              ),
                            ),
                            TextSpan(text: l10n.driverPrivacyAgreementBridge),
                            TextSpan(
                              text: l10n.driverPrivacyAgreementPolicy,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: PartnerFlowPalette.primarySolid,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            PartnerFlowGradientButton(
              key: const Key('driverPrivacyContinueButton'),
              label: l10n.driverAgreeAndContinue,
              onPressed: _agreed ? () => Navigator.of(context).pop(true) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _DriverInputField extends StatelessWidget {
  const _DriverInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: PartnerFlowPalette.textSecondary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          key: key,
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: PartnerFlowPalette.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: PartnerFlowPalette.textMuted,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: PartnerFlowPalette.surfaceSoft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: PartnerFlowPalette.primarySolid,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: PartnerFlowPalette.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(
                color: PartnerFlowPalette.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DriverVehicleTypeCard extends StatelessWidget {
  const _DriverVehicleTypeCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    return AnimatedContainer(
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 180),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: isSelected
            ? PartnerFlowPalette.surface
            : PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected
              ? PartnerFlowPalette.primarySolid
              : PartnerFlowPalette.borderSubtle,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 38,
                  color: isSelected
                      ? PartnerFlowPalette.primarySolid
                      : PartnerFlowPalette.textSecondary,
                ),
                const SizedBox(height: 10),
                Text(
                  label.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected
                        ? PartnerFlowPalette.primarySolid
                        : PartnerFlowPalette.textSecondary,
                    fontWeight: FontWeight.w800,
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

class _DriverLicenseUploadCard extends StatelessWidget {
  const _DriverLicenseUploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isUploaded,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isUploaded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    return AnimatedContainer(
      duration: disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isUploaded
              ? PartnerFlowPalette.primarySolid
              : PartnerFlowPalette.borderSubtle,
          width: 1.4,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 34),
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? PartnerFlowPalette.primarySoft
                        : PartnerFlowPalette.surfaceSoft,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    isUploaded
                        ? Icons.check_circle_rounded
                        : Icons.upload_file_rounded,
                    size: 28,
                    color: isUploaded
                        ? PartnerFlowPalette.primaryStart
                        : PartnerFlowPalette.primarySolid,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: PartnerFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.35,
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

String _fileNameFromPath(String path) {
  final segments = path.split(RegExp(r'[\\/]'));
  return segments.isEmpty ? path : segments.last;
}
