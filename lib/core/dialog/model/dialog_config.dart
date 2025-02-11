import 'package:flutter/material.dart';
import 'package:url_check/core/dialog/enum/dialog_type.dart';

class DialogConfig {
  final String title;
  final String content;
  final DialogType type;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const DialogConfig({
    required this.title,
    required this.content,
    this.type = DialogType.normal,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });
}
