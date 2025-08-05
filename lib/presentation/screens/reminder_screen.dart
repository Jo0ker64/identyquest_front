import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../config/theme.dart';
import '../../core/data/models/reminder_item.dart';
import '../../core/data/providers/reminder_provider.dart';
import '../widgets/back_button_widget.dart';

enum _Filter { all, rendezvous, traitement }

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  _Filter _filter = _Filter.all;

  List<ReminderItem> _applyFilter(List<ReminderItem> items) {
    final filtered = items.where((r) {
      switch (_filter) {
        case _Filter.all:
          return true;
        case _Filter.rendezvous:
          return r.type == ReminderType.rendezvous;
        case _Filter.traitement:
          return r.type == ReminderType.traitement;
      }
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReminderProvider>();
    final reminders = _applyFilter(provider.reminders);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Mes rappels'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          // --- Filtres ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Tous'),
                  selected: _filter == _Filter.all,
                  onSelected: (_) => setState(() => _filter = _Filter.all),
                ),
                ChoiceChip(
                  label: const Text('Rendez-vous'),
                  selected: _filter == _Filter.rendezvous,
                  onSelected: (_) => setState(() => _filter = _Filter.rendezvous),
                ),
                ChoiceChip(
                  label: const Text('Traitements'),
                  selected: _filter == _Filter.traitement,
                  onSelected: (_) => setState(() => _filter = _Filter.traitement),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          // --- Liste ---
          Expanded(
            child: reminders.isEmpty
                ? const Center(child: Text('Aucun rappel enregistré pour le moment.'))
                : ListView.builder(
                    itemCount: reminders.length,
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      final formattedDate = DateFormat('EEEE dd MMMM yyyy', 'fr_FR')
                          .format(reminder.dateTime);
                      final formattedTime = DateFormat.Hm('fr_FR').format(reminder.dateTime);
                      final isTraitement = reminder.type == ReminderType.traitement;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: Icon(
                            isTraitement ? Icons.medication : Icons.event_note,
                            color: isTraitement ? Colors.redAccent : Colors.blueAccent,
                          ),
                          title: Text(reminder.title),
                          subtitle: Text([
                            '$formattedDate à $formattedTime',
                            if ((reminder.note ?? '').isNotEmpty) (reminder.note ?? ''),
                            if ((reminder.frequency ?? '').isNotEmpty)
                              'Fréquence : ${reminder.frequency}',
                          ].join('\n')),
                          isThreeLine: true,
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              context.read<ReminderProvider>().removeReminder(reminder.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rappel supprimé')),
                              );
                            },
                          ),
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
