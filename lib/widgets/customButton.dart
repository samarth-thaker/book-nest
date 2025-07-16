import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final String action;
  final VoidCallback onTap;
  final double buttonWidth;

  const Custombutton({required this.action,
    required this.onTap,
    required this.buttonWidth,
    Key?key}):super
    (key:key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: buttonWidth,
      child: TextButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.deepPurple),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        child:  Text(
          action,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}