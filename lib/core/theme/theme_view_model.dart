import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'theme_state.dart';

part 'theme_view_model.g.dart';

@riverpod
class ThemeViewModel extends _$ThemeViewModel {
  @override
  ThemeState build() {
    return ThemeState(
      isDarkMode: false,
      themeData: _getLightTheme(),
    );
  }

  // 테마 변경 메서드
  void toggleTheme() {
    state = ThemeState(
      isDarkMode: !state.isDarkMode,
      themeData: state.isDarkMode ? _getLightTheme() : _getDarkTheme(),
    );
  }

  // 라이트 테마 반환
  ThemeData _getLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  // 다크 테마 반환
  ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
