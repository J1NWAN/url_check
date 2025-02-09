import 'package:flutter/material.dart';

enum SnackBarType {
  success(
    backgroundColor: Color(0xFF2ECC71),
    icon: Icons.check_circle,
  ),
  error(
    backgroundColor: Color(0xFFE74C3C),
    icon: Icons.error,
  ),
  warning(
    backgroundColor: Color(0xFFF1C40F),
    icon: Icons.warning,
  ),
  info(
    backgroundColor: Color(0xFF3498DB),
    icon: Icons.info,
  );

  final Color backgroundColor;
  final IconData icon;

  const SnackBarType({
    required this.backgroundColor,
    required this.icon,
  });
}
