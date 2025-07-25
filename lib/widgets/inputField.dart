import 'package:flutter/material.dart';
import 'package:flutter/src/services/text_formatter.dart';

class Inputfield extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  //final TextInputType keyboardType;
  const Inputfield({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    //this.keyboardType = TextInputType.number,
    Key? key, required TextInputType keyboardType, required String prefixText, required List<TextInputFormatter> inputFormatters, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        //keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
           
          ),
        ),
      ); 
  } 
}