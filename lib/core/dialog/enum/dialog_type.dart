import 'package:flutter/material.dart';

enum DialogType {
  normal(
    backgroundColor: Colors.white,
    icon: Icons.info_outline,
  ),
  warning(
    backgroundColor: Color(0xFFFFF3E0),
    icon: Icons.warning_amber,
  ),
  error(
    backgroundColor: Color(0xFFFFEBEE),
    icon: Icons.error_outline,
  );

  final Color backgroundColor;
  final IconData icon;

  const DialogType({
    required this.backgroundColor,
    required this.icon,
  });
}
