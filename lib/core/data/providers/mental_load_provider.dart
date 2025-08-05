import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mental_load_item.dart';

class MentalLoadProvider extends ChangeNotifier {
  static const _boxName = 'mentalLoad';
  late Box<MentalLoadItem> _box;

  Future<void> init() async {
    _box = await Hive.openBox<MentalLoadItem>(_boxName);
  }

  List<MentalLoadItem> get activeItems =>
      _box.values.where((i) => !i.isDone).toList()
        ..sort((a, b) => (a.dueDate ?? DateTime(2100))
            .compareTo(b.dueDate ?? DateTime(2100)));

  List<MentalLoadItem> get doneItems =>
      _box.values.where((i) => i.isDone).toList()
        ..sort((a, b) => b.dueDate?.compareTo(a.dueDate ?? DateTime.now()) ?? 0);

  Future<void> addItem(MentalLoadItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> updateItem(MentalLoadItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> removeItem(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}
