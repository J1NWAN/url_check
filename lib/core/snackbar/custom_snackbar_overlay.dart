import 'package:flutter/material.dart';
import 'package:url_check/core/snackbar/enum/snackbar_position.dart';
import 'package:url_check/core/snackbar/model/snackbar_config.dart';

class CustomSnackBarOverlay extends StatefulWidget {
  final SnackBarConfig config;
  final VoidCallback onDismiss;

  const CustomSnackBarOverlay({
    super.key,
    required this.config,
    required this.onDismiss,
  });

  @override
  State<CustomSnackBarOverlay> createState() => _CustomSnackBarOverlayState();
}

class _CustomSnackBarOverlayState extends State<CustomSnackBarOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    final beginOffset = widget.config.position == SnackBarPosition.top ? const Offset(0, -1) : const Offset(0, 1);

    _offsetAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    Future.delayed(widget.config.duration, () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.config.position == SnackBarPosition.top ? 0 : null,
      bottom: widget.config.position == SnackBarPosition.bottom ? 0 : null,
      left: 0,
      right: 0,
      child: SafeArea(
        child: SlideTransition(
          position: _offsetAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: widget.config.type.backgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              widget.config.type.icon,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DefaultTextStyle(
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                child: Text(
                                  widget.config.title,
                                ),
                              ),
                            ),
                            const SizedBox(width: 24), // 닫기 버튼 공간
                          ],
                        ),
                        if (widget.config.message.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          DefaultTextStyle(
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            child: Text(
                              widget.config.message,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: GestureDetector(
                      onTap: () {
                        _controller.reverse().then((_) => widget.onDismiss());
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
