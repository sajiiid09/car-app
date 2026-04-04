import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'courier_workflow_state.dart';

Duration courierMotionDuration(BuildContext context) {
  final reducedMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  return reducedMotion ? Duration.zero : const Duration(milliseconds: 280);
}

class CourierShellScaffold extends StatelessWidget {
  const CourierShellScaffold({
    super.key,
    required this.location,
    required this.child,
  });

  final String location;
  final Widget child;

  CourierShellTab get _activeTab {
    if (location.startsWith('/driver/profile')) {
      return CourierShellTab.profile;
    }
    if (location.startsWith('/driver/messages')) {
      return CourierShellTab.messages;
    }
    if (location.startsWith('/driver/earnings')) {
      return CourierShellTab.earnings;
    }
    if (location.startsWith('/driver/orders')) {
      return CourierShellTab.orders;
    }
    return CourierShellTab.dashboard;
  }

  @override
  Widget build(BuildContext context) {
    final theme = OcTheme.light.copyWith(
      scaffoldBackgroundColor: PartnerFlowPalette.background,
      colorScheme: OcTheme.light.colorScheme.copyWith(
        surface: PartnerFlowPalette.surface,
        onSurface: PartnerFlowPalette.textPrimary,
        primary: PartnerFlowPalette.primaryEnd,
      ),
      textTheme: OcTheme.light.textTheme.apply(
        bodyColor: PartnerFlowPalette.textPrimary,
        displayColor: PartnerFlowPalette.textPrimary,
      ),
    );

    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: PartnerFlowPalette.background,
        extendBody: true,
        body: child,
        bottomNavigationBar: CourierShellFooter(activeTab: _activeTab),
      ),
    );
  }
}

class CourierShellFooter extends StatelessWidget {
  const CourierShellFooter({super.key, required this.activeTab});

  final CourierShellTab activeTab;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: PartnerFlowPalette.borderSubtle),
                boxShadow: [
                  BoxShadow(
                    color: PartnerFlowPalette.primaryStart.withValues(
                      alpha: 0.08,
                    ),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _CourierFooterItem(
                        key: const Key('driverFooterItem-dashboard'),
                        label: l10n.driverShellDashboardTab,
                        icon: Icons.grid_view_rounded,
                        active: activeTab == CourierShellTab.dashboard,
                        onTap: () => context.go('/driver'),
                      ),
                    ),
                    Expanded(
                      child: _CourierFooterItem(
                        key: const Key('driverFooterItem-orders'),
                        label: l10n.driverShellOrdersTab,
                        icon: Icons.shopping_cart_outlined,
                        active: activeTab == CourierShellTab.orders,
                        onTap: () => context.go('/driver/orders'),
                      ),
                    ),
                    Expanded(
                      child: _CourierFooterItem(
                        key: const Key('driverFooterItem-earnings'),
                        label: l10n.driverShellEarningsTab,
                        icon: Icons.payments_outlined,
                        active: activeTab == CourierShellTab.earnings,
                        onTap: () => context.go('/driver/earnings'),
                      ),
                    ),
                    Expanded(
                      child: _CourierFooterItem(
                        key: const Key('driverFooterItem-messages'),
                        label: l10n.driverShellMessagesTab,
                        icon: Icons.chat_bubble_outline_rounded,
                        active: activeTab == CourierShellTab.messages,
                        onTap: () => context.go('/driver/messages'),
                      ),
                    ),
                    Expanded(
                      child: _CourierFooterItem(
                        key: const Key('driverFooterItem-profile'),
                        label: l10n.driverShellProfileTab,
                        icon: Icons.person_outline_rounded,
                        active: activeTab == CourierShellTab.profile,
                        onTap: () => context.go('/driver/profile'),
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

class _CourierFooterItem extends StatelessWidget {
  const _CourierFooterItem({
    super.key,
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: AnimatedContainer(
        duration: courierMotionDuration(context),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: active
              ? PartnerFlowPalette.primarySoft.withValues(alpha: 0.78)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: courierMotionDuration(context),
              curve: Curves.easeOutCubic,
              scale: active ? 1.08 : 1,
              child: Icon(
                icon,
                size: 26,
                color: active
                    ? PartnerFlowPalette.primaryEnd
                    : PartnerFlowPalette.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: active
                    ? PartnerFlowPalette.primaryEnd
                    : PartnerFlowPalette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CourierScrollView extends StatelessWidget {
  const CourierScrollView({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.fromLTRB(20, 18, 20, 140),
  });

  final List<Widget> children;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}

class CourierReveal extends StatelessWidget {
  const CourierReveal({
    super.key,
    required this.child,
    this.delay = 0,
    this.offset = const Offset(0, 18),
  });

  final Widget child;
  final int delay;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reducedMotion
        ? Duration.zero
        : Duration(milliseconds: 280 + delay);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        final dx = lerpDouble(offset.dx, 0, value) ?? 0;
        final dy = lerpDouble(offset.dy, 0, value) ?? 0;
        return Opacity(
          opacity: value,
          child: Transform.translate(offset: Offset(dx, dy), child: child),
        );
      },
    );
  }
}

class CourierHeader extends StatelessWidget {
  const CourierHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBack)
          Padding(
            padding: const EdgeInsets.only(right: 14, top: 4),
            child: CourierIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => context.pop(),
            ),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.6,
                  color: PartnerFlowPalette.primaryEnd,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 12),
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 16), trailing!],
      ],
    );
  }
}

class CourierTopChrome extends StatelessWidget {
  const CourierTopChrome({
    super.key,
    this.title = 'OnlyCars Courier',
    this.showNotification = true,
    this.onNotificationTap,
  });

  final String title;
  final bool showNotification;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: PartnerFlowPalette.surface,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: PartnerFlowPalette.primaryStart.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.delivery_dining_rounded,
            color: PartnerFlowPalette.primaryEnd,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: PartnerFlowPalette.primaryStart,
            ),
          ),
        ),
        if (showNotification)
          CourierIconButton(
            icon: Icons.notifications_none_rounded,
            onTap: onNotificationTap,
          ),
      ],
    );
  }
}

class CourierIconButton extends StatelessWidget {
  const CourierIconButton({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PartnerFlowPalette.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(icon, color: PartnerFlowPalette.textPrimary),
        ),
      ),
    );
  }
}

class CourierSectionTitle extends StatelessWidget {
  const CourierSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              actionLabel!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: PartnerFlowPalette.primaryEnd,
              ),
            ),
          ),
      ],
    );
  }
}

class CourierMetricTile extends StatelessWidget {
  const CourierMetricTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: PartnerFlowPalette.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: PartnerFlowPalette.borderSubtle),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.06),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: PartnerFlowPalette.textSecondary,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: accentColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CourierStatusChip extends StatelessWidget {
  const CourierStatusChip({
    super.key,
    required this.label,
    this.color = PartnerFlowPalette.primaryEnd,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: courierMotionDuration(context),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.11),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class CourierSurfaceCard extends StatelessWidget {
  const CourierSurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: PartnerFlowPalette.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: PartnerFlowPalette.primaryStart.withValues(alpha: 0.05),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: child,
    );
  }
}

class CourierPrimaryButton extends StatelessWidget {
  const CourierPrimaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.compact = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: compact ? 58 : 64,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            gradient: enabled ? PartnerFlowPalette.primaryGradient : null,
            color: enabled ? null : PartnerFlowPalette.buttonDisabled,
            borderRadius: BorderRadius.circular(20),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: PartnerFlowPalette.primaryEnd.withValues(
                        alpha: 0.16,
                      ),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: enabled
                            ? Colors.white
                            : PartnerFlowPalette.textMuted,
                      ),
                    ),
                    if (icon != null) ...[
                      const SizedBox(width: 10),
                      Icon(
                        icon,
                        color: enabled
                            ? Colors.white
                            : PartnerFlowPalette.textMuted,
                      ),
                    ],
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

class CourierSecondaryButton extends StatelessWidget {
  const CourierSecondaryButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null
            ? const SizedBox.shrink()
            : Icon(icon, color: PartnerFlowPalette.primaryEnd),
        label: Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: PartnerFlowPalette.primaryEnd,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: PartnerFlowPalette.borderSubtle),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class CourierRemoteImage extends StatelessWidget {
  const CourierRemoteImage({
    super.key,
    required this.url,
    this.height = 220,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
    this.placeholderIcon = Icons.delivery_dining_rounded,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double height;
  final BorderRadius borderRadius;
  final IconData placeholderIcon;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.network(
          url,
          fit: fit,
          errorBuilder: (context, error, stackTrace) =>
              _CourierImageFallback(icon: placeholderIcon),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const _CourierImageFallback(
              icon: Icons.auto_awesome_motion_rounded,
            );
          },
        ),
      ),
    );
  }
}

class _CourierImageFallback extends StatelessWidget {
  const _CourierImageFallback({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PartnerFlowPalette.primarySoft,
            PartnerFlowPalette.surfaceSoft,
          ],
        ),
      ),
      child: Center(
        child: Icon(icon, size: 52, color: PartnerFlowPalette.primarySolid),
      ),
    );
  }
}

class CourierMiniStat extends StatelessWidget {
  const CourierMiniStat({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: PartnerFlowPalette.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
