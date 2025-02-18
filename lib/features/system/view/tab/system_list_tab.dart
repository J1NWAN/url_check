import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/viewmodel/system_list_view_model.dart';

class SystemListTab extends ConsumerWidget {
  const SystemListTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemListViewModelProvider);

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
                  onChanged: (value) {
                    ref.read(systemListViewModelProvider.notifier).updateSearchQuery(value);
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: '시스템 검색',
                    hintStyle: CustomTextTheme.theme.bodyMedium,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        print('search');
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 보기 방식 전환 버튼
              IconButton(
                onPressed: () {
                  ref.read(systemListViewModelProvider.notifier).toggleViewType();
                },
                icon: Icon(
                  state.viewType == ViewType.list ? Icons.grid_view : Icons.list,
                ),
              ),
            ],
          ),
        ),
        // 시스템 목록
        Expanded(
          child: state.viewType == ViewType.list ? _buildListView(context, ref) : _buildGridView(context, ref),
        ),
      ],
    );
  }

  Widget _buildListView(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: 10,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text('시스템 ${index + 1}', style: CustomTextTheme.theme.bodyLarge),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('URL: https://example${index + 1}.com', style: CustomTextTheme.theme.bodySmall),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      const Icon(Icons.edit),
                      const SizedBox(width: 12),
                      Text('수정', style: CustomTextTheme.theme.bodyMedium),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete),
                      const SizedBox(width: 12),
                      Text('삭제', style: CustomTextTheme.theme.bodyMedium),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'edit') {
                  ref.read(systemListViewModelProvider.notifier).editSystem(context, '${index + 1}');
                } else if (value == 'delete') {
                  ref.read(systemListViewModelProvider.notifier).deleteSystem(context, '${index + 1}');
                }
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, WidgetRef ref) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                '시스템 ${index + 1}',
                style: CustomTextTheme.theme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                'https://example${index + 1}.com',
                style: CustomTextTheme.theme.bodySmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {
                      ref.read(systemListViewModelProvider.notifier).editSystem(context, '${index + 1}');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      ref.read(systemListViewModelProvider.notifier).deleteSystem(context, '${index + 1}');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
