import 'package:flutter/material.dart';
import 'package:url_check/core/button/custom_dropdown_button.dart';
import 'package:url_check/core/dialog/custom_dialog_overlay.dart';
import 'package:url_check/core/dialog/enum/dialog_type.dart';
import 'package:url_check/core/dialog/model/dialog_config.dart';

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
    CustomDropDownButton? dropdown,
    DialogType type = DialogType.normal,
    bool showIcon = true,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    final config = DialogConfig(
      title: title,
      content: content,
      dropdown: dropdown,
      type: type,
      showIcon: showIcon,
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
}
