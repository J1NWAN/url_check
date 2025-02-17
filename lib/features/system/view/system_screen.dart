import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/features/system/view/tab/monitoring_tab.dart';
import 'package:url_check/features/system/view/tab/system_list_tab.dart';
import 'package:url_check/features/system/viewmodel/system_list_view_model.dart';
import 'package:url_check/features/system/view/tab/inspection_history_tab.dart';

class SystemScreen extends ConsumerWidget {
  const SystemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: const Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: '시스템 목록'),
                Tab(text: '모니터링'),
                Tab(text: '점검 이력'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  SystemListTab(),
                  MonitoringTab(),
                  InspectionHistoryTab(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(systemListViewModelProvider.notifier).addSystem(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
