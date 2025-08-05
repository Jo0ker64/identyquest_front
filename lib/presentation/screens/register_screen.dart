import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../config/theme.dart';
import '../widgets/rounded_button.dart';
import '../widgets/onboarding_image.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                'Inscription',
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.08,
                  fontWeight: FontWeight.bold,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 24),

              // Placeholder image
              Image.asset(
                'assets/images/greeting.png',
                height: screenWidth * 0.4,
                width: screenWidth * 0.4,
                ),


              const SizedBox(height: 24),

              // Pseudo + Email côte à côte
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: _inputStyle('Pseudo'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: _inputStyle('E-mail'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // MDP + confirmation MDP
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: _inputStyle('Mot de passe'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      obscureText: true,
                      decoration: _inputStyle('Répéter mot de passe'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Règle mot de passe
              Text(
                'Le mot de passe doit contenir 8 caractères minimum :\n1 majuscule, 1 minuscule, 1 chiffre et 1 caractère spécial.',
                textAlign: TextAlign.center,
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w400,
                  color: AppColors.softAnthracite,
                ),
              ),

              const SizedBox(height: 16),

              // Année de naissance ou âge
              TextField(
                keyboardType: TextInputType.number,
                decoration: _inputStyle('Année de naissance / âge'),
              ),

              const SizedBox(height: 8),

              Text(
                '(Requis) minimum 16 ans',
                style: GoogleFonts.atkinsonHyperlegible(
                  fontSize: screenWidth * 0.035,
                  color: AppColors.softAnthracite.withOpacity(0.8),
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

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[200],
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
    );
  }
}
