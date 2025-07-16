import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/models/bookModel.dart';
import 'package:booknest/widgets/customButton.dart';
import 'package:booknest/widgets/inputField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookTab extends StatefulWidget {
  const AddBookTab({super.key});

  @override
  State<AddBookTab> createState() => _AddBookTabState();
}

class _AddBookTabState extends State<AddBookTab> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();

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

  void save() {
    final book = Book(
        title: _bookNameController.text,
        author: _authorNameController.text,
        genre: _selectedGenre ?? 'Other');
        
    Provider.of<BookProvider>(context, listen: false).addBook(book);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book added successfully!')),
    );

    _bookNameController.clear();
    _authorNameController.clear();
    setState(() {
      _selectedGenre = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        title: const Text(
          "Add a book",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ), */
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              hint: const Text('Select Genre'),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
            const SizedBox(height: 32),
            Custombutton(
              action: 'Add Book',
              onTap: save,
              buttonWidth: MediaQuery.of(context).size.width * 0.8,
            ),
          ],
        ),
      ),
    );
  }
}
