import 'package:flutter/material.dart';

/// Design tokens extracted from the Stitch AI Tailwind configuration.
/// Material 3 dark color scheme for the Daily App.
abstract final class AppColors {
  // ── Primary ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFFADC6FF);
  static const Color onPrimary = Color(0xFF002E6A);
  static const Color primaryContainer = Color(0xFF4D8EFF);
  static const Color onPrimaryContainer = Color(0xFF00285D);
  static const Color primaryFixed = Color(0xFFD8E2FF);
  static const Color primaryFixedDim = Color(0xFFADC6FF);
  static const Color onPrimaryFixed = Color(0xFF001A42);
  static const Color onPrimaryFixedVariant = Color(0xFF004395);
  static const Color inversePrimary = Color(0xFF005AC2);

  // ── Secondary ────────────────────────────────────────────────────────
  static const Color secondary = Color(0xFFA4C9FF);
  static const Color onSecondary = Color(0xFF00315D);
  static const Color secondaryContainer = Color(0xFF0267B8);
  static const Color onSecondaryContainer = Color(0xFFD6E5FF);
  static const Color secondaryFixed = Color(0xFFD4E3FF);
  static const Color secondaryFixedDim = Color(0xFFA4C9FF);
  static const Color onSecondaryFixed = Color(0xFF001C39);
  static const Color onSecondaryFixedVariant = Color(0xFF004883);

  // ── Tertiary ─────────────────────────────────────────────────────────
  static const Color tertiary = Color(0xFFFFB786);
  static const Color onTertiary = Color(0xFF502400);
  static const Color tertiaryContainer = Color(0xFFDF7412);
  static const Color onTertiaryContainer = Color(0xFF461F00);
  static const Color tertiaryFixed = Color(0xFFFFDCC6);
  static const Color tertiaryFixedDim = Color(0xFFFFB786);
  static const Color onTertiaryFixed = Color(0xFF311400);
  static const Color onTertiaryFixedVariant = Color(0xFF723600);

  // ── Error ────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  // ── Surface / Background ─────────────────────────────────────────────
  static const Color surface = Color(0xFF10131A);
  static const Color onSurface = Color(0xFFE1E2EB);
  static const Color surfaceDim = Color(0xFF10131A);
  static const Color surfaceBright = Color(0xFF363940);
  static const Color surfaceContainerLowest = Color(0xFF0B0E14);
  static const Color surfaceContainerLow = Color(0xFF191C22);
  static const Color surfaceContainer = Color(0xFF1D2026);
  static const Color surfaceContainerHigh = Color(0xFF272A31);
  static const Color surfaceContainerHighest = Color(0xFF32353C);
  static const Color surfaceVariant = Color(0xFF32353C);
  static const Color onSurfaceVariant = Color(0xFFC2C6D6);
  static const Color surfaceTint = Color(0xFFADC6FF);
  static const Color background = Color(0xFF10131A);
  static const Color onBackground = Color(0xFFE1E2EB);
  static const Color inverseSurface = Color(0xFFE1E2EB);
  static const Color inverseOnSurface = Color(0xFF2E3037);

  // ── Outline ──────────────────────────────────────────────────────────
  static const Color outline = Color(0xFF8C909F);
  static const Color outlineVariant = Color(0xFF424754);

  // ── Glassmorphism helpers ────────────────────────────────────────────
  static const Color glassBackground = Color(0x0AFFFFFF); // white 4%
  static const Color glassBorder = Color(0x1FFFFFFF); // white 12%
  static const Color glassShadow = Color(0x80000000); // black 50%
  static const Color glassActiveBackground = Color(0x1AADC6FF); // primary 10%
  static const Color glassActiveBorder = Color(0x80ADC6FF); // primary 50%
}
