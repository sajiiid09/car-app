import 'package:consumer/password_recovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final AnimationController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final recovery = ref.read(passwordRecoveryProvider);
    _passwordController = TextEditingController(text: recovery.password);
    _confirmPasswordController = TextEditingController(text: recovery.password);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(passwordRecoveryProvider.notifier);
    notifier.setPassword(_passwordController.text);
    notifier.markResetSucceeded();
    context.go('/auth/sign-in');
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
            child: Form(
              key: _formKey,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final value = disableAnimations
                      ? 1.0
                      : Curves.easeOutCubic.transform(_controller.value);
                  return Transform.translate(
                    offset: Offset(0, disableAnimations ? 0 : 24 * (1 - value)),
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
                          context.go('/auth/verify-reset');
                        },
                      ),
                    ),
                    const SizedBox(height: 138),
                    Text(
                      'Reset Password',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.06,
                        color: const Color(0xFF17314F),
                      ),
                    ),
                    const SizedBox(height: 72),
                    OcAnimatedAuthField(
                      key: const Key('resetPasswordField'),
                      label: 'Password',
                      controller: _passwordController,
                      hintText: '••••••••',
                      textInputAction: TextInputAction.next,
                      obscureText: _obscurePassword,
                      suffix: _PasswordToggle(
                        obscureText: _obscurePassword,
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').length < 8) {
                          return 'Use at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    OcAnimatedAuthField(
                      key: const Key('resetPasswordConfirmField'),
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      hintText: '••••••••',
                      obscureText: _obscureConfirmPassword,
                      suffix: _PasswordToggle(
                        obscureText: _obscureConfirmPassword,
                        onPressed: () => setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        ),
                      ),
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 48),
                    OcPillButton(
                      key: const Key('resetPasswordConfirmButton'),
                      label: 'Confirm',
                      filled: true,
                      width: double.infinity,
                      height: 78,
                      onPressed: _submit,
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

class _PasswordToggle extends StatelessWidget {
  const _PasswordToggle({
    required this.obscureText,
    required this.onPressed,
  });

  final bool obscureText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: Icon(
          obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
          key: ValueKey<bool>(obscureText),
          color: const Color(0xFF17314F),
        ),
      ),
    );
  }
}
