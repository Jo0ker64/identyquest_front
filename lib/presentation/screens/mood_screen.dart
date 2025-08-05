import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/theme.dart';
import '../widgets/back_button_widget.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  int? _selectedMood;
  // 7 emojis : très mal -> super bien
  final List<String> _moods = [
  "😭", // très mal
  "😔", // mal
  "😕", // bof
  "🙂", // neutre
  "😃", // bien
  "😁", // très bien
  "🤩", // excellent
  "🤪", // euphorique / surexcité
  ];

    final List<String> _labels = [
    "Très mal",
    "Mal",
    "Bof",
    "Neutre",
    "Bien",
    "Très bien",
    "Excellent",
    "Euphorique"
    ];

  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadMood();
  }

  Future<void> _loadMood() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMood = prefs.getInt('mood');

      final historyString = prefs.getString('mood_history');
      if (historyString != null) {
        _history = List<Map<String, dynamic>>.from(jsonDecode(historyString));
      }
    });
  }

  Future<void> _saveMood(int index) async {
    final prefs = await SharedPreferences.getInstance();

    final now = DateTime.now();
    final todayStr = "${now.year.toString().padLeft(4, '0')}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')}";

    // Supprime l'entrée du jour si elle existe déjà
    _history.removeWhere((e) => e["date"] == todayStr);

    // Ajoute la nouvelle humeur du jour
    _history.add({"date": todayStr, "mood": index});

    // Trie par date décroissante et limite à 30 entrées
    _history.sort((a, b) => (b["date"] as String).compareTo(a["date"] as String));
    if (_history.length > 30) {
      _history = _history.sublist(0, 30);
    }

    await prefs.setInt('mood', index);
    await prefs.setString('mood_history', jsonEncode(_history));

    setState(() => _selectedMood = index);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Humeur enregistrée : ${_labels[index]} ✅")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 4 colonnes -> 2 lignes (4 + 3)
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Mon humeur du jour'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "Comment te sens-tu aujourd'hui ?",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // --- GRILLE D'ÉMOJIS ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _moods.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 par ligne -> 2 lignes (4 + 3)
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final isSelected = _selectedMood == index;
                return Semantics(
                  button: true,
                  label: _labels[index],
                  selected: isSelected,
                  child: GestureDetector(
                    onTap: () => _saveMood(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? AppColors.softBlue.withOpacity(0.20)
                            : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          _moods[index],
                          style: TextStyle(
                            fontSize: isSelected ? 40 : 32,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          if (_selectedMood != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
              child: Text(
                "Humeur actuelle : ${_labels[_selectedMood!]} ${_moods[_selectedMood!]}",
                style: const TextStyle(fontSize: 14),
              ),
            ),

          const SizedBox(height: 8),
          const Divider(height: 1),

          // --- HISTORIQUE ---
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              "Historique (30 derniers jours)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: _history.isEmpty
                ? const Center(child: Text("Aucune humeur enregistrée"))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    itemCount: _history.length,
                    itemBuilder: (context, i) {
                      final entry = _history[i];
                      final moodIndex = entry["mood"] as int;
                      final parts = (entry["date"] as String).split("-");
                      final date = DateTime(
                        int.parse(parts[0]),
                        int.parse(parts[1]),
                        int.parse(parts[2]),
                      );
                      final dateLabel =
                          "${date.day.toString().padLeft(2, '0')}/"
                          "${date.month.toString().padLeft(2, '0')}/"
                          "${date.year}";

                      return ListTile(
                        leading: Text(_moods[moodIndex], style: const TextStyle(fontSize: 28)),
                        title: Text(dateLabel),
                        subtitle: Text(_labels[moodIndex]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            // supprime l'entrée de cette date
                            setState(() {
                              _history.removeWhere((e) => e["date"] == entry["date"]);
                            });
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString('mood_history', jsonEncode(_history));
                            // si on supprime l’humeur du jour, enlève la sélection
                            final today = DateTime.now();
                            final todayStr =
                                "${today.year}-${today.month}-${today.day}";
                            if (entry["date"] == todayStr) {
                              await prefs.remove('mood');
                              setState(() => _selectedMood = null);
                            }
                          },
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
