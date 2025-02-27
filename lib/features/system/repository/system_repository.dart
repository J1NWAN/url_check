import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/system_menu_model.dart';
import 'package:url_check/features/system/model/system_model.dart';

part 'system_repository.g.dart';

@Riverpod(keepAlive: true)
SystemRepository systemRepository(SystemRepositoryRef ref) {
  return SystemRepository(FirebaseFirestore.instance);
}

class SystemRepository {
  final FirebaseFirestore _firestore;

  SystemRepository(this._firestore);

  // 시스템 목록 조회 - ID를 별도로 추가
  Stream<List<SystemModel>> fetchSystems() {
    try {
      return _firestore.collection('system').orderBy('system_name_ko').snapshots().map((snapshot) => snapshot.docs
          .map((doc) => SystemModel.fromJson(doc.data()).copyWith(id: doc.id)) // ID를 별도로 추가
          .toList());
    } catch (e) {
      throw Exception("시스템 목록 조회 실패: $e");
    }
  }

  // 시스템 등록
  Future<void> createSystem(SystemModel system) async {
    try {
      system = system.copyWith(createdAt: Timestamp.now().toDate());
      await _firestore.collection('system').doc(system.systemNameEn).set(system.toJson());
    } catch (e) {
      throw Exception("시스템 등록 실패: $e");
    }
  }

  // 시스템 수정 - ID를 파라미터로 받음
  Future<void> updateSystem(String docId, SystemModel system) async {
    try {
      system = system.copyWith(updatedAt: Timestamp.now().toDate());
      await _firestore.collection('system').doc(docId).update(system.toJson());
    } catch (e) {
      throw Exception("시스템 수정 실패: $e");
    }
  }

  // 시스템 삭제 - ID를 파라미터로 받음
  Future<void> deleteSystem(String docId) async {
    try {
      await _firestore.collection('system').doc(docId).delete();
    } catch (e) {
      throw Exception("시스템 삭제 실패: $e");
    }
  }

  /// ************* 시스템 메뉴관련 **************
  Stream<List<SystemMenuModel>> fetchSystemMenu(String systemCode) {
    try {
      final query = _firestore
          .collection('system_menu') // 컬렉션 이름 확인 필요
          .where('system_code', isEqualTo: systemCode);

      return query.snapshots().map((snapshot) {
        final list = snapshot.docs.map((doc) => SystemMenuModel.fromJson(doc.data()).copyWith(id: doc.id)).toList();

        list.sort((a, b) => (a.menuName ?? '').compareTo(b.menuName ?? ''));
        return list;
      });
    } catch (e) {
      throw Exception("시스템 메뉴 조회 실패: $e");
    }
  }

  // 시스템 메뉴 등록
  Future<void> createSystemMenu(SystemMenuModel systemMenu) async {
    try {
      String id = '${systemMenu.systemCode!}_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
      await _firestore.collection('system_menu').doc(id).set(systemMenu.toJson());
    } catch (e) {
      throw Exception("시스템 메뉴 등록 실패: $e");
    }
  }

  // 시스템 메뉴 수정 - ID를 파라미터로 받음
  Future<void> updateSystemMenu(SystemMenuModel systemMenu, String docId) async {
    try {
      await _firestore.collection('system_menu').doc(docId).update(systemMenu.toJson());
    } catch (e) {
      throw Exception("시스템 메뉴 수정 실패: $e");
    }
  }

  // 시스템 메뉴 삭제 - ID를 파라미터로 받음
  Future<void> deleteSystemMenu(String docId) async {
    try {
      await _firestore.collection('system_menu').doc(docId).delete();
    } catch (e) {
      throw Exception("시스템 메뉴 삭제 실패: $e");
    }
  }
}
