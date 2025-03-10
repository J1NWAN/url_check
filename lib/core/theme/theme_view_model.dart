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
      //primaryColor: const Color.fromRGBO(47, 112, 243, 1.0),
      colorScheme: ColorScheme.fromSeed(
        primary: const Color.fromRGBO(47, 112, 243, 1.0),
        seedColor: const Color.fromRGBO(47, 112, 243, 1.0),
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
  }

  // 다크 테마 반환
  ThemeData _getDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      //primaryColor: const Color.fromRGBO(47, 112, 243, 1.0),
      colorScheme: ColorScheme.fromSeed(
        primary: const Color.fromRGBO(47, 112, 243, 1.0),
        seedColor: const Color.fromRGBO(47, 112, 243, 1.0),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    );
  }
}
