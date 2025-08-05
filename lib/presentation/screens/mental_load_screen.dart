import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../config/theme.dart';
import '../../core/data/models/mental_load_item.dart';
import '../../core/data/providers/mental_load_provider.dart';
import '../widgets/back_button_widget.dart';

class MentalLoadScreen extends StatefulWidget {
  const MentalLoadScreen({super.key});

  @override
  State<MentalLoadScreen> createState() => _MentalLoadScreenState();
}

class _MentalLoadScreenState extends State<MentalLoadScreen> {
  final _ctrl = TextEditingController();
  String _selectedCategory = 'Perso';
  DateTime? _dueDate;

  final _categories = {
    'Perso': AppColors.softBlue,
    'Pro': AppColors.mintGreen,
    'Urgent': AppColors.softPink,
    'Autre': AppColors.pastelLilac,
  };

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _addItem() async {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;

    final item = MentalLoadItem(
      id: const Uuid().v4(),
      title: text,
      category: _selectedCategory,
      dueDate: _dueDate,
    );
    await context.read<MentalLoadProvider>().addItem(item);
    _ctrl.clear();
    setState(() => _dueDate = null);
  }

  @override
  Widget build(BuildContext context) {
    final activeItems = context.watch<MentalLoadProvider>().activeItems;
    final doneItems = context.watch<MentalLoadProvider>().doneItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Mon espace mental'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Champ ajout
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(
                      hintText: "Nouvelle tâche...",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _selectedCategory,
                  items: _categories.keys.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedCategory = val!),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green),
                  onPressed: _addItem,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Liste active
            Expanded(
              child: ListView(
                children: [
                  ...activeItems.map((item) => Card(
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isDone,
                            onChanged: (val) {
                              context.read<MentalLoadProvider>().updateItem(
                                    item.copyWith(isDone: val ?? false),
                                  );
                            },
                          ),
                          title: Text(item.title),
                          subtitle: Text(
                            "${item.category} ${item.dueDate != null ? '• ${DateFormat.yMMMd('fr_FR').format(item.dueDate!)}' : ''}",
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => context.read<MentalLoadProvider>().removeItem(item.id),
                          ),
                        ),
                      )),
                  if (doneItems.isNotEmpty) const Divider(),
                  if (doneItems.isNotEmpty)
                    const Text("Terminé", style: TextStyle(fontWeight: FontWeight.bold)),
                  ...doneItems.map((item) => ListTile(
                        leading: const Icon(Icons.check, color: Colors.green),
                        title: Text(item.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
