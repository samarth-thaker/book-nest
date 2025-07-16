import 'package:hive/hive.dart';

part 'bookModel.g.dart';

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String author;

  @HiveField(2)
  final String genre;

  Book({
    required this.title,
    required this.author,
    required this.genre,
    
  });
}
