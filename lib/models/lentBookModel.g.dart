// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lentBookModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LentBookAdapter extends TypeAdapter<LentBook> {
  @override
  final int typeId = 1;

  @override
  LentBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LentBook(
      title: fields[0] as String,
      author: fields[1] as String,
      genre: fields[2] as String,
      lentTo: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LentBook obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.lentTo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LentBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
