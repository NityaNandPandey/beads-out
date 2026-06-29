import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Vibrant candy palette
  static const Color primaryColor = Color(0xFF8E44AD);
  static const Color primaryDark = Color(0xFF6C3483);
  static const Color secondaryColor = Color(0xFF1ABC9C);
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color goldColor = Color(0xFFFFC312);
  static const Color skyColor = Color(0xFF54A0FF);
  static const Color pinkColor = Color(0xFFFF9FF3);
  static const Color orangeColor = Color(0xFFFF9F43);

  static const Color backgroundTop = Color(0xFFDDD6FE);
  static const Color backgroundMid = Color(0xFFBAE6FD);
  static const Color backgroundBottom = Color(0xFFA7F3D0);
  static const Color boardColor = Color(0xFFFFFDF9);
  static const Color boardInner = Color(0xFFF3E8FF);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF2D1B4E);
  static const Color textSecondary = Color(0xFF6B5B8C);

  static const Color conveyorColor = Color(0xFFD4A574);
  static const Color conveyorDark = Color(0xFF8B6914);
  static const Color conveyorLight = Color(0xFFF5DEB3);
  static const Color conveyorRail = Color(0xFF6D4C41);

  static const Color playButtonColor = Color(0xFF2ECC71);
  static const Color playButtonDark = Color(0xFF27AE60);
  static const Color playButtonLight = Color(0xFF58D68D);

  static const Color dangerColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFF39C12);

  static const List<Color> rainbow = [
    accentColor,
    orangeColor,
    goldColor,
    playButtonColor,
    secondaryColor,
    skyColor,
    primaryColor,
    pinkColor,
  ];

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          backgroundTop,
          backgroundMid,
          Color(0xFFFDE68A),
          backgroundBottom,
        ],
        stops: [0.0, 0.35, 0.65, 1.0],
      );

  static LinearGradient get hudGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, Color(0xFF9B59B6), secondaryColor],
      );

  static LinearGradient get titleGradient => const LinearGradient(
        colors: [primaryColor, accentColor, orangeColor, goldColor],
      );

  static LinearGradient get playButtonGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [playButtonLight, playButtonColor, playButtonDark],
      );

  static LinearGradient get panelBorderGradient => LinearGradient(
        colors: [
          accentColor.withValues(alpha: 0.7),
          goldColor.withValues(alpha: 0.7),
          secondaryColor.withValues(alpha: 0.7),
          skyColor.withValues(alpha: 0.7),
          primaryColor.withValues(alpha: 0.7),
        ],
      );

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.35),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: color.withValues(alpha: 0.15),
          blurRadius: 40,
          spreadRadius: 2,
        ),
      ];

  static List<BoxShadow> get softShadow => glowShadow(primaryColor);

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.12),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundTop,
      fontFamily: 'Roboto',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        surface: surfaceColor,
        onSurface: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: playButtonColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
