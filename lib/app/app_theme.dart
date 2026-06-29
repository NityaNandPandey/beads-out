import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/design/premium_design.dart';

class AppTheme {
  AppTheme._();

  // Re-export premium tokens for backward compatibility
  static const Color primaryColor = PremiumDesign.royalPurple;
  static const Color primaryDark = PremiumDesign.violetDeep;
  static const Color secondaryColor = PremiumDesign.mintGreen;
  static const Color accentColor = PremiumDesign.coralPink;
  static const Color goldColor = PremiumDesign.goldenYellow;
  static const Color skyColor = PremiumDesign.oceanBlue;
  static const Color pinkColor = PremiumDesign.coralPink;
  static const Color orangeColor = PremiumDesign.sunsetOrange;

  static const Color backgroundTop = Color(0xFF667EEA);
  static const Color backgroundBottom = Color(0xFFF093FB);
  static const Color boardColor = Color(0xFFFFFDF9);
  static const Color boardInner = Color(0xFFF3E8FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = PremiumDesign.textDark;
  static const Color textSecondary = PremiumDesign.textMuted;

  static const Color conveyorColor = Color(0xFFD4A574);
  static const Color conveyorDark = Color(0xFF8B6914);
  static const Color conveyorLight = Color(0xFFF5DEB3);
  static const Color conveyorRail = Color(0xFF6D4C41);

  static const Color playButtonColor = PremiumDesign.mintGreen;
  static const Color playButtonDark = PremiumDesign.emerald;
  static const Color playButtonLight = Color(0xFF6EE7B7);

  static const Color dangerColor = Color(0xFFE74C3C);
  static const Color warningColor = PremiumDesign.sunsetOrange;

  static const List<Color> rainbow = [
    PremiumDesign.cyanGlow,
    PremiumDesign.royalPurple,
    PremiumDesign.sunsetOrange,
    PremiumDesign.goldenYellow,
    PremiumDesign.mintGreen,
  ];

  static LinearGradient get backgroundGradient => PremiumDesign.animatedSky;
  static LinearGradient get hudGradient => const LinearGradient(
        colors: [PremiumDesign.royalPurple, PremiumDesign.violetDeep, PremiumDesign.oceanBlue],
      );
  static LinearGradient get titleGradient => PremiumDesign.rainbowBorder;
  static LinearGradient get playButtonGradient => const LinearGradient(colors: PremiumDesign.playGradient);
  static LinearGradient get panelBorderGradient => PremiumDesign.rainbowBorder;

  static List<BoxShadow> glowShadow(Color color) => PremiumDesign.glow(color);
  static List<BoxShadow> get softShadow => PremiumDesign.glow(primaryColor);
  static List<BoxShadow> get cardShadow => PremiumDesign.cardDepth;

  static ThemeData get lightTheme {
    final base = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundTop,
      textTheme: base,
      fontFamily: GoogleFonts.poppins().fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        onSurface: textPrimary,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        titleTextStyle: PremiumDesign.heading(size: 20, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: playButtonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          textStyle: PremiumDesign.button(),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
