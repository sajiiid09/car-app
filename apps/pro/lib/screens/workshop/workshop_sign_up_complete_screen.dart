import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

import '../../l10n/app_localizations.dart';
import 'workshop_flow_palette.dart';
import 'workshop_sign_up_screen.dart';
import 'workshop_sign_up_state.dart';

class WorkshopSignUpCompleteScreen extends ConsumerStatefulWidget {
  const WorkshopSignUpCompleteScreen({super.key});

  @override
  ConsumerState<WorkshopSignUpCompleteScreen> createState() =>
      _WorkshopSignUpCompleteScreenState();
}

class _WorkshopSignUpCompleteScreenState
    extends ConsumerState<WorkshopSignUpCompleteScreen>
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
    ref.read(workshopRegistrationDraftProvider.notifier).clear();
    context.go('/workshop');
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
        systemNavigationBarColor: WorkshopFlowPalette.background,
      ),
      child: Scaffold(
        backgroundColor: WorkshopFlowPalette.background,
        body: Stack(
          children: [
            const Positioned.fill(child: _WorkshopCompletionBackground()),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: Column(
                  key: const Key('workshopSignUpCompleteScreen'),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    Center(
                      child: OcSuccessHalo(
                        animation: _controller,
                        iconColor: WorkshopFlowPalette.primarySolid,
                        haloColor: Colors.white.withValues(alpha: 0.82),
                        haloBorderColor: WorkshopFlowPalette.secondaryEnd
                            .withValues(alpha: 0.36),
                        shadowColor: WorkshopFlowPalette.secondaryEnd
                            .withValues(alpha: 0.22),
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
                          l10n.workshopCompleteTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: WorkshopFlowPalette.textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: contentAnimation,
                      child: WorkshopGradientButton(
                        key: const Key('workshopSignUpStartButton'),
                        label: l10n.workshopStart,
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

class _WorkshopCompletionBackground extends StatelessWidget {
  const _WorkshopCompletionBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  WorkshopFlowPalette.background,
                  WorkshopFlowPalette.surfaceSoft,
                ],
              ),
            ),
          ),
        ),
        ...List.generate(6, (index) {
          final alignmentX = -1.1 + (index * 0.44);
          return Positioned.fill(
            child: Align(
              alignment: Alignment(alignmentX, 0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: Container(
                  width: 34,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 90),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        WorkshopFlowPalette.secondaryEnd.withValues(
                          alpha: 0.18,
                        ),
                        WorkshopFlowPalette.secondarySoft.withValues(
                          alpha: 0.05,
                        ),
                        WorkshopFlowPalette.secondaryEnd.withValues(
                          alpha: 0.16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
