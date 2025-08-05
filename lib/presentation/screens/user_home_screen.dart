import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';


import '../../config/theme.dart'; // ton fichier avec AppColors
import '../../../core/data/quotes/quote_data.dart'; // ton fichier quotes.dart

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 📅 Récupère le jour de l'année (1 à 366)
    final now = DateTime.now();
    final dayOfYear = int.parse(DateFormat("D").format(now)) - 1;
    final quoteOfTheDay = quotes[dayOfYear.clamp(0, quotes.length - 1)];

    return Scaffold(
      backgroundColor: AppColors.softBlue,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              'Mon tableau de bord',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '"${quoteOfTheDay['text']}"\n— ${quoteOfTheDay['author']}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: const EdgeInsets.all(16),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.9,
                children: const [
                  _DashboardTile(
                    icon: Icons.manage_accounts,
                    label: "Profil",
                    route: '/profile',
                  ),
                  _DashboardTile(
                    icon: Icons.calendar_month,
                    label: "Agenda",
                    route: '/agenda',
                  ),
                  _DashboardTile(
                    icon: Icons.alarm,
                    label: "Rappel",
                    route: '/reminder',
                  ),
                  _DashboardTile(
                    icon: Icons.medical_information,
                    label: "Traitement",
                    route: '/traitement',
                  ),

                  
                  _DashboardTile(
                    icon: Icons.mood,
                    label: "Mood",
                    route: '/mood',
                  ),
                  _DashboardTile(
                    icon: Icons.water_drop,
                    label: "Hydratation",
                    route: '/hydration',
                  ),
                  _DashboardTile(
                    icon: Icons.wb_sunny_rounded,
                    label: "Météo",
                    route: '/weather',
                  ),
                  _DashboardTile(
                  icon: Icons.timer_outlined,
                  label: "Pomodoro",
                  route: '/pomodoro',
                  ),

                  _DashboardTile(
                    icon: Icons.lightbulb,
                    label: "Brain dump",
                    route: '/brain-dump',
                  ),
                  _DashboardTile(
                    icon: Icons.menu_book,
                    label: "Mes pensées",
                    route: '/mes-pensees',
                  ),
                  _DashboardTile(
                    icon: Icons.playlist_add_check,
                    label: "Liste mentale",
                    route: '/mental-load',
                  ),
                  _DashboardTile(
                    icon: Icons.celebration,
                    label: "Succès",
                  ),
                  
                  _DashboardTile(
                    icon: Icons.psychology_alt,
                    label: "Tests",
                  ),

                  
                  _DashboardTile(
                    icon: Icons.contacts,
                    label: "Annuaire",
                  ),
                  _DashboardTile(
                    icon: Icons.build,
                    label: "Outils",
                  ),

                  _DashboardTile(
                    icon: Icons.contact_emergency,
                    label: "Personne à prévenir",
                    route: '/contact',
                  ),

                  _DashboardTile(
                    icon: Icons.settings_applications,
                    label: "Paramètres",
                  ),
                  _DashboardTile(
                    icon: Icons.info,
                    label: "Infos",
                    route: '/infos',
                  ),
                  
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? route;

  const _DashboardTile({
    required this.icon,
    required this.label,
    this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.softBlue,
      elevation: 2,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (route != null) {
            context.go(route!);
          }
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: Colors.blue.withOpacity(0.2),
        highlightColor: Colors.blueGrey.withOpacity(0.1),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: Colors.black87),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
