import 'package:flutter/material.dart';

class Custombutton extends StatefulWidget {
  final String action;
  final VoidCallback onTap;
  final double buttonWidth;

  const Custombutton({
    required this.action,
    required this.onTap,
    required this.buttonWidth,
    Key? key,
  }) : super(key: key);

  @override
  State<Custombutton> createState() => _CustombuttonState();
}

class _CustombuttonState extends State<Custombutton> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.buttonWidth,
      child: TextButton(
        onPressed: () {
          setState(() {
            isSelected = !isSelected; 
          });
          widget.onTap();
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            isSelected ? Colors.deepPurple : Colors.transparent,
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.deepPurple),
            ),
          ),
        ),
        child: Text(
          widget.action,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
