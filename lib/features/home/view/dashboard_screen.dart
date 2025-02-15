import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/widget/chart_widget.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('대시보드', style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold)),
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.upload_file_outlined)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.download)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
              ],
            )
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('오늘')),
                    TextButton(onPressed: () {}, child: const Text('주')),
                    TextButton(onPressed: () {}, child: const Text('월')),
                    TextButton(onPressed: () {}, child: const Text('년')),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('최근 점검 결과', style: Theme.of(context).textTheme.titleMedium),
                      ],
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 2, // 최근 5개 결과만 표시
                      separatorBuilder: (context, index) => const Divider(),

                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            print('tapped');
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              index % 2 == 0 ? Icons.sentiment_very_satisfied_rounded : Icons.sentiment_very_dissatisfied_rounded,
                              color: index % 2 == 0 ? Colors.green : Colors.red,
                            ),
                            title: const Text('기관홈페이지 외 10개 시스템', style: TextStyle(fontSize: 14)),
                            subtitle: const Text('평균 응답시간: 245ms', style: TextStyle(fontSize: 12)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '1분 전',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  index % 2 == 0 ? '정상' : '오류',
                                  style: TextStyle(
                                    color: index % 2 == 0 ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('전체 결과 보기', style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_ios, size: 12),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
                color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
              ),
              child: const BarChartSample6(),
            ),
          ],
        ),
      ],
    );
  }

  // 통계 카드 위젯
  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
