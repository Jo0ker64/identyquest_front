import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text; // 🧾 Texte du bouton
  final VoidCallback? onPressed; // 🚀 Fonction déclenchée au clic
  final bool isEnabled; // ✅ Active/désactive le bouton
  final IconData? icon; // 🧠 Optionnel : icône devant le texte
  final Color? color; // 🎨 Permet de passer une autre couleur au besoin

  const RoundedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // 📏 Taille dynamique pour adapter texte et padding
    final double fontSize = screenWidth * 0.045; // ~18 sur tel 400px
    final double iconSize = screenWidth * 0.06;  // ~24 sur tel 400px
    final double horizontalPadding = screenWidth * 0.04; // ~24
    final double verticalPadding = screenWidth * 0.035;  // ~14

    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? const Color(0xFFB9E4C9), // mintGreen par défaut
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFF2E2E2E), size: iconSize),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Lexend',
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              color: const Color(0xFF2E2E2E),
            ),
          ),
        ],
      ),
    );
  }
}
