import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/features/system/view/system_detail_screen.dart';

class MonitoringTab extends ConsumerWidget {
  const MonitoringTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 상단 요약 정보
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: '전체 시스템',
                  value: '10',
                  icon: Icons.devices,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: '정상',
                  value: '8',
                  icon: Icons.check_circle,
                  valueColor: Colors.green,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  title: '오류',
                  value: '2',
                  icon: Icons.error,
                  valueColor: Colors.red,
                ),
              ),
            ],
          ),
        ),

        // 실시간 모니터링 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                    side: const BorderSide(color: Colors.transparent),
                  ),
                  title: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index % 3 == 0 ? Colors.red : Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '기관홈페이지 (WWW)',
                        style: CustomTextTheme.theme.bodyLarge,
                      ),
                    ],
                  ),
                  subtitle: Text(
                    'https://www.kins.re.kr',
                    style: CustomTextTheme.theme.bodySmall,
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildDetailRow('마지막 점검', '2024-03-21 15:30:00'),
                          _buildDetailRow('응답 시간', '1.2초'),
                          _buildDetailRow('상태 코드', '200 OK'),
                          _buildDetailRow('금일 가용성', '99.9%'),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // 알림 설정
                                },
                                icon: const Icon(Icons.notifications),
                                label: const Text('알림 설정'),
                              ),
                              const SizedBox(width: 16),
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SystemDetailScreen(
                                        systemName: '기관홈페이지 (WWW)',
                                        systemUrl: 'https://www.kins.re.kr',
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.analytics),
                                label: const Text('상세 통계'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16),
              const SizedBox(width: 8),
              Text(title, style: CustomTextTheme.theme.bodySmall),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: CustomTextTheme.theme.headlineMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: CustomTextTheme.theme.bodyMedium),
          Text(value, style: CustomTextTheme.theme.bodyMedium),
        ],
      ),
    );
  }
}
