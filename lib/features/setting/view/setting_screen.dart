import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('로그아웃', style: TextStyle(color: Colors.red)),
            onTap: () {
              CustomDialog.show(
                context,
                title: '로그아웃',
                content: '정말 로그아웃 하시겠습니까?',
                showIcon: false,
                confirmText: '로그아웃',
                cancelText: '취소',
                onConfirm: () {
                  context.go('/login');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
