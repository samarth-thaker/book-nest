import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Custompwdinput extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  const Custompwdinput({Key? key, required this.controller, required this.hintText}) : super(key: key);

  @override
  State<Custompwdinput> createState() => _CustompwdinputState();
}

class _CustompwdinputState extends State<Custompwdinput> {
  bool isHidden = true; 
  
  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        obscureText: isHidden,
        decoration: InputDecoration(
          hintText: widget.hintText, 
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          prefixIcon: Icon(Icons.lock),
          suffixIcon: IconButton(
            icon:
                isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
            onPressed: togglePasswordVisibility,
          ),
        ),
        keyboardType: TextInputType.visiblePassword,
        autofillHints: [AutofillHints.password],
        onEditingComplete: () => TextInput.finishAutofillContext(),
        validator: (password) => password != null && password.length < 6 
            ? 'Enter min. 6 characters'
            : null,
      );
  
  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);
}