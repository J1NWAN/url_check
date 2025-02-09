import 'package:flutter/material.dart';

enum ToastType {
  success(
    backgroundColor: Color(0xFF2ECC71),
    icon: Icons.check_circle,
  ),
  error(
    backgroundColor: Color(0xFFE74C3C),
    icon: Icons.error,
  ),
  info(
    backgroundColor: Color(0xFF3498DB),
    icon: Icons.info,
  );

  final Color backgroundColor;
  final IconData icon;

  const ToastType({
    required this.backgroundColor,
    required this.icon,
  });
}
