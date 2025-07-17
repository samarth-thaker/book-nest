import 'package:booknest/models/bookModel.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class BookService {
  static Box<Book>? _bookBox;
  static const String _boxName = 'books';
  
  // Initialize Hive
  static Future<void> init() async {
    if (_bookBox?.isOpen != true) {
      await Hive.initFlutter();
      Hive.registerAdapter(BookAdapter());
      _bookBox = await Hive.openBox<Book>(_boxName);
    }
  }
  
  // Get all books
  static Future<List<Book>> getAllBooks() async {
    try {
      await init();
      final books = _bookBox!.values.toList();
      
      // Sort by title for consistent ordering
      books.sort((a, b) => a.title.compareTo(b.title));
      
      return books;
    } catch (e) {
      print('Error getting all books: $e');
      return [];
    }
  }
  
  // Get book by ID
  static Future<Book?> getBookById(String id) async {
    try {
      await init();
      return _bookBox!.get(id);
    } catch (e) {
      print('Error getting book by ID: $e');
      return null;
    }
  }
  
  // Add a new book
  static Future<bool> addBook(Book book) async {
    try {
      await init();
      await _bookBox!.put(book.id, book);
      return true;
    } catch (e) {
      print('Error adding book: $e');
      return false;
    }
  }
  
  // Update an existing book
  static Future<bool> updateBook(Book book) async {
    try {
      await init();
      
      if (_bookBox!.containsKey(book.id)) {
        await _bookBox!.put(book.id, book);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating book: $e');
      return false;
    }
  }
  
  // Delete a book
  static Future<bool> deleteBook(String id) async {
    try {
      await init();
      
      if (_bookBox!.containsKey(id)) {
        await _bookBox!.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      print('Error deleting book: $e');
      return false;
    }
  }
  
  // Search books
  static Future<List<Book>> searchBooks(String query) async {
    try {
      await init();
      
      if (query.isEmpty) {
        return getAllBooks();
      }
      
      final lowercaseQuery = query.toLowerCase();
      final allBooks = _bookBox!.values.toList();
      
      return allBooks.where((book) =>
        book.title.toLowerCase().contains(lowercaseQuery) ||
        book.author.toLowerCase().contains(lowercaseQuery) ||
        (book.genre?.toLowerCase().contains(lowercaseQuery) ?? false) ||
        (book.isbn?.toLowerCase().contains(lowercaseQuery) ?? false)
      ).toList();
    } catch (e) {
      print('Error searching books: $e');
      return [];
    }
  }
  
  // Get books by genre
  static Future<List<Book>> getBooksByGenre(String genre) async {
    try {
      await init();
      
      final allBooks = _bookBox!.values.toList();
      return allBooks.where((book) => 
        book.genre?.toLowerCase() == genre.toLowerCase()
      ).toList();
    } catch (e) {
      print('Error getting books by genre: $e');
      return [];
    }
  }
  
  // Get all unique genres
  static Future<List<String>> getAllGenres() async {
    try {
      await init();
      
      final allBooks = _bookBox!.values.toList();
      final genres = allBooks
          .map((book) => book.genre)
          .where((genre) => genre != null && genre.isNotEmpty)
          .cast<String>()
          .toSet()
          .toList();
      
      genres.sort();
      return genres;
    } catch (e) {
      print('Error getting all genres: $e');
      return [];
    }
  }
  
  // Get books statistics
  static Future<Map<String, int>> getBooksStatistics() async {
    try {
      await init();
      
      final allBooks = _bookBox!.values.toList();
      
      return {
        'total': allBooks.length,
        'owned': allBooks.where((book) => book.status == BookStatus.owned).length,
        'lent': allBooks.where((book) => book.status == BookStatus.lent).length,
        //'wishlist': allBooks.where((book) => book.status == BookStatus.wishlist).length,
      };
    } catch (e) {
      print('Error getting books statistics: $e');
      return {
        'total': 0,
        'owned': 0,
        'lent': 0,
        'wishlist': 0,
      };
    }
  }
  
  // Clear all books (use with caution)
  static Future<bool> clearAllBooks() async {
    try {
      await init();
      await _bookBox!.clear();
      return true;
    } catch (e) {
      print('Error clearing all books: $e');
      return false;
    }
  }
  
  // Close the box (call when app is closing)
  static Future<void> close() async {
    await _bookBox?.close();
  }
}
