import 'package:flutter/material.dart';

class CustomTextField {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final int? maxLines;
  final int? maxLength;
  final bool isRequired;

  CustomTextField({
    required this.label,
    this.hintText,
    TextEditingController? controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.isRequired = false,
  }) : controller = controller ?? TextEditingController();
}
