import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_check/core/datepicker/custom_date_picker.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/theme/theme_view_model.dart';
import 'package:url_check/features/system/viewmodel/inspection_history_view_model.dart';

class InspectionHistoryTab extends ConsumerWidget {
  const InspectionHistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inspectionHistoryViewModelProvider);

    return Column(
      children: [
        // 날짜 범위 선택
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            children: [
              Expanded(
                child: CustomDatePicker(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) {
                    ref.read(inspectionHistoryViewModelProvider.notifier).updateDateRange(date, state.endDate);
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('~'),
              ),
              Expanded(
                child: CustomDatePicker(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateSelected: (date) {
                    ref.read(inspectionHistoryViewModelProvider.notifier).updateDateRange(state.startDate, date);
                  },
                ),
              ),
            ],
          ),
        ),
        // 검색 및 필터 영역
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // 검색 필드
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    ref.read(inspectionHistoryViewModelProvider.notifier).updateSearchQuery(value);
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  decoration: InputDecoration(
                    hintText: '점검 이력 검색',
                    hintStyle: CustomTextTheme.theme.bodyMedium,
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // 검색 실행
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
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
        ),
        // 점검 이력 목록
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    '기관홈페이지 (WWW)',
                    style: CustomTextTheme.theme.bodyLarge,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        'URL: https://www.kins.re.kr',
                        style: CustomTextTheme.theme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '점검 시간: 2024-03-21 14:30:00',
                        style: CustomTextTheme.theme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '응답 시간: 1.2초',
                        style: CustomTextTheme.theme.bodySmall,
                      ),
                    ],
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '정상',
                      style: CustomTextTheme.theme.bodySmall?.copyWith(
                        color: Colors.green,
                      ),
                    ),
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
