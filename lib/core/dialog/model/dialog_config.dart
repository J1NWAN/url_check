import 'package:flutter/material.dart';
import 'package:url_check/core/button/custom_dropdown_button.dart';
import 'package:url_check/core/dialog/enum/dialog_type.dart';

class DialogConfig {
  final String title;
  final String content;
  final Color? backgroundColor;
  final IconData? icon;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final CustomDropDownButton? dropdown;
  final bool? showIcon;

  const DialogConfig({
    required this.title,
    required this.content,
    this.backgroundColor,
    this.icon,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.dropdown,
    this.showIcon = true,
  });
}
