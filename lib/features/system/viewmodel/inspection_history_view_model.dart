import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/inspection_history_model.dart';
import 'package:url_check/features/system/repository/inspection_history_repository.dart';

part 'inspection_history_view_model.g.dart';

class InspectionHistoryState {
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<InspectionHistoryModel> inspectionHistoryList;

  InspectionHistoryState({
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.inspectionHistoryList = const [],
  });

  InspectionHistoryState copyWith({
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
    List<InspectionHistoryModel>? inspectionHistoryList,
  }) {
    return InspectionHistoryState(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      inspectionHistoryList: inspectionHistoryList ?? this.inspectionHistoryList,
    );
  }
}

@riverpod
class InspectionHistoryViewModel extends _$InspectionHistoryViewModel {
  @override
  InspectionHistoryState build() {
    // 초기 상태에서는 오늘 날짜를 시작일과 종료일로 설정
    final today = DateTime.now();
    state = InspectionHistoryState(
      startDate: today,
      endDate: today,
    );
    fetchInspectionHistoryList();
    return state;
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchInspectionHistoryList(); // 검색어가 변경될 때마다 조회
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
    );
    fetchInspectionHistoryList(); // 날짜가 변경될 때마다 조회
  }

  // 특정 날짜로 설정하는 메서드 (대시보드에서 이동 시 사용)
  void setSelectedDate(DateTime date) {
    state = state.copyWith(
      startDate: date,
      endDate: date,
    );
    fetchInspectionHistoryList();
  }

  void fetchInspectionHistoryList() {
    final repository = ref.read(inspectionHistoryRepositoryProvider);
    repository
        .fetchInspectionHistoryList(
      startDate: state.startDate,
      endDate: state.endDate,
    )
        .listen((list) {
      // 검색어로 필터링
      final filteredList = list.where((item) {
        final query = state.searchQuery.toLowerCase();
        final menuName = item.menuName?.toLowerCase() ?? '';
        final systemCode = item.systemCode?.toLowerCase() ?? '';
        final path = item.path?.toLowerCase() ?? '';

        return menuName.contains(query) || systemCode.contains(query) || path.contains(query);
      }).toList();

      state = state.copyWith(inspectionHistoryList: filteredList);
    });
  }
}
