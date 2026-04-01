import 'package:flutter/material.dart';

class WorkshopFlowPalette {
  WorkshopFlowPalette._();

  static const Color background = Color(0xFFF7F5F3);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF2EFEC);
  static const Color surfaceMuted = Color(0xFFEAE5E1);
  static const Color textPrimary = Color(0xFF1C1B1A);
  static const Color textSecondary = Color(0xFF6E675F);
  static const Color textMuted = Color(0xFF9A938B);
  static const Color borderSubtle = Color(0x141C1B1A);

  static const Color primaryStart = Color(0xFF1A2C4A);
  static const Color primaryEnd = Color(0xFF2997FF);
  static const Color primarySolid = Color(0xFF3D4E73);
  static const Color primarySoft = Color(0xFFE1E6F9);

  static const Color secondaryStart = Color(0xFF3D4E73);
  static const Color secondaryEnd = Color(0xFFAECBFA);
  static const Color secondarySolid = Color(0xFFAECBFA);
  static const Color secondarySoft = Color(0xFFE1E6F9);

  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFD98A00);
  static const Color error = Color(0xFFD64545);

  static const Color buttonDisabled = Color(0xFFE3DEDA);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [primaryStart, primaryEnd],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [secondaryStart, secondaryEnd],
  );
}
