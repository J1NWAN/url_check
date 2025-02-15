import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/view/home_screen.dart';
import 'package:url_check/features/home/viewmodel/home_view_model.dart';
import 'package:url_check/features/setting/view/setting_screen.dart';
import 'package:url_check/features/system/view/system_screen.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String? title;
  final int currentIndex;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentIndex,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: title != null ? Text(title!) : Text('URL\nChecker', style: GoogleFonts.blackOpsOne(fontSize: 16)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        actions: [
          const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/system');
              break;
            case 2:
              context.push('/settings');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.storage), label: '시스템'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
