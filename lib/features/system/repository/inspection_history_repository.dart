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
  Stream<List<InspectionHistoryModel>> fetchLatestInspectionHistoryList() {
    try {
      return _firestore.collection('url_check_history').orderBy('created_at', descending: true).limit(10).snapshots().map((snapshot) {
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
