import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pro/l10n/app_localizations.dart';

import '../shared/partner_flow_palette.dart';
import 'courier_flow_helpers.dart';
import 'courier_shared.dart';
import 'courier_workflow_state.dart';

class DriverNewDeliveryRequestScreen extends ConsumerWidget {
  const DriverNewDeliveryRequestScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(courierDeliveryProvider(deliveryId));
    final l10n = AppLocalizations.of(context)!;
    if (delivery == null) {
      return _MissingDeliveryView(message: l10n.driverDeliveryNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('driverNewDeliveryRequestScreen'),
      eyebrow: l10n.driverRequestEyebrow,
      title: l10n.driverRequestTitle,
      subtitle: l10n.driverRequestSubtitle,
      delivery: delivery,
      accentColor: PartnerFlowPalette.warning,
      infoCard: CourierSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverRequestDetailsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: l10n.driverPickupDetailsTitle,
              value: delivery.pickupAddress,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverDropoffDetailsTitle,
              value: delivery.dropoffAddress,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverPayoutLabel,
              value: delivery.payoutLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverDistanceLabel,
              value: delivery.distanceLabel,
            ),
            if (delivery.note != null) ...[
              const SizedBox(height: 12),
              _InfoRow(label: l10n.driverNoteLabel, value: delivery.note!),
            ],
          ],
        ),
      ),
      primaryButtonKey: const Key('driverAcceptDeliveryButton'),
      primaryLabel: l10n.driverAcceptDelivery,
      primaryIcon: Icons.check_circle_outline_rounded,
      onPrimary: () {
        ref.read(courierWorkflowProvider.notifier).acceptDelivery(delivery.id);
        context.go('/driver/orders/${delivery.id}/navigation');
      },
    );
  }
}

class DriverActiveDeliveryNavigationScreen extends ConsumerWidget {
  const DriverActiveDeliveryNavigationScreen({
    super.key,
    required this.deliveryId,
  });

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(courierDeliveryProvider(deliveryId));
    final l10n = AppLocalizations.of(context)!;
    if (delivery == null) {
      return _MissingDeliveryView(message: l10n.driverDeliveryNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('driverActiveDeliveryNavigationScreen'),
      eyebrow: l10n.driverNavigationEyebrow,
      title: l10n.driverNavigationTitle,
      subtitle: l10n.driverNavigationSubtitle,
      delivery: delivery,
      accentColor: PartnerFlowPalette.secondaryStart,
      heroChild: _NavigationHero(delivery: delivery),
      infoCard: CourierSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverPickupDetailsTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: l10n.driverPickupWindowLabel,
              value: delivery.pickupWindowLabel,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverDropoffWindowLabel,
              value: delivery.dropoffWindowLabel,
            ),
            const SizedBox(height: 18),
            _ChecklistCard(
              entries: [
                l10n.driverNavigationChecklistOne,
                l10n.driverNavigationChecklistTwo,
                l10n.driverNavigationChecklistThree,
              ],
            ),
          ],
        ),
      ),
      primaryButtonKey: const Key('driverNavigationProceedButton'),
      primaryLabel: l10n.driverProceedToConfirmation,
      primaryIcon: Icons.arrow_forward_rounded,
      onPrimary: () {
        ref
            .read(courierWorkflowProvider.notifier)
            .advanceToConfirmation(delivery.id);
        context.go('/driver/orders/${delivery.id}/confirm');
      },
    );
  }
}

class DriverConfirmDeliveryScreen extends ConsumerWidget {
  const DriverConfirmDeliveryScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(courierDeliveryProvider(deliveryId));
    final l10n = AppLocalizations.of(context)!;
    if (delivery == null) {
      return _MissingDeliveryView(message: l10n.driverDeliveryNotFound);
    }

    return _StageScaffold(
      screenKey: const Key('driverConfirmDeliveryScreen'),
      eyebrow: l10n.driverConfirmEyebrow,
      title: l10n.driverConfirmTitle,
      subtitle: l10n.driverConfirmSubtitle,
      delivery: delivery,
      accentColor: PartnerFlowPalette.primaryEnd,
      heroChild: _ProofOfDeliveryHero(delivery: delivery),
      infoCard: CourierSurfaceCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.driverRecipientTitle,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 16),
            _InfoRow(
              label: l10n.driverRecipientLabel,
              value: delivery.recipientName,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverPhoneLabel,
              value: delivery.recipientPhone,
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: l10n.driverTrackingCodeLabel,
              value: delivery.trackingCode,
            ),
          ],
        ),
      ),
      primaryButtonKey: const Key('driverCompleteDeliveryButton'),
      primaryLabel: l10n.driverMarkDelivered,
      primaryIcon: Icons.task_alt_rounded,
      onPrimary: () {
        ref
            .read(courierWorkflowProvider.notifier)
            .completeDelivery(delivery.id);
        context.go('/driver/orders/${delivery.id}/completed');
      },
    );
  }
}

class DriverDeliveryCompletedScreen extends ConsumerWidget {
  const DriverDeliveryCompletedScreen({super.key, required this.deliveryId});

  final String deliveryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final delivery = ref.watch(courierDeliveryProvider(deliveryId));
    final l10n = AppLocalizations.of(context)!;
    if (delivery == null) {
      return _MissingDeliveryView(message: l10n.driverDeliveryNotFound);
    }

    return CourierScrollView(
      children: [
        const KeyedSubtree(
          key: Key('driverDeliveryCompletedScreen'),
          child: SizedBox.shrink(),
        ),
        const CourierReveal(child: CourierTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 20,
          child: CourierHeader(
            showBack: true,
            eyebrow: l10n.driverCompletedEyebrow,
            title: l10n.driverCompletedTitle,
            subtitle: l10n.driverCompletedSubtitle,
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 50,
          child: CourierSurfaceCard(
            child: Column(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: PartnerFlowPalette.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Icon(
                    Icons.task_alt_rounded,
                    size: 44,
                    color: PartnerFlowPalette.success,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  delivery.requestCode,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  delivery.statusBody,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: PartnerFlowPalette.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: CourierMiniStat(
                        label: l10n.driverPayoutLabel,
                        value: delivery.payoutLabel,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CourierMiniStat(
                        label: l10n.driverTrackingCodeLabel,
                        value: delivery.trackingCode,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        CourierReveal(
          delay: 80,
          child: Row(
            children: [
              Expanded(
                child: CourierPrimaryButton(
                  label: l10n.driverBackToOrders,
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () => context.go('/driver/orders'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CourierSecondaryButton(
                  label: l10n.driverBackToDashboard,
                  icon: Icons.grid_view_rounded,
                  onPressed: () => context.go('/driver'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StageScaffold extends StatelessWidget {
  const _StageScaffold({
    required this.screenKey,
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.delivery,
    required this.accentColor,
    required this.infoCard,
    required this.primaryButtonKey,
    required this.primaryLabel,
    required this.primaryIcon,
    required this.onPrimary,
    this.heroChild,
  });

  final Key screenKey;
  final String eyebrow;
  final String title;
  final String subtitle;
  final CourierDeliveryRecord delivery;
  final Color accentColor;
  final Widget infoCard;
  final Key primaryButtonKey;
  final String primaryLabel;
  final IconData primaryIcon;
  final VoidCallback onPrimary;
  final Widget? heroChild;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CourierScrollView(
      children: [
        KeyedSubtree(key: screenKey, child: const SizedBox.shrink()),
        const CourierReveal(child: CourierTopChrome()),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 20,
          child: CourierHeader(
            showBack: true,
            eyebrow: eyebrow,
            title: title,
            subtitle: subtitle,
          ),
        ),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 50,
          child: _StageHeroCard(
            delivery: delivery,
            accentColor: accentColor,
            heroChild: heroChild,
          ),
        ),
        const SizedBox(height: 16),
        CourierReveal(delay: 80, child: infoCard),
        const SizedBox(height: 18),
        CourierReveal(
          delay: 110,
          child: Row(
            children: [
              Expanded(
                child: CourierPrimaryButton(
                  key: primaryButtonKey,
                  label: primaryLabel,
                  icon: primaryIcon,
                  onPressed: onPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CourierSecondaryButton(
                  label: l10n.driverBackToOrders,
                  icon: Icons.arrow_back_rounded,
                  onPressed: () => context.go('/driver/orders'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StageHeroCard extends StatelessWidget {
  const _StageHeroCard({
    required this.delivery,
    required this.accentColor,
    this.heroChild,
  });

  final CourierDeliveryRecord delivery;
  final Color accentColor;
  final Widget? heroChild;

  @override
  Widget build(BuildContext context) {
    return CourierSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heroChild == null)
            CourierRemoteImage(
              url: delivery.heroImageUrl,
              height: 200,
              placeholderIcon: Icons.delivery_dining_rounded,
            )
          else
            heroChild!,
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Text(
                  delivery.statusHeadline,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              CourierStatusChip(
                label: courierStageLabel(context, delivery.stage),
                color: accentColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            delivery.statusBody,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          _ProgressDots(stage: delivery.stage),
        ],
      ),
    );
  }
}

class _NavigationHero extends StatelessWidget {
  const _NavigationHero({required this.delivery});

  final CourierDeliveryRecord delivery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 212,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [PartnerFlowPalette.primarySoft, Color(0xFFF4F8FF)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _RoutePainter())),
          const Positioned(
            left: 32,
            top: 48,
            child: _PulseMarker(
              color: PartnerFlowPalette.primaryEnd,
              icon: Icons.storefront_outlined,
            ),
          ),
          const Positioned(
            right: 38,
            bottom: 42,
            child: _PulseMarker(
              color: PartnerFlowPalette.secondaryStart,
              icon: Icons.precision_manufacturing_rounded,
            ),
          ),
          Positioned(
            left: 22,
            right: 22,
            bottom: 18,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      delivery.distanceLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: PartnerFlowPalette.primaryStart,
                      ),
                    ),
                  ),
                  Text(
                    delivery.dropoffWindowLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: PartnerFlowPalette.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProofOfDeliveryHero extends StatelessWidget {
  const _ProofOfDeliveryHero({required this.delivery});

  final CourierDeliveryRecord delivery;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 304,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEAF3FF), PartnerFlowPalette.surfaceSoft],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: PartnerFlowPalette.primaryEnd.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: PartnerFlowPalette.primaryEnd,
                size: 28,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              delivery.workshopName,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.driverConfirmHeroNote,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: PartnerFlowPalette.textSecondary,
                height: 1.45,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: CourierMiniStat(
                    label: AppLocalizations.of(context)!.driverRecipientLabel,
                    value: delivery.recipientName,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CourierMiniStat(
                    label: AppLocalizations.of(
                      context,
                    )!.driverTrackingCodeLabel,
                    value: delivery.trackingCode,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistCard extends StatelessWidget {
  const _ChecklistCard({required this.entries});

  final List<String> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final (index, entry) in entries.indexed)
          Padding(
            padding: EdgeInsets.only(
              bottom: index == entries.length - 1 ? 0 : 12,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: PartnerFlowPalette.primarySoft,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: PartnerFlowPalette.primaryEnd,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: PartnerFlowPalette.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: PartnerFlowPalette.textSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    );
  }
}

class _ProgressDots extends StatelessWidget {
  const _ProgressDots({required this.stage});

  final CourierDeliveryStage stage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final step in CourierDeliveryStage.values) ...[
          Expanded(
            child: AnimatedContainer(
              duration: courierMotionDuration(context),
              curve: Curves.easeOutCubic,
              height: 8,
              decoration: BoxDecoration(
                color: step.index <= stage.index
                    ? courierStageColor(step)
                    : PartnerFlowPalette.surfaceMuted,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (step != CourierDeliveryStage.values.last)
            const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _PulseMarker extends StatefulWidget {
  const _PulseMarker({required this.color, required this.icon});

  final Color color;
  final IconData icon;

  @override
  State<_PulseMarker> createState() => _PulseMarkerState();
}

class _PulseMarkerState extends State<_PulseMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion && _isAnimating) {
      _controller.stop();
      _controller.value = 0;
      _isAnimating = false;
    } else if (!reducedMotion && !_isAnimating) {
      _controller.repeat(reverse: true);
      _isAnimating = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reducedMotion) {
      return _buildMarker(1);
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final scale = 0.9 + (_controller.value * 0.2);
        return Transform.scale(
          scale: scale,
          child: _buildMarker(1 - (_controller.value * 0.25)),
        );
      },
    );
  }

  Widget _buildMarker(double alpha) {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        color: widget.color.withValues(alpha: 0.16 * alpha),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..color = PartnerFlowPalette.primaryEnd.withValues(alpha: 0.45);
    final dashed = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..color = PartnerFlowPalette.secondaryStart.withValues(alpha: 0.32);

    final path = Path()
      ..moveTo(size.width * 0.18, size.height * 0.32)
      ..quadraticBezierTo(
        size.width * 0.42,
        size.height * 0.08,
        size.width * 0.62,
        size.height * 0.42,
      )
      ..quadraticBezierTo(
        size.width * 0.72,
        size.height * 0.58,
        size.width * 0.82,
        size.height * 0.72,
      );

    canvas.drawPath(path, paint);

    final pathMeasure = path.computeMetrics().single;
    for (double distance = 0; distance < pathMeasure.length; distance += 14) {
      final segment = pathMeasure.extractPath(distance, distance + 6);
      canvas.drawPath(segment, dashed);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MissingDeliveryView extends StatelessWidget {
  const _MissingDeliveryView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return CourierScrollView(
      children: [
        const CourierReveal(child: CourierTopChrome(showNotification: false)),
        const SizedBox(height: 24),
        CourierReveal(
          delay: 20,
          child: CourierHeader(
            showBack: true,
            eyebrow: AppLocalizations.of(context)!.driverDashboardEyebrow,
            title: message,
          ),
        ),
      ],
    );
  }
}
