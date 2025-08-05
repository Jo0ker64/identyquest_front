import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class MentionsScreen extends StatelessWidget {
  const MentionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Mentions légales"),
        leading: const BackButtonWidget(goToRoute: '/infos', color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          """
Mentions légales

Conformément aux dispositions de la loi n°2004-575 du 21 juin 2004 pour la confiance dans l'économie numérique, il est précisé aux utilisateurs de l'application IdentyQuest l'identité des différents intervenants dans le cadre de sa réalisation et de son suivi.

1. Éditeur de l'application
Nom de la société : Joe Ker  
Directeur de la publication : Jonathan Auroux Martel  
Directrice artistique : Jess — the best pro photoshop
Adresse : [À compléter]  
E-mail : identyquest@gmail.com  
Numéro SIRET/SIREN : [À compléter]  

2. Hébergement
L’application est hébergée par :  
[Nom de l’hébergeur]  
[Adresse complète]  
[Téléphone]  

3. Propriété intellectuelle
L’ensemble des éléments de l’application (textes, images, graphismes, logo, icônes, sons, logiciels) est la propriété exclusive de Joe Ker, sauf mention contraire.  
Toute reproduction, représentation, modification, publication, adaptation de tout ou partie des éléments de l’application, quel que soit le moyen ou le procédé utilisé, est interdite, sauf autorisation écrite préalable.

4. Limitation de responsabilité
L’éditeur ne pourra être tenu responsable des dommages directs ou indirects causés au matériel de l’utilisateur lors de l’accès à l’application IdentyQuest.  
L’éditeur décline toute responsabilité quant à l’utilisation qui pourrait être faite des informations et contenus présents dans l’application.

5. Loi applicable
Les présentes mentions légales sont régies par la loi française.  
En cas de litige et à défaut d’accord amiable, les tribunaux français seront seuls compétents.
""",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
