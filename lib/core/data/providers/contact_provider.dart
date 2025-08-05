import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/contact_item.dart';

class ContactProvider extends ChangeNotifier {
  static const String _boxName = 'contacts'; // ✅ nom clair et simple
  late Box<ContactItem> _box;

  List<ContactItem> get contacts => _box.values.toList();

  Future<void> init() async {
    _box = await Hive.openBox<ContactItem>(_boxName);
  }

  Future<void> addContact(ContactItem contact) async {
    await _box.put(contact.id, contact);
    notifyListeners();
  }

  Future<void> updateContact(ContactItem contact) async {
    await _box.put(contact.id, contact);
    notifyListeners();
  }

  Future<void> deleteContact(String id) async {
    await _box.delete(id);
    notifyListeners();
  }
}
