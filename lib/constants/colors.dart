import 'package:flutter/material.dart';

/// Neon Pulse Design System — Color Palette
class NeonColors {
  NeonColors._();

  // Background / Surface
  static const Color background = Color(0xFF0F131D);
  static const Color surface = Color(0xFF0F131D);
  static const Color surfaceDim = Color(0xFF0F131D);
  static const Color surfaceBright = Color(0xFF353944);
  static const Color surfaceContainerLowest = Color(0xFF0A0E18);
  static const Color surfaceContainerLow = Color(0xFF171B26);
  static const Color surfaceContainer = Color(0xFF1C1F2A);
  static const Color surfaceContainerHigh = Color(0xFF262A35);
  static const Color surfaceContainerHighest = Color(0xFF313540);

  // On-Surface Text
  static const Color onSurface = Color(0xFFDFE2F1);
  static const Color onSurfaceVariant = Color(0xFFBBCABF);
  static const Color inverseSurface = Color(0xFFDFE2F1);
  static const Color inverseOnSurface = Color(0xFF2C303B);

  // Outline / Border
  static const Color outline = Color(0xFF86948A);
  static const Color outlineVariant = Color(0xFF3C4A42);

  // Primary — Neon Green (snake, success, growth)
  static const Color primary = Color(0xFF4EDEA3);
  static const Color onPrimary = Color(0xFF003824);
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color primaryFixed = Color(0xFF6FFBBE);
  static const Color primaryFixedDim = Color(0xFF4EDEA3);
  static const Color surfaceTint = Color(0xFF4EDEA3);

  // Secondary — Neon Pink (food, high-priority alerts)
  static const Color secondary = Color(0xFFFFB0CD);
  static const Color onSecondary = Color(0xFF640039);
  static const Color secondaryContainer = Color(0xFFAA0266);
  static const Color secondaryFixed = Color(0xFFFFD9E4);
  static const Color secondaryFixedDim = Color(0xFFFFB0CD);
  static const Color secondaryPink = Color(0xFFEC4899); // vibrant accent

  // Tertiary — Cyan (HUD, navigation, controls)
  static const Color tertiary = Color(0xFF7BD0FF);
  static const Color onTertiary = Color(0xFF00354A);
  static const Color tertiaryContainer = Color(0xFF19AEE8);
  static const Color tertiaryFixed = Color(0xFFC4E7FF);
  static const Color tertiaryFixedDim = Color(0xFF7BD0FF);
  static const Color cyanButton = Color(0xFF38BDF8); // primary button color

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);

  // Neon Glow Colors (for box shadows)
  static const Color primaryGlow = Color(0xFF4EDEA3);
  static const Color secondaryGlow = Color(0xFFEC4899);
  static const Color tertiaryGlow = Color(0xFF38BDF8);

  // Utility
  static Color glassBackground = const Color(0xFF0F131D).withValues(alpha: 0.4);
  static Color glassBorder = Colors.white.withValues(alpha: 0.1);
  static Color gridLine = Colors.white.withValues(alpha: 0.05);
}
