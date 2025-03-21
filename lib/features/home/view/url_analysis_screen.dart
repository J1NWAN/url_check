import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/button/custom_button.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/home/viewmodel/url_analysis_view_model.dart';
import 'package:url_check/features/system/model/system_menu_model.dart';

class UrlAnalysisScreen extends ConsumerWidget {
  const UrlAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(urlAnalysisViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Row(
          children: [
            Text('URL 분석', style: GoogleFonts.notoSansKr(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            CustomButton.primary(
              text: '불러오기',
              height: 40,
              onPressed: () {
                ref.read(urlAnalysisViewModelProvider.notifier).getUrlAnalysis(context);
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // URL 입력 필드
        TextField(
          controller: state.urlController,
          onChanged: (value) {
            ref.read(urlAnalysisViewModelProvider.notifier).updateUrl(value);
          },
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          decoration: InputDecoration(
            hintText: 'https://example.com',
            hintStyle: CustomTextTheme.theme.bodyLarge,
            prefixIcon: const Icon(Icons.link),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                ref.read(urlAnalysisViewModelProvider.notifier).analyzeUrl(context);
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 32),

        if (state.isLoading) ...[
          const Center(child: CircularProgressIndicator()),
        ] else if (state.analysisResult != null) ...[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResultCard(
                    context,
                    title: '상태',
                    backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
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
                    backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
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
                    backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
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
                    backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
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
                  _buildResultCard(
                    context,
                    title: '점검대상 메뉴',
                    backgroundColor: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
                    icon: Icons.info_outline,
                    content: Column(
                      children: [
                        _buildMenuList(context, state.menuList ?? []),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ] else ...[
          const SizedBox(height: 100),
          const Center(child: Text('조회된 결과가 없습니다.')),
        ],
      ],
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String title,
    required Color backgroundColor,
    required IconData icon,
    required Widget content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
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

  Widget _buildMenuList(BuildContext context, List<SystemMenuModel> menuList) {
    if (menuList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Text('메뉴 정보가 없습니다.', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: menuList
          .map((menu) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.menu_book_outlined, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        menu.menuName ?? '이름 없음',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}
