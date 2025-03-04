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
    print('initMonitoringList');
    state = state.copyWith(isLoading: true);

    // 시스템별 성공/실패 카운트를 저장할 Map
    Map<String, Map<String, dynamic>> monitoringStatus = {};

    try {
      final repository = ref.read(monitoringRepositoryProvider);
      repository.fetchMonitoringList().listen(
        (systems) async {
          state = state.copyWith(
            systemList: systems,
            isLoading: false,
          );

          repository.fetchLatestMonitoringList(systems).then((monitoringList) {
            for (final monitoring in monitoringList) {
              // 시스템별 카운트 초기화
              if (!monitoringStatus.containsKey(monitoring['systemCode'])) {
                monitoringStatus['${monitoring['systemCode']}'] = {
                  'successCount': 0,
                  'errorCount': 0,
                  'responseTime': 0,
                };
              } else if (monitoringStatus.containsKey(monitoring['systemCode'])) {}
              // 시스템 정보 저장
              monitoringStatus['${monitoring['systemCode']}']!['systemNameKo'] = monitoring['systemNameKo'];
              monitoringStatus['${monitoring['systemCode']}']!['systemNameEn'] = monitoring['systemNameEn'];
              monitoringStatus['${monitoring['systemCode']}']!['systemUrl'] = monitoring['systemUrl'];
              monitoringStatus['${monitoring['systemCode']}']!['systemCode'] = monitoring['systemCode'];
              monitoringStatus['${monitoring['systemCode']}']!['actualStatus'] = monitoring['actualStatus'];
              monitoringStatus['${monitoring['systemCode']}']!['responseTime'] =
                  (monitoringStatus['${monitoring['systemCode']}']!['responseTime'] ?? 0) + monitoring['responseTime'];

              // 기존 응답시간에 새로운 응답시간을 더하고 평균 계산
              monitoringStatus['${monitoring['systemCode']}']!['createdAt'] =
                  (monitoring['createdAt'] as Timestamp).toDate().toString().substring(0, 16);

              // 상태에 따라 카운트 증가
              if (monitoring['actualStatus'] == 'OK') {
                monitoringStatus['${monitoring['systemCode']}']!['successCount'] =
                    (monitoringStatus['${monitoring['systemCode']}']!['successCount'] ?? 0) + 1;
              } else {
                monitoringStatus['${monitoring['systemCode']}']!['errorCount'] =
                    (monitoringStatus['${monitoring['systemCode']}']!['errorCount'] ?? 0) + 1;
              }
            }

            monitoringStatus.forEach((key, value) {
              if (value['responseTime'] != 0) {
                value['responseTime'] = (value['responseTime'] / (value['successCount'] + value['errorCount'])).round();
              }
            });
            print(monitoringStatus);
            state = state.copyWith(systemStatuses: monitoringStatus);
          });
        },
      );
    } catch (e) {
      print('Error fetching systems: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
