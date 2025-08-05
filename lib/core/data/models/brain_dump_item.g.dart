// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brain_dump_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrainDumpItemAdapter extends TypeAdapter<BrainDumpItem> {
  @override
  final int typeId = 4;

  @override
  BrainDumpItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrainDumpItem(
      id: fields[0] as String,
      text: fields[1] as String,
      createdAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, BrainDumpItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrainDumpItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
