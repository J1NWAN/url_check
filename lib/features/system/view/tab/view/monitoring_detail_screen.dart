import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';

class SystemDetailScreen extends ConsumerWidget {
  final String systemName;
  final String systemUrl;

  const SystemDetailScreen({
    super.key,
    required this.systemName,
    required this.systemUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '상세 통계',
          style: GoogleFonts.notoSansKr(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            width: double.infinity,
            child: Text(systemName, style: CustomTextTheme.theme.bodyLarge),
          ),
          // 시스템 요약 정보
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    title: '전체 메뉴',
                    value: '15',
                    icon: Icons.menu,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    title: '정상',
                    value: '13',
                    icon: Icons.check_circle,
                    valueColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
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

          // 메뉴 목록
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 15,
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
                            color: index % 5 == 0 ? Colors.red : Colors.green,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '공지사항',
                                style: CustomTextTheme.theme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '$systemUrl/notice',
                                style: CustomTextTheme.theme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailRow('마지막 점검', '2024-03-21 15:30:00'),
                            _buildDetailRow('응답 시간', '0.8초'),
                            _buildDetailRow('상태 코드', '200 OK'),
                            _buildDetailRow('금일 가용성', '99.9%'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // 메뉴 수정
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text('수정'),
                                ),
                                const SizedBox(width: 16),
                                TextButton.icon(
                                  onPressed: () {
                                    // 메뉴 삭제
                                  },
                                  icon: const Icon(Icons.delete),
                                  label: const Text('삭제'),
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
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
