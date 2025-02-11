import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/features/home/viewmodel/url_analysis_view_model.dart';

class UrlAnalysisScreen extends ConsumerWidget {
  const UrlAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(urlAnalysisViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text('URL 분석', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 24),

        // URL 입력 필드
        TextField(
          onChanged: (value) {
            ref.read(urlAnalysisViewModelProvider.notifier).updateUrl(value);
          },
          decoration: InputDecoration(
            hintText: 'https://example.com',
            prefixIcon: const Icon(Icons.link),
            suffixIcon: state.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      ref.read(urlAnalysisViewModelProvider.notifier).analyzeUrl();
                    },
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 32),

        if (state.error != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    state.error!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),

        if (state.analysisResult != null) ...[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultCard(
                    context,
                    title: '상태',
                    icon: Icons.info_outline,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          '상태 코드',
                          state.analysisResult!['status']['code'].toString(),
                        ),
                        _buildResultRow(
                          '성공 여부',
                          state.analysisResult!['status']['isSuccess'] ? '성공' : '실패',
                        ),
                      ],
                    ),
                  ),
                  _buildResultCard(
                    context,
                    title: '성능',
                    icon: Icons.speed,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          '응답 시간',
                          state.analysisResult!['performance']['responseTime'],
                        ),
                      ],
                    ),
                  ),
                  _buildResultCard(
                    context,
                    title: '서버 정보',
                    icon: Icons.dns,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          '서버 소프트웨어',
                          state.analysisResult!['server']['software'],
                        ),
                        _buildResultRow(
                          'Content-Type',
                          state.analysisResult!['server']['contentType'],
                        ),
                      ],
                    ),
                  ),
                  _buildResultCard(
                    context,
                    title: '보안',
                    icon: Icons.security,
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildResultRow(
                          'HTTPS',
                          state.analysisResult!['security']['isHttps'] ? '사용' : '미사용',
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '보안 헤더',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ...((state.analysisResult!['security']['headers'] as Map<String, dynamic>)
                            .entries
                            .map((e) => _buildResultRow(e.key, e.value ?? '미설정'))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
