import 'package:hive/hive.dart';

part 'mes_pensees_item.g.dart';

@HiveType(typeId: 5) // unique !
class MesPenseesItem {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String contenu; // texte long

  @HiveField(2)
  final DateTime createdAt;

  const MesPenseesItem({
    required this.id,
    required this.contenu,
    required this.createdAt,
  });

  MesPenseesItem copyWith({String? contenu}) => MesPenseesItem(
        id: id,
        contenu: contenu ?? this.contenu,
        createdAt: createdAt,
      );
}
