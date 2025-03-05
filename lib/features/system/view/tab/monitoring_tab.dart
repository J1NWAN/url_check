import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/features/system/viewmodel/monitoring_view_model.dart';

class MonitoringTab extends ConsumerStatefulWidget {
  const MonitoringTab({super.key});

  @override
  ConsumerState<MonitoringTab> createState() => _MonitoringTabState();
}

class _MonitoringTabState extends ConsumerState<MonitoringTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // 탭 변경 시 상태를 유지하도록 변경

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // 의존성이 변경될 때마다 데이터 로드
  }

  void _loadData() {
    Future.microtask(() {
      ref.read(monitoringViewModelProvider.notifier).initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAliveClientMixin 사용 시 필요

    final state = ref.watch(monitoringViewModelProvider);
    final systemEntries = state.systemStatuses.entries.toList();

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(monitoringViewModelProvider.notifier).refresh();
      },
      child: Column(
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
                    value: systemEntries.length.toString(),
                    icon: Icons.devices,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '정상',
                    value: state.systemStatuses.values.where((system) => system['status'] == 'OK').length.toString(),
                    icon: Icons.check_circle,
                    valueColor: Colors.green,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildSummaryCard(
                    context,
                    title: '오류',
                    value: state.systemStatuses.values.where((system) => system['status'] == 'ERROR').length.toString(),
                    icon: Icons.error,
                    valueColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          // 실시간 모니터링 목록
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(), // RefreshIndicator를 위해 필요
                    padding: const EdgeInsets.all(16),
                    itemCount: systemEntries.length,
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
                                  color: systemEntries[index].value['errorCount'] > 0 ? Colors.red : Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                systemEntries[index].value['systemNameKo'] ?? '',
                                style: CustomTextTheme.theme.bodyLarge,
                              ),
                            ],
                          ),
                          subtitle: Text(
                            systemEntries[index].value['systemUrl'] ?? '',
                            style: CustomTextTheme.theme.bodySmall,
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildDetailRow('마지막 점검', systemEntries[index].value['createdAt'] ?? ''),
                                  _buildDetailRow('응답 시간', '${systemEntries[index].value['responseTime']}ms'),
                                  _buildDetailRow('상태 코드', systemEntries[index].value['actualStatus'] ?? ''),
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
                                          context.push('/system/monitoring/detail');
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => const SystemDetailScreen(
                                          //       systemName: '기관홈페이지 (WWW)',
                                          //       systemUrl: 'https://www.kins.re.kr',
                                          //     ),
                                          //   ),
                                          // );
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
      ),
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
