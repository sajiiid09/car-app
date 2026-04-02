import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

import '../l10n/app_localizations.dart';

class RoleSelectorScreen extends StatelessWidget {
  const RoleSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: OcColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(OcSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),

              // Logo
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: OcColors.secondary,
                    borderRadius: BorderRadius.circular(OcRadius.lg),
                  ),
                  child: const Center(
                    child: Text(
                      'PRO',
                      style: TextStyle(
                        color: OcColors.textOnPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: OcSpacing.xl),

              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: OcColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: OcSpacing.sm),
              Text(
                l10n.selectRolePrompt,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: OcColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              // Role cards
              _RoleCard(
                key: const Key('workshopRoleCard'),
                icon: Icons.build_rounded,
                title: l10n.workshopRoleTitle,
                subtitle: l10n.workshopRoleSubtitle,
                color: OcColors.primary,
                onTap: () => context.go('/workshop/sign-up'),
              ),
              const SizedBox(height: OcSpacing.lg),

              _RoleCard(
                key: const Key('driverRoleCard'),
                icon: Icons.delivery_dining,
                title: l10n.driverRoleTitle,
                subtitle: l10n.driverRoleSubtitle,
                color: OcColors.secondary,
                onTap: () => context.go('/driver/sign-up'),
              ),
              const SizedBox(height: OcSpacing.lg),

              _RoleCard(
                key: const Key('shopRoleCard'),
                icon: Icons.store_rounded,
                title: l10n.shopRoleTitle,
                subtitle: l10n.shopRoleSubtitle,
                color: OcColors.warning,
                onTap: () => context.go('/shop/sign-up'),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OcSpacing.xl),
        decoration: BoxDecoration(
          color: OcColors.surfaceCard,
          borderRadius: BorderRadius.circular(OcRadius.xl),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(OcRadius.lg),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: OcSpacing.lg),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: OcColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: OcColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_left_rounded, color: OcColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
