import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'doc_view_colors.dart';
import 'doc_view_tokens.dart';
import 'doc_view_typography.dart';

/// App theme configurations for Material 3 light and dark themes (Doc View precision system).
class AppTheme {
  const AppTheme._();

  static const Color primaryBlue = DocViewColors.primaryBlue;
  static const Color lightScaffoldBackground = DocViewColors.backgroundLight;
  static const Color lightSurface = DocViewColors.surfaceLight;
  static const Color darkScaffoldBackground = DocViewColors.backgroundDark;
  static const Color darkSurface = DocViewColors.surfaceDark;

  /// Configure Android edge-to-edge system UI styling.
  static void configureSystemUI(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  /// Light theme definition (Material 3)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      surface: DocViewColors.surfaceLight,
      onSurface: DocViewColors.textPrimaryLight,
      onSurfaceVariant: DocViewColors.textSecondaryLight,
      outline: DocViewColors.hairlineLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: DocViewTypography.fontInter,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightScaffoldBackground,
      extensions: const [DocViewTokens.light],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: DocViewColors.textPrimaryLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DocViewColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: DocViewColors.hairlineLight, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: DocViewTypography.labelLg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: DocViewColors.textPrimaryLight,
          side: const BorderSide(color: DocViewColors.hairlineLight, width: 1),
          textStyle: DocViewTypography.labelLg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryBlue,
          textStyle: DocViewTypography.labelMd,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DocViewColors.surfaceLight,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.hairlineLight, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.hairlineLight, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: primaryBlue, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.error, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DocViewColors.backgroundLight,
        modalBackgroundColor: DocViewColors.backgroundLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: DocViewColors.backgroundLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: DocViewColors.textPrimaryLight,
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: DocViewTypography.fontInter,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: const TextTheme(
        displayLarge: DocViewTypography.headlineXl,
        displayMedium: DocViewTypography.headlineLg,
        displaySmall: DocViewTypography.headlineSm,
        headlineMedium: DocViewTypography.headlineSm,
        titleLarge: DocViewTypography.headlineSm,
        titleMedium: DocViewTypography.titleMd,
        titleSmall: DocViewTypography.labelMd,
        bodyLarge: DocViewTypography.bodyLg,
        bodyMedium: DocViewTypography.bodyMd,
        bodySmall: DocViewTypography.bodySm,
        labelLarge: DocViewTypography.labelLg,
        labelMedium: DocViewTypography.labelMd,
        labelSmall: DocViewTypography.labelXs,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: DocViewColors.backgroundLight,
        indicatorColor: primaryBlue.withValues(alpha: 0.12),
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlue);
          }
          return const IconThemeData(color: DocViewColors.textSecondaryLight);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              fontFamily: DocViewTypography.fontInter,
            );
          }
          return const TextStyle(
            color: DocViewColors.textSecondaryLight,
            fontWeight: FontWeight.normal,
            fontSize: 11,
            fontFamily: DocViewTypography.fontInter,
          );
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DocViewColors.backgroundLight,
        selectedItemColor: primaryBlue,
        unselectedItemColor: DocViewColors.textSecondaryLight,
      ),
    );
  }

  /// Dark theme definition (Material 3 - Deep Navy)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      surface: DocViewColors.surfaceDark,
      onSurface: DocViewColors.textPrimaryDark,
      onSurfaceVariant: DocViewColors.textSecondaryDark,
      outline: DocViewColors.hairlineDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: DocViewTypography.fontInter,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkScaffoldBackground,
      extensions: const [DocViewTokens.dark],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: DocViewColors.textPrimaryDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      cardTheme: const CardThemeData(
        color: DocViewColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: DocViewColors.hairlineDark, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: DocViewTypography.labelLg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          foregroundColor: DocViewColors.textPrimaryDark,
          side: const BorderSide(color: DocViewColors.hairlineDark, width: 1),
          textStyle: DocViewTypography.labelLg,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: DocViewColors.activeBlueDark,
          textStyle: DocViewTypography.labelMd,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: DocViewColors.surfaceDark,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.hairlineDark, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.hairlineDark, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.activeBlueDark, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide(color: DocViewColors.error, width: 1),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: DocViewColors.surfaceDark,
        modalBackgroundColor: DocViewColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: DocViewColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: DocViewColors.surfaceDark,
        contentTextStyle: TextStyle(
          color: DocViewColors.textPrimaryDark,
          fontFamily: DocViewTypography.fontInter,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      textTheme: const TextTheme(
        displayLarge: DocViewTypography.headlineXl,
        displayMedium: DocViewTypography.headlineLg,
        displaySmall: DocViewTypography.headlineSm,
        headlineMedium: DocViewTypography.headlineSm,
        titleLarge: DocViewTypography.headlineSm,
        titleMedium: DocViewTypography.titleMd,
        titleSmall: DocViewTypography.labelMd,
        bodyLarge: DocViewTypography.bodyLg,
        bodyMedium: DocViewTypography.bodyMd,
        bodySmall: DocViewTypography.bodySm,
        labelLarge: DocViewTypography.labelLg,
        labelMedium: DocViewTypography.labelMd,
        labelSmall: DocViewTypography.labelXs,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: DocViewColors.backgroundDark,
        indicatorColor: primaryBlue.withValues(alpha: 0.2),
        height: 64,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: DocViewColors.activeBlueDark);
          }
          return const IconThemeData(color: DocViewColors.textSecondaryDark);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: DocViewColors.activeBlueDark,
              fontWeight: FontWeight.w600,
              fontSize: 11,
              fontFamily: DocViewTypography.fontInter,
            );
          }
          return const TextStyle(
            color: DocViewColors.textSecondaryDark,
            fontWeight: FontWeight.normal,
            fontSize: 11,
            fontFamily: DocViewTypography.fontInter,
          );
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: DocViewColors.backgroundDark,
        selectedItemColor: DocViewColors.activeBlueDark,
        unselectedItemColor: DocViewColors.textSecondaryDark,
      ),
    );
  }
}
