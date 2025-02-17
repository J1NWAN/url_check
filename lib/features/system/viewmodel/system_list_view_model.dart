import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/textfield/model/text_field_config.dart';
import 'package:url_check/core/theme/theme_view_model.dart';

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

  void addSystem(BuildContext context) {
    final krNameController = TextEditingController();
    final enNameController = TextEditingController();
    final urlController = TextEditingController();

    CustomDialog.show(
      context,
      title: '시스템 추가',
      content: '추가할 시스템 정보를 입력해주세요.',
      showIcon: false,
      backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
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
      confirmText: '추가',
      cancelText: '취소',
      onConfirm: () {
        // 입력된 값 사용
        final krName = krNameController.text;
        final enName = enNameController.text;
        final url = urlController.text;

        print(krName);
        print(enName);
        print(url);

        // ...
        if (krName.isNotEmpty && enName.isNotEmpty && url.isNotEmpty) {
          // 데이터베이스에 저장

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
}
