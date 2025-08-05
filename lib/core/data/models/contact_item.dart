import 'package:hive/hive.dart';

part 'contact_item.g.dart';

@HiveType(typeId: 2)
class ContactItem {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String phone;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String relation;

  ContactItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.relation,
  });

  ContactItem copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? relation,
  }) {
    return ContactItem(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      relation: relation ?? this.relation,
    );
  }
}
