import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../widgets/back_button_widget.dart';
import '../../config/theme.dart';
import '../../core/data/models/reminder_item.dart';
import '../../core/data/providers/reminder_provider.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration? _reminderBefore;

  int _frequencyValue = 1;
  String _frequencyUnit = 'Jours';
  final List<String> _units = ['Jours', 'Semaines', 'Mois'];

  final List<Duration> _reminderOptions = const [
    Duration(minutes: 10),
    Duration(hours: 1),
    Duration(days: 1),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (!_formKey.currentState!.validate()) return;

    final dateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final freqText = _frequencyValue <= 0
        ? 'Aucune'
        : 'Toutes les $_frequencyValue $_frequencyUnit';

    final reminder = ReminderItem(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      dateTime: dateTime,
      note: _noteController.text.trim(),
      reminderBefore: _reminderBefore,
      frequency: freqText,
      type: ReminderType.rendezvous, // 💡 Enum centralisé
    );

    Provider.of<ReminderProvider>(context, listen: false).addReminder(reminder);

    _titleController.clear();
    _noteController.clear();
    setState(() {
      _selectedTime = TimeOfDay.now();
      _reminderBefore = null;
      _frequencyValue = 1;
      _frequencyUnit = 'Jours';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Événement ajouté à l’agenda')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventsForDay = context.watch<ReminderProvider>()
        .byDay(_selectedDay, type: ReminderType.rendezvous);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.softBlue,
        title: const Text('Mon agenda'),
        leading: const BackButtonWidget(goToRoute: '/user-home', color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              locale: 'fr_FR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: const CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mois',
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
            ),

            const SizedBox(height: 12),
            Text(
              "Ajouter un événement pour le ${DateFormat.yMMMMd('fr_FR').format(_selectedDay)}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: "Intitulé"),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? "Champ requis" : null,
                    ),
                    TextFormField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: "Adresse / Note"),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text("Heure : "),
                        TextButton(
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: _selectedTime,
                            );
                            if (picked != null) {
                              setState(() => _selectedTime = picked);
                            }
                          },
                          child: Text(_selectedTime.format(context)),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            initialValue: _frequencyValue.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Fréquence'),
                            onChanged: (val) {
                              final parsed = int.tryParse(val);
                              if (parsed != null && parsed >= 0) {
                                setState(() => _frequencyValue = parsed);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<String>(
                            value: _frequencyUnit,
                            decoration: const InputDecoration(labelText: 'Unité'),
                            items: _units.map((unit) {
                              return DropdownMenuItem<String>(
                                value: unit,
                                child: Text(unit),
                              );
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _frequencyUnit = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    DropdownButtonFormField<Duration>(
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
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text("Valider"),
                        onPressed: _addEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.softBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(fontSize: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Événements pour le ${DateFormat.yMMMMd('fr_FR').format(_selectedDay)}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (eventsForDay.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text("Aucun événement pour ce jour."),
              )
            else
              ...eventsForDay.map((event) {
                final time = DateFormat.Hm('fr_FR').format(event.dateTime);
                final freq = (event.frequency?.isNotEmpty == true)
                    ? event.frequency
                    : 'Ponctuel';
                return ListTile(
                  title: Text(event.title),
                  subtitle: Text("${event.note ?? ''} — $time — $freq"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () =>
                        Provider.of<ReminderProvider>(context, listen: false)
                            .removeReminder(event.id),
                  ),
                );
              }),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
