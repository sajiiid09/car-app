import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

@immutable
class OcOnboardingPageData {
  const OcOnboardingPageData({
    required this.imageAssetPath,
    required this.title,
    required this.subtitle,
    required this.ctaLabel,
    required this.fallbackIcon,
    required this.fallbackColors,
  });

  final String imageAssetPath;
  final String title;
  final String subtitle;
  final String ctaLabel;
  final IconData fallbackIcon;
  final List<Color> fallbackColors;
}

@immutable
class OcLanguageOption {
  const OcLanguageOption({
    required this.code,
    required this.label,
    required this.direction,
  });

  final String code;
  final String label;
  final TextDirection direction;
}

class OcWordmark extends StatelessWidget {
  const OcWordmark({super.key, this.color = OcColors.accent, this.size = 46});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'OnlyCars',
      style: GoogleFonts.plusJakartaSans(
        color: color,
        fontSize: size,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.045 * size,
        height: 0.95,
      ),
    );
  }
}

class OcPillButton extends StatelessWidget {
  const OcPillButton({
    super.key,
    required this.label,
    this.onPressed,
    this.filled = false,
    this.width,
    this.height = 58,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final double? width;
  final double height;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedForegroundColor = foregroundColor ?? Colors.white;
    final resolvedBorderColor = borderColor ?? OcColors.accent;
    final resolvedBackgroundColor =
        backgroundColor ??
        (filled ? OcColors.accent : Colors.black.withValues(alpha: 0.12));

    final hasFiniteWidth = width != null && width!.isFinite;
    final style = ButtonStyle(
      minimumSize: WidgetStateProperty.all<Size>(
        Size(hasFiniteWidth ? width! : 156, height),
      ),
      fixedSize: hasFiniteWidth
          ? WidgetStateProperty.all<Size>(Size(width!, height))
          : null,
      backgroundColor: WidgetStateProperty.all<Color>(resolvedBackgroundColor),
      foregroundColor: WidgetStateProperty.all<Color>(resolvedForegroundColor),
      elevation: WidgetStateProperty.all<double>(0),
      padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(horizontal: OcSpacing.xl),
      ),
      shape: WidgetStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(OcRadius.pill),
          side: BorderSide(
            color: filled ? Colors.transparent : resolvedBorderColor,
            width: filled ? 0 : 1.8,
          ),
        ),
      ),
      textStyle: WidgetStateProperty.all<TextStyle>(
        GoogleFonts.plusJakartaSans(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.02,
        ),
      ),
    );

    final child = Text(label, maxLines: 1, overflow: TextOverflow.ellipsis);
    return SizedBox(
      width: width,
      height: height,
      child: filled
          ? FilledButton(onPressed: onPressed, style: style, child: child)
          : OutlinedButton(onPressed: onPressed, style: style, child: child),
    );
  }
}

class OcOnboardingProgressIndicator extends StatelessWidget {
  const OcOnboardingProgressIndicator({
    super.key,
    required this.currentIndex,
    this.count = 3,
  });

  final int currentIndex;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return Container(
          key: Key(
            'onboardingIndicator-$index-${isActive ? 'active' : 'inactive'}',
          ),
          width: isActive ? 46 : 16,
          height: 16,
          margin: EdgeInsetsDirectional.only(end: index == count - 1 ? 0 : 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isActive ? 0.96 : 0.9),
            borderRadius: BorderRadius.circular(OcRadius.pill),
          ),
        );
      }),
    );
  }
}

class OcModalSheetShell extends StatelessWidget {
  const OcModalSheetShell({
    super.key,
    required this.child,
    required this.onClose,
  });

  final Widget child;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          boxShadow: OcShadows.sheet,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 12,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 78,
                  height: 5,
                  decoration: BoxDecoration(
                    color: OcColors.textMuted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(OcRadius.pill),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 18,
              end: 18,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: OcColors.backgroundLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: OcColors.borderLight),
                ),
                child: IconButton(
                  key: const Key('languageSheetCloseButton'),
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                  color: OcColors.textSecondary,
                  iconSize: 28,
                  splashRadius: 22,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 54, 24, 20),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

class OcOnboardingScaffold extends StatelessWidget {
  const OcOnboardingScaffold({
    super.key,
    required this.page,
    required this.currentIndex,
    required this.pageCount,
    required this.onCtaPressed,
  });

  final OcOnboardingPageData page;
  final int currentIndex;
  final int pageCount;
  final VoidCallback onCtaPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _OcOnboardingBackground(page: page, pageIndex: currentIndex),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: 0.52),
                Colors.black.withValues(alpha: 0.72),
              ],
              stops: const [0.0, 0.36, 0.72, 1.0],
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                Text(
                  page.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.04,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  page.subtitle,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white.withValues(alpha: 0.93),
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.02,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    OcOnboardingProgressIndicator(
                      currentIndex: currentIndex,
                      count: pageCount,
                    ),
                    const Spacer(),
                    OcPillButton(
                      key: const Key('firstRunCtaButton'),
                      label: page.ctaLabel,
                      onPressed: onCtaPressed,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _OcOnboardingBackground extends StatefulWidget {
  const _OcOnboardingBackground({required this.page, required this.pageIndex});

  final OcOnboardingPageData page;
  final int pageIndex;

  @override
  State<_OcOnboardingBackground> createState() =>
      _OcOnboardingBackgroundState();
}

class _OcOnboardingBackgroundState extends State<_OcOnboardingBackground> {
  late Future<bool> _hasAsset;

  @override
  void initState() {
    super.initState();
    _hasAsset = _checkAsset(widget.page.imageAssetPath);
  }

  @override
  void didUpdateWidget(covariant _OcOnboardingBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page.imageAssetPath != widget.page.imageAssetPath) {
      _hasAsset = _checkAsset(widget.page.imageAssetPath);
    }
  }

  Future<bool> _checkAsset(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasAsset,
      builder: (context, snapshot) {
        if (snapshot.data ?? false) {
          return Image.asset(
            widget.page.imageAssetPath,
            fit: BoxFit.cover,
            alignment: Alignment.center,
          );
        }

        return _OcFallbackArtwork(
          pageIndex: widget.pageIndex,
          fallbackColors: widget.page.fallbackColors,
          fallbackIcon: widget.page.fallbackIcon,
        );
      },
    );
  }
}

class _OcFallbackArtwork extends StatelessWidget {
  const _OcFallbackArtwork({
    required this.pageIndex,
    required this.fallbackColors,
    required this.fallbackIcon,
  });

  final int pageIndex;
  final List<Color> fallbackColors;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    final baseGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: fallbackColors,
    );

    return DecoratedBox(
      decoration: BoxDecoration(gradient: baseGradient),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _BlurredOrb(
              size: 220,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Positioned(
            bottom: pageIndex == 1 ? 110 : 60,
            left: pageIndex == 1 ? -20 : 20,
            child: _BlurredOrb(
              size: pageIndex == 1 ? 200 : 160,
              color: OcColors.accent.withValues(alpha: 0.2),
            ),
          ),
          Center(
            child: Icon(
              fallbackIcon,
              size: 168,
              color: Colors.white.withValues(alpha: 0.15),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 160),
                child: SizedBox(
                  width: 280,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(36),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.14),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(3, (index) {
                          return Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(
                                alpha: index == pageIndex ? 0.24 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              index == 0
                                  ? Icons.build_circle_outlined
                                  : index == 1
                                  ? Icons.precision_manufacturing_outlined
                                  : Icons.route_outlined,
                              color: Colors.white.withValues(alpha: 0.82),
                              size: 28,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurredOrb extends StatelessWidget {
  const _BlurredOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 34, sigmaY: 34),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
