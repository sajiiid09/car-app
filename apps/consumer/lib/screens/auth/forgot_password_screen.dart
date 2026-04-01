import 'package:consumer/auth_flow.dart';
import 'package:consumer/password_recovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    final recovery = ref.read(passwordRecoveryProvider);
    final authDraft = ref.read(authFlowProvider);
    _emailController = TextEditingController(
      text: recovery.email.isNotEmpty ? recovery.email : authDraft.email,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 720),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final notifier = ref.read(passwordRecoveryProvider.notifier);
    notifier.setEmail(_emailController.text);
    notifier.resetCode();
    context.push('/auth/verify-reset');
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
                          context.go('/auth/sign-in');
                        },
                      ),
                    ),
                    const SizedBox(height: 140),
                    Text(
                      'Forgot Password',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.06,
                        color: const Color(0xFF17314F),
                      ),
                    ),
                    const SizedBox(height: 72),
                    OcAnimatedAuthField(
                      key: const Key('forgotPasswordEmailField'),
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty || !email.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 80),
                    OcPillButton(
                      key: const Key('forgotPasswordSubmitButton'),
                      label: 'Send OTP',
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
