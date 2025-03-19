import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/button/custom_dropdown_button.dart';
import 'package:url_check/core/button/model/dropdown_config.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/model/system_menu_model.dart';
import 'package:url_check/features/system/repository/system_repository.dart';

part 'url_analysis_view_model.g.dart';

class UrlAnalysisState {
  final String url;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? analysisResult;
  final String selectedUrlId;
  final TextEditingController urlController;
  final List<SystemMenuModel>? menuList;
  UrlAnalysisState({
    this.url = '',
    this.isLoading = false,
    this.error,
    this.analysisResult,
    this.selectedUrlId = '1',
    TextEditingController? urlController,
    this.menuList = const [],
  }) : urlController = urlController ?? TextEditingController();

  UrlAnalysisState copyWith({
    String? url,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? analysisResult,
    String? selectedUrlId,
    TextEditingController? urlController,
    List<SystemMenuModel>? menuList,
  }) {
    return UrlAnalysisState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      analysisResult: analysisResult ?? this.analysisResult,
      selectedUrlId: selectedUrlId ?? this.selectedUrlId,
      urlController: urlController ?? this.urlController,
      menuList: menuList ?? this.menuList,
    );
  }
}

@riverpod
class UrlAnalysisViewModel extends _$UrlAnalysisViewModel {
  @override
  UrlAnalysisState build() => UrlAnalysisState();

  void updateUrl(String url) {
    state = state.copyWith(url: url);
  }

  Future<void> analyzeUrl(BuildContext context) async {
    if (state.url.isEmpty) {
      CustomSnackBar.show(
        context,
        title: '알림',
        message: 'URL을 입력해주세요',
        type: SnackBarType.info,
      );
      return;
    }

    // URL 형식 검증
    Uri? uri;
    try {
      uri = Uri.parse(state.url);
      if (!uri.isAbsolute) {
        throw const FormatException('올바른 URL 형식이 아닙니다');
      }
    } catch (e) {
      CustomSnackBar.show(
        context,
        title: '알림',
        message: '올바른 URL 형식이 아닙니다',
        type: SnackBarType.error,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // 응답 시간 측정 시작
      final stopwatch = Stopwatch()..start();

      // HTTP 요청 보내기
      final response = await http.get(uri).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('요청 시간이 초과되었습니다');
        },
      );

      // 응답 시간 측정 종료
      stopwatch.stop();
      final responseTime = stopwatch.elapsedMilliseconds;

      // 응답 헤더 분석
      final serverInfo = response.headers['server'] ?? 'Unknown';
      final contentType = response.headers['content-type'] ?? 'Unknown';
      final securityHeaders = {
        'Strict-Transport-Security': response.headers['strict-transport-security'],
        'X-Content-Type-Options': response.headers['x-content-type-options'],
        'X-Frame-Options': response.headers['x-frame-options'],
        'Content-Security-Policy': response.headers['content-security-policy'],
      };

      // SSL 정보 (HTTPS인 경우)
      final isHttps = uri.scheme == 'https';

      final result = {
        'status': {
          'code': response.statusCode,
          'isSuccess': response.statusCode >= 200 && response.statusCode < 300,
        },
        'performance': {
          'responseTime': '$responseTime ms',
        },
        'server': {
          'software': serverInfo,
          'contentType': contentType,
        },
        'security': {
          'isHttps': isHttps,
          'headers': securityHeaders,
        },
      };

      state = state.copyWith(
        isLoading: false,
        analysisResult: result,
      );

      // URL에 해당하는 시스템 ID 찾기
      String systemId = await _findSystemIdByUrl(state.url);

      // 메뉴 불러오기
      await _fetchMenusForSystem(systemId);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '분석 중 오류가 발생했습니다: $e',
      );
    }
  }

  // URL을 기반으로 시스템 ID를 찾는 메서드
  Future<String> _findSystemIdByUrl(String url) async {
    final repository = ref.read(systemRepositoryProvider);
    final systems = await repository.fetchSystems().first;

    // 입력된 URL과 일치하거나 가장 유사한 시스템 찾기
    for (var system in systems) {
      if (system.url == url) {
        return system.systemNameEn ?? '1'; // 기본값으로 1 설정
      }
    }

    // URL 기본 도메인만 비교
    Uri? inputUri = Uri.tryParse(url);
    if (inputUri != null) {
      String inputHost = inputUri.host;
      for (var system in systems) {
        Uri? systemUri = Uri.tryParse(system.url ?? '');
        if (systemUri != null && systemUri.host == inputHost) {
          return system.systemNameEn ?? '1';
        }
      }
    }

    return '1'; // 일치하는 시스템이 없을 경우 기본값 반환
  }

  // 해당 시스템의 메뉴를 가져오는 메서드
  Future<void> _fetchMenusForSystem(String systemId) async {
    final repository = ref.read(systemRepositoryProvider);
    final menu = repository.fetchSystemMenu(systemId);

    final menuList = await menu.first;
    state = state.copyWith(menuList: menuList);
  }

  Future<void> getUrlAnalysis(BuildContext context) async {
    final repository = ref.read(systemRepositoryProvider);
    final systems = repository.fetchSystems();

    // 빈 DropdownConfig 리스트 생성
    List<DropdownConfig> dropdownCategories = [];

    try {
      // Stream에서 첫 번째 이벤트(시스템 목록)를 기다림
      final systemList = await systems.first;

      // 시스템 목록을 DropdownConfig로 변환
      for (var system in systemList) {
        dropdownCategories.add(DropdownConfig(id: system.systemNameEn ?? '', name: system.url ?? '', color: '0xFF808080'));
      }

      // 드롭다운 목록이 비어있는지 확인
      if (dropdownCategories.isEmpty) {
        CustomSnackBar.show(
          context,
          title: '알림',
          message: '불러올 URL이 없습니다.',
          type: SnackBarType.info,
        );
        return;
      }

      // 초기 선택값 설정 (첫 번째 항목)
      String initialValue = dropdownCategories.isNotEmpty ? dropdownCategories[0].id : state.selectedUrlId;

      // 다이얼로그 표시
      await CustomDialog.show(
        context,
        title: 'URL 불러오기',
        content: 'URL을 선택해주세요.',
        showIcon: false,
        backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
        dropdown: CustomDropDownButton(
          label: 'URL 선택',
          categories: dropdownCategories,
          value: state.selectedUrlId == '' ? initialValue : state.selectedUrlId,
          onChanged: (value) {
            final selectedUrl = dropdownCategories.firstWhere((category) => category.id == value).name;
            state = state.copyWith(
              selectedUrlId: value,
              url: selectedUrl,
            );
          },
        ),
        confirmText: '적용',
        cancelText: '취소',
        onConfirm: () {
          if (dropdownCategories.isNotEmpty) {
            final selectedUrl =
                dropdownCategories.firstWhere((category) => category.id == state.selectedUrlId, orElse: () => dropdownCategories[0]).name;
            updateUrl(selectedUrl);
            state.urlController.text = selectedUrl;
          }
        },
      );
    } catch (e) {
      CustomSnackBar.show(
        context,
        title: '오류',
        message: 'URL 목록을 불러오는 중 오류가 발생했습니다: $e',
        type: SnackBarType.error,
      );
    }
  }
}
