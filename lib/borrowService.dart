import 'package:booknest/bookService.dart';
import 'package:booknest/models/bookModel.dart';
class Borrowservice {

  static Future<void> borrowBook(Book book, String lenderName, 
       DateTime dueDate) async {
    book.status = BookStatus.borrowed;
    book.borrowedFromPersonName = lenderName;
    book.borrowedDate = DateTime.now();
    book.expectedReturnDate = dueDate;
    //book.borrowerContact = borrowerContact;
    await book.save(); // Hive method to save changes
  }

  // Return a book

  static Future<void> returnBook(Book book) async {
    //book.status = BookStatus.owned;
    book.borrowedFromPersonName = null;
    book.borrowedDate = null;
    book.expectedReturnDate = null;
    //book.borrowerContact = null;
    await book.save();
  }

  
  static Future<List<Book>> getBorrowedBooks() async {
    final allBooks = await BookService.getAllBooks();
    return allBooks.where((book) => book.status == BookStatus.borrowed).toList();
  }
  
  
  static Future<List<Book>> getOverdueBooks() async {
    final borrowedBooks = await getBorrowedBooks();
    final now = DateTime.now();
    return borrowedBooks.where((book) => 
      book.expectedReturnDate != null && book.expectedReturnDate!.isBefore(now)
    ).toList();
  }
}
