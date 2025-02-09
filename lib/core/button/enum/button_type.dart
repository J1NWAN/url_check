import 'package:flutter/material.dart';

enum ButtonType {
  primary(
    backgroundColor: Color(0xFF3498DB),
    textColor: Colors.white,
  ),
  secondary(
    backgroundColor: Color(0xFF95A5A6),
    textColor: Colors.white,
  ),
  success(
    backgroundColor: Color(0xFF2ECC71),
    textColor: Colors.white,
  ),
  danger(
    backgroundColor: Color(0xFFE74C3C),
    textColor: Colors.white,
  ),
  outline(
    backgroundColor: Colors.transparent,
    textColor: Color(0xFF3498DB),
    borderColor: Color(0xFF3498DB),
  );

  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;

  const ButtonType({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
  });
}
