import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Neon Pulse Design System — Typography
class NeonTextStyles {
  NeonTextStyles._();

  /// JetBrains Mono 700 — 48px, -0.02em tracking
  static TextStyle displayScore({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.96, // -0.02em of 48px
        height: 1.0,
        color: color,
      );

  /// JetBrains Mono 600 — 32px
  static TextStyle headlineLg({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: color,
      );

  /// JetBrains Mono 600 — 24px
  static TextStyle headlineLgMobile({Color? color}) =>
      GoogleFonts.jetBrainsMono(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        color: color,
      );

  /// Inter 400 — 16px
  static TextStyle bodyMd({Color? color}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  /// JetBrains Mono 500 — 12px, 0.1em tracking, UPPERCASE
  static TextStyle labelCaps({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.2, // 0.1em of 12px
        height: 1.33,
        color: color,
      );

  /// JetBrains Mono 600 — 14px
  static TextStyle buttonText({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        color: color,
      );

  /// JetBrains Mono 500 — 10px, wide tracking
  static TextStyle labelSmall({Color? color}) => GoogleFonts.jetBrainsMono(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: color,
      );
}
