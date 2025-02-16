import 'package:flutter/material.dart';
import 'package:url_check/core/button/custom_dropdown_button.dart';
import 'package:url_check/core/textfield/model/text_field_config.dart';

class DialogConfig {
  final String title;
  final String content;
  final CustomDropDownButton? dropdown;
  final List<CustomTextField>? textFields;
  final Color? backgroundColor;
  final IconData? icon;
  final bool showIcon;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  DialogConfig({
    required this.title,
    required this.content,
    this.dropdown,
    this.textFields,
    this.backgroundColor,
    this.icon,
    this.showIcon = true,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });
}
