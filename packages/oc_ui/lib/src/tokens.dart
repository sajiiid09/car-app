import 'package:flutter/material.dart';

/// OnlyCars Design System
///
/// The mobile-first refresh uses a neutral surface system with a saturated
/// blue accent for CTAs, onboarding, and primary interactions.

class OcColors {
  OcColors._();

  // ── Brand Accent ─────────────────────────────────────
  static const Color accent = Color(0xFF145BFF);
  static const Color accentDark = Color(0xFF0E46C9);
  static const Color accentSoft = Color(0xFFE8F0FF);
  static const Color onAccent = Color(0xFFFFFFFF);

  // Legacy aliases (backward compat)
  static const Color primary = accent;
  static const Color primaryLight = accent;
  static const Color primaryDark = accentDark;
  static const Color secondary = accent;
  static const Color secondaryLight = accentSoft;
  static const Color secondaryDark = accentDark;

  // ── Backgrounds ──────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF4F6FA);

  // ── Nav Bar ──────────────────────────────────────────
  static const Color navBar = Color(0xFF11151C);
  static const Color navIcon = Color(0xFFF8FAFC);
  static const Color navActive = accent;

  // ── Text ─────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF182032);
  static const Color textSecondary = Color(0xFF687385);
  static const Color textMuted = Color(0xFF98A2B3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDark = textPrimary;
  static const Color textDarkSecondary = Color(0xFF5F6B7C);

  // ── Status ───────────────────────────────────────────
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF9A825);
  static const Color info = Color(0xFF1976D2);
  static const Color saleRed = Color(0xFFFF3B3B); // Countdown timer
  static const Color starAmber = Color(0xFFFFB800); // Rating star

  // ── Borders ──────────────────────────────────────────
  static const Color border = Color(0xFFDDE3EE);
  static const Color borderLight = Color(0xFFE8EDF4);
  static const Color divider = Color(0xFFEDF1F7);

  // ── Chip States ──────────────────────────────────────
  static const Color chipActive = Color(0xFF101827);
  static const Color chipInactive = Color(0xFFFFFFFF);
  static const Color chipBorder = border;
}

class OcSpacing {
  OcSpacing._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Page horizontal padding (matches reference)
  static const double page = 16;
  // Section vertical gap
  static const double section = 24;
  // Card gap in grids
  static const double cardGap = 10;
}

class OcRadius {
  OcRadius._();

  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double pill = 100;

  // Specific radii from reference
  static const double card = 16;
  static const double chip = 18;
  static const double searchBar = 22;
  static const double navBar = 30;
  static const double banner = 16;
}

class OcShadows {
  OcShadows._();

  static List<BoxShadow> get card => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get elevated => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get navBar => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get sheet => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 36,
      offset: const Offset(0, -8),
    ),
  ];
}

/// Sizes from reference screens
class OcSizes {
  OcSizes._();

  static const double navBarHeight = 60;
  static const double navBarBottomMargin = 16;
  static const double searchBarHeight = 44;
  static const double chipHeight = 36;
  static const double bannerHeight = 200;
  static const double iconSize = 22;
  static const double activeTabHeight = 36;
}
