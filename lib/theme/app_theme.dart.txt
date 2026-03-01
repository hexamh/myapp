import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2B8CEE);
  static const Color primaryDarkColor = Color(0xFF1A6BBD);
  
  static const Color lightBackground = Color(0xFFF6F7F8);
  static const Color darkBackground = Color(0xFF101922);
  
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkSurface = Color(0xFF192633);
  
  static const Color textLight = Color(0xFF101922); // Dark text for light mode
  static const Color textDark = Color(0xFFF1F5F9); // Light text for dark mode
  
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF1E293B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        surface: lightSurface,
        onSurface: textLight,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.spaceGrotesk(color: textLight, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.spaceGrotesk(color: textLight),
        bodyMedium: GoogleFonts.spaceGrotesk(color: textLight),
        bodySmall: GoogleFonts.spaceGrotesk(color: textSecondaryLight),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackground,
        foregroundColor: textLight,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderLight),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: darkSurface,
        onSurface: textDark,
      ),
      textTheme: GoogleFonts.spaceGroteskTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        displaySmall: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        headlineSmall: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.w600),
        titleMedium: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.w500),
        titleSmall: GoogleFonts.spaceGrotesk(color: textDark, fontWeight: FontWeight.w500),
        bodyLarge: GoogleFonts.spaceGrotesk(color: textDark),
        bodyMedium: GoogleFonts.spaceGrotesk(color: textDark),
        bodySmall: GoogleFonts.spaceGrotesk(color: textSecondaryDark),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderDark),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
