import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/viewmodel/system_list_view_model.dart';

class SystemListTab extends ConsumerStatefulWidget {
  const SystemListTab({super.key});

  @override
  ConsumerState<SystemListTab> createState() => _SystemListTabState();
}

class _SystemListTabState extends ConsumerState<SystemListTab> {
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 초기화
    Future.microtask(() {
      ref.read(systemListViewModelProvider.notifier).initState();
    });
  }

  @override
  Widget build(BuildContext context) {
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
    final state = ref.watch(systemListViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.systemList.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.isEmpty ? '등록된 시스템이 없습니다.' : '검색 결과가 없습니다.',
          style: CustomTextTheme.theme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.systemList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final system = state.systemList[index];
        return Container(
          decoration: BoxDecoration(
            color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: InkWell(
            onTap: () {
              context.push('/system/systemList/detail', extra: system);
            },
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              title: Text(system.systemNameKo ?? '', style: CustomTextTheme.theme.bodyLarge),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('URL: ${system.url}', style: CustomTextTheme.theme.bodySmall),
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
                    ref.read(systemListViewModelProvider.notifier).updateSystem(context, system);
                  } else if (value == 'delete') {
                    ref.read(systemListViewModelProvider.notifier).deleteSystem(context, system);
                  }
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridView(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemListViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.systemList.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.isEmpty ? '등록된 시스템이 없습니다.' : '검색 결과가 없습니다.',
          style: CustomTextTheme.theme.bodyMedium,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: state.systemList.length,
      itemBuilder: (context, index) {
        final system = state.systemList[index];
        return InkWell(
          onTap: () {
            context.push('/system/systemList/detail', extra: system);
          },
          child: Container(
            padding: const EdgeInsets.all(10),
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
                  system.systemNameKo ?? '',
                  style: CustomTextTheme.theme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${system.url}',
                  style: CustomTextTheme.theme.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        ref.read(systemListViewModelProvider.notifier).updateSystem(context, system);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        ref.read(systemListViewModelProvider.notifier).deleteSystem(context, system);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
