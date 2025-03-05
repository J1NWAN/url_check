import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
        ),
        title: const Text('설정'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('다크 모드'),
            trailing: Switch(
              value: themeState.isDarkMode,
              onChanged: (_) {
                ref.read(themeViewModelProvider.notifier).toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
