import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../core/data/models/mes_pensees_item.dart';
import '../../core/data/providers/mes_pensees_provider.dart';
import '../widgets/back_button_widget.dart';

class MesPenseesScreen extends StatefulWidget {
  const MesPenseesScreen({super.key});

  @override
  State<MesPenseesScreen> createState() => _MesPenseesScreenState();
}

class _MesPenseesScreenState extends State<MesPenseesScreen> {
  final _ctrl = TextEditingController();
  final String font = 'Lexend';
  static const _maxChars = 4000;

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    final item = MesPenseesItem(
      id: const Uuid().v4(),
      contenu: text,
      createdAt: DateTime.now(),
    );
    await context.read<MesPenseesProvider>().add(item);
    _ctrl.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrée ajoutée ✅')),
      );
    }
  }

  Future<void> _edit(MesPenseesItem item) async {
    final tmp = TextEditingController(text: item.contenu);
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Modifier'),
        content: SizedBox(
          width: double.maxFinite,
          child: TextField(
            controller: tmp,
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () async {
              final txt = tmp.text.trim();
              if (txt.isNotEmpty) {
                await context.read<MesPenseesProvider>().update(item.copyWith(contenu: txt));
              }
              if (mounted) Navigator.pop(context);
            },
            child: const Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(MesPenseesItem item) async {
    await context.read<MesPenseesProvider>().remove(item.id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Entrée supprimée')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<MesPenseesProvider>().items;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Mes pensées'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Prends quelques minutes pour poser tes pensées.",
                style: TextStyle(fontFamily: font, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ctrl,
                maxLines: 8,
                maxLength: _maxChars,
                decoration: InputDecoration(
                  hintText: "Écris librement…",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),

              // Historique
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text("Aucune pensée enregistrée pour l’instant…"))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          final it = items[i];
                          final dateLabel = DateFormat('EEE dd MMM • HH:mm', 'fr_FR')
                              .format(it.createdAt);
                          return Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              title: Text(it.contenu),
                              subtitle: Text(dateLabel),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _edit(it),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => _delete(it),
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
