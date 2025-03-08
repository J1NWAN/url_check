import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/inspection_history_model.dart';
import 'package:url_check/features/system/repository/inspection_history_repository.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'dashboard_view_model.g.dart';

class DashboardState {
  final List<Map<String, dynamic>> dashboardResultList; // 최근 점검 결과에 사용
  final List<Map<String, dynamic>> dashboardStatusList; // 최근 시스템 현황에 사용

  final DateTime selectedDate;

  DashboardState({
    this.dashboardResultList = const [],
    this.dashboardStatusList = const [],
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  DashboardState copyWith({
    List<Map<String, dynamic>>? dashboardResultList,
    List<Map<String, dynamic>>? dashboardStatusList,
    DateTime? selectedDate,
  }) {
    return DashboardState(
      dashboardResultList: dashboardResultList ?? this.dashboardResultList,
      dashboardStatusList: dashboardStatusList ?? this.dashboardStatusList,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}

@riverpod
class DashboardViewModel extends _$DashboardViewModel {
  @override
  DashboardState build() {
    initBuild();
    return DashboardState();
  }

  /// ************* 초기 데이터 설정 **************
  Future<void> initBuild() async {
    // 대시보드 결과 리스트 설정
    setDashboardResultList();

    // 대시보드 시스템 현황 리스트 설정
    setDashboardStatusList();
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    setDashboardResultList();
    setDashboardStatusList();
  }

  /// ************* 대시보드 최근 점검 결과 리스트 설정 **************
  void setDashboardResultList() {
    final systemRepository = ref.read(systemRepositoryProvider);
    final inspectionHistoryRepository = ref.read(inspectionHistoryRepositoryProvider);

    // 시스템 메뉴 조회
    final systemMenuList = systemRepository.fetchSystemMenu('all');

    // 가장 최근 점검 이력 리스트와 그 다음 최근 점검 이력 리스트
    List<Map<String, dynamic>> firstInspectionHistoryList = [];
    List<Map<String, dynamic>> secondInspectionHistoryList = [];

    // 완료된 메뉴 수를 추적하기 위한 카운터
    int completedMenus = 0;

    systemMenuList.listen((snapshot) {
      final totalMenus = snapshot.length;

      for (var menu in snapshot) {
        InspectionHistoryModel model = InspectionHistoryModel(
          path: menu.path,
        );

        final searchTime = state.selectedDate;
        final inspectionResultList = inspectionHistoryRepository.fetchLatestInspectionHistoryList(model, searchTime, limit: 2);

        int index = 0;
        inspectionResultList.listen((snapshot) {
          for (var inspectionHistory in snapshot) {
            if (index == 0) {
              if (inspectionHistory.actualStatus == 'OK') {
                firstInspectionHistoryList.add({
                  'title': inspectionHistory.menuName,
                  'path': inspectionHistory.path,
                  'status': inspectionHistory.actualStatus,
                  'responseTime': inspectionHistory.responseTime,
                  'createdAt': inspectionHistory.createdAt,
                });
              }
            } else {
              if (inspectionHistory.actualStatus == 'OK') {
                secondInspectionHistoryList.add({
                  'title': inspectionHistory.menuName,
                  'path': inspectionHistory.path,
                  'status': inspectionHistory.actualStatus,
                  'responseTime': inspectionHistory.responseTime,
                  'createdAt': inspectionHistory.createdAt,
                });
              }
            }
            index++;
          }

          // 메뉴 하나의 처리가 완료될 때마다 카운터 증가
          completedMenus++;

          // 모든 메뉴의 처리가 완료되었을 때 최종 결과 출력
          if (completedMenus == totalMenus) {
            List<Map<String, dynamic>> resultList = [];

            int firstTotalResponseTime = 0;
            int firstErrorCount = 0;
            int firstCompletedTime = 0;

            int secondTotalResponseTime = 0;
            int secondErrorCount = 0;
            int secondCompletedTime = 0;

            for (var history in firstInspectionHistoryList) {
              firstTotalResponseTime += (history['responseTime'] as int? ?? 0);
              final createdAt = history['createdAt'] as DateTime;
              firstCompletedTime = DateTime.now().difference(createdAt).inMinutes;

              if (history['status'] != 'OK') {
                firstErrorCount++;
              }
            }

            for (var history in secondInspectionHistoryList) {
              secondTotalResponseTime += (history['responseTime'] as int? ?? 0);
              final createdAt = history['createdAt'] as DateTime;
              secondCompletedTime = DateTime.now().difference(createdAt).inMinutes;

              if (history['status'] != 'OK') {
                secondErrorCount++;
              }
            }

            /// 평균 응답 시간 계산
            final firstAverageResponseTime =
                firstInspectionHistoryList.isEmpty ? 0 : firstTotalResponseTime / firstInspectionHistoryList.length;
            final secondAverageResponseTime =
                secondInspectionHistoryList.isEmpty ? 0 : secondTotalResponseTime / secondInspectionHistoryList.length;

            // systemCount를 먼저 가져온 후 나머지 로직 실행
            systemRepository.fetchSystemCount().then((systemCount) {
              String firstTitle = '기관홈페이지 외 $systemCount개 시스템';
              String secondTitle = '기관홈페이지 외 $systemCount개 시스템';

              // 첫 번째 점검 이력 리스트 처리
              if (firstErrorCount == 0) {
                resultList.add({
                  'title': firstTitle,
                  'status': 'OK',
                  'avgResponseTime': firstAverageResponseTime.round(),
                  'completedTime': firstCompletedTime,
                });
              } else if (firstErrorCount > 0) {
                resultList.add({
                  'title': firstTitle,
                  'status': 'ERROR',
                  'avgResponseTime': firstAverageResponseTime.round(),
                  'completedTime': firstCompletedTime,
                });
              }

              // 두 번째 점검 이력 리스트 처리
              if (secondErrorCount == 0) {
                resultList.add({
                  'title': secondTitle,
                  'status': 'OK',
                  'avgResponseTime': secondAverageResponseTime.round(),
                  'completedTime': secondCompletedTime,
                });
              } else if (secondErrorCount > 0) {
                resultList.add({
                  'title': secondTitle,
                  'status': 'ERROR',
                  'avgResponseTime': secondAverageResponseTime.round(),
                  'completedTime': secondCompletedTime,
                });
              }

              state = state.copyWith(dashboardResultList: resultList);
            });
          }
        });
      }
    });
  }

  /// ************* 대시보드 최근 시스템 현황 리스트 설정 **************
  void setDashboardStatusList() {
    final systemRepository = ref.read(systemRepositoryProvider);
    final inspectionHistoryRepository = ref.read(inspectionHistoryRepositoryProvider);

    // 시스템 메뉴 조회
    final systemMenuList = systemRepository.fetchSystemMenu('all');

    // 시스템별 성공/실패 카운트를 저장할 Map
    Map<String, Map<String, int>> systemStatusCounts = {};

    systemMenuList.listen((snapshot) {
      final totalMenus = snapshot.length;
      int completedMenus = 0;

      for (var menu in snapshot) {
        InspectionHistoryModel model = InspectionHistoryModel(
          systemCode: menu.systemCode,
          path: menu.path,
        );

        final searchTime = state.selectedDate;
        final inspectionResultList = inspectionHistoryRepository.fetchLatestInspectionHistoryList(model, searchTime);

        inspectionResultList.listen((snapshot) {
          for (var inspectionHistory in snapshot) {
            final systemCode = inspectionHistory.systemCode;

            // 시스템별 카운트 초기화
            if (!systemStatusCounts.containsKey(systemCode)) {
              systemStatusCounts['$systemCode'] = {'successCount': 0, 'errorCount': 0};
            }

            // 상태에 따라 카운트 증가
            if (inspectionHistory.actualStatus == 'OK') {
              systemStatusCounts[systemCode]!['successCount'] = (systemStatusCounts[systemCode]!['successCount'] ?? 0) + 1;
            } else {
              systemStatusCounts[systemCode]!['errorCount'] = (systemStatusCounts[systemCode]!['errorCount'] ?? 0) + 1;
            }
          }

          completedMenus++;

          // 모든 메뉴 처리가 완료되면 결과 저장
          if (completedMenus == totalMenus) {
            // systemCode 길이에 따라 정렬된 리스트 생성
            List<String> sortedSystemCodes = systemStatusCounts.keys.toList();
            sortedSystemCodes.sort((a, b) => a.length.compareTo(b.length));

            // 짧은 코드와 긴 코드를 번갈아가며 새로운 리스트 생성
            List<String> alternatingSystemCodes = [];
            int shortIndex = 0;
            int longIndex = sortedSystemCodes.length - 1;

            while (shortIndex <= longIndex) {
              if (shortIndex == longIndex) {
                alternatingSystemCodes.add(sortedSystemCodes[shortIndex]);
                break;
              }
              alternatingSystemCodes.add(sortedSystemCodes[shortIndex]);
              alternatingSystemCodes.add(sortedSystemCodes[longIndex]);
              shortIndex++;
              longIndex--;
            }

            // 최종 결과 리스트 생성
            List<Map<String, dynamic>> statusList = [];
            for (int i = 0; i < alternatingSystemCodes.length; i++) {
              String systemCode = alternatingSystemCodes[i];
              statusList.add({
                'index': i,
                'systemCode': systemCode,
                'successCount': systemStatusCounts[systemCode]?['successCount'] ?? 0,
                'errorCount': systemStatusCounts[systemCode]?['errorCount'] ?? 0,
              });
            }

            state = state.copyWith(dashboardStatusList: statusList);
          }
        });
      }
    });
  }
}
