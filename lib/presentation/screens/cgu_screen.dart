import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class CguScreen extends StatelessWidget {
  const CguScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Conditions Générales d’Utilisation"),
        leading: const BackButtonWidget(goToRoute: '/infos', color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          """
Conditions Générales d’Utilisation (CGU)

1. Objet
Les présentes CGU définissent les règles d’utilisation de l’application IdentyQuest.

2. Acceptation
En utilisant l’application, vous acceptez pleinement et entièrement les présentes conditions.

3. Utilisation de l’application
IdentyQuest est fournie à titre informatif et de support personnel. L’éditeur ne saurait être tenu responsable des décisions prises sur la base des informations fournies par l’application.

4. Responsabilités
L’éditeur met tout en œuvre pour assurer un service fiable, mais ne garantit pas l’absence d’erreurs ou d’interruptions.

5. Propriété intellectuelle
Tous les éléments de l’application (textes, visuels, code) sont protégés par le droit de la propriété intellectuelle.

6. Données personnelles
Aucune donnée n’est transmise à des tiers. Les données sont stockées uniquement en local sur l’appareil de l’utilisateur.

7. Modification des CGU
L’éditeur se réserve le droit de modifier les présentes conditions à tout moment. Les utilisateurs seront informés via l’application.

8. Contact
Pour toute question concernant les CGU, contactez : contact@tonsite.fr
""",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
