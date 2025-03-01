import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/button/model/dropdown_config.dart';
import 'package:url_check/features/system/model/inspection_history_model.dart';
import 'package:url_check/features/system/repository/inspection_history_repository.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'dashboard_view_model.g.dart';

class DashboardState {
  final List<DropdownConfig> systems;
  final String? selectedSystemId;
  final List<Map<String, dynamic>> inspectionResultList;
  final List<Map<String, dynamic>> dashboardResultList;
  final DateTime selectedDate;

  DashboardState({
    this.systems = const [],
    this.selectedSystemId,
    this.inspectionResultList = const [],
    this.dashboardResultList = const [],
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  DashboardState copyWith({
    List<DropdownConfig>? systems,
    String? selectedSystemId,
    List<Map<String, dynamic>>? inspectionResultList,
    List<Map<String, dynamic>>? dashboardResultList,
    DateTime? selectedDate,
  }) {
    return DashboardState(
      systems: systems ?? this.systems,
      selectedSystemId: selectedSystemId ?? this.selectedSystemId,
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
    _initSystems();
    return DashboardState();
  }

  void updateSelectedDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      inspectionResultList: [],
      dashboardResultList: [],
    );
    _fetchInspectionResults();
  }

  void updateSelectedSystem(String systemId) {
    state = state.copyWith(
      selectedSystemId: systemId,
      inspectionResultList: [],
      dashboardResultList: [],
    );
    _fetchInspectionResults();
  }

  Future<void> _fetchInspectionResults() async {
    final repository = ref.watch(systemRepositoryProvider);
    final inspectionHistoryRepository = ref.watch(inspectionHistoryRepositoryProvider);

    // 결과 리스트 초기화
    state = state.copyWith(
      inspectionResultList: [],
      dashboardResultList: [],
    );

    print('점검 결과 조회 시작: ${state.selectedDate}');

    // 시스템 목록이 비어있는 경우 처리
    if (state.systems.isEmpty) {
      print('시스템 목록이 비어 있습니다.');
      return;
    }

    // 시스템별 결과를 저장할 Map (systemId -> 상태)
    Map<String, String> systemStatusMap = {};
    // 시스템별 응답 시간을 저장할 Map (systemId -> 응답시간 리스트)
    Map<String, List<int>> systemResponseTimeMap = {};

    // 처리 완료된 시스템 수를 추적하기 위한 카운터
    final totalSystems = state.systems.length;
    int processedSystems = 0;

    print('총 시스템 수: $totalSystems');

    // 모든 시스템 처리 완료 여부를 확인하고 대시보드 결과를 생성하는 함수
    void checkAllSystemsProcessed() {
      print('처리된 시스템: $processedSystems / $totalSystems');

      if (processedSystems >= totalSystems) {
        print('모든 시스템 처리 완료. 최종 결과: ${state.inspectionResultList}');
        _generateDashboardResults();
      }
    }

    // 각 시스템에 대한 결과를 업데이트하는 함수
    void updateSystemResult(String systemId, String systemName) {
      // 평균 응답 시간 계산
      double avgResponseTime = 0;
      final responseTimeList = systemResponseTimeMap[systemId] ?? [];
      if (responseTimeList.isNotEmpty) {
        int sum = responseTimeList.reduce((a, b) => a + b);
        avgResponseTime = sum / responseTimeList.length;
        print('$systemName의 평균 응답시간: $avgResponseTime ms');
      } else {
        print('$systemName의 응답시간 데이터 없음');
      }

      // 임시 결과 리스트 생성
      List<Map<String, dynamic>> updatedResultList = [...state.inspectionResultList];

      // 이미 해당 시스템의 결과가 있는지 확인
      int existingIndex = updatedResultList.indexWhere((item) => item['systemId'] == systemId);

      Map<String, dynamic> resultItem = {
        'systemId': systemId,
        'systemName': systemName,
        'actualStatus': systemStatusMap[systemId] ?? 'OK',
        'responseTime': avgResponseTime.round(),
      };

      if (existingIndex >= 0) {
        // 기존 결과 업데이트
        updatedResultList[existingIndex] = resultItem;
      } else {
        // 새 결과 추가
        updatedResultList.add(resultItem);
      }

      // 상태 업데이트
      state = state.copyWith(inspectionResultList: updatedResultList);

      // 처리된 시스템 수 증가
      processedSystems++;

      // 모든 시스템 처리 완료 여부 확인
      checkAllSystemsProcessed();
    }

    // 각 시스템에 대해 처리
    for (var system in state.systems) {
      final systemId = system.id ?? '';
      final systemName = system.name;

      // 초기 상태는 OK로 설정
      systemStatusMap[systemId] = 'OK';
      // 응답 시간 리스트 초기화
      systemResponseTimeMap[systemId] = [];

      print('시스템 메뉴 조회 시작: $systemName');

      try {
        final systemMenuList = repository.fetchSystemMenu(systemId);

        systemMenuList.listen((systemMenus) {
          // 시스템의 모든 메뉴를 처리한 후 최종 상태를 결정하기 위한 카운터
          int menuCount = systemMenus.length;
          int processedCount = 0;

          print('$systemName의 메뉴 수: $menuCount');

          // 메뉴가 없는 경우 바로 처리 완료로 표시
          if (menuCount == 0) {
            print('$systemName은 메뉴가 없음.');
            updateSystemResult(systemId, systemName);
            return;
          }

          for (var systemMenu in systemMenus) {
            InspectionHistoryModel inspectionHistoryModel = InspectionHistoryModel(
              systemCode: systemMenu.systemCode,
              path: systemMenu.path,
            );

            print('점검 이력 조회: ${systemMenu.systemCode}/${systemMenu.path}');

            try {
              // 선택된 날짜로 점검 이력 조회
              inspectionHistoryRepository.fetchLatestInspectionHistoryList(inspectionHistoryModel, state.selectedDate).listen(
                  (inspectionHistoryList) {
                if (inspectionHistoryList.isEmpty) {
                  print('${systemMenu.path} 점검 이력 없음');
                  return;
                }

                processedCount++;

                print('${systemMenu.path} 처리 중: $processedCount / $menuCount');

                if (inspectionHistoryList.isNotEmpty) {
                  final status = inspectionHistoryList.first.actualStatus;
                  final responseTime = inspectionHistoryList.first.responseTime;

                  // 하나라도 ERROR가 있으면 시스템 상태를 ERROR로 설정
                  if (status != 'OK') {
                    systemStatusMap[systemId] = 'ERROR';
                  }

                  // 응답 시간이 있으면 리스트에 추가
                  if (responseTime != null) {
                    systemResponseTimeMap[systemId]!.add(responseTime);
                  }
                }

                // 모든 메뉴가 처리되었을 때 해당 시스템의 결과 업데이트
                if (processedCount >= menuCount) {
                  print('$systemName의 모든 메뉴 처리 완료');
                  updateSystemResult(systemId, systemName);
                }
              }, onError: (error) {
                print('점검 이력 조회 오류: $error');
                processedCount++;

                // 오류가 발생해도 모든 메뉴 처리 완료 확인
                if (processedCount >= menuCount) {
                  updateSystemResult(systemId, systemName);
                }
              }, onDone: () {
                print('${systemMenu.path} 점검 이력 조회 완료');
              });
            } catch (e) {
              print('점검 이력 조회 예외: $e');
              processedCount++;

              // 예외가 발생해도 모든 메뉴 처리 완료 확인
              if (processedCount >= menuCount) {
                updateSystemResult(systemId, systemName);
              }
            }
          }
        }, onError: (error) {
          print('시스템 메뉴 조회 오류: $error');
          updateSystemResult(systemId, systemName);
        }, onDone: () {
          print('$systemName 메뉴 조회 완료');
        });
      } catch (e) {
        print('시스템 메뉴 조회 예외: $e');
        updateSystemResult(systemId, systemName);
      }
    }

    // 일정 시간 후에도 모든 시스템이 처리되지 않았다면 강제로 대시보드 결과 생성
    Future.delayed(const Duration(seconds: 10), () {
      if (processedSystems < totalSystems) {
        print('시간 초과: 일부 시스템만 처리됨 ($processedSystems / $totalSystems)');
        _generateDashboardResults();
      }
    });
  }

  // 대시보드용 결과 생성 메소드
  void _generateDashboardResults() {
    print('대시보드 결과 생성 시작');

    // 이미 대시보드 결과가 생성되었는지 확인
    if (state.dashboardResultList.isNotEmpty) {
      print('대시보드 결과가 이미 생성되어 있습니다.');
      return;
    }

    // 결과가 없는 경우 처리
    if (state.inspectionResultList.isEmpty) {
      print('점검 결과가 없습니다.');
      state = state.copyWith(dashboardResultList: []);
      return;
    }

    // 결과를 상태(OK/ERROR)별로 그룹화
    Map<String, List<Map<String, dynamic>>> groupedResults = {
      'OK': [],
      'ERROR': [],
    };

    // 결과를 상태별로 분류
    for (var result in state.inspectionResultList) {
      String status = result['actualStatus'] ?? 'OK';
      groupedResults[status]!.add(result);
    }

    // 각 그룹을 생성 시간 기준으로 정렬 (최신순)
    // 참고: 여기서는 실제 생성 시간 정보가 없으므로 임의로 현재 시간 사용
    DateTime now = DateTime.now();

    // 대시보드용 결과 리스트 생성
    List<Map<String, dynamic>> dashboardResults = [];

    // ERROR 그룹 처리 (있는 경우)
    if (groupedResults['ERROR']!.isNotEmpty) {
      // 평균 응답 시간 계산
      int totalResponseTime = 0;
      for (var result in groupedResults['ERROR']!) {
        totalResponseTime += (result['responseTime'] as int? ?? 0);
      }
      double avgResponseTime = groupedResults['ERROR']!.isNotEmpty ? totalResponseTime / groupedResults['ERROR']!.length : 0;

      // 첫 번째 시스템 이름 가져오기
      String firstSystemName = groupedResults['ERROR']![0]['systemName'] ?? '';
      int otherSystemCount = groupedResults['ERROR']!.length - 1;

      // 대시보드용 결과 항목 생성
      dashboardResults.add({
        'title': otherSystemCount > 0 ? '$firstSystemName 외 $otherSystemCount개 시스템' : firstSystemName,
        'completedTime': now,
        'avgResponseTime': avgResponseTime.round(),
        'status': 'ERROR',
      });
    }

    // OK 그룹 처리 (있는 경우)
    if (groupedResults['OK']!.isNotEmpty) {
      // 평균 응답 시간 계산
      int totalResponseTime = 0;
      for (var result in groupedResults['OK']!) {
        totalResponseTime += (result['responseTime'] as int? ?? 0);
      }
      double avgResponseTime = groupedResults['OK']!.isNotEmpty ? totalResponseTime / groupedResults['OK']!.length : 0;

      // 첫 번째 시스템 이름 가져오기
      String firstSystemName = groupedResults['OK']![0]['systemName'] ?? '';
      int otherSystemCount = groupedResults['OK']!.length - 1;

      // 대시보드용 결과 항목 생성
      dashboardResults.add({
        'title': otherSystemCount > 0 ? '$firstSystemName 외 $otherSystemCount개 시스템' : firstSystemName,
        'completedTime': now.subtract(const Duration(minutes: 5)), // 임의로 5분 전으로 설정
        'avgResponseTime': avgResponseTime.round(),
        'status': 'OK',
      });
    }

    // 최대 2개만 유지
    if (dashboardResults.length > 2) {
      dashboardResults = dashboardResults.sublist(0, 2);
    }

    // 상태 업데이트
    state = state.copyWith(dashboardResultList: dashboardResults);
    print('대시보드용 결과 생성 완료: $dashboardResults');
  }

  Future<void> _initSystems() async {
    final repository = ref.watch(systemRepositoryProvider);
    final systems = repository.fetchSystems();

    systems.listen((snapshot) {
      final systems = snapshot.map((doc) {
        return DropdownConfig(
          id: doc.id!,
          name: doc.systemNameKo ?? '',
          color: '0xFF808080',
        );
      }).toList();

      state = state.copyWith(
        systems: systems,
        selectedSystemId: systems.isNotEmpty ? systems[0].id : null,
      );

      _fetchInspectionResults();
    });
  }
}
