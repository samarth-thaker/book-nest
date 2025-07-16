import 'package:flutter/material.dart';
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

  void clearBooks() {
    _box.clear();
    _books.clear();
    notifyListeners();
  }
}
