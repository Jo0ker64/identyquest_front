import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Crédits"),
        leading: const BackButtonWidget(goToRoute: '/infos', color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          """
Crédits et remerciements

L'application IdentyQuest a été développée avec le framework Flutter.

1. Technologies utilisées
- Flutter (framework UI)
- Dart (langage de programmation)
- Provider (gestion d’état)
- Hive (base de données locale)
- go_router (navigation)
- table_calendar (calendrier interactif)
- image_picker (sélection d’images)
- geolocator (géolocalisation pour la météo)

2. Ressources externes
- Icônes : Material Icons, Font Awesome, Ionicons
- API Météo : Open-Meteo (https://open-meteo.com)
- Bibliothèques open source utilisées dans l’application

3. Design et inspirations
- Palette de couleurs personnalisée
- Inspiration UX/UI : applications de productivité et de suivi personnel

4. Équipe
- Développement : Jonathan Auroux Martel  
- Direction artistique : Jess — un big up pour sa patience, sa créativité et ses idées 💖  
- Société : Joe Ker

5. Mur des remerciements
Un immense merci à toutes les personnes qui ont soutenu et inspiré IdentyQuest :  
- Les testeurs et amis pour leurs retours honnêtes  
- La famille pour la motivation et le soutien moral  
- Les membres de la communauté open source  
- Et toutes celles et ceux qui croient en ce projet ❤️

Un grand merci aux contributeurs open source et aux ressources libres qui ont permis la réalisation de ce projet.
""",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
