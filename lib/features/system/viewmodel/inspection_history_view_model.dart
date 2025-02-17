import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inspection_history_view_model.g.dart';

class InspectionHistoryState {
  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;

  InspectionHistoryState({
    this.searchQuery = '',
    this.startDate,
    this.endDate,
  });

  InspectionHistoryState copyWith({
    String? searchQuery,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return InspectionHistoryState(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}

@riverpod
class InspectionHistoryViewModel extends _$InspectionHistoryViewModel {
  @override
  InspectionHistoryState build() {
    return InspectionHistoryState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      startDate: start,
      endDate: end,
    );
  }
}
