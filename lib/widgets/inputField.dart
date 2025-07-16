import 'package:flutter/material.dart';

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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
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