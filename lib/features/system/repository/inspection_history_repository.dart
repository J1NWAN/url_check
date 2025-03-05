import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/inspection_history_model.dart';

part 'inspection_history_repository.g.dart';

@Riverpod(keepAlive: true)
InspectionHistoryRepository inspectionHistoryRepository(InspectionHistoryRepositoryRef ref) {
  return InspectionHistoryRepository(FirebaseFirestore.instance);
}

class InspectionHistoryRepository {
  final FirebaseFirestore _firestore;

  InspectionHistoryRepository(this._firestore);

  /// ************* 점검 이력 조회 **************
  Stream<List<InspectionHistoryModel>> fetchInspectionHistoryList({DateTime? startDate, DateTime? endDate}) {
    try {
      var query = _firestore.collection('url_check_history').orderBy('created_at', descending: true);

      // 시작일이 있는 경우
      if (startDate != null) {
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        query = query.where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(start));
      }

      // 종료일이 있는 경우
      if (endDate != null) {
        final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
        query = query.where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(end));
      }

      return query.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return InspectionHistoryModel.fromJson(doc.data()).copyWith(id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error in fetchInspectionHistoryList: $e');
      throw Exception("점검 이력 조회 실패: $e");
    }
  }

  /// ************* 최근 점검 이력 **************
  Stream<List<InspectionHistoryModel>> fetchLatestInspectionHistoryList(InspectionHistoryModel model, DateTime? searchTime,
      {int limit = 1}) {
    try {
      // 검색 시작 시간 설정 (해당 일자의 시작)
      final startTime = searchTime != null ? DateTime(searchTime.year, searchTime.month, searchTime.day) : DateTime.now();

      // 검색 종료 시간 설정 (해당 일자의 끝)
      final endTime = searchTime != null ? DateTime(searchTime.year, searchTime.month, searchTime.day, 23, 59, 59) : DateTime.now();

      return _firestore
          .collection('url_check_history')
          .where('system_code', isEqualTo: model.systemCode)
          .where('path', isEqualTo: model.path)
          .where('created_at', isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
          .where('created_at', isLessThanOrEqualTo: Timestamp.fromDate(endTime))
          .orderBy('created_at', descending: true)
          .limit(limit)
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return InspectionHistoryModel.fromJson(doc.data()).copyWith(id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error in fetchLatestInspectionHistoryList: $e'); // 에러 출력
      throw Exception("최근 점검 이력 조회 실패: $e");
    }
  }
}
