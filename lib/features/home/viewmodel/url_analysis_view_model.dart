import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';

part 'url_analysis_view_model.g.dart';

class UrlAnalysisState {
  final String url;
  final bool isLoading;
  final String? error;
  final Map<String, dynamic>? analysisResult;

  UrlAnalysisState({
    this.url = '',
    this.isLoading = false,
    this.error,
    this.analysisResult,
  });

  UrlAnalysisState copyWith({
    String? url,
    bool? isLoading,
    String? error,
    Map<String, dynamic>? analysisResult,
  }) {
    return UrlAnalysisState(
      url: url ?? this.url,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      analysisResult: analysisResult ?? this.analysisResult,
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
      state = state.copyWith(error: 'URL을 입력해주세요');
      CustomSnackBar.show(
        context,
        title: '알림',
        message: 'URL을 입력해주세요',
        type: SnackBarType.info,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      final result = {
        'status': 'success',
        'responseTime': '234ms',
        'ssl': {
          'issuer': 'DigiCert Inc',
          'expiryDate': '2024-12-31',
          'encryption': 'SHA-256',
        },
        'server': {
          'type': 'nginx/1.18.0',
          'ip': '192.168.1.1',
          'location': 'Seoul, Korea',
        },
      };

      state = state.copyWith(
        isLoading: false,
        analysisResult: result,
      );

      CustomSnackBar.show(
        context,
        title: '성공',
        message: 'URL 분석이 완료되었습니다',
        type: SnackBarType.success,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '분석 중 오류가 발생했습니다: $e',
      );

      CustomSnackBar.show(
        context,
        title: '오류',
        message: '분석 중 오류가 발생했습니다',
        type: SnackBarType.error,
      );
    }
  }
}
