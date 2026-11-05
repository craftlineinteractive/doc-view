import 'package:flutter/material.dart';

/// App theme configurations for Material 3 light and dark themes.
class AppTheme {
  const AppTheme._();

  static const Color primaryBlue = Color(0xFF1A73E8);
  static const Color darkScaffoldBackground = Color(0xFF12161F);
  static const Color darkSurface = Color(0xFF1B2030);

  static const Color lightScaffoldBackground = Color(0xFFF8F9FA);
  static const Color lightSurface = Colors.white;

  /// Light theme definition (Material 3)
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
      primary: primaryBlue,
      surface: lightSurface,
      onSurface: const Color(0xFF0F172A), // Slate 900: > 15:1 contrast on white
      onSurfaceVariant: const Color(0xFF334155), // Slate 700: > 7:1 contrast on white
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF0F172A)),
        bodyMedium: TextStyle(color: Color(0xFF1E293B)),
        bodySmall: TextStyle(color: Color(0xFF334155)),
        titleLarge: TextStyle(color: Color(0xFF0F172A)),
        titleMedium: TextStyle(color: Color(0xFF0F172A)),
        titleSmall: TextStyle(color: Color(0xFF1E293B)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: primaryBlue.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlue);
          }
          return const IconThemeData(color: Color(0xFF475569));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: Color(0xFF475569),
            fontWeight: FontWeight.normal,
            fontSize: 12,
          );
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF475569),
      ),
    );
  }

  /// Dark theme definition (Material 3)
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.dark,
      primary: primaryBlue,
      surface: darkSurface,
      onSurface: const Color(0xFFF8FAFC), // Slate 50: > 15:1 contrast on dark surface
      onSurfaceVariant: const Color(0xFFCBD5E1), // Slate 300: > 9:1 contrast
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkScaffoldBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFF8FAFC)),
        bodyMedium: TextStyle(color: Color(0xFFF1F5F9)),
        bodySmall: TextStyle(color: Color(0xFFCBD5E1)),
        titleLarge: TextStyle(color: Color(0xFFF8FAFC)),
        titleMedium: TextStyle(color: Color(0xFFF8FAFC)),
        titleSmall: TextStyle(color: Color(0xFFF1F5F9)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: primaryBlue.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryBlue);
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.normal,
            fontSize: 12,
          );
        }),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Color(0xFF94A3B8),
      ),
    );
  }
}

