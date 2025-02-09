import 'package:flutter/material.dart';
import 'package:url_check/core/snackbar/custom_snackbar_overlay.dart';
import 'package:url_check/core/snackbar/enum/snackbar_position.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/snackbar/model/snackbar_config.dart';

/// 커스텀 스낵바
///
/// 사용법
///
/// CustomSnackBar.show(
///   context,
///   title: '제목',
///   message: '메시지',
///   type: 타입,
///   position: 위치,
///   duration: 지속시간,
class CustomSnackBar {
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    SnackBarType type = SnackBarType.success,
    SnackBarPosition position = SnackBarPosition.top,
    Duration? duration,
  }) {
    final config = SnackBarConfig(
      title: title,
      message: message,
      type: type,
      position: position,
      duration: duration ?? const Duration(seconds: 3),
    );

    final overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CustomSnackBarOverlay(
        config: config,
        onDismiss: () => overlayEntry.remove(),
      ),
    );

    overlayState.insert(overlayEntry);
  }
}
