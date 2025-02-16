import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'system_list_view_model.g.dart';

enum ViewType {
  list,
  grid,
}

class SystemListState {
  final ViewType viewType;
  final String searchQuery;

  SystemListState({
    this.viewType = ViewType.list,
    this.searchQuery = '',
  });

  SystemListState copyWith({
    ViewType? viewType,
    String? searchQuery,
  }) {
    return SystemListState(
      viewType: viewType ?? this.viewType,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@riverpod
class SystemListViewModel extends _$SystemListViewModel {
  @override
  SystemListState build() {
    return SystemListState();
  }

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.list ? ViewType.grid : ViewType.list,
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}
