import 'package:hive/hive.dart';
part 'lentBookModel.g.dart';

@HiveType(typeId: 1)
class LentBook extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String genre;

  @HiveField(3)
  final String lentTo;

  LentBook({
    required this.title,
    required this.author,
    required this.genre,
    required this.lentTo,
  });
}