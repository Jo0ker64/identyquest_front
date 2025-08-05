import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/reminder_item.dart';

class ReminderProvider extends ChangeNotifier {
  static const String _boxName = 'reminders'; // ✅ même nom qu’avant
  late Box<ReminderItem> _box;

  List<ReminderItem> get reminders => _box.values.toList();

  Future<void> init() async {
    _box = await Hive.openBox<ReminderItem>(_boxName);
  }

  Future<void> addReminder(ReminderItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> removeReminder(String id) async {
    await _box.delete(id);
    notifyListeners();
  }

  Future<void> updateReminder(ReminderItem updated) async {
    await _box.put(updated.id, updated);
    notifyListeners();
  }

  ReminderItem? getById(String id) => _box.get(id);

  List<ReminderItem> byDay(DateTime day, {ReminderType? type}) {
    bool sameYMD(DateTime a, DateTime b) =>
        a.year == b.year && a.month == b.month && a.day == b.day;

    return reminders.where((r) {
      final okDay = sameYMD(r.dateTime, day);
      final okType = type == null || r.type == type;
      return okDay && okType;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }
}