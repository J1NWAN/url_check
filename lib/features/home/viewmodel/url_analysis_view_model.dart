import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/button/custom_dropdown_button.dart';
import 'package:url_check/core/button/model/dropdown_config.dart';
import 'package:url_check/core/dialog/custom_dialog.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/core/theme/theme_view_model.dart';

part 'url_analysis_view_model.g.dart';

class UrlAnalysisState {
  final String url;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? analysisResult;
  final String selectedUrlId;
  final TextEditingController urlController;

  UrlAnalysisState({
    this.url = '',
    this.isLoading = false,
    this.error,
    this.analysisResult,
    this.selectedUrlId = '1',
    TextEditingController? urlController,
  }) : urlController = urlController ?? TextEditingController();

  UrlAnalysisState copyWith({
    String? url,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? analysisResult,
    String? selectedUrlId,
    TextEditingController? urlController,
  }) {
    return UrlAnalysisState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      analysisResult: analysisResult ?? this.analysisResult,
      selectedUrlId: selectedUrlId ?? this.selectedUrlId,
      urlController: urlController ?? this.urlController,
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
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '분석 중 오류가 발생했습니다: $e',
      );
    }
  }

  Future<void> getUrlAnalysis(BuildContext context) async {
    final categories = [
      DropdownConfig(id: '1', name: 'https://www.kins.re.kr', color: '0xFF808080'),
      DropdownConfig(id: '2', name: 'https://google.com', color: '0xFF808080'),
    ];

    await CustomDialog.show(
      context,
      title: 'URL 불러오기',
      content: 'URL을 선택해주세요.',
      showIcon: false,
      backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
      dropdown: CustomDropDownButton(
        label: 'URL 선택',
        categories: categories,
        value: state.selectedUrlId,
        onChanged: (value) {
          final selectedUrl = categories.firstWhere((category) => category.id == value).name;

          state = state.copyWith(
            selectedUrlId: value,
            url: selectedUrl,
          );
        },
      ),
      confirmText: '적용',
      cancelText: '취소',
      onConfirm: () {
        final selectedUrl = categories.firstWhere((category) => category.id == state.selectedUrlId).name;
        updateUrl(selectedUrl);
        state.urlController.text = selectedUrl;
      },
    );
  }
}
