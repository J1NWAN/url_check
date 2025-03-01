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
  Stream<List<InspectionHistoryModel>> fetchInspectionHistoryList() {
    try {
      return _firestore.collection('url_check_history').orderBy('created_at', descending: true).snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return InspectionHistoryModel.fromJson(doc.data()).copyWith(id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error in fetchMonitoringList: $e'); // 에러 출력
      throw Exception("시스템 목록 조회 실패: $e");
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

  /// ************* 날짜별 전체 점검 이력 **************
  Stream<List<InspectionHistoryModel>> fetchDailyInspectionHistoryList(DateTime? searchTime, {int limit = 10}) {
    try {
      // 검색 시작 시간 설정 (해당 일자의 시작)
      final startTime = searchTime != null ? DateTime(searchTime.year, searchTime.month, searchTime.day) : DateTime.now();

      // 검색 종료 시간 설정 (해당 일자의 끝)
      final endTime = searchTime != null ? DateTime(searchTime.year, searchTime.month, searchTime.day, 23, 59, 59) : DateTime.now();

      return _firestore
          .collection('url_check_history')
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
      print('Error in fetchDailyInspectionHistoryList: $e'); // 에러 출력
      throw Exception("날짜별 점검 이력 조회 실패: $e");
    }
  }
}
