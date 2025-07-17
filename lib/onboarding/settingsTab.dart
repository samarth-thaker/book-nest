import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:booknest/providers/bookProvider.dart';
//import 'package:booknest/providers/lendingProvider.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final TextEditingController _noteController = TextEditingController();
  late Box<String> _notesBox;
  int? _editingNoteKey;

  @override
  void initState() {
    super.initState();
    _openNotesBox();
  }

  Future<void> _openNotesBox() async {
    _notesBox = await Hive.openBox<String>('notes');
    setState(() {});
  }

  void _exportBooks(BuildContext context) {
    final books = Provider.of<BookProvider>(context, listen: false).books;
    //final lentBooks = Provider.of<LendingProvider>(context, listen: false).lentBooks;

    String exportText = '--- My Library ---\n';
    for (var book in books) {
      exportText += '${book.title} by ${book.author} [${book.genre}]\n';
    }

    exportText += '\n--- Lent Books ---\n';
    /* for (var lent in lentBooks) {
      exportText += '${lent.title} to ${lent.lentTo} [${lent.genre}]\n';
     }*/

    Share.share(exportText);
  }

  void _saveNote() {
    final note = _noteController.text.trim();
    if (note.isEmpty) return;

    if (_editingNoteKey != null) {
      _notesBox.put(_editingNoteKey, note);
    } else {
      _notesBox.add(note);
    }

    _noteController.clear();
    _editingNoteKey = null;
    setState(() {});
  }

  void _editNoteDialog(int key, String currentNote) {
    _noteController.text = currentNote;
    setState(() {
      _editingNoteKey = key;
    });
  }

  void _deleteNoteDialog(int key) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Note"),
        content: const Text("Are you sure you want to delete this note?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _notesBox.delete(key);
              Navigator.pop(ctx);
              setState(() {});
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(int key, String note) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.rate_review, color: Colors.blue),
        title: Text(note, style: const TextStyle(fontSize: 14)),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _editNoteDialog(key, note);
            } else if (value == 'delete') {
              _deleteNoteDialog(key);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'edit', child: Text("Edit")),
            const PopupMenuItem(value: 'delete', child: Text("Delete")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final notes = _notesBox.toMap();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Export Your Data", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _exportBooks(context),
                icon: const Icon(Icons.share),
                label: const Text("Export Books & Lending Data"),
              ),
              const SizedBox(height: 24),
              const Text("Personal Notes / Reviews", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: "Write your thoughts, reviews, or anything else...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(_editingNoteKey != null ? "Update Note" : "Save Note"),
                ),
              ),
              const SizedBox(height: 24),
              if (notes.isNotEmpty)
                const Text("Saved Notes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...notes.entries.map((entry) => _buildReviewCard(entry.key, entry.value)).toList(),
            ],
          ),
        ),
      ),
    );
  }
}