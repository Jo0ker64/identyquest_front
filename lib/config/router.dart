import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/welcome_screen.dart';
import '../presentation/screens/login_screen.dart';
import '../presentation/screens/register_screen.dart';
import '../presentation/screens/user_home_screen.dart';
import '../presentation/screens/profil_screen.dart';
import '../presentation/screens/tools_screen.dart';
import '../presentation/screens/agenda_screen.dart';
import '../presentation/screens/reminder_screen.dart';
import '../presentation/screens/traitement_screen.dart';
import '../presentation/screens/pomodoro_screen.dart';
import '../presentation/screens/contact_screen.dart';
import '../presentation/screens/mood_screen.dart';
import '../presentation/screens/hydration_screen.dart';
import '../presentation/screens/brain_dump_screen.dart';
import '../presentation/screens/weather_screen.dart';
import '../presentation/screens/mes_pensees_screen.dart';
import '../presentation/screens/mental_load_screen.dart';
import '../presentation/screens/info_screen.dart';
import '../presentation/screens/mentions_screen.dart';
import '../presentation/screens/rgpd_screen.dart';
import '../presentation/screens/credits_screen.dart';
import '../presentation/screens/cgu_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/welcome', // tu peux même l'enlever, vu la redirection
  routes: [
    GoRoute(
      path: '/', // redirige toujours vers l’écran d’accueil de l'app
      redirect: (_, __) => '/welcome',
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/user-home',
      builder: (context, state) => const UserHomeScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
        path: '/tools',
        builder: (context, state) => const ToolsScreen(),
    ),
    GoRoute(
        path: '/agenda',
        builder: (context, state) => AgendaScreen(),
    ),
    GoRoute(
      path: '/reminder',
      builder: (context, state) => const ReminderScreen(),
    ),
    GoRoute(
      path: '/traitement',
      builder: (context, state) => const TraitementScreen(),
    ),
    GoRoute(
      path: '/pomodoro',
      builder: (context, state) => const PomodoroScreen(),
    ),
    GoRoute(
      path: '/contact',
      builder: (context, state) => const ContactScreen(),
    ),
    GoRoute(
      path: '/mood',
      builder: (context, state) => const MoodScreen(),
    ),
    GoRoute(
      path: '/hydration',
      builder: (context, state) => const HydrationScreen(),
    ),
    GoRoute(
      path: '/brain-dump',
      builder: (context, state) => const BrainDumpScreen(),
    ),
    GoRoute(
      path: '/weather',
      builder: (context, state) => const WeatherScreen(),
    ),
    GoRoute(
      path: '/mes-pensees',
      builder: (context, state) => const MesPenseesScreen(),
    ),
    GoRoute(
      path: '/mental-load',
      builder: (context, state) => const MentalLoadScreen(),
    ),
    GoRoute(
      path: '/infos',
      builder: (context, state) => const InfoScreen(),
    ),
    GoRoute(
      path: '/mentions',
      builder: (context, state) => const MentionsScreen(),
    ),
    GoRoute(
      path: '/rgpd',
      builder: (context, state) => const RgpdScreen(),
    ),
    GoRoute(
      path: '/credits',
      builder: (context, state) => const CreditsScreen(),
    ),
    GoRoute(
      path: '/cgu',
      builder: (context, state) => const CguScreen(),
    ),

  ],
);
