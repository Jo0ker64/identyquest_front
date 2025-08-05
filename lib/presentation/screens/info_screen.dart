import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  Widget _infoTile(BuildContext context, IconData icon, String label, String route) {
    return InkWell(
      onTap: () => context.go(route),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: AppColors.softBlue),
              const SizedBox(height: 12),
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text("Infos"),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 2, 
          mainAxisSpacing: 12,
          children: [
            _infoTile(context, Icons.article, "Mentions légales", '/mentions'),
            _infoTile(context, Icons.privacy_tip, "RGPD", '/rgpd'),
            _infoTile(context, Icons.star, "Crédits", '/credits'),
            _infoTile(context, Icons.gavel, "CGU", '/cgu'),
          ],
        ),
      ),
    );
  }
}
