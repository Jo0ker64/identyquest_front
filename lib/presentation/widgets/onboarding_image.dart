import 'package:flutter/material.dart';
import 'package:identyquest_v2/config/theme.dart'; // 👈 Pour accéder à AppColors

class OnboardingImage extends StatelessWidget {
  final String assetName; // 🖼️ Nom de l'image
  final double size;      // 📐 Taille du conteneur (par défaut 400)

  const OnboardingImage(
    this.assetName, {
    super.key,
    this.size = 400,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        color: AppColors.softBlue, // 🎨 Ici on remplace le fond gris par le beau bleu doux
        borderRadius: BorderRadius.circular(24), // 🟦 Coins arrondis
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.asset(
          'assets/images/$assetName', // 📁 Chemin dynamique vers l'image
          fit: BoxFit.cover, // 🔲 Couvre tout l'espace
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Text(
              "Image manquante",
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                fontFamily: 'Cursive',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
