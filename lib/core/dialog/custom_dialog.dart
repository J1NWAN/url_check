import 'package:flutter/material.dart';
import 'package:url_check/core/dialog/custom_dialog_overlay.dart';
import 'package:url_check/core/dialog/enum/dialog_type.dart';
import 'package:url_check/core/dialog/model/dialog_config.dart';
import 'package:url_check/core/dialog/model/dropdown_config.dart';
import 'package:url_check/core/dialog/dropdown_dialog_overlay.dart';

/*
 * 커스텀 다이얼로그
 * 
 * 사용법
 * 
 * CustomDialog.show(
 *   context,
 *   title: '제목',
 *   content: '내용',
 *   confirmText: '확인 버튼 텍스트',
 *   cancelText: '취소 버튼 텍스트',
 * );
 */
class CustomDialog {
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    DialogType type = DialogType.normal,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final config = DialogConfig(
      title: title,
      content: content,
      type: type,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
    );

    return showDialog<bool>(
      context: context,
      builder: (context) => CustomDialogOverlay(config: config),
    );
  }

  static Future<T?> dropDown<T>(
    BuildContext context, {
    required String title,
    required List<DropdownItem<T>> items,
    T? initialValue,
    String? confirmText,
    String? cancelText,
  }) async {
    final config = DropdownConfig<T>(
      title: title,
      items: items,
      initialValue: initialValue,
      confirmText: confirmText,
      cancelText: cancelText,
    );

    return showDialog<T>(
      context: context,
      builder: (context) => DropdownDialogOverlay<T>(config: config),
    );
  }
}
