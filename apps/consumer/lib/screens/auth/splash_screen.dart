import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:consumer/first_run.dart';
import 'package:oc_ui/oc_ui.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _runSplashSequence();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            opacity: _visible ? 1 : 0,
            child: const OcWordmark(size: 52),
          ),
        ),
      ),
    );
  }

  Future<void> _runSplashSequence() async {
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    if (!mounted) {
      return;
    }

    setState(() => _visible = false);
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted) {
      return;
    }

    final hasCompletedOnboarding = ref
        .read(firstRunControllerProvider)
        .hasCompletedOnboarding;
    context.go(hasCompletedOnboarding ? '/login' : '/onboarding');
  }
}
