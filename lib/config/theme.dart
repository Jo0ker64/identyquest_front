import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color softBlue = Color(0xFFA2C7E5);       // fond principal relaxant
  static const Color mintGreen = Color(0xFFB9E4C9);      // accents positifs
  static const Color pastelLilac = Color(0xFFCBB9E5);    // émotions onboarding
  static const Color softPink = Color(0xFFF5CED8);       // erreurs douces
  static const Color lightGreyBlue = Color(0xFFEEF2F5);  // arrière-plan
  static const Color softAnthracite = Color(0xFF2E2E2E); // texte sombre
  static const Color cream = Color(0xFFFAF9F6);          // texte clair
}

/// Thème clair avec police personnalisée
ThemeData buildLightTheme(String fontFamily) {
    return ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.softBlue,
        textTheme: _getFont(fontFamily).apply(
        bodyColor: AppColors.softAnthracite,
        displayColor: AppColors.softAnthracite,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: AppColors.softAnthracite,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            ),
        ),
        ),
    );
    }

    /// Thème sombre avec police personnalisée
    ThemeData buildDarkTheme(String fontFamily) {
    return ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.softAnthracite,
        textTheme: _getFont(fontFamily).apply(
        bodyColor: AppColors.cream,
        displayColor: AppColors.cream,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cream,
            foregroundColor: AppColors.softAnthracite,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            ),
        ),
        ),
    );
    }

    /// Fonction pour retourner la bonne police selon le nom sélectionné
    TextTheme _getFont(String font) {
    switch (font) {
        case 'Lexend':
        return GoogleFonts.lexendTextTheme();
        case 'Atkinson Hyperlegible':
        return GoogleFonts.atkinsonHyperlegibleTextTheme();
        case 'OpenDyslexic':
        return const TextTheme(
            bodyMedium: TextStyle(fontFamily: 'OpenDyslexic'),
            titleLarge: TextStyle(fontFamily: 'OpenDyslexic', fontSize: 24),
            labelLarge: TextStyle(fontFamily: 'OpenDyslexic', fontWeight: FontWeight.bold),
        );
        default:
        return GoogleFonts.lexendTextTheme(); // fallback
    }
}
