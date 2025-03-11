import 'package:flutter/material.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';

class SignupCheckboxItem extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final bool isRequired;
  final bool showViewButton;
  final VoidCallback? onViewPressed;

  const SignupCheckboxItem({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    required this.isRequired,
    this.showViewButton = false,
    this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: CustomTextTheme.theme.bodyMedium?.fontSize),
        ),
        const SizedBox(width: 8),
        if (showViewButton)
          InkWell(
            onTap: onViewPressed,
            child: Text(
              '보기',
              style: TextStyle(
                color: Colors.grey,
                fontSize: CustomTextTheme.theme.bodyMedium?.fontSize,
              ),
            ),
          ),
      ],
    );
  }
}
