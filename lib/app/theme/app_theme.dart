import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Professional admin theme — a refined indigo/violet system distinct from the
/// consumer pink brand, suited to dashboards and data tables.
class AppTheme {
  static const Color primary = Color(0xFF5B2BE0); // indigo-violet
  static const Color primaryDark = Color(0xFF3F1BA8);
  static const Color primaryLight = Color(0xFFEDE7FF);
  static const Color accent = Color(0xFF00C2A8); // teal

  static const Color background = Color(0xFFF5F6FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2333);
  static const Color textSecondary = Color(0xFF7A8194);
  static const Color divider = Color(0xFFECEEF3);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static TextTheme get _textTheme => TextTheme(
        displayLarge: GoogleFonts.poppins(
            fontSize: 26, fontWeight: FontWeight.bold, color: textPrimary),
        titleLarge: GoogleFonts.poppins(
            fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
        titleMedium: GoogleFonts.poppins(
            fontSize: 15, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: GoogleFonts.poppins(fontSize: 14, color: textPrimary),
        bodyMedium: GoogleFonts.poppins(fontSize: 13, color: textSecondary),
        labelLarge: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        primaryColor: primary,
        scaffoldBackgroundColor: background,
        colorScheme: const ColorScheme.light(
          primary: primary,
          secondary: accent,
          error: error,
          surface: surface,
          background: background,
        ),
        textTheme: _textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: surface,
          elevation: 0,
          iconTheme: IconThemeData(color: textPrimary),
          titleTextStyle: TextStyle(
              color: textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: surface,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: divider)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: divider)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primary, width: 1.5)),
          labelStyle: const TextStyle(color: textSecondary),
        ),
        cardTheme: CardThemeData(
            color: surface,
            elevation: 2,
            shadowColor: Colors.black.withOpacity(0.05),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16))),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: textPrimary,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
}
