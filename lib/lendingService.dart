/* import 'package:booknest/models/bookModel.dart';

class LendingService {
  static Future<void> lendBook(
      Book book, String borrowerName, DateTime dueDate) async {
    book.status = BookStatus.lent;
    book.lendTo(borrowerName);
    book.lentDate = DateTime.now();
    book.expectedReturnDate = dueDate;
    await book.save();
  }
}
 */
import 'package:booknest/bookService.dart';
import 'package:booknest/models/bookModel.dart';

class LendingService {
  // Lend a book to someone
  static Future<void> lendBook(Book book, String borrowerName, 
       DateTime dueDate) async {
    book.status = BookStatus.lent;
    book.lentToPersonName = borrowerName;
    book.lentDate = DateTime.now();
    book.expectedReturnDate = dueDate;
    //book.borrowerContact = borrowerContact;
    await book.save(); // Hive method to save changes
  }

  // Return a book

  static Future<void> returnBook(Book book) async {
    book.status = BookStatus.owned;
    book.lentToPersonName = null;
    book.lentDate = null;
    book.expectedReturnDate = null;
    //book.borrowerContact = null;
    await book.save();
  }

  // Get all lent books
  static Future<List<Book>> getLentBooks() async {
    final allBooks = await BookService.getAllBooks();
    return allBooks.where((book) => book.status == BookStatus.lent).toList();
  }

  // Get overdue books
  static Future<List<Book>> getOverdueBooks() async {
    final lentBooks = await getLentBooks();
    final now = DateTime.now();
    return lentBooks.where((book) => 
      book.expectedReturnDate != null && book.expectedReturnDate!.isBefore(now)
    ).toList();
  }
}

