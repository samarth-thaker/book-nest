import 'dart:io';
import 'package:booknest/models/bookModel.dart';
import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/widgets/customBookTile.dart';
import 'package:booknest/widgets/customButton.dart';
import 'package:booknest/widgets/inputField.dart';
import 'package:booknest/widgets/searchField.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BorrowedBooksScreen extends StatefulWidget {
  const BorrowedBooksScreen({super.key});

  @override
  State<BorrowedBooksScreen> createState() => _BorrowedBooksScreenState();
}

class _BorrowedBooksScreenState extends State<BorrowedBooksScreen> {
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _bookTitleController = TextEditingController();
  String? _selectedGenre;
  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Biography',
    'Science',
    'Fantasy',
    'Finance'
        'Mystery',
    'Romance',
    'Thriller',
    'History',
    'Philosophy',
    'Poetry',
    'Self-Help',
    'Technology',
    'Other'
  ];

  DateTime? _expectedReturnDate;
  Future<void> _selectReturnDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _expectedReturnDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _expectedReturnDate = picked;
      });
    }
  }

  void _clearForm() {
    _personController.clear();
    _authorController.clear();
    _bookTitleController.clear();
    setState(() {
      _expectedReturnDate = null;
    });
  }

  void _borrowBook() {
    if (_authorController.text.trim().isEmpty ||
        _bookTitleController.text.trim().isEmpty ||
        _personController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a book and enter person name')),
      );
      return;
    }

    final updatedBook = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _bookTitleController.text,
        author: _authorController.text,
        genre: _selectedGenre.toString());
    Provider.of<BookProvider>(context, listen: false).updateBook(updatedBook);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOut,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${_bookTitleController.text} borrowed successfully!')),
    );
    print("Borrowed book status: ${updatedBook.status}");
    print("All books: ");
    Provider.of<BookProvider>(context, listen: false).books.forEach((b) {
      print("${b.title} - ${b.status}");
    });
    _clearForm();
    Navigator.pop(context);
  }

  void _openBorrowedForm() {
    _clearForm();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(ctx).size.height * 0.75,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                  top: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Borrow a Book',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Inputfield(
                          controller: _bookTitleController,
                          hintText: 'Book Name',
                          keyboardType: TextInputType.text,
                          prefixText: '',
                          inputFormatters: const [],
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter book name';
                            }
                            return null;
                          }),
                      const SizedBox(height: 16),
                      Inputfield(
                        controller: _authorController,
                        hintText: 'Author Name',
                        keyboardType: TextInputType.text,
                        prefixText: '',
                        inputFormatters: const [],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter author name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedGenre,
                        hint: const Text('Select Genre'),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: _genres.map((String genre) {
                          return DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGenre = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a genre';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Inputfield(
                        controller: _personController,
                        hintText: 'Borrowed from (Person\'s name)',
                        keyboardType: TextInputType.text,
                        prefixText: '',
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter person name';
                          }
                          return null;
                        },
                        inputFormatters: const [],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _selectReturnDate,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _expectedReturnDate != null
                                    ? 'Return by: ${DateFormat('dd/MM/yyyy').format(_expectedReturnDate!)}'
                                    : 'Expected return date (Optional)',
                                style: TextStyle(
                                  color: _expectedReturnDate != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                              const Icon(Icons.calendar_today,
                                  color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Custombutton(
                              onTap: () {
                                _clearForm();
                                Navigator.pop(context);
                              },
                              action: 'Cancel',
                              buttonWidth: double.infinity,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Custombutton(
                              action: 'Borrow Book',
                              onTap: _borrowBook,
                              buttonWidth: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _returnBook(Book book) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Return Book'),
        content: Text('Mark "${book.title}" as returned?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final returnedBook = book.returnBook();
              Provider.of<BookProvider>(context, listen: false)
                  .updateBook(returnedBook);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${book.title} returned successfully!')),
              );
            },
            child: const Text('Return'),
          ),
        ],
      ),
    );
  }

  Widget _buildLentBookCard(Book book) {
    final isOverdue = book.isOverdue;
    final daysSinceLent = book.lentDate != null
        ? DateTime.now().difference(book.lentDate!).inDays
        : 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: book.hasCoverImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.file(
                  File(book.coverImagePath!),
                  width: 40,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.book_outlined, color: Colors.teal),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${book.author}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Lent to ${book.lentToPersonName}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              book.lentDate != null
                  ? 'Borrowed $daysSinceLent days ago'
                  : 'Recently borrowed',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            if (book.expectedReturnDate != null)
              Text(
                isOverdue
                    ? 'Overdue since ${DateFormat('dd/MM/yyyy').format(book.expectedReturnDate!)}'
                    : 'Due: ${DateFormat('dd/MM/yyyy').format(book.expectedReturnDate!)}',
                style: TextStyle(
                  color: isOverdue ? Colors.red : Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isOverdue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'OVERDUE',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'return') {
                  _returnBook(book);
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'return',
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_return, size: 16),
                      SizedBox(width: 8),
                      Text('Mark as Returned'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final borrowedBooks = bookProvider.books
        .where((book) => book.status == BookStatus.lent)
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (borrowedBooks.isNotEmpty) ...[
              Text(
                'Books Currently Lent (${borrowedBooks.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: borrowedBooks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.library_books_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No books borrowed yet.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text("Tap + to borrow a book ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: borrowedBooks.length,
                      itemBuilder: (ctx, index) {
                        return _buildLentBookCard(borrowedBooks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openBorrowedForm,
        child: const Icon(Icons.add),
      ),
    );
  }
}
