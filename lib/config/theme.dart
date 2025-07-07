import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static TextTheme? _getGoogleFontsTextTheme(Brightness brightness) {
    try {
      return GoogleFonts.manropeTextTheme(
        brightness == Brightness.dark 
          ? ThemeData.dark().textTheme 
          : ThemeData.light().textTheme,
      );
    } catch (e) {
      return null;
    }
  }

  // === Enhanced Color Palette ===
  static const _lightPrimary = Color(0xFF3B82F6);  // Muted Blue
  static const _lightBackground = Color(0xFFF9FAFB); // Soft White
  static const _lightSurface = Color(0xFFF1F5F9);    // Light Gray
  static const _lightText = Color(0xFF111827);       // Charcoal
  static const _lightMutedText = Color(0xFF6B7280);  // Mid Gray
  
  // Status Colors (Light)
  static const _lightSuccess = Color(0xFF10B981);    // Emerald
  static const _lightWarning = Color(0xFFF59E0B);    // Amber
  static const _lightError = Color(0xFFEF4444);      // Red

  static const _darkPrimary = Color(0xFF60A5FA);     // Lighter Blue for dark mode
  static const _darkBackground = Color(0xFF0F172A);  // Deep Gray
  static const _darkSurface = Color(0xFF1E293B);     // Dark Gray
  static const _darkText = Color(0xFFF8FAFC);        // Light Gray
  static const _darkMutedText = Color(0xFFCBD5E1);   // Mid Gray
  
  // Status Colors (Dark)
  static const _darkSuccess = Color(0xFF34D399);     // Lighter Emerald
  static const _darkWarning = Color(0xFFFBBF24);     // Lighter Amber
  static const _darkError = Color(0xFFF87171);       // Lighter Red

  // Getters for easy access
  static Color getSuccessColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? _darkSuccess : _lightSuccess;
  
  static Color getWarningColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? _darkWarning : _lightWarning;
  
  static Color getErrorColor(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark ? _darkError : _lightError;

  static ThemeData lightTheme = ThemeData(
    textTheme: _getGoogleFontsTextTheme(Brightness.light),
    brightness: Brightness.light,
    primaryColor: _lightPrimary,
    scaffoldBackgroundColor: _lightBackground,
    cardColor: _lightSurface,
    iconTheme: const IconThemeData(color: _lightMutedText),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _lightText),
      titleTextStyle: TextStyle(
        color: _lightText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _lightSurface,
      selectedItemColor: _lightPrimary,
      unselectedItemColor: _lightMutedText,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(
      color: _lightSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _lightPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: _lightPrimary,
      background: _lightBackground,
      surface: _lightSurface,
      onPrimary: Colors.white,
      onSurface: _lightText,
      onBackground: _lightText,
      error: _lightError,
      tertiary: _lightSuccess,
      tertiaryContainer: _lightWarning,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    textTheme: _getGoogleFontsTextTheme(Brightness.dark),
    brightness: Brightness.dark,
    primaryColor: _darkPrimary,
    scaffoldBackgroundColor: _darkBackground,
    cardColor: _darkSurface,
    iconTheme: const IconThemeData(color: _darkMutedText),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      iconTheme: IconThemeData(color: _darkText),
      titleTextStyle: TextStyle(
        color: _darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: _darkSurface,
      selectedItemColor: _darkPrimary,
      unselectedItemColor: _darkMutedText,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardTheme(
      color: _darkSurface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _darkPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: _darkPrimary,
      background: _darkBackground,
      surface: _darkSurface,
      onPrimary: Colors.white,
      onSurface: _darkText,
      onBackground: _darkText,
      error: _darkError,
      tertiary: _darkSuccess,
      tertiaryContainer: _darkWarning,
    ),
  );
}