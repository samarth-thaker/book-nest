import 'package:booknest/widgets/customButton.dart';
import 'package:flutter/material.dart';

Widget buildSelectableButton(
    Custombutton button, bool isSelected, Function(Custombutton) onTap) {
  return GestureDetector(
    onTap: ()=>onTap(button),
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.blue.shade50 : Colors.white,
        ),
        child: button,
    ),
  );
}
