import 'package:flutter/material.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class RgpdScreen extends StatelessWidget {
  const RgpdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Politique de Confidentialité (RGPD)"),
        leading: const BackButtonWidget(goToRoute: '/infos', color: Colors.white),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(
          """
Politique de confidentialité et protection des données personnelles (RGPD)

1. Identité du responsable du traitement
L’application IdentyQuest est éditée et gérée par [Ton nom / ta société], responsable du traitement des données collectées via l’application.

2. Nature des données collectées
IdentyQuest ne collecte **aucune donnée personnelle** sur des serveurs externes.
Toutes les données saisies par l’utilisateur (notes, rappels, résultats de tests, etc.) sont **stockées uniquement sur l’appareil**.

3. Finalité des données
Les données enregistrées servent exclusivement à permettre le fonctionnement des fonctionnalités de l’application : suivi personnel, rappels, notes, tests, etc.
Aucune donnée n’est utilisée à des fins publicitaires, de profilage ou de revente.

4. Base légale
Le traitement des données repose sur le **consentement explicite** de l’utilisateur, donné lors de l’utilisation de l’application.

5. Conservation des données
Les données sont conservées **uniquement sur l’appareil** de l’utilisateur, pour la durée de son utilisation de l’application.  
L’utilisateur peut à tout moment supprimer ses données via la fonction « Supprimer mes données » dans l’application.

6. Partage des données
Aucune donnée n’est transmise à des tiers, ni transférée en dehors de l’Union européenne.

7. Droits des utilisateurs
Conformément au Règlement Général sur la Protection des Données (RGPD) et à la loi Informatique et Libertés, vous disposez des droits suivants :
- Droit d’accès à vos données
- Droit de rectification
- Droit à l’effacement
- Droit à la portabilité de vos données
- Droit de retirer votre consentement à tout moment

Pour exercer vos droits, vous pouvez contacter :  
[Adresse email de contact]

8. Sécurité des données
IdentyQuest met tout en œuvre pour assurer la sécurité des données stockées sur l’appareil (chiffrement, stockage local sécurisé).

9. Modifications de la politique de confidentialité
L’éditeur se réserve le droit de modifier la présente politique à tout moment.  
La version la plus récente sera toujours disponible dans l’application.
""",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
