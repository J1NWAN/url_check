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

    return SizedBox.expand(
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
    );
  }
}
