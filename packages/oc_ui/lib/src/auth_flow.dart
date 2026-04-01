import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

class OcCircleBackButton extends StatelessWidget {
  const OcCircleBackButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(34),
        child: Ink(
          width: 72,
          height: 72,
          decoration: const BoxDecoration(
            color: OcColors.accent,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}

class OcAnimatedAuthField extends StatefulWidget {
  const OcAnimatedAuthField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffix,
    this.prefix,
    this.readOnly = false,
    this.onTap,
    this.validator,
    this.maxLines = 1,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final Widget? suffix;
  final Widget? prefix;
  final bool readOnly;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final int maxLines;

  @override
  State<OcAnimatedAuthField> createState() => _OcAnimatedAuthFieldState();
}

class _OcAnimatedAuthFieldState extends State<OcAnimatedAuthField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_handleFocusChanged)
      ..dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isActive = _focusNode.hasFocus || widget.controller.text.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              color: OcColors.accent,
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.03,
            ),
          ),
          const SizedBox(height: 12),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isActive ? OcColors.accent : Colors.transparent,
              width: isActive ? 1.5 : 1,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: OcColors.accent.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : const [],
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            onTap: widget.onTap,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            maxLines: widget.maxLines,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF163154),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.prefix,
              suffixIcon: widget.suffix,
              filled: false,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 24,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              hintStyle: GoogleFonts.plusJakartaSans(
                color: OcColors.textSecondary,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OcSocialAuthButton extends StatelessWidget {
  const OcSocialAuthButton({
    super.key,
    required this.label,
    required this.leading,
    this.onPressed,
  });

  final String label;
  final Widget leading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 76,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF171717),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(OcRadius.pill),
          ),
          elevation: 0,
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.03,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            const SizedBox(width: 18),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OcEngineTypeChips<T> extends StatelessWidget {
  const OcEngineTypeChips({
    super.key,
    required this.options,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  final List<T> options;
  final T? selected;
  final String Function(T value) labelBuilder;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: options.map((option) {
        final isSelected = option == selected;
        return GestureDetector(
          onTap: () => onSelected(option),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 22),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : const Color(0xFFEDEDED),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? OcColors.accent : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Text(
              labelBuilder(option),
              style: GoogleFonts.plusJakartaSans(
                color: isSelected
                    ? const Color(0xFF163154)
                    : const Color(0xFF5F5F5F),
                fontSize: 17,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                letterSpacing: -0.03,
              ),
            ),
          ),
        );
      }).toList(growable: false),
    );
  }
}

class OcSuccessHalo extends StatelessWidget {
  const OcSuccessHalo({
    super.key,
    required this.animation,
  });

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final haloAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 0.55, curve: Curves.easeOutCubic),
    );
    final checkAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.35, 0.9, curve: Curves.easeOutBack),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final haloValue = haloAnimation.value.clamp(0.0, 1.0);
        final checkValue = checkAnimation.value.clamp(0.0, 1.0);
        return SizedBox(
          width: 248,
          height: 248,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: haloValue,
                child: Transform.scale(
                  scale: 0.88 + (haloValue * 0.12),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.18),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.55),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.2),
                          blurRadius: 38,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                ),
              ),
              Transform.scale(
                scale: checkValue,
                child: Opacity(
                  opacity: checkValue,
                  child: Icon(
                    Icons.check_rounded,
                    size: 104,
                    color: const Color(0xFFB6B6B6),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class OcImmersiveHeroBackground extends StatefulWidget {
  const OcImmersiveHeroBackground({
    super.key,
    required this.assetPath,
    required this.heroTag,
    required this.fallbackColors,
    required this.fallbackIcon,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.height,
    this.overlayGradient,
  });

  final String assetPath;
  final String heroTag;
  final List<Color> fallbackColors;
  final IconData fallbackIcon;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? height;
  final Gradient? overlayGradient;

  @override
  State<OcImmersiveHeroBackground> createState() =>
      _OcImmersiveHeroBackgroundState();
}

class _OcImmersiveHeroBackgroundState extends State<OcImmersiveHeroBackground> {
  late Future<bool> _hasAsset;

  @override
  void initState() {
    super.initState();
    _hasAsset = _checkAsset(widget.assetPath);
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
    Widget content = FutureBuilder<bool>(
      future: _hasAsset,
      builder: (context, snapshot) {
        final hasAsset = snapshot.data ?? false;
        if (hasAsset) {
          return Image.asset(
            widget.assetPath,
            fit: widget.fit,
            width: double.infinity,
            height: widget.height,
          );
        }

        return Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.fallbackColors,
            ),
          ),
          child: Center(
            child: Icon(
              widget.fallbackIcon,
              size: widget.height == null ? 132 : 88,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
        );
      },
    );

    content = Hero(
      tag: widget.heroTag,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          fit: StackFit.expand,
          children: [
            content,
            if (widget.overlayGradient != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: widget.overlayGradient,
                ),
              ),
          ],
        ),
      ),
    );

    if (widget.borderRadius != null) {
      content = ClipRRect(
        borderRadius: widget.borderRadius!,
        child: content,
      );
    }

    if (widget.height != null) {
      content = SizedBox(
        height: widget.height,
        width: double.infinity,
        child: content,
      );
    }

    return content;
  }
}
