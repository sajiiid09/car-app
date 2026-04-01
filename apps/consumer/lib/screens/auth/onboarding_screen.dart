import 'dart:ui';

import 'package:consumer/first_run.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:oc_ui/oc_ui.dart';

const _languageSelectionSubtitle =
    'From Service to Parts — OnlyCars Has You Covered.';

const _onboardingPages = <OcOnboardingPageData>[
  OcOnboardingPageData(
    imageAssetPath: 'assets/images/onboarding_find_workshops.png',
    title: 'Find Nearby Workshops',
    subtitle: 'Easily discover trusted car workshops and book services anytime',
    ctaLabel: 'Skip',
    fallbackIcon: Icons.car_repair_rounded,
    fallbackColors: [Color(0xFF0E161E), Color(0xFF162430), Color(0xFF24323D)],
  ),
  OcOnboardingPageData(
    imageAssetPath: 'assets/images/onboarding_shop_parts.png',
    title: 'Track Your Orders',
    subtitle:
        'Shop original car parts from reliable sellers with fast delivery',
    ctaLabel: 'Next',
    fallbackIcon: Icons.precision_manufacturing_rounded,
    fallbackColors: [Color(0xFF071217), Color(0xFF0A2533), Color(0xFF1D3946)],
  ),
  OcOnboardingPageData(
    imageAssetPath: 'assets/images/onboarding_track_orders.png',
    title: 'Track Your Orders',
    subtitle: 'Stay updated with your service and delivery status in real time',
    ctaLabel: 'Get Started',
    heroTag: 'authWelcomeBackground',
    fallbackIcon: Icons.route_rounded,
    fallbackColors: [Color(0xFF0B1219), Color(0xFF162028), Color(0xFF24343E)],
  ),
];

const _languageOptions = <OcLanguageOption>[
  OcLanguageOption(
    code: 'en',
    label: 'English (LTR)',
    direction: TextDirection.ltr,
  ),
  OcLanguageOption(
    code: 'ar',
    label: 'Arabic (RTL)',
    direction: TextDirection.rtl,
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  late final TextEditingController _searchController;
  int _currentPage = 0;
  bool _isLanguageSheetOpen = false;
  String _selectedLanguageCode = 'en';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
    _selectedLanguageCode = ref.read(appLocaleProvider).languageCode;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleCtaPress() async {
    if (_currentPage == 0) {
      await _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    if (_currentPage == 1) {
      await _pageController.animateToPage(
        2,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
      return;
    }

    setState(() => _isLanguageSheetOpen = true);
  }

  Future<void> _continueWithLanguage() async {
    final controller = ref.read(firstRunControllerProvider.notifier);
    await controller.setPreferredLocaleCode(_selectedLanguageCode);
    await controller.completeOnboarding();
    if (!mounted) {
      return;
    }
    context.pushReplacement('/login');
  }

  Future<void> _skipForNow() async {
    await ref.read(firstRunControllerProvider.notifier).completeOnboarding();
    if (!mounted) {
      return;
    }
    context.pushReplacement('/login');
  }

  void _closeLanguageSheet() {
    setState(() => _isLanguageSheetOpen = false);
  }

  List<OcLanguageOption> get _filteredLanguages {
    if (_searchQuery.trim().isEmpty) {
      return _languageOptions;
    }

    final query = _searchQuery.trim().toLowerCase();
    return _languageOptions
        .where((option) => option.label.toLowerCase().contains(query))
        .toList(growable: false);
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
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _onboardingPages.length,
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              itemBuilder: (context, index) {
                return OcOnboardingScaffold(
                  page: _onboardingPages[index],
                  currentIndex: _currentPage,
                  pageCount: _onboardingPages.length,
                  onCtaPressed: _handleCtaPress,
                );
              },
            ),
            if (_isLanguageSheetOpen)
              Positioned.fill(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ColoredBox(
                          color: Colors.black.withValues(alpha: 0.28),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SafeArea(
                          top: false,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.78,
                            ),
                            child: OcModalSheetShell(
                              onClose: _closeLanguageSheet,
                              child: _LanguageSelectionSheetContent(
                                selectedLanguageCode: _selectedLanguageCode,
                                searchController: _searchController,
                                searchQuery: _searchQuery,
                                filteredLanguages: _filteredLanguages,
                                onSearchChanged: (value) {
                                  setState(() => _searchQuery = value);
                                },
                                onLanguageSelected: (code) {
                                  setState(() => _selectedLanguageCode = code);
                                },
                                onContinue: _continueWithLanguage,
                                onSkip: _skipForNow,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _LanguageSelectionSheetContent extends StatelessWidget {
  const _LanguageSelectionSheetContent({
    required this.selectedLanguageCode,
    required this.searchController,
    required this.searchQuery,
    required this.filteredLanguages,
    required this.onSearchChanged,
    required this.onLanguageSelected,
    required this.onContinue,
    required this.onSkip,
  });

  final String selectedLanguageCode;
  final TextEditingController searchController;
  final String searchQuery;
  final List<OcLanguageOption> filteredLanguages;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String> onLanguageSelected;
  final VoidCallback onContinue;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final selectedLanguage = _languageOptions.firstWhere(
      (language) => language.code == selectedLanguageCode,
      orElse: () => _languageOptions.first,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Text(
            'Language Selection',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: OcColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _languageSelectionSubtitle,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: OcColors.textMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: OcColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedLanguage.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: OcColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: OcColors.textPrimary,
                  size: 28,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            key: const Key('languageSelectionSheet'),
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: OcColors.borderLight),
              boxShadow: OcShadows.card,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  key: const Key('languageSearchField'),
                  controller: searchController,
                  onChanged: onSearchChanged,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search_rounded),
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 18,
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OcColors.borderLight),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: OcColors.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (filteredLanguages.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Text(
                      'No languages found',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: OcColors.textSecondary,
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      for (
                        var index = 0;
                        index < filteredLanguages.length;
                        index++
                      ) ...[
                        if (index > 0) const SizedBox(height: 8),
                        _LanguageOptionTile(
                          option: filteredLanguages[index],
                          selected:
                              filteredLanguages[index].code ==
                              selectedLanguageCode,
                          onTap: () =>
                              onLanguageSelected(filteredLanguages[index].code),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          OcPillButton(
            key: const Key('languageContinueButton'),
            label: 'Continue',
            filled: true,
            width: double.infinity,
            height: 62,
            onPressed: onContinue,
          ),
          const SizedBox(height: 10),
          TextButton(
            key: const Key('languageSkipButton'),
            onPressed: onSkip,
            child: Text(
              'Skip for now',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: OcColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOptionTile extends StatelessWidget {
  const _LanguageOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final OcLanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarBackground = option.code == 'en'
        ? const Color(0xFFEFF4FC)
        : const Color(0xFFFFE6B7);

    return InkWell(
      key: Key('languageOption-${option.code}'),
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: avatarBackground,
              child: Text(
                option.code.toUpperCase(),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: OcColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: OcColors.textPrimary,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? OcColors.accent : Colors.white,
                border: Border.all(
                  color: selected ? OcColors.accent : OcColors.border,
                  width: 2,
                ),
              ),
              child: selected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 22,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
