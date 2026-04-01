import 'package:consumer/password_recovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_ui/oc_ui.dart';

class VerifyResetCodeScreen extends ConsumerStatefulWidget {
  const VerifyResetCodeScreen({super.key});

  @override
  ConsumerState<VerifyResetCodeScreen> createState() =>
      _VerifyResetCodeScreenState();
}

class _VerifyResetCodeScreenState extends ConsumerState<VerifyResetCodeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final OcOtpInputController _otpController;
  late String _code;

  bool get _canContinue => _code.length == 4;

  @override
  void initState() {
    super.initState();
    final recovery = ref.read(passwordRecoveryProvider);
    _code = recovery.code;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
    _otpController = OcOtpInputController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _code.isNotEmpty) {
        return;
      }
      _otpController.clearAndFocusFirst();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _continue() {
    if (!_canContinue) {
      return;
    }

    ref.read(passwordRecoveryProvider.notifier).setCode(_code);
    context.push('/auth/reset-password');
  }

  void _resendCode() {
    ref.read(passwordRecoveryProvider.notifier).resetCode();
    setState(() => _code = '');
    _otpController.clearAndFocusFirst();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final value = disableAnimations
                    ? 1.0
                    : Curves.easeOutCubic.transform(_controller.value);
                return Transform.translate(
                  offset: Offset(0, disableAnimations ? 0 : 22 * (1 - value)),
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: OcCircleBackButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                          return;
                        }
                        context.go('/auth/forgot-password');
                      },
                    ),
                  ),
                  const SizedBox(height: 136),
                  Text(
                    'Enter Verification Code',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.06,
                      color: const Color(0xFF17314F),
                    ),
                  ),
                  const SizedBox(height: 76),
                  Center(
                    child: OcOtpInputRow(
                      key: const Key('verifyResetOtpRow'),
                      controller: _otpController,
                      initialValue: _code,
                      onChanged: (value) {
                        setState(() => _code = value);
                        ref.read(passwordRecoveryProvider.notifier).setCode(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Haven’t received code yet ',
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF7E8798),
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.03,
                          ),
                        ),
                        TextButton(
                          key: const Key('verifyResetResendButton'),
                          onPressed: _resendCode,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: OcColors.accent,
                          ),
                          child: Text(
                            'send again',
                            style: GoogleFonts.plusJakartaSans(
                              color: OcColors.accent,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.03,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 42),
                  OcPillButton(
                    key: const Key('verifyResetContinueButton'),
                    label: 'Continue',
                    filled: true,
                    width: double.infinity,
                    height: 78,
                    backgroundColor: _canContinue
                        ? OcColors.accent
                        : const Color(0xFFD9E2F2),
                    foregroundColor: _canContinue
                        ? Colors.white
                        : OcColors.textMuted,
                    onPressed: _canContinue ? _continue : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
