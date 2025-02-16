import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/theme_view_model.dart';

class SystemListTab extends ConsumerWidget {
  const SystemListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 검색 및 필터 영역
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 검색 필드
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '시스템 검색',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 정렬 필터 버튼
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
              ),
              // 보기 방식 전환 버튼 (리스트/그리드)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.grid_view),
              ),
            ],
          ),
        ),
        // 시스템 목록
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: 10, // 임시 데이터
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: index % 2 == 0 ? Colors.green : Colors.red,
                    child: Icon(
                      index % 2 == 0 ? Icons.check : Icons.error,
                      color: Colors.white,
                    ),
                  ),
                  title: Text('시스템 ${index + 1}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('URL: https://example${index + 1}.com'),
                      const SizedBox(height: 4),
                      Text('마지막 점검: ${DateTime.now().toString().substring(0, 16)}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('수정'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 8),
                            Text('삭제'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      // 메뉴 선택 처리
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
