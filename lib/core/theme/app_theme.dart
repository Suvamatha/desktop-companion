import 'package:flutter/material.dart';

/// All visual design decisions live here.
/// Why? Changing the app's look means editing ONE file, not dozens.
class AppTheme {
  // Color palette — anime-inspired dark theme
  static const Color primaryColor = Color(0xFF6C63FF);     // Purple accent
  static const Color secondaryColor = Color(0xFFFF6584);   // Pink accent
  static const Color accentColor = Color(0xFF43E97B);      // Green for success
  static const Color warningColor = Color(0xFFFFBE0B);     // Yellow for warning
  static const Color errorColor = Color(0xFFFF4757);       // Red for errors
  static const Color surfaceColor = Color(0xFF1A1A2E);     // Dark blue-black
  static const Color surfaceVariant = Color(0xFF16213E);   // Slightly lighter
  static const Color onSurface = Color(0xFFE8E8F0);        // Light text

  // Glass morphism effect colors
  static const Color glassFill = Color(0x331A1A2E);        // 20% opacity
  static const Color glassBorder = Color(0x446C63FF);      // 27% opacity purple

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: Colors.transparent,
      fontFamily: 'Segoe UI', // Windows native font
      cardTheme: CardThemeData(
        color: surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: glassBorder, width: 1),
        ),
      ),
    );
  }

  AppTheme._();
}