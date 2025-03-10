import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:url_check/core/button/model/dropdown_config.dart';

class CustomDropDownButton extends StatelessWidget {
  final String label;
  final List<DropdownConfig> categories;
  final String value;
  final Function(String) onChanged;

  const CustomDropDownButton({
    super.key,
    required this.label,
    required this.categories,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValidValue = categories.any((item) => item.id == value);
    final String currentValue = isValidValue ? value : (categories.isNotEmpty ? categories[0].id : '');

    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        value: currentValue,
        items: categories
            .map((item) => DropdownMenuItem(
                  value: item.id,
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            onChanged(value);
          }
        },
        isExpanded: true,
        hint: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        buttonStyleData: ButtonStyleData(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          isOverButton: false,
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: WidgetStateProperty.all(6),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
