import 'dart:ui';

import 'package:flutter/material.dart';

import 'partner_flow_palette.dart';

class PartnerFlowGradientButton extends StatelessWidget {
  const PartnerFlowGradientButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 78,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: enabled ? null : PartnerFlowPalette.buttonDisabled,
            gradient: enabled ? PartnerFlowPalette.primaryGradient : null,
            borderRadius: BorderRadius.circular(999),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: PartnerFlowPalette.primaryEnd.withValues(
                        alpha: 0.18,
                      ),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ]
                : null,
          ),
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(999),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: enabled ? Colors.white : PartnerFlowPalette.textMuted,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PartnerFlowCompletionBackground extends StatelessWidget {
  const PartnerFlowCompletionBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  PartnerFlowPalette.background,
                  PartnerFlowPalette.surfaceSoft,
                ],
              ),
            ),
          ),
        ),
        ...List.generate(6, (index) {
          final alignmentX = -1.1 + (index * 0.44);
          return Positioned.fill(
            child: Align(
              alignment: Alignment(alignmentX, 0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                child: Container(
                  width: 34,
                  height: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 90),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        PartnerFlowPalette.secondaryEnd.withValues(alpha: 0.18),
                        PartnerFlowPalette.secondarySoft.withValues(
                          alpha: 0.05,
                        ),
                        PartnerFlowPalette.secondaryEnd.withValues(alpha: 0.16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
