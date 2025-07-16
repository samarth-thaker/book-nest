import 'package:booknest/models/lentBookModel.dart';
import 'package:booknest/providers/lendingProvider.dart';
import 'package:booknest/widgets/customButton.dart';
import 'package:booknest/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LendingTab extends StatefulWidget {
  const LendingTab({super.key});

  @override
  State<LendingTab> createState() => _LendingTabState();
}

class _LendingTabState extends State<LendingTab> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _personController = TextEditingController();

  String? _selectedGenre;
  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Biography',
    'Science',
    'Fantasy',
    'Mystery',
    'Romance',
    'Other'
  ];

  void lend() {
    final lentBook = LentBook(
      title: _bookNameController.text.trim(),
      author: _authorNameController.text.trim(),
      genre: _selectedGenre ?? 'Other',
      lentTo: _personController.text.trim(),
    );

    Provider.of<LendingProvider>(context, listen: false).addLentBook(lentBook);

    _bookNameController.clear();
    _authorNameController.clear();
    _personController.clear();
    setState(() => _selectedGenre = null);

    Navigator.pop(context); // Close the bottom sheet after lending
  }

  void _openLendForm() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Inputfield(
                  controller: _bookNameController,
                  hintText: 'Book Name',
                ),
                const SizedBox(height: 16),
                Inputfield(
                  controller: _authorNameController,
                  hintText: 'Author',
                ),
                const SizedBox(height: 16),
                Inputfield(
                  controller: _personController,
                  hintText: 'Lent to',
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
                ),
                const SizedBox(height: 24),
                Custombutton(
                  action: 'Lend Book',
                  onTap: lend, // ✅ FIXED: use the right function
                  buttonWidth: MediaQuery.of(context).size.width * 0.8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLentBookCard(LentBook book) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.book_outlined, color: Colors.teal),
        title: Text(book.title),
        subtitle: Text('To: ${book.lentTo} • ${book.genre}'),
        trailing: const Icon(Icons.person),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lentBooks = Provider.of<LendingProvider>(context).lentBooks;

    return Scaffold(
     /*  appBar: AppBar(
        title: const Text(
          "Lent Books",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ), */
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: lentBooks.isEmpty
            ? const Center(child: Text("No books lent yet."))
            : ListView.builder(
                itemCount: lentBooks.length,
                itemBuilder: (ctx, index) {
                  return _buildLentBookCard(lentBooks[index]);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLendForm,
        child: const Icon(Icons.add),
        tooltip: 'Lend a book',
      ),
    );
  }
}
