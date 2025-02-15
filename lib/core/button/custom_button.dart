import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'enum/button_type.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final double? width;
  final double height;
  final bool isLoading;
  final IconData? icon;
  final double borderRadius;
  final EdgeInsets padding;

  const CustomButton._({
    super.key,
    required this.text,
    this.onPressed,
    required this.type,
    this.width,
    this.height = 48,
    this.isLoading = false,
    this.icon,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  // Primary Button
  factory CustomButton.primary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double height = 48,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsets? padding,
  }) {
    return CustomButton._(
      text: text,
      onPressed: onPressed,
      type: ButtonType.primary,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // Secondary Button
  factory CustomButton.secondary({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double height = 48,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsets? padding,
  }) {
    return CustomButton._(
      text: text,
      onPressed: onPressed,
      type: ButtonType.secondary,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // Success Button
  factory CustomButton.success({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double height = 48,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsets? padding,
  }) {
    return CustomButton._(
      text: text,
      onPressed: onPressed,
      type: ButtonType.success,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // Danger Button
  factory CustomButton.danger({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double height = 48,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsets? padding,
  }) {
    return CustomButton._(
      text: text,
      onPressed: onPressed,
      type: ButtonType.danger,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  // Outline Button
  factory CustomButton.outline({
    required String text,
    VoidCallback? onPressed,
    double? width,
    double height = 48,
    bool isLoading = false,
    IconData? icon,
    double borderRadius = 8,
    EdgeInsets? padding,
  }) {
    return CustomButton._(
      text: text,
      onPressed: onPressed,
      type: ButtonType.outline,
      width: width,
      height: height,
      isLoading: isLoading,
      icon: icon,
      borderRadius: borderRadius,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isLoading ? null : widget.onPressed,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Ink(
            decoration: BoxDecoration(
              color: widget.type.backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: widget.type.borderColor != null ? Border.all(color: widget.type.borderColor!) : null,
            ),
            child: Center(
              child: Padding(
                padding: widget.padding,
                child: widget.isLoading
                    ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            widget.type.textColor,
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.icon != null) ...[
                            Icon(
                              widget.icon,
                              color: widget.type.textColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(
                            widget.text,
                            style: GoogleFonts.notoSansKr(
                              color: widget.type.textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
