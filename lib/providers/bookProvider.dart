/* import 'package:booknest/lendingService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookModel.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> get books => _books;

  final Box<Book> _box = Hive.box<Book>('books');

  void loadBooksFromHive() {
    _books.clear(); // maybe the cause of issue
    _books.addAll(_box.values);
    print('Loaded ${_books.length} books from hive');
    notifyListeners();
  }

  void addBook(Book book) {
    //final int newKey = _box.length; 
    Hive.box<Book>('books').put(book.id, book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);

    if (index != -1) {
      // Update the book in the Hive box
      _box.put(updatedBook.id, updatedBook);

      // Update the book in the local list
      _books[index] = updatedBook;

      notifyListeners();
    }
  }

  void deleteBook(Book book) {
    book.delete();
    _books.removeWhere((b) => b.id == book.id);
    notifyListeners();
  }

  void clearBooks() {
    //_box.clear();
    _books.clear();
    notifyListeners();
  }

  List<Book> getBooksByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  List<Book> get ownedBooks =>
      _books.where((book) => book.status == BookStatus.owned).toList();
  List<Book> get lentBooks {
    return getBooksByStatus(BookStatus.lent);
  }

  List<Book> get availableBooks {
    return getBooksByStatus(BookStatus.owned);
  }

  Future<void> lendBook(
      Book book, String lendToPersonName, DateTime expectedReturnDate) async {
    await LendingService.lendBook(book, lendToPersonName, expectedReturnDate);
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;

    final lowercaseQuery = query.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          book.genre!.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Book> get overdueBooks {
    return lentBooks.where((book) => book.isOverdue).toList();
  }

  List<Book> get borrowedBooks {
    return getBooksByStatus(BookStatus.borrowed);
  }

  Future<void> markAsBorrowed(
      Book book, String borrowedFrom, DateTime expectedReturnDate) async {
    final updatedBook = book.copyWith(
      status: BookStatus.borrowed,
      lentToPersonName: borrowedFrom,
      lentDate: DateTime.now(),
      expectedReturnDate: expectedReturnDate,
    );

    updateBook(updatedBook);
  }

  int get totalBooks => _books.length;

  int getBookCountByStatus(BookStatus status) {
    return getBooksByStatus(status).length;
  }
}
 */
import 'package:booknest/lendingService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookModel.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Book> get books => _books;

  final Box<Book> _box = Hive.box<Book>('books');

  void loadBooksFromHive() {
    _books.clear();
    _books.addAll(_box.values);
    print('Loaded ${_books.length} books from hive');
    notifyListeners();
  }

  void addBook(Book book) {
    _box.put(book.id, book);
    loadBooksFromHive();
  }

  void updateBook(Book updatedBook) {
    _box.put(updatedBook.id, updatedBook);
    loadBooksFromHive();
  }

  void deleteBook(Book book) {
    _box.delete(book.id);
    loadBooksFromHive();
  }

  void clearBooks() {
    _books.clear();
    notifyListeners();
  }

  List<Book> getBooksByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  List<Book> get ownedBooks => getBooksByStatus(BookStatus.owned);
  List<Book> get lentBooks => getBooksByStatus(BookStatus.lent);
  List<Book> get availableBooks => getBooksByStatus(BookStatus.owned);

  Future<void> lendBook(
      Book book, String lendToPersonName, DateTime expectedReturnDate) async {
    await LendingService.lendBook(book, lendToPersonName, expectedReturnDate);
    loadBooksFromHive();
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;
    final lowercaseQuery = query.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          (book.genre ?? '').toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Book> get overdueBooks => lentBooks.where((book) => book.isOverdue).toList();
  List<Book> get borrowedBooks => getBooksByStatus(BookStatus.borrowed);

  Future<void> markAsBorrowed(
      Book book, String borrowedFrom, DateTime expectedReturnDate) async {
    final updatedBook = book.copyWith(
      status: BookStatus.borrowed,
      lentToPersonName: borrowedFrom,
      lentDate: DateTime.now(),
      expectedReturnDate: expectedReturnDate,
    );
    updateBook(updatedBook);
  }

  int get totalBooks => _books.length;
  int getBookCountByStatus(BookStatus status) => getBooksByStatus(status).length;
}