import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/system_menu_model.dart';
import 'package:url_check/features/system/model/system_model.dart';

part 'monitoring_repository.g.dart';

@Riverpod(keepAlive: true)
MonitoringRepository monitoringRepository(MonitoringRepositoryRef ref) {
  return MonitoringRepository(FirebaseFirestore.instance);
}

class MonitoringRepository {
  final FirebaseFirestore _firestore;

  MonitoringRepository(this._firestore);

  /// ************* 모니터링 목록 조회 **************
  Stream<List<SystemModel>> fetchMonitoringList() {
    try {
      return _firestore.collection('system').orderBy('system_name_en').snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          return SystemModel.fromJson(doc.data()).copyWith(id: doc.id);
        }).toList();
      });
    } catch (e) {
      print('Error in fetchMonitoringList: $e'); // 에러 출력
      throw Exception("시스템 목록 조회 실패: $e");
    }
  }

  /// 시스템별 최신 점검 이력 조회 (시스템 URL + 메뉴 PATH)
  Future<List<String>> fetchLatestCheckHistory(List<SystemModel> systems) async {
    try {
      List<String> errorList = [];

      for (final system in systems) {
        /// 시스템 메뉴 조회
        final systemMenuSnapshot = await _firestore
            .collection('system_menu')
            .where('system_code', isEqualTo: system.systemNameEn)
            .orderBy('created_at', descending: true)
            .get();

        for (final systemMenu in systemMenuSnapshot.docs) {
          final systemMenuData = SystemMenuModel.fromJson(systemMenu.data());

          final url = '${system.url}${systemMenuData.path}';
          try {
            /// 최신 점검 이력 조회
            final checkHistorySnapshot = await _firestore
                .collection('url_check_history')
                .where('system_code', isEqualTo: systemMenuData.systemCode)
                .where('url', isEqualTo: url)
                .orderBy('created_at', descending: true)
                .limit(1)
                .get();

            if (checkHistorySnapshot.docs.isNotEmpty) {
              final checkHistoryData = checkHistorySnapshot.docs.first.data();

              /// 오류 검증
              if (checkHistoryData['actual_status'] != 'OK') {
                errorList.add(checkHistoryData['system_code']);
                break;
              }
            }
          } catch (e) {
            print('Error in fetchLatestCheckHistory2: $e');
          }
        }
      }

      return errorList;
    } catch (e) {
      print('Error in fetchLatestCheckHistory: $e');
      throw Exception("최신 점검 이력 조회 실패: $e");
    }
  }
}
