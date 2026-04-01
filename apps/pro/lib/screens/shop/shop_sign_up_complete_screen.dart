import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../l10n/app_localizations.dart';
import '../shared/partner_flow_palette.dart';
import '../shared/partner_flow_widgets.dart';
import 'shop_sign_up_state.dart';

class ShopSignUpCompleteScreen extends ConsumerStatefulWidget {
  const ShopSignUpCompleteScreen({super.key});

  @override
  ConsumerState<ShopSignUpCompleteScreen> createState() =>
      _ShopSignUpCompleteScreenState();
}

class _ShopSignUpCompleteScreenState
    extends ConsumerState<ShopSignUpCompleteScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 980),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _start() {
    ref.read(shopRegistrationDraftProvider.notifier).clear();
    context.go('/shop');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final contentAnimation = CurvedAnimation(
      parent: _controller,
      curve: disableAnimations
          ? Curves.linear
          : const Interval(0.45, 1, curve: Curves.easeOutCubic),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: PartnerFlowPalette.background,
      ),
      child: Scaffold(
        backgroundColor: PartnerFlowPalette.background,
        body: Stack(
          children: [
            const Positioned.fill(child: PartnerFlowCompletionBackground()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  key: const Key('shopSignUpCompleteScreen'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Center(
                      child: OcSuccessHalo(
                        animation: _controller,
                        iconColor: PartnerFlowPalette.primarySolid,
                        haloColor: Colors.white.withValues(alpha: 0.82),
                        haloBorderColor: PartnerFlowPalette.secondaryEnd
                            .withValues(alpha: 0.36),
                        shadowColor: PartnerFlowPalette.secondaryEnd.withValues(
                          alpha: 0.22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: contentAnimation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.08),
                          end: Offset.zero,
                        ).animate(contentAnimation),
                        child: Text(
                          l10n.shopCompleteTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: PartnerFlowPalette.textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: contentAnimation,
                      child: PartnerFlowGradientButton(
                        key: const Key('shopSignUpStartButton'),
                        label: l10n.shopStart,
                        onPressed: _start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
