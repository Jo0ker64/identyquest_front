import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme.dart';
import '../widgets/rounded_button.dart';
import '../widgets/onboarding_image.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.softBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              // Titre
              Text(
                'Connexion',
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 32),

              // Placeholder image
              Container(
                height: screenWidth * 0.6,
                width: screenWidth * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/greeting.png'),
                    fit: BoxFit.cover, // ou BoxFit.contain selon l'effet souhaité
                  ),
                ),
              ),


              const SizedBox(height: 32),

              // Champ Pseudo
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Pseudo',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Champ Mot de passe
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Mot de passe',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Bouton envoyer
              RoundedButton(
                text: 'Envoyer',
                onPressed: () {
                  context.go('/user-home'); // ou context.push() si tu veux pouvoir revenir en arrière
                }
              ),
            ],
          ),
        ),
      ),
    );
  }
}
