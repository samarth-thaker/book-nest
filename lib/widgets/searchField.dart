import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  const SearchField({required this.controller,Key?key, required Null Function(dynamic value) onChanged}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search books...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
