import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/repository/monitoring_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'monitoring_view_model.g.dart';

class MonitoringState {
  final List<SystemModel> systemList;
  final Map<String, Map<String, dynamic>> systemStatuses;
  final List<Map<String, dynamic>> monitoringDetailList;
  final bool isLoading;

  MonitoringState({
    this.systemList = const [],
    this.systemStatuses = const {},
    this.monitoringDetailList = const [],
    this.isLoading = false,
  });

  MonitoringState copyWith({
    List<SystemModel>? systemList,
    Map<String, Map<String, dynamic>>? systemStatuses,
    List<Map<String, dynamic>>? monitoringDetailList,
    bool? isLoading,
  }) {
    return MonitoringState(
      systemList: systemList ?? this.systemList,
      systemStatuses: systemStatuses ?? this.systemStatuses,
      monitoringDetailList: monitoringDetailList ?? this.monitoringDetailList,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class MonitoringViewModel extends _$MonitoringViewModel {
  // 캐시 만료 시간 설정
  static const cacheDuration = Duration(minutes: 5);
  DateTime? _lastFetchTime;

  @override
  MonitoringState build() {
    return MonitoringState(
      systemList: const [],
      systemStatuses: const {},
      isLoading: true,
    );
  }

  void initState() {
    // 캐시가 유효한지 확인
    if (_lastFetchTime == null || DateTime.now().difference(_lastFetchTime!) > cacheDuration) {
      _initMonitoringList();
    }
  }

  Future<void> _initMonitoringList() async {
    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(monitoringRepositoryProvider);
      repository.fetchMonitoringList().listen(
        (systems) async {
          final monitoringList = await repository.fetchLatestMonitoringList(systems);

          // 데이터 처리 및 상태 업데이트
          final processedData = _processMonitoringData(monitoringList);
          state = state.copyWith(
            systemList: systems,
            systemStatuses: processedData,
            isLoading: false,
          );

          // 캐시 시간 업데이트
          _lastFetchTime = DateTime.now();
        },
      );
    } catch (e) {
      print('Error fetching systems: $e');
      state = state.copyWith(isLoading: false);
    }
  }

  // 수동 새로고침을 위한 메서드
  Future<void> refresh() async {
    _lastFetchTime = null;
    await _initMonitoringList();
  }

  Map<String, Map<String, dynamic>> _processMonitoringData(List<Map<String, dynamic>> monitoringList) {
    Map<String, Map<String, dynamic>> monitoringStatus = {};

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
    for (var value in monitoringStatus.values) {
      if (value['errorCount'] > 0) {
        value['status'] = 'ERROR';
      } else {
        value['status'] = 'OK';
      }
    }
    monitoringStatus.forEach((key, value) {
      if (value['responseTime'] != 0) {
        value['responseTime'] = (value['responseTime'] / (value['successCount'] + value['errorCount'])).round();
      }
    });
    return monitoringStatus;
  }

  Future<List<Map<String, dynamic>>> fetchMonitoringDetail(String systemNameEn) async {
    final repository = ref.read(monitoringRepositoryProvider);
    final monitoringDetailList = await repository.fetchMonitoringDetail(systemNameEn);
    print('monitoringDetailList: $monitoringDetailList');
    state = state.copyWith(monitoringDetailList: monitoringDetailList);
    return monitoringDetailList;
  }
}
