import 'package:flutter/material.dart';

class ThemeState {
  final bool isDarkMode;
  final ThemeData themeData;

  ThemeState({
    required this.isDarkMode,
    required this.themeData,
  });

  ThemeState copyWith({
    bool? isDarkMode,
    ThemeData? themeData,
  }) {
    return ThemeState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeData: themeData ?? this.themeData,
    );
  }
}
