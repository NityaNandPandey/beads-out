import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium casual-game design tokens — original art direction inspired by
/// top puzzle games, not copied assets.
class PremiumDesign {
  PremiumDesign._();

  // Core palette
  static const Color oceanBlue = Color(0xFF4FACFE);
  static const Color cyanGlow = Color(0xFF00F2FE);
  static const Color royalPurple = Color(0xFF7B2FF7);
  static const Color violetDeep = Color(0xFF5B21B6);
  static const Color sunsetOrange = Color(0xFFFF8C42);
  static const Color goldenYellow = Color(0xFFFFD93D);
  static const Color coralPink = Color(0xFFFF6B9D);
  static const Color mintGreen = Color(0xFF43E97B);
  static const Color emerald = Color(0xFF059669);
  static const Color glassWhite = Color(0xE6FFFFFF);
  static const Color glassBorder = Color(0x99FFFFFF);
  static const Color textDark = Color(0xFF1E1B4B);
  static const Color textMuted = Color(0xFF6366A1);

  static const List<Color> skyGradient = [
    Color(0xFF667EEA),
    Color(0xFF764BA2),
    Color(0xFFF093FB),
  ];

  static const List<Color> playGradient = [
    Color(0xFF43E97B),
    Color(0xFF38F9D7),
    Color(0xFF059669),
  ];

  static const List<Color> goldGradient = [
    Color(0xFFFFD93D),
    Color(0xFFFF8C42),
  ];

  static const List<Color> gemGradient = [
    Color(0xFF00F2FE),
    Color(0xFF4FACFE),
    Color(0xFF7B2FF7),
  ];

  static LinearGradient get animatedSky => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4FACFE),
          Color(0xFF667EEA),
          Color(0xFF764BA2),
          Color(0xFFF093FB),
        ],
        stops: [0.0, 0.35, 0.7, 1.0],
      );

  static LinearGradient get glassGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.55),
          Colors.white.withValues(alpha: 0.18),
        ],
      );

  static LinearGradient get rainbowBorder => const LinearGradient(
        colors: [cyanGlow, royalPurple, sunsetOrange, goldenYellow, mintGreen],
      );

  static List<BoxShadow> glow(Color color, {double blur = 24}) => [
        BoxShadow(
          color: color.withValues(alpha: 0.45),
          blurRadius: blur,
          spreadRadius: -2,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.2),
          blurRadius: blur * 1.5,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> cardDepth = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.12),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: royalPurple.withValues(alpha: 0.08),
      blurRadius: 30,
      offset: const Offset(0, 16),
    ),
  ];

  static TextStyle display({double size = 32, Color color = textDark}) =>
      GoogleFonts.baloo2(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: color,
        height: 1.1,
      );

  static TextStyle heading({double size = 22, Color color = textDark}) =>
      GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.3,
      );

  static TextStyle body({double size = 14, Color color = textMuted}) =>
      GoogleFonts.nunito(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle button({double size = 16}) => GoogleFonts.poppins(
        fontSize: size,
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: 0.5,
      );

  static TextStyle currency({Color color = textDark}) => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w800,
        color: color,
      );
}
