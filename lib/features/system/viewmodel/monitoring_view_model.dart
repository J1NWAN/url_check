import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/repository/monitoring_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'monitoring_view_model.g.dart';

class MonitoringState {
  final List<SystemModel> systemList;
  final Map<String, Map<String, dynamic>> systemStatuses;
  final bool isLoading;

  MonitoringState({
    this.systemList = const [],
    this.systemStatuses = const {},
    this.isLoading = false,
  });

  MonitoringState copyWith({
    List<SystemModel>? systemList,
    Map<String, Map<String, dynamic>>? systemStatuses,
    bool? isLoading,
  }) {
    return MonitoringState(
      systemList: systemList ?? this.systemList,
      systemStatuses: systemStatuses ?? this.systemStatuses,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class MonitoringViewModel extends _$MonitoringViewModel {
  @override
  MonitoringState build() {
    return MonitoringState(
      systemList: const [],
      systemStatuses: const {},
      isLoading: true,
    );
  }

  void initState() {
    _initMonitoringList();
  }

  Future<void> _initMonitoringList() async {
    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(monitoringRepositoryProvider);
      repository.fetchMonitoringList().listen(
        (systems) async {
          state = state.copyWith(
            systemList: systems,
            isLoading: false,
          );
          repository.fetchLatestCheckHistory(systems).then((errorList) {
            print('Error list: $errorList');
          });
        },
      );
    } catch (e) {
      print('Error fetching systems: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
