import 'package:hive/hive.dart';

part 'mental_load_item.g.dart';

@HiveType(typeId: 6) // ID unique
class MentalLoadItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category; // perso, pro, urgent…

  @HiveField(3)
  final DateTime? dueDate;

  @HiveField(4)
  final bool isDone;

  MentalLoadItem({
    required this.id,
    required this.title,
    required this.category,
    this.dueDate,
    this.isDone = false,
  });

  MentalLoadItem copyWith({
    String? title,
    String? category,
    DateTime? dueDate,
    bool? isDone,
  }) {
    return MentalLoadItem(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}
