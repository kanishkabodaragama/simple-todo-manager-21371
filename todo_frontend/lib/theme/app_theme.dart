import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color secondary = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF111827);
  static const Color outline = Color(0xFFE5E7EB);
}

class AppTheme {
  /// PUBLIC_INTERFACE
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        error: AppColors.error,
        surface: AppColors.surface,
        background: AppColors.background,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColors.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: AppColors.surface,
        foregroundColor: AppColors.text,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.text,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        surfaceTintColor: AppColors.surface,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.outline),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: StadiumBorder(),
      ),
      chipTheme: base.chipTheme.copyWith(
        color: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.blue.shade50;
          }
          return Colors.grey.shade100;
        }),
        side: const BorderSide(color: AppColors.outline),
        selectedColor: Colors.blue.shade50,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        iconColor: AppColors.primary,
        textColor: AppColors.text,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
