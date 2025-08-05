import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mes_pensees_item.dart';

class MesPenseesProvider extends ChangeNotifier {
  static const _boxName = 'mesPensees';
  late Box<MesPenseesItem> _box;

  Future<void> init() async {
    _box = await Hive.openBox<MesPenseesItem>(_boxName);
  }

  List<MesPenseesItem> get items =>
      _box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> add(MesPenseesItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> update(MesPenseesItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}
