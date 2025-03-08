import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/datepicker/custom_date_picker.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/widget/chart_widget.dart';
import 'package:url_check/features/home/viewmodel/dashboard_view_model.dart';
import 'package:url_check/features/system/viewmodel/inspection_history_view_model.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModelProvider);

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomDatePicker(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      initialDate: dashboardState.selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onDateSelected: (date) {
                        ref.read(dashboardViewModelProvider.notifier).updateSelectedDate(date);
                      },
                    ),
                  ),
                ],
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
                        Text('최근 점검 결과', style: CustomTextTheme.theme.bodyLarge),
                      ],
                    ),
                    dashboardState.dashboardResultList.isNotEmpty
                        ? ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: dashboardState.dashboardResultList.length,
                            separatorBuilder: (context, index) => const Divider(),
                            itemBuilder: (context, index) {
                              final result = dashboardState.dashboardResultList[index];
                              final isOk = result['status'] == 'OK';

                              return GestureDetector(
                                onTap: () {
                                  print('tapped');
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(
                                    isOk ? Icons.sentiment_very_satisfied_rounded : Icons.sentiment_very_dissatisfied_rounded,
                                    color: isOk ? Colors.green : Colors.red,
                                  ),
                                  title: Text(result['title'], style: CustomTextTheme.theme.bodyMedium),
                                  subtitle: Text('평균 응답시간: ${result['avgResponseTime']}ms', style: CustomTextTheme.theme.bodySmall),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        getTimeAgo(result['completedTime'] as int),
                                        style: CustomTextTheme.theme.bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        isOk ? '정상' : '오류',
                                        style: TextStyle(
                                          color: isOk ? Colors.green : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const SizedBox(
                            height: 150,
                            child: Center(
                              child: Text('점검 이력이 없습니다.'),
                            ),
                          ),
                    if (dashboardState.dashboardResultList.isNotEmpty)
                      InkWell(
                        onTap: () {
                          // 선택된 날짜를 가지고 점검 이력 탭으로 이동
                          final selectedDate = dashboardState.selectedDate;

                          // 점검 이력 화면으로 이동하면서 선택된 날짜를 extra 파라미터로 전달
                          context.go('/system/history', extra: selectedDate);
                        },
                        child: Padding(
                          padding: EdgeInsets.zero,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('전체 결과 보기', style: CustomTextTheme.theme.bodySmall),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 12),
                            ],
                          ),
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
              child: ref.watch(dashboardViewModelProvider).dashboardStatusList.isNotEmpty
                  ? BarChartSample6(dashboardStatusList: ref.watch(dashboardViewModelProvider).dashboardStatusList)
                  : const Center(
                      child: Text('데이터가 없습니다.'),
                    ),
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

  // 경과 시간을 사람이 읽기 쉬운 형태로 변환하는 메소드
  String getTimeAgo(int minutes) {
    if (minutes < 1) return '1분 전';
    if (minutes < 60) return '$minutes분 전';
    if (minutes < 24 * 60) return '${(minutes / 60).floor()}시간 전';
    if (minutes < 30 * 24 * 60) return '${(minutes / (24 * 60)).floor()}일 전';
    if (minutes < 12 * 30 * 24 * 60) return '${(minutes / (30 * 24 * 60)).floor()}개월 전';
    return '${(minutes / (12 * 30 * 24 * 60)).floor()}년 전';
  }
}
