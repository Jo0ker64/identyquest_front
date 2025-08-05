import 'package:hive/hive.dart';

part 'event_model.g.dart';

@HiveType(typeId: 3)
class EventModel {
  @HiveField(0)
  String title;
  @HiveField(1)
  String? note;
  @HiveField(2)
  String time; // HH:mm
  @HiveField(3)
  String? frequency;
  @HiveField(4)
  int? reminderMinutes;

  EventModel({
    required this.title,
    this.note,
    required this.time,
    this.frequency,
    this.reminderMinutes,
  });
}
