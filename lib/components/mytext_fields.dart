import 'package:flutter/material.dart';

class MyTextFields extends StatelessWidget {
  final String mhintText;
  final bool mobsecureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final void Function(String)? onChanged;

  MyTextFields({super.key,
    required this.mhintText,
    required this.mobsecureText, required this.onChanged,this.keyboardType, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged:onChanged,
          obscureText: mobsecureText,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            fillColor: Colors.white,
            filled: true,
            hintText: mhintText,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
