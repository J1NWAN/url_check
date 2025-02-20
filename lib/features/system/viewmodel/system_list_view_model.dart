import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/textfield/model/text_field_config.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'system_list_view_model.g.dart';

enum ViewType {
  list,
  grid,
}

class SystemListState {
  final List<SystemModel> systemList;
  final ViewType viewType;
  final String searchQuery;
  final bool isLoading;

  SystemListState({
    this.systemList = const [],
    this.viewType = ViewType.list,
    this.searchQuery = '',
    this.isLoading = false,
  });

  SystemListState copyWith({
    List<SystemModel>? systemList,
    ViewType? viewType,
    String? searchQuery,
    bool? isLoading,
  }) {
    return SystemListState(
      systemList: systemList ?? this.systemList,
      viewType: viewType ?? this.viewType,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class SystemListViewModel extends _$SystemListViewModel {
  @override
  SystemListState build() {
    // 초기 상태만 반환하고, 스트림 구독은 별도 메서드로 분리
    return SystemListState(
      systemList: const [],
      viewType: ViewType.list,
      searchQuery: '',
      isLoading: true,
    );
  }

  // initState 메서드 추가
  void initState() {
    _initSystems();
  }

  Future<void> _initSystems() async {
    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(systemRepositoryProvider);
      repository.fetchSystems().listen((systems) {
        final filteredSystems = systems.where((system) {
          final searchLower = state.searchQuery.toLowerCase();
          final nameKo = system.systemNameKo?.toLowerCase() ?? '';
          final nameEn = system.systemNameEn?.toLowerCase() ?? '';
          return nameKo.contains(searchLower) || nameEn.contains(searchLower);
        }).toList();

        state = state.copyWith(
          systemList: filteredSystems,
          isLoading: false,
        );
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _initSystems();
  }

  void toggleViewType() {
    state = state.copyWith(
      viewType: state.viewType == ViewType.list ? ViewType.grid : ViewType.list,
    );
  }

  void addSystem(BuildContext context) {
    final krNameController = TextEditingController();
    final enNameController = TextEditingController();

    CustomDialog.show(
      context,
      title: '시스템 추가',
      content: '추가할 시스템 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '시스템 한글명',
          hintText: '예시: 기관홈페이지',
          controller: krNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: '시스템 영문명',
          hintText: '예시: WWW',
          controller: enNameController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
      ],
      confirmText: '추가',
      cancelText: '취소',
      onConfirm: () {
        // 입력된 값 사용
        final krName = krNameController.text;
        final enName = enNameController.text;

        print(krName);
        print(enName);

        // ...
        if (krName.isNotEmpty && enName.isNotEmpty) {
          // 데이터베이스에 저장
          final repository = ref.read(systemRepositoryProvider);
          repository.createSystem(SystemModel(
            id: enName,
            systemNameKo: krName,
            systemNameEn: enName,
          ));

          CustomSnackBar.show(
            context,
            title: '완료',
            message: '시스템이 추가되었습니다.',
            type: SnackBarType.success,
          );
        }
      },
    );
  }

  void deleteSystem(BuildContext context, String id) {
    CustomDialog.show(
      context,
      title: '삭제',
      content: '삭제하시겠습니까?',
      showIcon: false,
      confirmText: '삭제',
      cancelText: '취소',
      onConfirm: () {
        // 데이터베이스에서 삭제
        final repository = ref.read(systemRepositoryProvider);
        repository.deleteSystem(id);
        CustomSnackBar.show(
          context,
          title: '완료',
          message: '시스템이 삭제되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }

  void editSystem(BuildContext context, String id) {
    final krNameController = TextEditingController();
    final enNameController = TextEditingController();
    final urlController = TextEditingController();

    CustomDialog.show(
      context,
      title: '수정',
      content: '수정할 시스템 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '시스템 한글명',
          hintText: '예시: 기관홈페이지',
          controller: krNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: '시스템 영문명',
          hintText: '예시: WWW',
          controller: enNameController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
        CustomTextField(
          label: 'URL',
          hintText: '예시: https://www.kins.re.kr',
          controller: urlController,
          keyboardType: TextInputType.url,
        ),
      ],
      confirmText: '수정',
      cancelText: '취소',
      onConfirm: () {
        // 데이터베이스에서 수정
        final repository = ref.read(systemRepositoryProvider);
        repository.updateSystem(SystemModel(
          id: id,
          systemNameKo: krNameController.text,
          systemNameEn: enNameController.text,
        ));
        CustomSnackBar.show(
          context,
          title: '완료',
          message: '시스템이 수정되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }
}
