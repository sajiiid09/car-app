import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'tokens.dart';

class OcCircleBackButton extends StatelessWidget {
  const OcCircleBackButton({super.key, required this.onPressed});

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
            color: isActive ? Colors.white : const Color(0xFFEDEDED),
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
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class OcOtpInputController extends ChangeNotifier {
  int _resetTick = 0;

  int get resetTick => _resetTick;

  void clearAndFocusFirst() {
    _resetTick++;
    notifyListeners();
  }
}

class OcOtpInputRow extends StatefulWidget {
  const OcOtpInputRow({
    super.key,
    required this.onChanged,
    this.length = 4,
    this.initialValue = '',
    this.controller,
    this.cellWidth = 48,
    this.cellHeight = 92,
  });

  final ValueChanged<String> onChanged;
  final int length;
  final String initialValue;
  final OcOtpInputController? controller;
  final double cellWidth;
  final double cellHeight;

  @override
  State<OcOtpInputRow> createState() => _OcOtpInputRowState();
}

class _OcOtpInputRowState extends State<OcOtpInputRow> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
      growable: false,
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
      growable: false,
    );
    for (final node in _focusNodes) {
      node.addListener(_handleFocusChanged);
    }
    widget.controller?.addListener(_handleExternalReset);
    _populate(widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant OcOtpInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleExternalReset);
      widget.controller?.addListener(_handleExternalReset);
    }

    final currentValue = _joinedValue;
    if (!_syncing && widget.initialValue != currentValue) {
      _populate(widget.initialValue);
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalReset);
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.removeListener(_handleFocusChanged);
      node.dispose();
    }
    super.dispose();
  }

  String get _joinedValue =>
      _controllers.map((controller) => controller.text).join();

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _handleExternalReset() {
    _clearAndFocusFirst();
  }

  void _populate(String value) {
    _syncing = true;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (var index = 0; index < widget.length; index++) {
      final text = index < digits.length ? digits[index] : '';
      _controllers[index].text = text;
      _controllers[index].selection = TextSelection.collapsed(
        offset: text.length,
      );
    }
    _syncing = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _clearAndFocusFirst() {
    _syncing = true;
    for (final controller in _controllers) {
      controller.clear();
    }
    _syncing = false;
    widget.onChanged('');
    if (!mounted) {
      return;
    }
    _focusNodes.first.requestFocus();
    setState(() {});
  }

  void _handleChanged(int index, String rawValue) {
    if (_syncing) {
      return;
    }

    final digits = rawValue.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      _setText(index, '');
      widget.onChanged(_joinedValue);
      setState(() {});
      return;
    }

    if (digits.length > 1) {
      _applyPastedDigits(startIndex: index, digits: digits);
      return;
    }

    _setText(index, digits);
    if (index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    } else {
      _focusNodes[index].unfocus();
    }
    widget.onChanged(_joinedValue);
    setState(() {});
  }

  void _applyPastedDigits({required int startIndex, required String digits}) {
    _syncing = true;
    var cursor = startIndex;
    for (final digit in digits.split('')) {
      if (cursor >= widget.length) {
        break;
      }
      _controllers[cursor].text = digit;
      _controllers[cursor].selection = const TextSelection.collapsed(offset: 1);
      cursor++;
    }
    _syncing = false;

    widget.onChanged(_joinedValue);
    final nextFocusIndex = cursor >= widget.length ? widget.length - 1 : cursor;
    if (cursor >= widget.length) {
      _focusNodes.last.unfocus();
    } else {
      _focusNodes[nextFocusIndex].requestFocus();
    }
    setState(() {});
  }

  void _setText(int index, String value) {
    _syncing = true;
    _controllers[index].text = value;
    _controllers[index].selection = TextSelection.collapsed(
      offset: value.length,
    );
    _syncing = false;
  }

  KeyEventResult _handleKeyEvent(int index, KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }

    if (_controllers[index].text.isEmpty && index > 0) {
      _setText(index - 1, '');
      _focusNodes[index - 1].requestFocus();
      widget.onChanged(_joinedValue);
      setState(() {});
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.length, (index) {
        final hasValue = _controllers[index].text.isNotEmpty;
        final isFocused = _focusNodes[index].hasFocus;
        return Padding(
          padding: EdgeInsetsDirectional.only(
            end: index == widget.length - 1 ? 0 : 16,
          ),
          child: Focus(
            onKeyEvent: (_, event) => _handleKeyEvent(index, event),
            child: AnimatedContainer(
              key: Key('otpDigitCell-$index'),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: widget.cellWidth,
              height: widget.cellHeight,
              decoration: BoxDecoration(
                color: hasValue ? const Color(0xFFEDEDED) : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isFocused ? OcColors.accent : const Color(0xFFDDE3EE),
                  width: isFocused ? 2.2 : 1.4,
                ),
                boxShadow: isFocused
                    ? [
                        BoxShadow(
                          color: OcColors.accent.withValues(alpha: 0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : const [],
              ),
              child: Center(
                child: TextField(
                  key: Key('otpDigitField-$index'),
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (value) => _handleChanged(index, value),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF17314F),
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                  cursorColor: OcColors.accent,
                  cursorWidth: 2.2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                    contentPadding: EdgeInsets.zero,
                  ),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 4,
                ),
              ),
            ),
          ),
        );
      }),
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
      children: options
          .map((option) {
            final isSelected = option == selected;
            return GestureDetector(
              onTap: () => onSelected(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 34,
                  vertical: 22,
                ),
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
          })
          .toList(growable: false),
    );
  }
}

class OcSuccessHalo extends StatelessWidget {
  const OcSuccessHalo({
    super.key,
    required this.animation,
    this.iconColor = const Color(0xFFB6B6B6),
    this.haloColor,
    this.haloBorderColor,
    this.shadowColor,
  });

  final Animation<double> animation;
  final Color iconColor;
  final Color? haloColor;
  final Color? haloBorderColor;
  final Color? shadowColor;

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
                      color: haloColor ?? Colors.white.withValues(alpha: 0.18),
                      border: Border.all(
                        color:
                            haloBorderColor ??
                            Colors.white.withValues(alpha: 0.55),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color:
                              shadowColor ??
                              Colors.white.withValues(alpha: 0.2),
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
                  child: Icon(Icons.check_rounded, size: 104, color: iconColor),
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
                decoration: BoxDecoration(gradient: widget.overlayGradient),
              ),
          ],
        ),
      ),
    );

    if (widget.borderRadius != null) {
      content = ClipRRect(borderRadius: widget.borderRadius!, child: content);
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
