import 'package:flutter/material.dart';
import 'package:url_check/core/button/custom_button.dart';
import 'package:url_check/core/dialog/model/dialog_config.dart';

class CustomDialogOverlay extends StatefulWidget {
  final DialogConfig config;

  const CustomDialogOverlay({
    super.key,
    required this.config,
  });

  @override
  State<CustomDialogOverlay> createState() => _CustomDialogOverlayState();
}

class _CustomDialogOverlayState extends State<CustomDialogOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: widget.config.backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.config.showIcon ?? true)
                    Icon(
                      widget.config.icon,
                      size: 48,
                      color: Colors.grey[800],
                    ),
                  if (widget.config.showIcon ?? true) const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.config.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.config.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.left,
                    ),
                  ),
                  if (widget.config.dropdown != null) ...[
                    const SizedBox(height: 24),
                    widget.config.dropdown!,
                  ],
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (widget.config.cancelText != null)
                        CustomButton.danger(
                          text: widget.config.cancelText!,
                          height: 40,
                          onPressed: () {
                            widget.config.onCancel?.call();
                            Navigator.of(context).pop(false);
                          },
                        ),
                      if (widget.config.confirmText != null) ...[
                        const SizedBox(width: 8),
                        CustomButton.primary(
                          text: widget.config.confirmText!,
                          height: 40,
                          onPressed: () {
                            widget.config.onConfirm?.call();
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    ],
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
