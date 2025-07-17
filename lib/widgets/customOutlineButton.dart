import 'package:flutter/material.dart';

class Customoutlinebutton extends StatelessWidget {
  final String action;
  final VoidCallback onTap;
  final double buttonWidth;
  const Customoutlinebutton({required this.action,
    required this.onTap,
    required this.buttonWidth,
    Key?key}):super
    (key:key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(onPressed: onTap, child: Text(action)),
    );
  }
}