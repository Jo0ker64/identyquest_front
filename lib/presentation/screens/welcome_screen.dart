import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme.dart';
import '../widgets/rounded_button.dart';
import '../widgets/onboarding_image.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; 
    // 🔍 On récupère la largeur de l’écran pour rendre les tailles *responsive*

    return Scaffold(
      backgroundColor: AppColors.softBlue, // 🎨 Fond bleu doux personnalisé
      body: SafeArea(
        child: SingleChildScrollView( // 🔃 Permet de scroller si le contenu dépasse
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 30.0), // 📏 Marges autour du contenu
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 🧲 Centre le contenu horizontalement
            children: [
              // 🧠 Phrase d'accroche principale
              Text(
                'Explore ton esprit,',
                textAlign: TextAlign.center,
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.06, // ✨ Taille responsive : 8% de la largeur écran (~32 sur un écran 400px)
                  fontWeight: FontWeight.bold,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 10), // 🧱 Espace vertical

              // 🃏 Logo de l'app au centre (taille gérée dans OnboardingImage)
              const OnboardingImage('logo.png'),

              const SizedBox(height: 10),

              // 🧠 Deuxième phrase d'accroche
              Text(
                'Et embrasse ton identité !',
                textAlign: TextAlign.center,
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.06, // Même taille que la 1ère accroche
                  fontWeight: FontWeight.bold,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 22),

              // 💬 Petit texte d’introduction bienveillant
              Text(
                'Tu t’apprêtes à entamer une quête intérieure.\n'
                'IdentyQuest est là pour t’accompagner,\n'
                'sans pression, à ton rythme.',
                textAlign: TextAlign.center,
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.04, // Plus petit (~18 à 20), pour une lecture fluide
                  fontWeight: FontWeight.w500,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 44), // 🧱 Gros espace avant les boutons

              // 👇 Les deux boutons côte à côte : inscription et connexion
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: RoundedButton(
                      text: 'Inscription',
                      onPressed: () {
                        context.go('/register'); 
                      },

                    ),
                  ),
                  const SizedBox(width: 16), // 🧱 Espace entre les deux boutons
                  Expanded(
                    child: RoundedButton(
                      text: 'Connexion',
                      onPressed: () {
                        context.go('/login'); // 🔁 Va vers la page de login
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
