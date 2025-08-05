import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../core/data/models/brain_dump_item.dart';
import '../../core/data/providers/brain_dump_provider.dart';
import '../widgets/back_button_widget.dart';

class BrainDumpScreen extends StatefulWidget {
  const BrainDumpScreen({super.key});

  @override
  State<BrainDumpScreen> createState() => _BrainDumpScreenState();
}

class _BrainDumpScreenState extends State<BrainDumpScreen> {
  final TextEditingController _noteController = TextEditingController();
  final String font = 'Lexend';

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addNote() async {
    final text = _noteController.text.trim();
    if (text.isEmpty) return;

    final item = BrainDumpItem(
      id: const Uuid().v4(),
      text: text,
      createdAt: DateTime.now(),
    );

    await context.read<BrainDumpProvider>().add(item);
    _noteController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note ajoutée ✅")),
      );
    }
  }

  Future<void> _editNote(BrainDumpItem item) async {
    _noteController.text = item.text;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Modifier la note",
          style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: TextField(
          controller: _noteController,
          maxLines: 5,
          style: TextStyle(fontFamily: font),
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler", style: TextStyle(fontFamily: font)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newText = _noteController.text.trim();
              if (newText.isNotEmpty) {
                await context.read<BrainDumpProvider>().update(
                      item.copyWith(text: newText),
                    );
              }
              _noteController.clear();
              if (mounted) Navigator.pop(context);
            },
            child: Text("Sauvegarder", style: TextStyle(fontFamily: font)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteNote(BrainDumpItem item) async {
    await context.read<BrainDumpProvider>().remove(item.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note supprimée")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<BrainDumpProvider>().items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Brain Dump'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "En quoi consiste le brain dump ?",
                style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Décharge ton cerveau : pose ici toutes tes idées (brillantes… ou pas 😅).",
                style: TextStyle(fontFamily: font, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _noteController,
                maxLines: 5,
                style: TextStyle(fontFamily: font),
                decoration: InputDecoration(
                  hintText: "Déverse tout ce qui te passe par la tête…",
                  hintStyle: TextStyle(fontFamily: font),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Bouton ajouter
              ElevatedButton.icon(
                onPressed: _addNote,
                icon: const Icon(Icons.add),
                label: const Text("Ajouter la note"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 12),
              const Divider(),

              // Historique
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Aucune note pour l’instant…"))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final note = items[index];
                          final dateLabel = DateFormat('EEE dd MMM • HH:mm', 'fr_FR')
                              .format(note.createdAt);
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(note.text, style: TextStyle(fontFamily: font)),
                              subtitle: Text(dateLabel),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editNote(note),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _deleteNote(note),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
