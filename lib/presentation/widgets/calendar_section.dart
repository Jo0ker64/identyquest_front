import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'rounded_button.dart';
import 'mini_rounded_button.dart';

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final List<Map<String, dynamic>> _events = [];

  @override
  Widget build(BuildContext context) {
    // 🔽 On récupère les événements triés pour le jour sélectionné
    final eventsOfDay = _events
        .where((e) => isSameDay(e['date'], _selectedDay))
        .toList()
      ..sort((a, b) => a['datetime'].compareTo(b['datetime']));

    return Column(
      children: [
        // 📅 Calendrier mensuel en français
        TableCalendar(
          locale: 'fr_FR',
          focusedDay: _focusedDay,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          onDaySelected: (selected, focused) {
            setState(() {
              _selectedDay = selected;
              _focusedDay = focused;
            });
          },
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarFormat: CalendarFormat.month,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mois',
          },
          calendarStyle: const CalendarStyle(
            todayDecoration:
                BoxDecoration(color: Colors.lightBlue, shape: BoxShape.circle),
            selectedDecoration:
                BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
          ),
        ),
        const SizedBox(height: 12),

        // 🗒️ Événements listés
        if (_selectedDay != null) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Évènements le ${DateFormat('dd/MM/yyyy').format(_selectedDay!)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Column(
            children: eventsOfDay
                .map(
                  (e) => ListTile(
                    title: Text(e['title']),
                    subtitle: Text('${e['time']} - ${e['address']}'),
                    onTap: () => _openEventForm(context, existingEvent: e),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Color(0xFF2E2E2E)),
                      onPressed: () => _removeEvent(e),
                    ),
                  ),
                )
                .toList(),
          ),
        ],

        const SizedBox(height: 12),

        // ➕ Ajouter un événement
        RoundedButton(
          text: "Ajouter un événement",
          icon: Icons.add,
          onPressed: () => _openEventForm(context),
        ),
      ],
    );
  }

  // 🧾 Ajouter ou modifier un événement
  void _openEventForm(BuildContext context, {Map<String, dynamic>? existingEvent}) {
    final titleController = TextEditingController(text: existingEvent?['title'] ?? '');
    final addressController = TextEditingController(text: existingEvent?['address'] ?? '');
    final noteController = TextEditingController(text: existingEvent?['note'] ?? '');
    DateTime? selectedDate = existingEvent?['date'] ?? _selectedDay;
    TimeOfDay? selectedTime = existingEvent != null
        ? TimeOfDay.fromDateTime(existingEvent['datetime'])
        : null;
    String selectedReminder = existingEvent?['reminder'] ?? '10 minutes avant';
    String selectedFrequency = existingEvent?['frequency'] ?? 'Aucune';
    String selectedSound = existingEvent?['sound'] ?? 'Son par défaut';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Nouvel événement"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Intitulé"),
                TextField(controller: titleController),
                const SizedBox(height: 12),
                const Text("Adresse "),
                TextField(controller: addressController),
                const SizedBox(height: 12),
                const Text("Note complémentaire"),
                TextField(controller: noteController),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MiniRoundedButton(
                        text: selectedDate != null
                            ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                            : "Choisir la date",
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: MiniRoundedButton(
                        text: selectedTime != null
                            ? selectedTime!.format(context)
                            : "Choisir l'heure",
                        onPressed: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedTime = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButton<String>(
                  value: selectedReminder,
                  onChanged: (value) => setState(() => selectedReminder = value!),
                  items: [
                    'Pas de rappel',
                    '10 minutes avant',
                    '30 minutes avant',
                    '1 heure avant',
                    '1 jour avant'
                  ].map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: selectedFrequency,
                  onChanged: (value) => setState(() => selectedFrequency = value!),
                  items: [
                    'Aucune',
                    'Quotidien',
                    'Hebdomadaire',
                    'Mensuel'
                  ].map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                      .toList(),
                ),
                DropdownButton<String>(
                  value: selectedSound,
                  onChanged: (value) => setState(() => selectedSound = value!),
                  items: [
                    'Son par défaut',
                    'Bip',
                    'Sonnerie douce',
                    'Vibration seule'
                  ].map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label),
                      ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        actions: [
          MiniRoundedButton(
            text: "Annuler",
            onPressed: () => Navigator.pop(context),
          ),
          MiniRoundedButton(
            text: existingEvent != null ? "Modifier" : "Enregistrer",
            onPressed: () {
              if (titleController.text.isNotEmpty &&
                  selectedDate != null &&
                  selectedTime != null) {
                final fullDateTime = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );

                setState(() {
                  if (existingEvent != null) _events.remove(existingEvent);
                  _events.add({
                    'title': titleController.text,
                    'address': addressController.text,
                    'note': noteController.text,
                    'date': selectedDate,
                    'time': selectedTime!.format(context),
                    'datetime': fullDateTime,
                    'reminder': selectedReminder,
                    'frequency': selectedFrequency,
                    'sound': selectedSound,
                  });
                });

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _removeEvent(Map<String, dynamic> event) {
    setState(() => _events.remove(event));
  }
}
