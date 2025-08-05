import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'onboarding_image.dart';
import '../../core/constants/app_text_styles.dart';
import 'rounded_button.dart'; // ✅ Correct car même dossier `widgets/`


class OnboardingIntroScreen extends StatelessWidget {
    final String imageAsset;
    final String message;
    final VoidCallback onNext;

    const OnboardingIntroScreen({
        super.key,
        required this.imageAsset,
        required this.message,
        required this.onNext,
    });
    
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softBlue, // 🎨 Couleur de fond
      body: SafeArea(
        child: Center( // 🧲 Centrage horizontal global
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 📐 Équilibre vertical
              crossAxisAlignment: CrossAxisAlignment.center, // 🧲 Centrage horizontal des enfants
              mainAxisSize: MainAxisSize.max,
              children: [
                OnboardingImage(imageAsset), // 🖼️ Image d'intro
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.dynamic(
                    20,
                    selectedFont: 'Lexend',
                    weight: FontWeight.w600,
                  ),
                ),
                RoundedButton( // 🧁 bouton stylé
                  text: 'Continuer',
                  onPressed: onNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
