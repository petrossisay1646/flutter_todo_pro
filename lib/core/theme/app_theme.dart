import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.interTextTheme();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primary,
        surface: AppColors.lightCard,
        onSurface: AppColors.textMainLight,
        error: AppColors.danger,
        onError: Colors.white,
        outline: AppColors.borderLight,
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textMainLight,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textMainLight,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.textMainLight,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textMutedLight,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.textMutedLight,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF9FBFD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMutedLight, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMutedLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: Colors.white,
        surface: AppColors.darkCard,
        onSurface: AppColors.textMainDark,
        error: AppColors.danger,
        onError: Colors.white,
        outline: AppColors.borderDark,
      ),
      textTheme: baseTextTheme.copyWith(
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textMainDark,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textMainDark,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.textMainDark,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textMutedDark,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.textMutedDark,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0D1423),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkCard,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMutedDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
