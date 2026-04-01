import 'package:consumer/auth_flow.dart';
import 'package:consumer/screens/auth/auth_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_ui/oc_ui.dart';

const _authWelcomeBackgroundAsset = 'assets/images/onboarding_track_orders.png';
const _authWelcomeHeroTag = 'authWelcomeBackground';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _backgroundOpacity;
  late final Animation<double> _contentOpacity;
  late final Animation<Offset> _contentOffset;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    );
    _backgroundOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0, 0.62, curve: Curves.easeOutCubic),
    );
    _contentOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.18, 1, curve: Curves.easeOutCubic),
    );
    _contentOffset = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.18, 1, curve: Curves.easeOutCubic),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openRoleSheet() async {
    final selectedRole = await showRoleSelectionSheet(
      context: context,
      initialRole: ref.read(authFlowProvider).role,
    );
    if (selectedRole == null || !mounted) {
      return;
    }

    ref.read(authFlowProvider.notifier).setRole(selectedRole);
    context.push('/auth/sign-up');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            FadeTransition(
              opacity: _backgroundOpacity,
              child: OcImmersiveHeroBackground(
                assetPath: _authWelcomeBackgroundAsset,
                heroTag: _authWelcomeHeroTag,
                fallbackIcon: Icons.route_rounded,
                fallbackColors: const [
                  Color(0xFF091217),
                  Color(0xFF121E27),
                  Color(0xFF1C2C37),
                ],
                overlayGradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.06),
                    Colors.black.withValues(alpha: 0.16),
                    Colors.black.withValues(alpha: 0.5),
                    Colors.black.withValues(alpha: 0.78),
                  ],
                  stops: const [0, 0.35, 0.66, 1],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
                child: FadeTransition(
                  opacity: _contentOpacity,
                  child: SlideTransition(
                    position: _contentOffset,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(),
                        Text(
                          'Welcome to OnlyCars',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 29,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.05,
                            height: 1.04,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Sign in to continue or create a new account and unlock your full experience',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.94),
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.03,
                            height: 1.28,
                          ),
                        ),
                        const SizedBox(height: 34),
                        OcPillButton(
                          key: const Key('authWelcomeCreateAccountButton'),
                          label: 'Create Account',
                          filled: true,
                          width: double.infinity,
                          height: 78,
                          onPressed: _openRoleSheet,
                        ),
                        const SizedBox(height: 16),
                        OcPillButton(
                          key: const Key('authWelcomeSignInButton'),
                          label: 'Sign In',
                          width: double.infinity,
                          height: 78,
                          backgroundColor: const Color(0xFFE9EEF7),
                          borderColor: const Color(0xFFE9EEF7),
                          foregroundColor: const Color(0xFF17314F),
                          onPressed: () => context.push('/auth/sign-in'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
