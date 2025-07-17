import 'package:booknest/providers/bookProvider.dart';
import 'package:booknest/models/bookModel.dart';
import 'package:booknest/widgets/customButton.dart';
import 'package:booknest/widgets/inputField.dart';
import 'package:booknest/widgets/selectableButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddBookTab extends StatefulWidget {
  const AddBookTab({super.key});

  @override
  State<AddBookTab> createState() => _AddBookTabState();
}

class _AddBookTabState extends State<AddBookTab> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _isbnController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _pageCountController = TextEditingController();
  final TextEditingController _publicationYearController =
      TextEditingController();
  final TextEditingController _purchasePriceController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  String? _selectedGenre;
  BookStatus _selectedStatus = BookStatus.owned;
  double _rating = 0.0;
  DateTime? _purchaseDate;
  File? _coverImage;
  int selectedIndex = -1;
  List<String> actions = ['Clear', 'Submit'];
  final List<String> _genres = [
    'Fiction',
    'Non-Fiction',
    'Biography',
    'Science',
    'Fantasy',
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

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _coverImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _selectPurchaseDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _purchaseDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _purchaseDate = picked;
      });
    }
  }

  void _clearForm() {
    _bookNameController.clear();
    _authorNameController.clear();
    _isbnController.clear();
    _publisherController.clear();
    _pageCountController.clear();
    _publicationYearController.clear();
    _purchasePriceController.clear();
    _notesController.clear();
    setState(() {
      _selectedGenre = null;
      _selectedStatus = BookStatus.owned;
      _rating = 0.0;
      _purchaseDate = null;
      _coverImage = null;
    });
  }

  void save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final book = Book(
      title: _bookNameController.text.trim(),
      author: _authorNameController.text.trim(),
      genre: _selectedGenre ?? 'Other',
      isbn: _isbnController.text.trim().isEmpty
          ? null
          : _isbnController.text.trim(),
      coverImagePath: _coverImage?.path,
      status: _selectedStatus,
    );

    Provider.of<BookProvider>(context, listen: false).addBook(book);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Book added successfully!')),
    );

    _clearForm();
  }

  Widget _buildRatingSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rating',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _rating = index + 1.0;
                });
              },
              child: Icon(
                index < _rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 30,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Book Cover',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 120,
            width: 90,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: _coverImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      _coverImage!,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          size: 30, color: Colors.grey),
                      Text('Add Cover', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Basic Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Inputfield(
                controller: _bookNameController,
                hintText: 'Book Name *',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter book name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                prefixText: '',
                inputFormatters: [],
              ),
              const SizedBox(height: 16),
              Inputfield(
                controller: _authorNameController,
                hintText: 'Author *',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter author name';
                  }
                  return null;
                },
                keyboardType: TextInputType.text,
                prefixText: '',
                inputFormatters: [],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGenre,
                hint: const Text('Select Genre *'),
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
                validator: (value) {
                  if (value == null) {
                    return 'Please select a genre';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              const Text(
                'Additional Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Inputfield(
                      controller: _publisherController,
                      hintText: 'Publisher (Optional)',
                      keyboardType: TextInputType.text,
                      inputFormatters: [],
                      prefixText: '',
                      validator: (value) {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Inputfield(
                      controller: _publicationYearController,
                      hintText: 'Year (Optional)',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      prefixText: '',
                      validator: (value) {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 24),
              const SizedBox(height: 16),
              const SizedBox(height: 32),
              Row(
                children: [
                   Expanded(
                    child: Custombutton(
                      onTap: _clearForm,
                      action: 'Clear Form',
                      buttonWidth: double.infinity,
                    ),
                  ), 
                  const SizedBox(width: 16),
                  Expanded(
                    child: Custombutton(
                      onTap: save,
                      action: 'Add book',
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
  }

  @override
  void dispose() {
    _bookNameController.dispose();
    _authorNameController.dispose();
    _isbnController.dispose();
    _publisherController.dispose();
    _pageCountController.dispose();
    _publicationYearController.dispose();
    _purchasePriceController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
