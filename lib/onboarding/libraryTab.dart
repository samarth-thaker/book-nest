import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/widgets/customBookTile.dart';
import 'package:booknest/widgets/searchField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknest/models/bookModel.dart';

class LibraryTab extends StatefulWidget {
  const LibraryTab({super.key});

  @override
  State<LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookList = Provider.of<BookProvider>(context).books;

    // Filter the list based on the search query
    final _filteredBooks = bookList.where((book) {
      final title = book.title.toLowerCase();
      final author = book.author.toLowerCase();
      final genre = book.genre?.toLowerCase();
      return title.contains(_searchQuery) ||
          author.contains(_searchQuery) ||
          genre!.contains(_searchQuery);
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(controller: _searchController, onChanged: (value) {  },),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredBooks.isEmpty
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.library_books_outlined,
                            size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No books found.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 8),
                        Text("Tap + to add a book to your library",
                            style:
                                TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                  )
                  : ListView.builder(
                      itemCount: _filteredBooks.length,
                      itemBuilder: (ctx, index) {
                        final book = _filteredBooks[index];
                        return CustomBookTile(
                        book: book,
                        showLendingInfo: true,
                        onReturn: (){}, showStatus: true,);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
