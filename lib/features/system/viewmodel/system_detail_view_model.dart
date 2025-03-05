import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/textfield/model/text_field_config.dart';
import 'package:url_check/features/system/model/system_menu_model.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'system_detail_view_model.g.dart';

class SystemDetailState {
  final List<SystemMenuModel> systemMenuList;
  final String searchQuery;
  final bool isGridView;
  final bool isLoading;

  SystemDetailState({
    this.systemMenuList = const [],
    this.searchQuery = '',
    this.isGridView = false,
    this.isLoading = false,
  });

  SystemDetailState copyWith({
    List<SystemMenuModel>? systemMenuList,
    String? searchQuery,
    bool? isGridView,
    bool? isLoading,
  }) {
    return SystemDetailState(
      systemMenuList: systemMenuList ?? this.systemMenuList,
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@riverpod
class SystemDetailViewModel extends _$SystemDetailViewModel {
  @override
  SystemDetailState build() {
    // 초기 상태만 반환하고, 스트림 구독은 별도 메서드로 분리
    return SystemDetailState(
      systemMenuList: const [],
      isLoading: true,
      searchQuery: '',
      isGridView: false,
    );
  }

  // initState 메서드 추가
  void initState(String systemCode) {
    _initSystemMenu(systemCode);
  }

  Future<void> _initSystemMenu(String systemCode) async {
    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(systemRepositoryProvider);
      repository.fetchSystemMenu(systemCode).listen((systems) {
        final filteredSystems = systems.where((system) {
          final searchLower = state.searchQuery.toLowerCase();
          final menuName = system.menuName?.toLowerCase() ?? '';
          final path = system.path?.toLowerCase() ?? '';
          return menuName.contains(searchLower) || path.contains(searchLower);
        }).toList();

        state = state.copyWith(
          systemMenuList: filteredSystems,
          isLoading: false,
        );
      });
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleViewType() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  void addSystemMenu(BuildContext context, String systemCode) {
    if (systemCode.isEmpty) {
      CustomSnackBar.show(
        context,
        title: '오류',
        message: '시스템 코드를 불러올 수 없습니다.',
        type: SnackBarType.error,
      );
      return;
    }

    final menuNameController = TextEditingController();
    final pathController = TextEditingController();

    CustomDialog.show(
      context,
      title: '메뉴 등록',
      content: '등록할 메뉴 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '메뉴명',
          hintText: '예시: 메인화면',
          controller: menuNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: 'PATH',
          hintText: '예시: /index',
          controller: pathController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
      ],
      confirmText: '등록',
      cancelText: '취소',
      onConfirm: () {
        final repository = ref.read(systemRepositoryProvider);
        final systemMenu = SystemMenuModel(
          menuName: menuNameController.text,
          systemCode: systemCode,
          path: pathController.text,
          createdAt: DateTime.now(),
        );
        repository.createSystemMenu(systemMenu);

        CustomSnackBar.show(
          context,
          title: '완료',
          message: '메뉴가 등록되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }

  void editSystemMenu(BuildContext context, SystemMenuModel systemMenu) {
    final menuNameController = TextEditingController(text: systemMenu.menuName);
    final pathController = TextEditingController(text: systemMenu.path);

    CustomDialog.show(
      context,
      title: '메뉴 수정',
      content: '수정할 메뉴 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '메뉴명',
          hintText: '예시: 메인페이지',
          controller: menuNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: 'URL',
          hintText: '예시: https://www.kins.re.kr/main',
          controller: pathController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
      ],
      confirmText: '수정',
      cancelText: '취소',
      onConfirm: () {
        final repository = ref.read(systemRepositoryProvider);
        final model = SystemMenuModel(
          menuName: menuNameController.text,
          systemCode: systemMenu.systemCode,
          path: pathController.text,
          updatedAt: DateTime.now(),
        );
        repository.updateSystemMenu(model, systemMenu.id!);

        CustomSnackBar.show(
          context,
          title: '완료',
          message: '메뉴가 수정되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }

  void deleteSystemMenu(BuildContext context, String docId) {
    CustomDialog.show(
      context,
      title: '메뉴 삭제',
      content: '선택한 메뉴를 삭제하시겠습니까?',
      showIcon: false,
      confirmText: '삭제',
      cancelText: '취소',
      onConfirm: () {
        final repository = ref.read(systemRepositoryProvider);
        repository.deleteSystemMenu(docId);

        CustomSnackBar.show(
          context,
          title: '완료',
          message: '메뉴가 삭제되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }
}
