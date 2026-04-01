import 'package:consumer/auth_flow.dart';
import 'package:consumer/screens/auth/auth_sheets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authFlowProvider);
    _nameController = TextEditingController(text: draft.name);
    _emailController = TextEditingController(text: draft.email);
    _passwordController = TextEditingController(text: draft.password);
    _confirmPasswordController = TextEditingController(text: draft.password);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 760),
    )..forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authFlowProvider.notifier).setBasicInfo(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

    final agreed = await showPrivacySheet(context);
    if (agreed != true || !mounted) {
      return;
    }

    ref.read(authFlowProvider.notifier).setAcceptedPrivacy(true);
    context.push('/vehicle/add');
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
                          context.go('/login');
                        },
                      ),
                    ),
                    const SizedBox(height: 56),
                    Text(
                      'Create Account',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.06,
                        color: const Color(0xFF17314F),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Access your services, orders, and car details',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF435A78),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 44),
                    OcAnimatedAuthField(
                      key: const Key('signUpNameField'),
                      label: 'Name',
                      controller: _nameController,
                      hintText: 'Asma Islam',
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if ((value?.trim().length ?? 0) < 2) {
                          return 'Enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    OcAnimatedAuthField(
                      key: const Key('signUpEmailField'),
                      label: 'Email',
                      controller: _emailController,
                      hintText: 'you@example.com',
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty || !email.contains('@')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    OcAnimatedAuthField(
                      key: const Key('signUpPasswordField'),
                      label: 'Password',
                      controller: _passwordController,
                      hintText: '********',
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
                      key: const Key('signUpConfirmPasswordField'),
                      label: 'Confirm Password',
                      controller: _confirmPasswordController,
                      hintText: '********',
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
                    const SizedBox(height: 72),
                    OcPillButton(
                      key: const Key('signUpSubmitButton'),
                      label: 'Sign up',
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
