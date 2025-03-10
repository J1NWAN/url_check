import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
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

  /// ************* 최신 모니터링 목록 일괄 조회 **************
  Future<List<Map<String, dynamic>>> fetchLatestMonitoringList(List<SystemModel> systems) async {
    try {
      List<Map<String, dynamic>> monitoringList = [];

      // systems를 30개씩 청크로 나누기
      for (var i = 0; i < systems.length; i += 30) {
        final systemsChunk = systems.skip(i).take(30).toList();
        final systemCodes = systemsChunk.map((s) => s.systemNameEn).toList();

        // 시스템 메뉴 청크별 조회
        final systemMenuQuery = await _firestore.collection('system_menu').where('system_code', whereIn: systemCodes).get();

        // 각 시스템 코드별로 최신 점검 이력 조회
        for (final system in systemsChunk) {
          final systemMenus = systemMenuQuery.docs.where((doc) => doc.data()['system_code'] == system.systemNameEn);

          for (final menu in systemMenus) {
            final menuData = menu.data();

            // 각 메뉴별로 최신 점검 이력 조회
            final checkHistoryQuery = await _firestore
                .collection('url_check_history')
                .where('system_code', isEqualTo: system.systemNameEn)
                .where('path', isEqualTo: menuData['path'])
                .orderBy('created_at', descending: true)
                .limit(1) // 최신 기록 하나만 가져오기
                .get();

            if (checkHistoryQuery.docs.isNotEmpty) {
              final checkData = checkHistoryQuery.docs.first.data();
              monitoringList.add({
                'systemNameEn': system.systemNameEn,
                'systemNameKo': system.systemNameKo,
                'systemCode': menuData['system_code'],
                'systemUrl': system.url,
                'path': menuData['path'],
                'actualStatus': checkData['actual_status'],
                'responseTime': checkData['response_time'],
                'createdAt': checkData['created_at'],
              });
            }
          }
        }
      }

      return monitoringList;
    } catch (e) {
      print('Error in fetchLatestMonitoringList: $e');
      throw Exception("최신 점검 이력 조회 실패: $e");
    }
  }
}
