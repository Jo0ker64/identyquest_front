import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
    static TextStyle lexend(double size,
        {FontWeight weight = FontWeight.normal, Color? color}) {
        return GoogleFonts.lexend(
        fontSize: size,
        fontWeight: weight,
        color: color,
        );
    }

    static TextStyle atkinson(double size,
        {FontWeight weight = FontWeight.normal, Color? color}) {
        return GoogleFonts.atkinsonHyperlegible(
        fontSize: size,
        fontWeight: weight,
        color: color,
        );
    }

    static TextStyle openDyslexic(double size,
        {FontWeight weight = FontWeight.normal, Color? color}) {
        return TextStyle(
        fontFamily: 'OpenDyslexic',
        fontSize: size,
        fontWeight: weight,
        color: color,
        );
    }

    /// Pour usage plus tard : choix utilisateur
    static TextStyle dynamic(
        double size, {
        required String selectedFont,
        FontWeight weight = FontWeight.normal,
        Color? color,
    }) {
        switch (selectedFont) {
        case 'Lexend':
            return lexend(size, weight: weight, color: color);
        case 'Atkinson Hyperlegible':
            return atkinson(size, weight: weight, color: color);
        case 'OpenDyslexic':
            return openDyslexic(size, weight: weight, color: color);
        default:
            return lexend(size, weight: weight, color: color);
        }
    }
}
