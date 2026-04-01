import 'dart:ui';

import 'package:consumer/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oc_ui/oc_ui.dart';

const _authSheetSubtitle = 'From Service to Parts — OnlyCars Has You Covered.';

Future<T?> showOcBlurredBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext dialogContext) builder,
}) {
  final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  return showGeneralDialog<T>(
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
                  onTap: () => Navigator.of(dialogContext).maybePop(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.22),
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
                        maxHeight: MediaQuery.of(dialogContext).size.height * 0.82,
                      ),
                      child: builder(dialogContext),
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
      final slide = Tween<Offset>(
        begin: const Offset(0, 0.08),
        end: Offset.zero,
      ).animate(
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

Future<AuthRole?> showRoleSelectionSheet({
  required BuildContext context,
  required AuthRole initialRole,
}) {
  return showOcBlurredBottomSheet<AuthRole?>(
    context: context,
    builder: (dialogContext) => _RoleSelectionSheet(initialRole: initialRole),
  );
}

Future<bool?> showPrivacySheet(BuildContext context) {
  return showOcBlurredBottomSheet<bool?>(
    context: context,
    builder: (_) => const _PrivacySheet(),
  );
}

class _RoleSelectionSheet extends StatefulWidget {
  const _RoleSelectionSheet({required this.initialRole});

  final AuthRole initialRole;

  @override
  State<_RoleSelectionSheet> createState() => _RoleSelectionSheetState();
}

class _RoleSelectionSheetState extends State<_RoleSelectionSheet> {
  late final TextEditingController _searchController;
  late AuthRole _selectedRole;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedRole = widget.initialRole;
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AuthRole> get _filteredRoles {
    if (_query.trim().isEmpty) {
      return AuthRole.values;
    }

    final normalized = _query.trim().toLowerCase();
    return AuthRole.values
        .where((role) => role.label.toLowerCase().contains(normalized))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return OcModalSheetShell(
      closeButtonKey: const Key('roleSheetCloseButton'),
      onClose: () => Navigator.of(context).pop(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Choose your role',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: OcColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _authSheetSubtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: OcColors.textMuted,
                height: 1.34,
              ),
            ),
            const SizedBox(height: 24),
            _PseudoDropdownField(
              label: _selectedRole.label,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            Container(
              key: const Key('roleSelectionSheet'),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: OcColors.borderLight),
                boxShadow: OcShadows.card,
              ),
              child: Column(
                children: [
                  TextField(
                    key: const Key('roleSearchField'),
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search_rounded),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 18,
                      ),
                      fillColor: Colors.white,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: OcColors.borderLight),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: OcColors.accent),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._filteredRoles.map(_buildRoleOption),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (!_selectedRole.canContinueWithRole) ...[
              Text(
                _selectedRole.comingSoonLabel,
                key: const Key('roleComingSoonHelper'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: OcColors.textMuted,
                ),
              ),
              const SizedBox(height: 12),
            ],
            OcPillButton(
              key: const Key('roleContinueButton'),
              label: 'Continue',
              filled: true,
              width: double.infinity,
              height: 78,
              backgroundColor: _selectedRole.canContinueWithRole
                  ? OcColors.accent
                  : const Color(0xFFD9E2F2),
              foregroundColor: _selectedRole.canContinueWithRole
                  ? Colors.white
                  : OcColors.textMuted,
              onPressed: _selectedRole.canContinueWithRole
                  ? () => Navigator.of(context).pop(_selectedRole)
                  : null,
            ),
            const SizedBox(height: 10),
            TextButton(
              key: const Key('roleSkipButton'),
              onPressed: () => Navigator.of(context).pop(AuthRole.customer),
              child: Text(
                'Skip for now',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: OcColors.textMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleOption(AuthRole role) {
    final isSelected = role == _selectedRole;

    return InkWell(
      key: Key('roleOption-${role.name}'),
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: role.avatarColor,
                shape: BoxShape.circle,
              ),
              child: Icon(role.icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                role.label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFF17314F),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? OcColors.accent : Colors.transparent,
                border: Border.all(
                  color: isSelected ? OcColors.accent : const Color(0xFFD1D8E2),
                  width: 2.2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 22)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySheet extends StatefulWidget {
  const _PrivacySheet();

  @override
  State<_PrivacySheet> createState() => _PrivacySheetState();
}

class _PrivacySheetState extends State<_PrivacySheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    return OcModalSheetShell(
      closeButtonKey: const Key('privacySheetCloseButton'),
      onClose: () => Navigator.of(context).pop(false),
      child: SingleChildScrollView(
        key: const Key('privacySheet'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Privacy & Data Protection',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: OcColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Summary bullets:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 18),
            ...const [
              'Your data is encrypted.',
              'Only authorized providers can access your records.',
              'You control who can view your information.',
            ].map(
              (bullet) => Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: Text(
                  '• $bullet',
                  style: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 17,
                    height: 1.32,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            InkWell(
              key: const Key('privacyCheckbox'),
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
                      color: _agreed ? OcColors.accent : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: _agreed
                            ? OcColors.accent
                            : const Color(0xFFE1E1E1),
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
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF8A8A8A),
                            height: 1.35,
                          ),
                          children: const [
                            TextSpan(text: 'I agree to the '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: ' and '),
                            TextSpan(
                              text: 'HIPAA terms',
                              style: TextStyle(fontWeight: FontWeight.w700),
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
            OcPillButton(
              key: const Key('privacyContinueButton'),
              label: 'Agree & Continue',
              filled: true,
              width: double.infinity,
              height: 78,
              backgroundColor: _agreed
                  ? OcColors.accent
                  : const Color(0xFFD9E2F2),
              foregroundColor: _agreed ? Colors.white : OcColors.textMuted,
              onPressed: _agreed ? () => Navigator.of(context).pop(true) : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _PseudoDropdownField extends StatelessWidget {
  const _PseudoDropdownField({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: OcColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: const Color(0xFF17314F),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF17314F),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
