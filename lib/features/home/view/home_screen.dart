import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/features/home/view/dashboard_screen.dart';
import 'package:url_check/features/home/view/url_analysis_screen.dart';
import 'package:url_check/features/home/viewmodel/home_view_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('URL Checker'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent, // 스크롤 시 색상 오버레이 제거
        scrolledUnderElevation: 0, // 스크롤 시 그림자 제거
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
