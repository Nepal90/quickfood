import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
