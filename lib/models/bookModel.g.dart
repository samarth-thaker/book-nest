// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      title: fields[0] as String,
      author: fields[1] as String,
      genre: fields[2] as String,
      id: fields[14] as String,
      isbn: fields[3] as String?,
      purchaseDate: fields[5] as DateTime?,
      coverImagePath: fields[7] as String?,
      status: fields[8] as BookStatus,
      personalNotes: fields[9] as String?,
      dateAdded: fields[10] as DateTime?,
      lentToPersonName: fields[11] as String?,
      lentDate: fields[12] as DateTime?,
      expectedReturnDate: fields[13] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.author)
      ..writeByte(2)
      ..write(obj.genre)
      ..writeByte(3)
      ..write(obj.isbn)
      ..writeByte(5)
      ..write(obj.purchaseDate)
      ..writeByte(7)
      ..write(obj.coverImagePath)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.personalNotes)
      ..writeByte(10)
      ..write(obj.dateAdded)
      ..writeByte(11)
      ..write(obj.lentToPersonName)
      ..writeByte(12)
      ..write(obj.lentDate)
      ..writeByte(13)
      ..write(obj.expectedReturnDate)
      ..writeByte(14)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BookStatusAdapter extends TypeAdapter<BookStatus> {
  @override
  final int typeId = 1;

  @override
  BookStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return BookStatus.owned;
      case 1:
        return BookStatus.lent;
      case 2:
        return BookStatus.borrowed;
      default:
        return BookStatus.owned;
    }
  }

  @override
  void write(BinaryWriter writer, BookStatus obj) {
    switch (obj) {
      case BookStatus.owned:
        writer.writeByte(0);
        break;
      case BookStatus.lent:
        writer.writeByte(1);
        break;
      case BookStatus.borrowed:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
