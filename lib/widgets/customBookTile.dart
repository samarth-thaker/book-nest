import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/bookModel.dart';

class CustomBookTile extends StatelessWidget {
  final Book book;
  final VoidCallback? onReturn;
  final bool showLendingInfo;

  const CustomBookTile({
    super.key,
    required this.book,
    this.onReturn,
    this.showLendingInfo = false, required bool showStatus,
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
            : Icon(
                showLendingInfo ? Icons.book_outlined : Icons.book,
                color: showLendingInfo ? Colors.teal : Colors.blueAccent,
              ),
        title: Text(
          book.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${book.author} • ${book.genre}"),
            if (showLendingInfo && book.isLent) ...[
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
          ],
        ),
        trailing: showLendingInfo && book.isLent
            ? Row(
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
                      if (value == 'return' && onReturn != null) {
                        onReturn!();
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
              )
            : IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () => _showOpenLibraryInfo(context, book.title, book.author),
                tooltip: 'Fetch Book Info',
              ),
        isThreeLine: showLendingInfo && book.isLent,
      ),
    );
  }
}