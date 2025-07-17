import 'dart:io';
import 'package:booknest/models/bookModel.dart';
// ignore: unused_import
import 'package:booknest/widgets/lentBookCard.dart';
import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/widgets/customButton.dart';
import 'package:booknest/widgets/inputField.dart';
import 'package:booknest/widgets/searchField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class LendingTab extends StatefulWidget {
  const LendingTab({super.key});

  @override
  State<LendingTab> createState() => _LendingTabState();
}

class _LendingTabState extends State<LendingTab> {
  final TextEditingController _personController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
      
  Book? _selectedBook;
  DateTime? _expectedReturnDate;
  String _searchQuery = '';

  void _lendBook() {
    if (_selectedBook == null || _personController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a book and enter person name')),
      );
      return;
    }

    final updatedBook = _selectedBook!.lendTo(
      _personController.text.trim(),
      returnDate: _expectedReturnDate,
    );

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
      SnackBar(content: Text('${_selectedBook!.title} lent successfully!')),
    );
    print("Lent book status: ${updatedBook.status}");
    print("All books: ");
    Provider.of<BookProvider>(context, listen: false).books.forEach((b) {
      print("${b.title} - ${b.status}");
    });
    _clearForm();
    Navigator.pop(context);
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

  void _clearForm() {
    _personController.clear();
    setState(() {
      _selectedBook = null;
      _expectedReturnDate = null;
    });
  }

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

  Widget _buildSelectableBookTile(
      Book book, bool isSelected, Function(Book) onTap) {
    return GestureDetector(
      onTap: () => onTap(book),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
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
              : const Icon(Icons.book, color: Colors.blueAccent),
          title: Text(
            book.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.blue.shade700 : Colors.black,
            ),
          ),
          subtitle: Text(
            "${book.author} • ${book.genre ?? 'Unknown Genre'}",
            style: TextStyle(
              color: isSelected ? Colors.blue.shade600 : Colors.grey.shade600,
            ),
          ),
          trailing: isSelected
              ? const Icon(Icons.check_circle, color: Colors.blue)
              : const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }

  void _openLendForm() {
    _clearForm();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final bookProvider =
                Provider.of<BookProvider>(context, listen: false);
            final availableBooks = bookProvider.books
                .where((book) => book.status == BookStatus.owned)
                .where((book) =>
                    book.title
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()) ||
                    book.author
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                top: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lend a Book',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    SearchField(controller: _searchController, onChanged: (value) {  },),
                    const SizedBox(height: 16),
                    if (availableBooks.isEmpty)
                      const Text(
                        'No available books found. Add books to your library first.',
                        style: TextStyle(color: Colors.grey),
                      )
                    else
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: availableBooks.length,
                          itemBuilder: (context, index) {
                            final book = availableBooks[index];
                            final isSelected = _selectedBook?.key == book.key;

                            return _buildSelectableBookTile(
                              book,
                              isSelected,
                              (selectedBook) {
                                setModalState(() {
                                  _selectedBook = selectedBook;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 16),
                    Inputfield(
                      controller: _personController,
                      hintText: 'Lent to (Person\'s name)',
                      keyboardType: TextInputType.text,
                      prefixText: '',
                      validator: (value) => null,
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
                            action: 'Lend Book',
                            onTap: _lendBook,
                            buttonWidth: double.infinity,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
                  ? 'Lent $daysSinceLent days ago'
                  : 'Recently lent',
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
    final lentBooks = bookProvider.books
        .where((book) => book.status == BookStatus.lent)
        .toList();

    lentBooks.sort((a, b) {
      if (a.isOverdue && !b.isOverdue) return -1;
      if (!a.isOverdue && b.isOverdue) return 1;
      if (a.lentDate != null && b.lentDate != null) {
        return b.lentDate!.compareTo(a.lentDate!);
      }
      return 0;
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lentBooks.isNotEmpty) ...[
              Text(
                'Books Currently Lent (${lentBooks.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
            ],
            Expanded(
              child: lentBooks.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.library_books_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("No books lent yet.",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text("Tap + to lend a book from your library",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: lentBooks.length,
                      itemBuilder: (ctx, index) {
                        return _buildLentBookCard(lentBooks[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLendForm,
        tooltip: 'Lend a book',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _personController.dispose();
    _searchController.dispose();
    _scrollController.dispose(); // dispose scroll controller
    super.dispose();
  }
} 
