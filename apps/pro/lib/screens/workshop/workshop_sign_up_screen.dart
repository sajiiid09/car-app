import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../l10n/app_localizations.dart';
import 'workshop_flow_palette.dart';
import 'workshop_sign_up_state.dart';

class WorkshopSignUpScreen extends ConsumerStatefulWidget {
  const WorkshopSignUpScreen({super.key});

  @override
  ConsumerState<WorkshopSignUpScreen> createState() =>
      _WorkshopSignUpScreenState();
}

class _WorkshopSignUpScreenState extends ConsumerState<WorkshopSignUpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _workshopNameController;
  late final TextEditingController _ownerNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final AnimationController _controller;
  late Set<WorkshopSpecialty> _selectedSpecialties;
  String? _tradeLicenseImagePath;
  bool _showSupplementaryErrors = false;

  final _formKey = GlobalKey<FormState>();

  bool get _canSubmit =>
      _workshopNameController.text.trim().isNotEmpty &&
      _ownerNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _locationController.text.trim().isNotEmpty &&
      _selectedSpecialties.isNotEmpty &&
      _tradeLicenseImagePath != null;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(workshopRegistrationDraftProvider);
    _workshopNameController = TextEditingController(text: draft.workshopName)
      ..addListener(_handleFieldChanged);
    _ownerNameController = TextEditingController(text: draft.ownerName)
      ..addListener(_handleFieldChanged);
    _phoneController = TextEditingController(text: draft.phone)
      ..addListener(_handleFieldChanged);
    _locationController = TextEditingController(text: draft.location)
      ..addListener(_handleFieldChanged);
    _selectedSpecialties = {...draft.selectedSpecialties};
    _tradeLicenseImagePath = draft.tradeLicenseImagePath;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
  }

  @override
  void dispose() {
    _workshopNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFieldChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  WorkshopRegistrationDraft _currentDraft({bool acceptedPrivacy = false}) {
    return WorkshopRegistrationDraft(
      workshopName: _workshopNameController.text.trim(),
      ownerName: _ownerNameController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      selectedSpecialties: _selectedSpecialties,
      tradeLicenseImagePath: _tradeLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy,
    );
  }

  String _specialtyLabel(AppLocalizations l10n, WorkshopSpecialty specialty) {
    switch (specialty) {
      case WorkshopSpecialty.engine:
        return l10n.workshopSpecialtyEngine;
      case WorkshopSpecialty.electrical:
        return l10n.workshopSpecialtyElectrical;
      case WorkshopSpecialty.tires:
        return l10n.workshopSpecialtyTires;
      case WorkshopSpecialty.paint:
        return l10n.workshopSpecialtyPaint;
      case WorkshopSpecialty.oil:
        return l10n.workshopSpecialtyOil;
      case WorkshopSpecialty.other:
        return l10n.workshopSpecialtyOther;
    }
  }

  Future<void> _pickTradeLicense() async {
    final l10n = AppLocalizations.of(context)!;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: WorkshopFlowPalette.surface,
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
                      color: WorkshopFlowPalette.textMuted.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.workshopChooseImageSource,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: WorkshopFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  key: const Key('tradeLicenseCameraOption'),
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.workshopCamera),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  key: const Key('tradeLicenseGalleryOption'),
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.workshopGallery),
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

    final picker = ref.read(workshopTradeLicensePickerProvider);
    final path = await picker.pickImage(source: source);
    if (!mounted || path == null) {
      return;
    }

    setState(() {
      _tradeLicenseImagePath = path;
      _showSupplementaryErrors = false;
    });
  }

  void _toggleSpecialty(WorkshopSpecialty specialty) {
    setState(() {
      if (_selectedSpecialties.contains(specialty)) {
        _selectedSpecialties.remove(specialty);
      } else {
        _selectedSpecialties.add(specialty);
      }
      _showSupplementaryErrors = false;
    });
  }

  void _saveDraft() {
    ref
        .read(workshopRegistrationDraftProvider.notifier)
        .saveDraft(_currentDraft());
    context.go('/roles');
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final supplementaryValid =
        _selectedSpecialties.isNotEmpty && _tradeLicenseImagePath != null;

    if (!formValid || !supplementaryValid) {
      setState(() => _showSupplementaryErrors = true);
      return;
    }

    final agreed = await showWorkshopPrivacySheet(context);
    if (agreed != true || !mounted) {
      return;
    }

    ref
        .read(workshopRegistrationDraftProvider.notifier)
        .saveDraft(_currentDraft(acceptedPrivacy: true));
    context.go('/workshop/sign-up/complete');
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
        systemNavigationBarColor: WorkshopFlowPalette.background,
      ),
      child: Scaffold(
        backgroundColor: WorkshopFlowPalette.background,
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
                  key: const Key('workshopSignUpScreen'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _WorkshopBackButton(
                          onPressed: () => context.go('/roles'),
                        ),
                        const Spacer(),
                        Text(
                          'OnlyCars',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: WorkshopFlowPalette.textPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.workshopRegistrationEyebrow.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: WorkshopFlowPalette.primarySolid,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.workshopRegistrationTitle,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: WorkshopFlowPalette.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.workshopRegistrationSubtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: WorkshopFlowPalette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _WorkshopInputField(
                      key: const Key('workshopNameField'),
                      controller: _workshopNameController,
                      label: l10n.workshopNameLabel,
                      hintText: l10n.workshopNameHint,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return l10n.workshopNameValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _WorkshopInputField(
                      key: const Key('workshopOwnerField'),
                      controller: _ownerNameController,
                      label: l10n.workshopOwnerLabel,
                      hintText: l10n.workshopOwnerHint,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return l10n.workshopOwnerValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _WorkshopInputField(
                      key: const Key('workshopPhoneField'),
                      controller: _phoneController,
                      label: l10n.workshopPhoneLabel,
                      hintText: l10n.workshopPhoneHint,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final digits = (value ?? '').replaceAll(
                          RegExp(r'\D'),
                          '',
                        );
                        if (digits.length < 8) {
                          return l10n.workshopPhoneValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    _WorkshopInputField(
                      key: const Key('workshopLocationField'),
                      controller: _locationController,
                      label: l10n.workshopLocationLabel,
                      hintText: l10n.workshopLocationHint,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 4) {
                          return l10n.workshopLocationValidation;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    Text(
                      l10n.workshopSpecialtiesTitle.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: WorkshopFlowPalette.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: WorkshopSpecialty.values.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.92,
                          ),
                      itemBuilder: (context, index) {
                        final specialty = WorkshopSpecialty.values[index];
                        final isSelected = _selectedSpecialties.contains(
                          specialty,
                        );
                        return _WorkshopSpecialtyChip(
                          key: Key('workshopSpecialty-${specialty.name}'),
                          label: _specialtyLabel(l10n, specialty),
                          icon: specialty.icon,
                          isSelected: isSelected,
                          onTap: () => _toggleSpecialty(specialty),
                        );
                      },
                    ),
                    if (_showSupplementaryErrors &&
                        _selectedSpecialties.isEmpty) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.workshopSpecialtyValidation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: WorkshopFlowPalette.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    Text(
                      l10n.workshopVerificationTitle.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: WorkshopFlowPalette.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _TradeLicenseUploadCard(
                      key: const Key('tradeLicenseUploadCard'),
                      title: l10n.workshopTradeLicenseUploadTitle,
                      subtitle: _tradeLicenseImagePath == null
                          ? l10n.workshopTradeLicenseUploadHint
                          : _fileNameFromPath(_tradeLicenseImagePath!),
                      isUploaded: _tradeLicenseImagePath != null,
                      onTap: _pickTradeLicense,
                    ),
                    if (_showSupplementaryErrors &&
                        _tradeLicenseImagePath == null) ...[
                      const SizedBox(height: 10),
                      Text(
                        l10n.workshopTradeLicenseValidation,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: WorkshopFlowPalette.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: 32),
                    WorkshopGradientButton(
                      key: const Key('workshopSignUpSubmitButton'),
                      label: l10n.workshopCompleteRegistration,
                      onPressed: _canSubmit ? _submit : null,
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      key: const Key('workshopSignUpSaveDraftButton'),
                      onPressed: _saveDraft,
                      style: TextButton.styleFrom(
                        foregroundColor: WorkshopFlowPalette.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        l10n.workshopSaveDraft,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: WorkshopFlowPalette.textSecondary,
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

Future<bool?> showWorkshopPrivacySheet(BuildContext context) {
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
                      child: const _WorkshopPrivacySheet(),
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

class _WorkshopPrivacySheet extends StatefulWidget {
  const _WorkshopPrivacySheet();

  @override
  State<_WorkshopPrivacySheet> createState() => _WorkshopPrivacySheetState();
}

class _WorkshopPrivacySheetState extends State<_WorkshopPrivacySheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OcModalSheetShell(
      closeButtonKey: const Key('workshopPrivacySheetCloseButton'),
      onClose: () => Navigator.of(context).pop(false),
      child: SingleChildScrollView(
        key: const Key('workshopPrivacySheet'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.workshopPrivacyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: WorkshopFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.workshopPrivacySummaryTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: WorkshopFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            ...[
              l10n.workshopPrivacyBulletEncryption,
              l10n.workshopPrivacyBulletAccess,
              l10n.workshopPrivacyBulletControl,
            ].map(
              (bullet) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '• $bullet',
                  style: const TextStyle(
                    color: WorkshopFlowPalette.textSecondary,
                    fontSize: 17,
                    height: 1.32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            InkWell(
              key: const Key('workshopPrivacyCheckbox'),
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
                          ? WorkshopFlowPalette.primarySolid
                          : WorkshopFlowPalette.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _agreed
                            ? WorkshopFlowPalette.primarySolid
                            : WorkshopFlowPalette.borderSubtle,
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
                                color: WorkshopFlowPalette.textSecondary,
                                height: 1.35,
                              ),
                          children: [
                            TextSpan(text: l10n.workshopPrivacyAgreementLead),
                            TextSpan(
                              text: l10n.workshopPrivacyAgreementPolicy,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: WorkshopFlowPalette.primarySolid,
                              ),
                            ),
                            TextSpan(text: l10n.workshopPrivacyAgreementBridge),
                            TextSpan(
                              text: l10n.workshopPrivacyAgreementHipaa,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: WorkshopFlowPalette.primarySolid,
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
            WorkshopGradientButton(
              key: const Key('workshopPrivacyContinueButton'),
              label: l10n.workshopAgreeAndContinue,
              onPressed: _agreed ? () => Navigator.of(context).pop(true) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkshopBackButton extends StatelessWidget {
  const _WorkshopBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        shape: BoxShape.circle,
        border: Border.all(color: WorkshopFlowPalette.borderSubtle),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_rounded),
        color: WorkshopFlowPalette.primarySolid,
      ),
    );
  }
}

class _WorkshopInputField extends StatelessWidget {
  const _WorkshopInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hintText,
    this.validator,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String hintText;
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
            color: WorkshopFlowPalette.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: WorkshopFlowPalette.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: WorkshopFlowPalette.textMuted,
            ),
            filled: true,
            fillColor: WorkshopFlowPalette.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: WorkshopFlowPalette.borderSubtle,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: WorkshopFlowPalette.primarySolid,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: WorkshopFlowPalette.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: WorkshopFlowPalette.error,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkshopSpecialtyChip extends StatelessWidget {
  const _WorkshopSpecialtyChip({
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
            ? WorkshopFlowPalette.primarySoft
            : WorkshopFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? WorkshopFlowPalette.primarySolid
              : WorkshopFlowPalette.borderSubtle,
          width: isSelected ? 1.8 : 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 6, 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? WorkshopFlowPalette.primaryStart
                      : WorkshopFlowPalette.textSecondary,
                  size: 20,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? WorkshopFlowPalette.primaryStart
                        : WorkshopFlowPalette.textSecondary,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 0.5,
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

class _TradeLicenseUploadCard extends StatelessWidget {
  const _TradeLicenseUploadCard({
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
        color: WorkshopFlowPalette.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isUploaded
              ? WorkshopFlowPalette.primarySolid
              : WorkshopFlowPalette.borderSubtle,
          width: isUploaded ? 1.6 : 1.2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
            child: Column(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: isUploaded
                        ? WorkshopFlowPalette.primarySoft
                        : WorkshopFlowPalette.surfaceSoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUploaded
                        ? Icons.check_circle_rounded
                        : Icons.file_upload_outlined,
                    color: isUploaded
                        ? WorkshopFlowPalette.primaryStart
                        : WorkshopFlowPalette.primarySolid,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: WorkshopFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: WorkshopFlowPalette.textSecondary,
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

class WorkshopGradientButton extends StatelessWidget {
  const WorkshopGradientButton({
    super.key,
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: 78,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: enabled ? null : WorkshopFlowPalette.buttonDisabled,
            gradient: enabled ? WorkshopFlowPalette.primaryGradient : null,
            borderRadius: BorderRadius.circular(999),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: WorkshopFlowPalette.primaryEnd.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(999),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: enabled ? Colors.white : WorkshopFlowPalette.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
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
