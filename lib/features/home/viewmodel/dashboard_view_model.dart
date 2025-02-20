import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/button/model/dropdown_config.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'dashboard_view_model.g.dart';

class DashboardState {
  final List<DropdownConfig> systems;
  final String? selectedSystemId;

  DashboardState({
    this.systems = const [],
    this.selectedSystemId,
  });

  DashboardState copyWith({
    List<DropdownConfig>? systems,
    String? selectedSystemId,
  }) {
    return DashboardState(
      systems: systems ?? this.systems,
      selectedSystemId: selectedSystemId ?? this.selectedSystemId,
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

  Future<void> _initSystems() async {
    final repository = ref.watch(systemRepositoryProvider);
    final systems = repository.fetchSystems();

    systems.listen((snapshot) {
      final systems = snapshot.map((doc) {
        return DropdownConfig(
          id: doc.id,
          name: doc.systemNameKo ?? '',
          color: '0xFF808080',
        );
      }).toList();

      state = state.copyWith(
        systems: systems,
        selectedSystemId: systems.isNotEmpty ? systems[0].id : null,
      );
    });
  }

  void updateSelectedSystem(String systemId) {
    state = state.copyWith(selectedSystemId: systemId);
  }
}
