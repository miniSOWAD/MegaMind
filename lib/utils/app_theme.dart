import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF06B6D4); // cyan
  static const Color primaryDark = Color(0xFF0891B2);
  static const Color primaryLight = Color(0xFFE0F7FF);
  static const Color accent = Color(0xFFA78BFA); // light purple
  static const Color background = Color(0xFFF5FBFF);
  static const Color cardColor = Colors.white;

  static const Color correct = Color(0xFF10B981);
  static const Color correctLight = Color(0xFFD1FAE5);
  static const Color incorrect = Color(0xFFEF4444);
  static const Color incorrectLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);

  static const Color textPrimary = Color(0xFF102A43);
  static const Color textSecondary = Color(0xFF486581);
  static const Color textMuted = Color(0xFF829AB1);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: accent,
        surface: background,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: textPrimary),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 3,
        shadowColor: const Color(0x2206B6D4),
        shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(Radius.circular(22))),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(56),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
