import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CustomBookTile extends StatelessWidget {
  final String bookTitle;
  final String author;
  final String genre;

  const CustomBookTile({
    super.key,
    required this.bookTitle,
    required this.author,
    required this.genre,
  });

  Future<void> _showOpenLibraryInfo(BuildContext context, String title, String author) async {
    showDialog(
      context: context,
      builder: (ctx) => const AlertDialog(
        content: SizedBox(
          height: 100,
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    );

    try {
      final queryTitle = Uri.encodeComponent(title);
      final queryAuthor = Uri.encodeComponent(author);
      final searchUrl = 'https://openlibrary.org/search.json?title=$queryTitle&author=$queryAuthor';
      final searchRes = await http.get(Uri.parse(searchUrl));

      if (searchRes.statusCode == 200) {
        final searchData = json.decode(searchRes.body);
        if (searchData['docs'].isNotEmpty) {
          final firstDoc = searchData['docs'][0];
          final workKey = firstDoc['key'];
          final detailUrl = 'https://openlibrary.org$workKey.json';
          final detailRes = await http.get(Uri.parse(detailUrl));
          final detailData = json.decode(detailRes.body);

          Navigator.of(context).pop();

          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(title),
              content: Text(detailData['description'] is String
                  ? detailData['description']
                  : detailData['description']?['value'] ?? 'No description available.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text("Close"),
                ),
              ],
            ),
          );
        } else {
          Navigator.of(context).pop();
          _showErrorDialog(context);
        }
      } else {
        Navigator.of(context).pop();
        _showErrorDialog(context);
      }
    } catch (e) {
      Navigator.of(context).pop();
      _showErrorDialog(context);
    }
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Not Found"),
        content: const Text("Could not find book information."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.book, color: Colors.blueAccent),
        title: Text(
          bookTitle,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        subtitle: Text("$author • $genre"),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 16),
          onPressed: () => _showOpenLibraryInfo(context, bookTitle, author),
          tooltip: 'Fetch Book Info',
        ),
      ),
    );
  }
}
