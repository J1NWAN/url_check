import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UrlAnalysisScreen extends ConsumerWidget {
  const UrlAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목
        Text('URL 분석', style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 24),

        // URL 입력 필드
        TextField(
          decoration: InputDecoration(
            hintText: 'https://example.com',
            prefixIcon: const Icon(Icons.link),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // URL 분석 시작
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 32),

        // 분석 결과 카드들
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // 상태 카드
                _buildAnalysisCard(
                  context,
                  title: '접속 상태',
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check, color: Colors.green, size: 16),
                            SizedBox(width: 4),
                            Text(
                              '정상 작동',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text('응답 시간: 234ms'),
                    ],
                  ),
                ),

                // SSL 인증서 정보 카드
                _buildAnalysisCard(
                  context,
                  title: 'SSL 인증서',
                  icon: Icons.security,
                  iconColor: Colors.blue,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('발급자: DigiCert Inc'),
                      SizedBox(height: 4),
                      Text('만료일: 2024-12-31'),
                      SizedBox(height: 4),
                      Text('암호화: SHA-256'),
                    ],
                  ),
                ),

                // 메타데이터 카드
                _buildAnalysisCard(
                  context,
                  title: '메타데이터',
                  icon: Icons.info_outline,
                  iconColor: Colors.orange,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('제목: Example Website'),
                      SizedBox(height: 4),
                      Text('설명: This is an example website'),
                      SizedBox(height: 4),
                      Text('언어: ko-KR'),
                    ],
                  ),
                ),

                // 서버 정보 카드
                _buildAnalysisCard(
                  context,
                  title: '서버 정보',
                  icon: Icons.dns,
                  iconColor: Colors.purple,
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('서버: nginx/1.18.0'),
                      SizedBox(height: 4),
                      Text('IP: 192.168.1.1'),
                      SizedBox(height: 4),
                      Text('위치: Seoul, Korea'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
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
              Icon(icon, color: iconColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
