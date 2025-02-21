import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/model/system_model.dart';
import 'package:url_check/features/system/viewmodel/system_detail_view_model.dart';

class SystemListDetailScreen extends ConsumerStatefulWidget {
  final SystemModel system;

  const SystemListDetailScreen({super.key, required this.system});

  @override
  ConsumerState<SystemListDetailScreen> createState() => _SystemListDetailScreenState();
}

class _SystemListDetailScreenState extends ConsumerState<SystemListDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 위젯이 처음 생성될 때 초기화
    Future.microtask(() {
      ref.read(systemDetailViewModelProvider.notifier).initState(widget.system.systemNameEn ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(systemDetailViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('시스템 상세', style: CustomTextTheme.theme.titleMedium),
      ),
      body: Column(
        children: [
          // 시스템 정보
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home, size: 20),
                      const SizedBox(width: 8),
                      Text('${widget.system.systemNameKo ?? ''} (${widget.system.systemNameEn ?? ''})',
                          style: CustomTextTheme.theme.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.link, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        widget.system.url ?? '',
                        style: CustomTextTheme.theme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 검색 및 보기 방식 전환
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(systemDetailViewModelProvider.notifier).updateSearchQuery(value);
                    },
                    decoration: InputDecoration(
                      hintText: '메뉴 검색',
                      hintStyle: CustomTextTheme.theme.bodyMedium,
                      suffixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      constraints: const BoxConstraints(maxHeight: 40),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () {
                    ref.read(systemDetailViewModelProvider.notifier).toggleViewType();
                  },
                  icon: Icon(
                    state.isGridView ? Icons.list : Icons.grid_view,
                  ),
                ),
              ],
            ),
          ),
          // 메뉴 목록
          Expanded(
            child: state.isGridView ? _buildMenuGridView(context, ref) : _buildMenuListView(context, ref),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(systemDetailViewModelProvider.notifier).addSystemMenu(context, widget.system.systemNameEn ?? '');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildMenuGridView(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemDetailViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.systemMenuList.isEmpty) {
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
      itemCount: state.systemMenuList.length,
      itemBuilder: (context, index) {
        final systemMenu = state.systemMenuList[index];

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
                '메뉴 ${index + 1}',
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
                      ref.read(systemDetailViewModelProvider.notifier).editSystemMenu(context, systemMenu);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20),
                    onPressed: () {
                      ref.read(systemDetailViewModelProvider.notifier).deleteSystemMenu(context, widget.system.id!);
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

  Widget _buildMenuListView(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemDetailViewModelProvider);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.systemMenuList.isEmpty) {
      return Center(
        child: Text(
          state.searchQuery.isEmpty ? '등록된 시스템이 없습니다.' : '검색 결과가 없습니다.',
          style: CustomTextTheme.theme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.systemMenuList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final systemMenu = state.systemMenuList[index];

        return Container(
          decoration: BoxDecoration(
            color: ref.watch(themeViewModelProvider).themeData.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            title: Text(systemMenu.menuName ?? '', style: CustomTextTheme.theme.bodyLarge),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(systemMenu.path ?? '', style: CustomTextTheme.theme.bodySmall),
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
                  ref.read(systemDetailViewModelProvider.notifier).editSystemMenu(context, systemMenu);
                } else if (value == 'delete') {
                  ref.read(systemDetailViewModelProvider.notifier).deleteSystemMenu(context, widget.system.id!);
                }
              },
            ),
          ),
        );
      },
    );
  }
}
