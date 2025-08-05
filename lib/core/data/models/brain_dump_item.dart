import 'package:hive/hive.dart';

part 'brain_dump_item.g.dart';

@HiveType(typeId: 4) // ⚠️ garde un typeId unique
class BrainDumpItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String text;

  @HiveField(2)
  final DateTime createdAt;

  const BrainDumpItem({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  BrainDumpItem copyWith({String? text}) =>
      BrainDumpItem(id: id, text: text ?? this.text, createdAt: createdAt);
}
