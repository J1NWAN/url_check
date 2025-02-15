import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/view/dashboard_screen.dart';
import 'package:url_check/features/home/view/url_analysis_screen.dart';
import 'package:url_check/features/home/viewmodel/home_view_model.dart';
import 'package:url_check/features/setting/view/setting_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 10,
        title: Text('URL\nChecker', style: GoogleFonts.blackOpsOne(fontSize: 16)),
        backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
        surfaceTintColor: Colors.transparent, // 스크롤 시 색상 오버레이 제거
        scrolledUnderElevation: 0, // 스크롤 시 그림자 제거
        actions: [
          const SizedBox(),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: PageView(
            scrollDirection: Axis.vertical,
            controller: viewModel.pageController,
            onPageChanged: (page) {
              ref.read(homeViewModelProvider.notifier).onPageChanged(page);
            },
            children: const [
              DashboardScreen(),
              UrlAnalysisScreen(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            viewModel.pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
