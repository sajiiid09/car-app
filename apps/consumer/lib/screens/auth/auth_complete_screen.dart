import 'package:consumer/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_ui/oc_ui.dart';

class AuthCompleteScreen extends ConsumerStatefulWidget {
  const AuthCompleteScreen({super.key});

  @override
  ConsumerState<AuthCompleteScreen> createState() => _AuthCompleteScreenState();
}

class _AuthCompleteScreenState extends ConsumerState<AuthCompleteScreen>
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
    ref.read(authPreviewSessionProvider.notifier).state = true;
    ref.read(authFlowProvider.notifier).reset();
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
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
        systemNavigationBarColor: const Color(0xFFEAF2FF),
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF2FF),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Center(child: OcSuccessHalo(animation: _controller)),
                const SizedBox(height: 20),
                FadeTransition(
                  opacity: contentAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.08),
                      end: Offset.zero,
                    ).animate(contentAnimation),
                    child: Text(
                      'You’re All Set',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF4A5E7B),
                        fontSize: 34,
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.06,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                FadeTransition(
                  opacity: contentAnimation,
                  child: OcPillButton(
                    key: const Key('authCompleteStartButton'),
                    label: 'Start',
                    filled: true,
                    width: double.infinity,
                    height: 78,
                    onPressed: _start,
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
