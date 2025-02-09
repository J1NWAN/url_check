import 'package:flutter/material.dart';

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
    String? confirmText,
    String? cancelText,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(confirmText),
            ),
        ],
      ),
    );
  }
}
