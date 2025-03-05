import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/features/system/view/tab/monitoring_tab.dart';
import 'package:url_check/features/system/view/tab/system_list_tab.dart';
import 'package:url_check/features/system/viewmodel/system_list_view_model.dart';
import 'package:url_check/features/system/view/tab/inspection_history_tab.dart';

class SystemScreen extends ConsumerStatefulWidget {
  const SystemScreen({super.key});

  @override
  ConsumerState<SystemScreen> createState() => _SystemScreenState();
}

class _SystemScreenState extends ConsumerState<SystemScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {}); // 탭이 변경될 때 화면을 다시 그립니다
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '시스템 목록'),
              Tab(text: '모니터링'),
              Tab(text: '점검 이력'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                SystemListTab(),
                MonitoringTab(),
                InspectionHistoryTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                ref.read(systemListViewModelProvider.notifier).addSystem(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
