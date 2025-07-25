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

  @HiveField(3)
  final String? isbn;

  @HiveField(4)
  final double? rating; // 0.0 to 5.0 star rating  */

  @HiveField(5)
  final DateTime? purchaseDate;

  @HiveField(7)
  final String? coverImagePath; // Path to local image file

  @HiveField(8)
  BookStatus status;

  @HiveField(9)
  final String? personalNotes;

  @HiveField(10)
  final DateTime dateAdded;

  @HiveField(11)
  String? lentToPersonName;

  @HiveField(12)
  DateTime? lentDate;

  @HiveField(13)
  DateTime? expectedReturnDate;
  @HiveField(14)
  final String id;
  @HiveField(15)
  String? borrowedFromPersonName;
  @HiveField(16)
  DateTime? borrowedDate;
  Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.id,
    this.isbn,
    this.rating,
    this.purchaseDate,
    
    this.coverImagePath,
    this.status = BookStatus.owned,
    this.personalNotes,
    DateTime? dateAdded,
    this.borrowedFromPersonName,
    this.borrowedDate,
    this.lentToPersonName,
    this.lentDate,
    this.expectedReturnDate,
  }) : dateAdded = dateAdded ?? DateTime.now();

  bool get isLent => status == BookStatus.lent;
  bool get isBorrowed => status == BookStatus.borrowed;
  bool get isAvailable => status == BookStatus.owned;
  
  bool get hasRating => rating != null && rating! > 0;
  bool get hasCoverImage =>
      coverImagePath != null && coverImagePath!.isNotEmpty;
  bool get isOverdue =>
      isLent &&
      expectedReturnDate != null &&
      DateTime.now().isAfter(expectedReturnDate!);

  //get id => null;

  Book copyWith({
    String? title,
    String? author,
    String? genre,
    String? isbn,
    double? rating,
    DateTime? purchaseDate,
    double? purchasePrice,
    String? coverImagePath,
    BookStatus? status,
    String? personalNotes,
    DateTime? dateAdded,
    String? lentToPersonName,
    String? borrowedFromPersonName,
    DateTime? lentDate,
    DateTime? borrowedDate,
    DateTime? expectedReturnDate,
    String? publisher,
    int? pageCount,
    int? publicationYear,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      isbn: isbn ?? this.isbn,
      rating: rating ?? this.rating,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      id: id,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      status: status ?? this.status,
      personalNotes: personalNotes ?? this.personalNotes,
      dateAdded: dateAdded ?? this.dateAdded,
      lentToPersonName: lentToPersonName ?? this.lentToPersonName,
      lentDate: lentDate ?? this.lentDate,
      expectedReturnDate: expectedReturnDate ?? this.expectedReturnDate,
      borrowedFromPersonName:
          borrowedFromPersonName ?? this.borrowedFromPersonName,
      borrowedDate: borrowedDate ?? this.borrowedDate,
    );
  }

  Book lendTo(String personName, {DateTime? returnDate}) {
    return copyWith(
      status: BookStatus.lent,
      lentToPersonName: personName,
      lentDate: DateTime.now(),
      expectedReturnDate: returnDate,
    );
  }

  Book borrowedFrom(String personName, {DateTime? returnDate}) {
    return copyWith(
      status: BookStatus.borrowed,
      borrowedFromPersonName: personName,
      borrowedDate: DateTime.now(),
      expectedReturnDate: returnDate,
    );
  }

  Book returnBook() {
    return copyWith(
      status: BookStatus.owned,
      lentToPersonName: null,
      lentDate: null,
      expectedReturnDate: null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'genre': genre,
      'isbn': isbn,
      'rating': rating,
      'purchaseDate': purchaseDate?.toIso8601String(),
      'coverImagePath': coverImagePath,
      'status': status.index,
      'personalNotes': personalNotes,
      'dateAdded': dateAdded.toIso8601String(),
      'lentToPersonName': lentToPersonName,
      'lentDate': lentDate?.toIso8601String(),
      'expectedReturnDate': expectedReturnDate?.toIso8601String(),
      'borrowedFromPersonName': borrowedFromPersonName,
    };
  }

  @override
  String toString() {
    return 'Book(title: $title, author: $author, genre: $genre, status: $status)';
  }
}

@HiveType(typeId: 1)
enum BookStatus {
  @HiveField(0)
  owned,

  @HiveField(1)
  lent,

  @HiveField(2)
  borrowed,
}
