import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/brain_dump_item.dart';

class BrainDumpProvider extends ChangeNotifier {
  static const _boxName = 'brainDump';
  late Box<BrainDumpItem> _box;

  List<BrainDumpItem> get items =>
      _box.values.toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  Future<void> init() async {
    _box = await Hive.openBox<BrainDumpItem>(_boxName);
  }

  Future<void> add(BrainDumpItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> update(BrainDumpItem item) async {
    await _box.put(item.id, item);
    notifyListeners();
  }

  Future<void> remove(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}
