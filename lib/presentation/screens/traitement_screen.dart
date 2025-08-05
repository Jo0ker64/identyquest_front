import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

import '../../config/theme.dart';
import '../../core/data/models/reminder_item.dart';
import '../../core/data/providers/reminder_provider.dart';
import '../widgets/back_button_widget.dart';

class TraitementScreen extends StatefulWidget {
  const TraitementScreen({super.key});

  @override
  State<TraitementScreen> createState() => _TraitementScreenState();
}

class _TraitementScreenState extends State<TraitementScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  Duration? _reminderBefore;

  final List<Duration> _reminderOptions = const [
    Duration(minutes: 10),
    Duration(hours: 1),
    Duration(days: 1),
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (_nomController.text.isEmpty || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complète le nom, la date et l’heure 😉')),
      );
      return;
    }

    final dateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final reminder = ReminderItem(
      id: const Uuid().v4(),
      title: _nomController.text.trim(),
      dateTime: dateTime,
      note: _noteController.text.trim(),
      reminderBefore: _reminderBefore,
      frequency: 'quotidien',
      type: ReminderType.traitement,
    );

    Provider.of<ReminderProvider>(context, listen: false).addReminder(reminder);

    _nomController.clear();
    _noteController.clear();
    setState(() {
      _selectedDate = null;
      _selectedTime = null;
      _reminderBefore = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Traitement enregistré')),
    );

    Future.microtask(() => Navigator.pop(context));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = _selectedDate != null
        ? DateFormat('dd/MM/yyyy').format(_selectedDate!)
        : 'Choisir la date';
    final hour = _selectedTime?.format(context) ?? 'Choisir l’heure';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Ajouter un traitement'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom du traitement'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optionnel)'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _pickDate,
                    child: Text(now),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _pickTime,
                    child: Text(hour),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<Duration>(
                value: _reminderBefore,
                hint: const Text("Rappel avant"),
                items: _reminderOptions.map((d) {
                  final label = d.inMinutes < 60
                      ? '${d.inMinutes} min'
                      : d.inHours < 24
                          ? '${d.inHours} h'
                          : '${d.inDays} j';
                  return DropdownMenuItem(
                    value: d,
                    child: Text("Rappel $label avant"),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _reminderBefore = value),
              ),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Enregistrer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.softBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
