import 'package:flutter/material.dart';

class DropdownItem<T> {
  final T value;
  final String label;
  final Widget? icon;

  DropdownItem({
    required this.value,
    required this.label,
    this.icon,
  });
}

class DropdownConfig<T> {
  final String title;
  final List<DropdownItem<T>> items;
  final T? initialValue;
  final String? confirmText;
  final String? cancelText;

  const DropdownConfig({
    required this.title,
    required this.items,
    this.initialValue,
    this.confirmText,
    this.cancelText,
  });
}
