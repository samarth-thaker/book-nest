/* import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/bookModel.dart';

class BookProvider with ChangeNotifier {
  final List<Book> _books = [];
  List<Book> get books => List.unmodifiable(_books);

  final Box<Book> _box = Hive.box<Book>('books');

  void loadBooksFromHive() {
    _books.clear();
    _books.addAll(_box.values);
    notifyListeners();
  }

   void addBook(Book book) {
    _box.add(book);
    _books.add(book);
    notifyListeners();
  } 
 

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.key == updatedBook.key);

    if (index != -1) {
      final existingBook = _books[index];

      existingBook.save();
      loadBooksFromHive();
      notifyListeners();
    }
  }

  void deleteBook(Book book) {
    book.delete();

    _books.removeWhere((b) => b.key == book.key);

    notifyListeners();
  }

  void clearBooks() {
    _box.clear();
    _books.clear();
    notifyListeners();
  }

  List<Book> getBooksByStatus(BookStatus status) {
    return _books.where((book) => book.status == status).toList();
  }

  List<Book> get lentBooks {
    return getBooksByStatus(BookStatus.lent);
  }

  List<Book> get availableBooks {
    return getBooksByStatus(BookStatus.owned);
  }

  List<Book> searchBooks(String query) {
    if (query.isEmpty) return _books;

    final lowercaseQuery = query.toLowerCase();
    return _books.where((book) {
      return book.title.toLowerCase().contains(lowercaseQuery) ||
          book.author.toLowerCase().contains(lowercaseQuery) ||
          book.genre.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  List<Book> get overdueBooks {
    return lentBooks.where((book) => book.isOverdue).toList();
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
    notifyListeners();
  }

  void addBook(Book book) {
    _box.add(book);
    _books.add(book);
    notifyListeners();
  }

  void updateBook(Book updatedBook) {
    final index = _books.indexWhere((book) => book.key == updatedBook.key);

    if (index != -1) {
      // Update the book in the Hive box
      _box.put(updatedBook.key, updatedBook);

      // Update the book in the local list
      _books[index] = updatedBook;

      notifyListeners();
    }
  }

  void deleteBook(Book book) {
    book.delete();
    _books.removeWhere((b) => b.key == book.key);
    notifyListeners();
  }

  void clearBooks() {
    _box.clear();
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
  Future <void>lendBook(Book book, String lendToPersonName, DateTime expectedReturnDate)async{
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

  int get totalBooks => _books.length;

  int getBookCountByStatus(BookStatus status) {
    return getBooksByStatus(status).length;
  }
}
