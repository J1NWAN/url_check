import 'package:flutter/material.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/features/home/view/home_screen.dart';

class UrlCheckerApp extends StatelessWidget {
  const UrlCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'URL Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        textTheme: CustomTextTheme.theme,
      ),
      home: const HomeScreen(),
    );
  }
}
