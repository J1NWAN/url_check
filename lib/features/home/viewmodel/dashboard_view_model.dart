import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/inspection_history_model.dart';
import 'package:url_check/features/system/repository/inspection_history_repository.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'dashboard_view_model.g.dart';

class DashboardState {
  final List<Map<String, dynamic>> inspectionResultList;
  final List<Map<String, dynamic>> dashboardResultList;
  final DateTime selectedDate;

  DashboardState({
    this.inspectionResultList = const [],
    this.dashboardResultList = const [],
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  DashboardState copyWith({
    List<Map<String, dynamic>>? inspectionResultList,
    List<Map<String, dynamic>>? dashboardResultList,
    DateTime? selectedDate,
  }) {
    return DashboardState(
      inspectionResultList: inspectionResultList ?? this.inspectionResultList,
      dashboardResultList: dashboardResultList ?? this.dashboardResultList,
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
    final systemRepository = ref.read(systemRepositoryProvider);
    final inspectionHistoryRepository = ref.read(inspectionHistoryRepositoryProvider);

    // 대시보드 결과 리스트 설정
    setDashboardResultList();
  }

  /// ************* 대시보드 결과 리스트 설정 **************
  void setDashboardResultList() {
    final systemRepository = ref.read(systemRepositoryProvider);
    final inspectionHistoryRepository = ref.read(inspectionHistoryRepositoryProvider);

    final systemCount = systemRepository.fetchSystemCount();

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

        final searchTime = DateTime.now();
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
            print('최종 firstInspectionHistoryList: $firstInspectionHistoryList\n');
            print('최종 secondInspectionHistoryList: $secondInspectionHistoryList\n');

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
            final firstAverageResponseTime = firstTotalResponseTime / firstInspectionHistoryList.length;
            final secondAverageResponseTime = secondTotalResponseTime / secondInspectionHistoryList.length;

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
}
