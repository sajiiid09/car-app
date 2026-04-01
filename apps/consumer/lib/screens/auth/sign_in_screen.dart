import 'package:consumer/auth_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oc_ui/oc_ui.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(authFlowProvider);
    _emailController = TextEditingController(text: draft.email);
    _passwordController = TextEditingController(text: draft.password);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _logIn() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    ref.read(authFlowProvider.notifier).setBasicInfo(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    ref.read(authPreviewSessionProvider.notifier).state = true;
    context.go('/home');
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
                  final animationValue = disableAnimations
                      ? 1.0
                      : Curves.easeOutCubic.transform(_controller.value);
                  final offset = disableAnimations
                      ? 0.0
                      : 28 * (1 - animationValue);

                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Opacity(
                      opacity: animationValue,
                      child: child,
                    ),
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
                    const SizedBox(height: 70),
                    Text(
                      'Welcome Back',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.06,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Sign in to continue to OnlyCars',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF424242),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 44),
                    OcAnimatedAuthField(
                      key: const Key('signInEmailField'),
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
                      key: const Key('signInPasswordField'),
                      label: 'Password',
                      controller: _passwordController,
                      hintText: '••••••••',
                      textInputAction: TextInputAction.done,
                      obscureText: _obscurePassword,
                      suffix: _PasswordToggle(
                        obscureText: _obscurePassword,
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').isEmpty) {
                          return 'Enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        key: const Key('forgotPasswordButton'),
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF163154),
                          padding: EdgeInsets.zero,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.03,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    OcPillButton(
                      key: const Key('signInSubmitButton'),
                      label: 'Log In',
                      filled: true,
                      width: double.infinity,
                      height: 78,
                      onPressed: _logIn,
                    ),
                    const SizedBox(height: 40),
                    const _AuthDividerLabel(label: 'Or'),
                    const SizedBox(height: 34),
                    OcSocialAuthButton(
                      key: const Key('googleAuthButton'),
                      label: 'Continue with Google',
                      onPressed: () {},
                      leading: Text(
                        'G',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                        ).copyWith(
                          foreground: Paint()
                            ..shader = const LinearGradient(
                              colors: [
                                Color(0xFF4285F4),
                                Color(0xFF34A853),
                                Color(0xFFFBBC05),
                                Color(0xFFEA4335),
                              ],
                            ).createShader(
                              const Rect.fromLTWH(0, 0, 36, 36),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    OcSocialAuthButton(
                      key: const Key('appleAuthButton'),
                      label: 'Continue with Apple',
                      onPressed: () {},
                      leading: const Icon(
                        Icons.apple_rounded,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            'Don’t have an account? ',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          InkWell(
                            key: const Key('signInToSignUpLink'),
                            onTap: () => context.push('/auth/sign-up'),
                            child: Text(
                              'Sign up',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFF17314F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
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

class _AuthDividerLabel extends StatelessWidget {
  const _AuthDividerLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: Color(0xFF5F5F5F),
            thickness: 1,
            indent: 24,
            endIndent: 24,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFF6F6F6F),
          ),
        ),
        const Expanded(
          child: Divider(
            color: Color(0xFF5F5F5F),
            thickness: 1,
            indent: 24,
            endIndent: 24,
          ),
        ),
      ],
    );
  }
}
