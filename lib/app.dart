import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/view/home_screen.dart';

class UrlCheckerApp extends ConsumerWidget {
  const UrlCheckerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return MaterialApp(
      title: 'URL Checker',
      theme: themeState.themeData,
      home: const HomeScreen(),
    );
  }
}
