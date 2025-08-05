// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mes_pensees_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MesPenseesItemAdapter extends TypeAdapter<MesPenseesItem> {
  @override
  final int typeId = 5;

  @override
  MesPenseesItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MesPenseesItem(
      id: fields[0] as String,
      contenu: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, MesPenseesItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.contenu)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MesPenseesItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
