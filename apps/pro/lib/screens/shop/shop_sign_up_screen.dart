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
import 'shop_sign_up_state.dart';

class ShopSignUpScreen extends ConsumerStatefulWidget {
  const ShopSignUpScreen({super.key});

  @override
  ConsumerState<ShopSignUpScreen> createState() => _ShopSignUpScreenState();
}

class _ShopSignUpScreenState extends ConsumerState<ShopSignUpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _shopNameController;
  late final TextEditingController _contactNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _locationController;
  late final AnimationController _controller;
  late Set<ShopInventoryCategory> _selectedCategories;
  String? _businessLicenseImagePath;
  bool _showSupplementaryErrors = false;

  final _formKey = GlobalKey<FormState>();

  bool get _canSubmit =>
      _shopNameController.text.trim().isNotEmpty &&
      _contactNameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _locationController.text.trim().isNotEmpty &&
      _selectedCategories.isNotEmpty &&
      _businessLicenseImagePath != null;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(shopRegistrationDraftProvider);
    _shopNameController = TextEditingController(text: draft.shopName)
      ..addListener(_handleFieldChanged);
    _contactNameController = TextEditingController(text: draft.contactName)
      ..addListener(_handleFieldChanged);
    _phoneController = TextEditingController(text: draft.phone)
      ..addListener(_handleFieldChanged);
    _locationController = TextEditingController(text: draft.location)
      ..addListener(_handleFieldChanged);
    _selectedCategories = {...draft.selectedCategories};
    _businessLicenseImagePath = draft.businessLicenseImagePath;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _contactNameController.dispose();
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

  ShopRegistrationDraft _currentDraft({bool acceptedPrivacy = false}) {
    return ShopRegistrationDraft(
      shopName: _shopNameController.text.trim(),
      contactName: _contactNameController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _locationController.text.trim(),
      selectedCategories: _selectedCategories,
      businessLicenseImagePath: _businessLicenseImagePath,
      acceptedPrivacy: acceptedPrivacy,
    );
  }

  String _categoryLabel(AppLocalizations l10n, ShopInventoryCategory category) {
    switch (category) {
      case ShopInventoryCategory.engine:
        return l10n.shopCategoryEngine;
      case ShopInventoryCategory.brakes:
        return l10n.shopCategoryBrakes;
      case ShopInventoryCategory.suspension:
        return l10n.shopCategorySuspension;
      case ShopInventoryCategory.body:
        return l10n.shopCategoryBody;
      case ShopInventoryCategory.electrical:
        return l10n.shopCategoryElectrical;
    }
  }

  Future<void> _pickBusinessLicense() async {
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
                  l10n.shopChooseImageSource,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: PartnerFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  key: const Key('shopBusinessLicenseCameraOption'),
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: Text(l10n.shopCamera),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  key: const Key('shopBusinessLicenseGalleryOption'),
                  leading: const Icon(Icons.photo_library_outlined),
                  title: Text(l10n.shopGallery),
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

    final picker = ref.read(shopBusinessLicensePickerProvider);
    final path = await picker.pickImage(source: source);
    if (!mounted || path == null) {
      return;
    }

    setState(() {
      _businessLicenseImagePath = path;
      _showSupplementaryErrors = false;
    });
  }

  void _toggleCategory(ShopInventoryCategory category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _showSupplementaryErrors = false;
    });
  }

  void _saveDraft() {
    ref.read(shopRegistrationDraftProvider.notifier).saveDraft(_currentDraft());
    context.go('/roles');
  }

  Future<void> _submit() async {
    final formValid = _formKey.currentState?.validate() ?? false;
    final supplementaryValid =
        _selectedCategories.isNotEmpty && _businessLicenseImagePath != null;

    if (!formValid || !supplementaryValid) {
      setState(() => _showSupplementaryErrors = true);
      return;
    }

    final agreed = await showShopPrivacySheet(context);
    if (agreed != true || !mounted) {
      return;
    }

    ref
        .read(shopRegistrationDraftProvider.notifier)
        .saveDraft(_currentDraft(acceptedPrivacy: true));
    context.go('/shop/sign-up/complete');
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
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
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
                  key: const Key('shopSignUpScreen'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _ShopTopBar(),
                    const SizedBox(height: 32),
                    Text(
                      l10n.shopRegistrationTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: PartnerFlowPalette.textPrimary,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.shopRegistrationSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: PartnerFlowPalette.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Container(
                      decoration: BoxDecoration(
                        color: PartnerFlowPalette.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: PartnerFlowPalette.borderSubtle,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _ShopSectionHeading(
                            label: l10n.shopGeneralInformationTitle,
                          ),
                          const SizedBox(height: 16),
                          _ShopInputField(
                            key: const Key('shopNameField'),
                            controller: _shopNameController,
                            label: l10n.shopNameLabel,
                            hintText: l10n.shopNameHint,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if ((value?.trim().length ?? 0) < 2) {
                                return l10n.shopNameValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _ShopInputField(
                            key: const Key('shopContactNameField'),
                            controller: _contactNameController,
                            label: l10n.shopContactNameLabel,
                            hintText: l10n.shopContactNameHint,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if ((value?.trim().length ?? 0) < 2) {
                                return l10n.shopContactNameValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _ShopInputField(
                            key: const Key('shopPhoneField'),
                            controller: _phoneController,
                            label: l10n.shopPhoneLabel,
                            hintText: l10n.shopPhoneHint,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              final digits = (value ?? '').replaceAll(
                                RegExp(r'\D'),
                                '',
                              );
                              if (digits.length < 8) {
                                return l10n.shopPhoneValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          _ShopSectionHeading(label: l10n.shopLocationTitle),
                          const SizedBox(height: 16),
                          _ShopLocationField(
                            key: const Key('shopLocationField'),
                            controller: _locationController,
                            hintText: l10n.shopLocationHint,
                            validator: (value) {
                              if ((value?.trim().length ?? 0) < 4) {
                                return l10n.shopLocationValidation;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 28),
                          _ShopSectionHeading(label: l10n.shopCategoriesTitle),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: ShopInventoryCategory.values
                                .map((category) {
                                  final isSelected = _selectedCategories
                                      .contains(category);
                                  return _ShopCategoryChip(
                                    key: Key('shopCategory-${category.name}'),
                                    label: _categoryLabel(l10n, category),
                                    icon: category.icon,
                                    isSelected: isSelected,
                                    onTap: () => _toggleCategory(category),
                                  );
                                })
                                .toList(growable: false),
                          ),
                          if (_showSupplementaryErrors &&
                              _selectedCategories.isEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              l10n.shopCategoriesValidation,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: PartnerFlowPalette.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          _ShopSectionHeading(
                            label: l10n.shopVerificationTitle,
                          ),
                          const SizedBox(height: 16),
                          _ShopBusinessLicenseCard(
                            key: const Key('shopBusinessLicenseUploadCard'),
                            title: l10n.shopBusinessLicenseUploadTitle,
                            subtitle: _businessLicenseImagePath == null
                                ? l10n.shopBusinessLicenseUploadHint
                                : _fileNameFromPath(_businessLicenseImagePath!),
                            isUploaded: _businessLicenseImagePath != null,
                            onTap: _pickBusinessLicense,
                          ),
                          if (_showSupplementaryErrors &&
                              _businessLicenseImagePath == null) ...[
                            const SizedBox(height: 10),
                            Text(
                              l10n.shopBusinessLicenseValidation,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: PartnerFlowPalette.error,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                          const SizedBox(height: 28),
                          Container(
                            height: 1,
                            color: PartnerFlowPalette.surfaceSoft,
                          ),
                          const SizedBox(height: 24),
                          PartnerFlowGradientButton(
                            key: const Key('shopSignUpSubmitButton'),
                            label: l10n.shopCompleteRegistration,
                            onPressed: _canSubmit ? _submit : null,
                          ),
                          const SizedBox(height: 14),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: PartnerFlowPalette.textSecondary,
                                    height: 1.45,
                                  ),
                              children: [
                                TextSpan(text: l10n.shopLegalLead),
                                TextSpan(
                                  text: l10n.shopLegalTerms,
                                  style: const TextStyle(
                                    color: PartnerFlowPalette.primarySolid,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: l10n.shopLegalBridge),
                                TextSpan(
                                  text: l10n.shopLegalPrivacy,
                                  style: const TextStyle(
                                    color: PartnerFlowPalette.primarySolid,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: l10n.shopLegalTail),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      key: const Key('shopSignUpSaveDraftButton'),
                      onPressed: _saveDraft,
                      style: TextButton.styleFrom(
                        foregroundColor: PartnerFlowPalette.textSecondary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        l10n.shopSaveDraft,
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

Future<bool?> showShopPrivacySheet(BuildContext context) {
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
                      child: const _ShopPrivacySheet(),
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

class _ShopPrivacySheet extends StatefulWidget {
  const _ShopPrivacySheet();

  @override
  State<_ShopPrivacySheet> createState() => _ShopPrivacySheetState();
}

class _ShopPrivacySheetState extends State<_ShopPrivacySheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OcModalSheetShell(
      closeButtonKey: const Key('shopPrivacySheetCloseButton'),
      onClose: () => Navigator.of(context).pop(false),
      child: SingleChildScrollView(
        key: const Key('shopPrivacySheet'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.shopPrivacyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: PartnerFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              l10n.shopPrivacySummaryTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: PartnerFlowPalette.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),
            ...[
              l10n.shopPrivacyBulletEncryption,
              l10n.shopPrivacyBulletAccess,
              l10n.shopPrivacyBulletControl,
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
              key: const Key('shopPrivacyCheckbox'),
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
                            TextSpan(text: l10n.shopPrivacyAgreementLead),
                            TextSpan(
                              text: l10n.shopPrivacyAgreementTerms,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: PartnerFlowPalette.primarySolid,
                              ),
                            ),
                            TextSpan(text: l10n.shopPrivacyAgreementBridge),
                            TextSpan(
                              text: l10n.shopPrivacyAgreementPolicy,
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
              key: const Key('shopPrivacyContinueButton'),
              label: l10n.shopAgreeAndContinue,
              onPressed: _agreed ? () => Navigator.of(context).pop(true) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShopTopBar extends StatelessWidget {
  const _ShopTopBar();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Icon(
          Icons.settings_input_component,
          color: PartnerFlowPalette.primarySolid,
          size: 22,
        ),
        const SizedBox(width: 8),
        Text(
          'OnlyCars',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: PartnerFlowPalette.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          l10n.shopRegistrationStep,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: PartnerFlowPalette.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 92,
          height: 6,
          decoration: BoxDecoration(
            color: PartnerFlowPalette.surfaceMuted,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 46,
              decoration: BoxDecoration(
                gradient: PartnerFlowPalette.primaryGradient,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ShopSectionHeading extends StatelessWidget {
  const _ShopSectionHeading({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 22,
          decoration: BoxDecoration(
            color: PartnerFlowPalette.primarySolid,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: PartnerFlowPalette.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _ShopInputField extends StatelessWidget {
  const _ShopInputField({
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
            color: PartnerFlowPalette.textSecondary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: PartnerFlowPalette.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: PartnerFlowPalette.textMuted,
            ),
            filled: true,
            fillColor: PartnerFlowPalette.surfaceSoft,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: PartnerFlowPalette.primarySolid,
                width: 1.6,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: PartnerFlowPalette.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
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

class _ShopLocationField extends StatelessWidget {
  const _ShopLocationField({
    super.key,
    required this.controller,
    required this.hintText,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      controller: controller,
      validator: validator,
      textInputAction: TextInputAction.done,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: PartnerFlowPalette.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(
          Icons.location_on_rounded,
          color: PartnerFlowPalette.textSecondary,
        ),
        hintStyle: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: PartnerFlowPalette.textMuted),
        filled: true,
        fillColor: PartnerFlowPalette.surfaceSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: PartnerFlowPalette.primarySolid,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: PartnerFlowPalette.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: PartnerFlowPalette.error,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

class _ShopCategoryChip extends StatelessWidget {
  const _ShopCategoryChip({
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
            ? PartnerFlowPalette.primarySoft
            : PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isSelected
              ? PartnerFlowPalette.primarySolid
              : PartnerFlowPalette.borderSubtle,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? PartnerFlowPalette.primaryStart
                      : PartnerFlowPalette.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: isSelected
                        ? PartnerFlowPalette.primaryStart
                        : PartnerFlowPalette.textSecondary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
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

class _ShopBusinessLicenseCard extends StatelessWidget {
  const _ShopBusinessLicenseCard({
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUploaded
              ? PartnerFlowPalette.primarySolid
              : PartnerFlowPalette.borderSubtle,
          width: isUploaded ? 1.6 : 1.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 28),
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
                    color: isUploaded
                        ? PartnerFlowPalette.primaryStart
                        : PartnerFlowPalette.textSecondary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: PartnerFlowPalette.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
