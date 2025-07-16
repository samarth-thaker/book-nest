import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/lentBookModel.dart';

class LendingProvider extends ChangeNotifier {
  final List<LentBook> _lentBooks = [];

  List<LentBook> get lentBooks => _lentBooks;

  void addLentBook(LentBook book) async {
    final box = await Hive.openBox<LentBook>('lentBooks');
    await box.add(book);
    _lentBooks.add(book);
    notifyListeners();
  }

  void loadLentBooksFromHive() async {
    final box = await Hive.openBox<LentBook>('lentBooks');
    _lentBooks.clear();
    _lentBooks.addAll(box.values);
    notifyListeners();
  }
}
