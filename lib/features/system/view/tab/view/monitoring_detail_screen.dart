import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/viewmodel/monitoring_view_model.dart';

class MonitoringDetailScreen extends ConsumerStatefulWidget {
  final SystemModel system;

  const MonitoringDetailScreen({
    super.key,
    required this.system,
  });

  @override
  ConsumerState<MonitoringDetailScreen> createState() => _MonitoringDetailScreenState();
}

class _MonitoringDetailScreenState extends ConsumerState<MonitoringDetailScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(monitoringViewModelProvider.notifier).fetchMonitoringDetail(widget.system.systemNameEn ?? '');
  }

  @override
  Widget build(BuildContext context) {
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
            child: Text(widget.system.systemNameKo ?? '', style: CustomTextTheme.theme.bodyLarge),
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
                    value: ref.watch(monitoringViewModelProvider).monitoringDetailList.length.toString(),
                    icon: Icons.menu,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    title: '정상',
                    value: ref
                        .watch(monitoringViewModelProvider)
                        .monitoringDetailList
                        .where((element) => element['actual_status'] == 'OK')
                        .length
                        .toString(),
                    icon: Icons.check_circle,
                    valueColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryItem(
                    context,
                    title: '오류',
                    value: ref
                        .watch(monitoringViewModelProvider)
                        .monitoringDetailList
                        .where((element) => element['actual_status'] == 'ERROR')
                        .length
                        .toString(),
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
              itemCount: ref.watch(monitoringViewModelProvider).monitoringDetailList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final menu = ref.watch(monitoringViewModelProvider).monitoringDetailList[index];

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
                            color: menu['actual_status'] == 'OK' ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                menu['menu_name'],
                                style: CustomTextTheme.theme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                menu['path'],
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
                            _buildDetailRow('마지막 점검', (menu['created_at'] as Timestamp).toDate().toString().substring(0, 16)),
                            _buildDetailRow('응답 시간', '${menu['response_time']}초'),
                            _buildDetailRow('상태 코드', menu['actual_status']),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton.icon(
                                  onPressed: () {
                                    // 메뉴 열기
                                  },
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('열기'),
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
              Icon(icon, size: 16, color: valueColor),
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
