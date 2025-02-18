import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/textfield/model/text_field_config.dart';

part 'system_detail_view_model.g.dart';

class SystemDetailState {
  final String searchQuery;
  final bool isGridView;

  SystemDetailState({
    this.searchQuery = '',
    this.isGridView = false,
  });

  SystemDetailState copyWith({
    String? searchQuery,
    bool? isGridView,
  }) {
    return SystemDetailState(
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
    );
  }
}

@riverpod
class SystemDetailViewModel extends _$SystemDetailViewModel {
  @override
  SystemDetailState build() {
    return SystemDetailState();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleViewType() {
    state = state.copyWith(isGridView: !state.isGridView);
  }

  void addMenu(BuildContext context) {
    final krNameController = TextEditingController();
    final urlController = TextEditingController();

    CustomDialog.show(
      context,
      title: '메뉴 등록',
      content: '등록할 메뉴 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '메뉴명',
          hintText: '예시: 메인페이지',
          controller: krNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: 'URL',
          hintText: '예시: https://www.kins.re.kr/main',
          controller: urlController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
      ],
      confirmText: '등록',
      cancelText: '취소',
      onConfirm: () {
        // 메뉴 등록 로직
        CustomSnackBar.show(
          context,
          title: '완료',
          message: '메뉴가 등록되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }

  void editMenu(BuildContext context, String id) {
    final krNameController = TextEditingController();
    final urlController = TextEditingController();

    CustomDialog.show(
      context,
      title: '메뉴 수정',
      content: '수정할 메뉴 정보를 입력해주세요.',
      showIcon: false,
      textFields: [
        CustomTextField(
          label: '메뉴명',
          hintText: '예시: 메인페이지',
          controller: krNameController,
          isRequired: true,
        ),
        CustomTextField(
          label: 'URL',
          hintText: '예시: https://www.kins.re.kr/main',
          controller: urlController,
          keyboardType: TextInputType.url,
          isRequired: true,
        ),
      ],
      confirmText: '수정',
      cancelText: '취소',
      onConfirm: () {
        // 메뉴 수정 로직
        CustomSnackBar.show(
          context,
          title: '완료',
          message: '메뉴가 수정되었습니다.',
          type: SnackBarType.success,
        );
      },
    );
  }

  void deleteMenu(BuildContext context, String id) {
    CustomDialog.show(
      context,
      title: '메뉴 삭제',
      content: '선택한 메뉴를 삭제하시겠습니까?',
      showIcon: false,
      confirmText: '삭제',
      cancelText: '취소',
      onConfirm: () {
        // 메뉴 삭제 로직
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
