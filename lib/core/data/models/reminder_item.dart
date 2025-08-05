import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'reminder_item.g.dart';

@HiveType(typeId: 0)
enum ReminderType {
  @HiveField(0)
  rendezvous,
  @HiveField(1)
  traitement,
}

@HiveType(typeId: 1)
class ReminderItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final DateTime dateTime;
  @HiveField(3)
  final String? note;
  @HiveField(4)
  final Duration? reminderBefore; // ⚠️ voir note plus bas
  @HiveField(5)
  final String? frequency;
  @HiveField(6)
  final ReminderType type;

  ReminderItem({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.type,
    this.note,
    this.reminderBefore,
    this.frequency,
  });
}
