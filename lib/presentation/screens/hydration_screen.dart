import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class HydrationScreen extends StatefulWidget {
  const HydrationScreen({super.key});

  @override
  State<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends State<HydrationScreen> {
  int _filledDrops = 0; // gouttes pleines du jour
  final int _totalDrops = 10;
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHydration();
  }

  Future<void> _loadHydration() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _todayString();

    // Charger historique
    final historyString = prefs.getString('hydration_history');
    if (historyString != null) {
      _history = List<Map<String, dynamic>>.from(jsonDecode(historyString));
    }

    // Si on a déjà une entrée pour aujourd'hui → la charger
    final todayEntry = _history.firstWhere(
      (e) => e['date'] == todayStr,
      orElse: () => {"date": todayStr, "drops": 0},
    );
    setState(() {
      _filledDrops = todayEntry["drops"];
    });
  }

  Future<void> _saveHydration() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _todayString();

    // Supprimer l'entrée du jour si elle existe
    _history.removeWhere((e) => e['date'] == todayStr);

    // Ajouter la nouvelle
    _history.add({
      "date": todayStr,
      "drops": _filledDrops,
    });

    // Trier par date décroissante et garder 30 jours max
    _history.sort((a, b) => b['date'].compareTo(a['date']));
    if (_history.length > 30) {
      _history = _history.sublist(0, 30);
    }

    await prefs.setString('hydration_history', jsonEncode(_history));
  }

  void _toggleDrop(int index) {
    setState(() {
      if (index < _filledDrops) {
        _filledDrops = index; // enlever
      } else {
        _filledDrops = index + 1; // ajouter
      }
    });
    _saveHydration();
  }

  String _todayString() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    double litres = _filledDrops * 0.3; // 30cl par goutte

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Hydratation'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Hydratation du jour :",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "$_filledDrops/$_totalDrops verres (${litres.toStringAsFixed(1)} L)",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),

          // --- Grille 2 lignes (5 gouttes par ligne) ---
          SizedBox(
            width: 300, // largeur max pour forcer le retour à la ligne après 5 gouttes
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(_totalDrops, (index) {
                bool isFilled = index < _filledDrops;
                return GestureDetector(
                  onTap: () => _toggleDrop(index),
                  child: Image.asset(
                    isFilled
                        ? 'assets/images/goutte_pleine.png'
                        : 'assets/images/goutte_vide.png',
                    width: 50, // taille plus grande
                    height: 50,
                  ),
                );
              }),
            ),
          ),


          const SizedBox(height: 12),
          const Text(
            "1 goutte = 1 verre de 30cl",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 12),

          // Message motivationnel
          if (_filledDrops >= 5 && _filledDrops < 10)
            const Text(
              "💪 Bien, continue !",
              style: TextStyle(fontSize: 16, color: Colors.blueAccent),
            ),
          if (_filledDrops == 10)
            const Text(
              "🏆 Objectif atteint !",
              style: TextStyle(fontSize: 16, color: Colors.green),
            ),

          const Divider(height: 32),

          // Historique
          const Text(
            "Historique (30 derniers jours)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: _history.isEmpty
                ? const Center(child: Text("Aucune donnée d'hydratation"))
                : ListView.builder(
                    itemCount: _history.length,
                    itemBuilder: (context, index) {
                      final entry = _history[index];
                      final dateParts = entry["date"].split("-");
                      final date = "${dateParts[2]}/${dateParts[1]}/${dateParts[0]}";
                      return ListTile(
                        leading: Text(
                          "${entry["drops"]}💧",
                          style: const TextStyle(fontSize: 20),
                        ),
                        title: Text(date),
                        subtitle: Text(
                          "${(entry["drops"] * 0.3).toStringAsFixed(1)} L",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
