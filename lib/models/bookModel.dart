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

  /* @HiveField(4)
  final double? rating; // 0.0 to 5.0 star rating */

  @HiveField(5)
  final DateTime? purchaseDate;

  /* @HiveField(6)
  final double? purchasePrice; */

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

  

  Book({
    required this.title,
    required this.author,
    required this.genre,
    this.isbn,
    //this.rating,
    this.purchaseDate,
    //this.purchasePrice,
    this.coverImagePath,
    this.status = BookStatus.owned,
    this.personalNotes,
    DateTime? dateAdded,
    this.lentToPersonName,
    this.lentDate,
    this.expectedReturnDate,
   // this.publisher,
    //this.pageCount,
   // this.publicationYear,
  }) : dateAdded = dateAdded ?? DateTime.now();

  
  bool get isLent => status == BookStatus.lent;
  bool get isAvailable => status == BookStatus.owned;
  //bool get isWishlist => status == BookStatus.wishlist;
  //bool get hasRating => rating != null && rating! > 0;
  bool get hasCoverImage => coverImagePath != null && coverImagePath!.isNotEmpty;
  bool get isOverdue => 
    isLent && 
    expectedReturnDate != null && 
    DateTime.now().isAfter(expectedReturnDate!);

  get id => null;

  
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
    DateTime? lentDate,
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
     // rating: rating ?? this.rating,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      
      coverImagePath: coverImagePath ?? this.coverImagePath,
      status: status ?? this.status,
      personalNotes: personalNotes ?? this.personalNotes,
      dateAdded: dateAdded ?? this.dateAdded,
      lentToPersonName: lentToPersonName ?? this.lentToPersonName,
      lentDate: lentDate ?? this.lentDate,
      expectedReturnDate: expectedReturnDate ?? this.expectedReturnDate,
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
     // 'rating': rating,
      'purchaseDate': purchaseDate?.toIso8601String(),
     // 'purchasePrice': purchasePrice,
      'coverImagePath': coverImagePath,
      'status': status.index,
      'personalNotes': personalNotes,
      'dateAdded': dateAdded.toIso8601String(),
      'lentToPersonName': lentToPersonName,
      'lentDate': lentDate?.toIso8601String(),
      'expectedReturnDate': expectedReturnDate?.toIso8601String(),
     // 'publisher': publisher,
     // 'pageCount': pageCount,
     // 'publicationYear': publicationYear,
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

} 
