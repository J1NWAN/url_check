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
      return _firestore.collection('system').orderBy('system_name_en').snapshots().map((snapshot) => snapshot.docs
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
      await _firestore.collection('system').doc().set(system.toJson());
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
  Stream<List<SystemMenuModel>> fetchSystemMenu() {
    try {
      return _firestore
          .collection('system_menu')
          .orderBy('system_name_en')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => SystemMenuModel.fromJson({'id': doc.id, ...doc.data()})).toList());
    } catch (e) {
      throw Exception("시스템 메뉴 조회 실패: $e");
    }
  }

  // 시스템 메뉴 등록
  Future<void> createSystemMenu(SystemMenuModel system) async {
    try {
      String id = '${system.systemCode!}_${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}';
      await _firestore.collection('system_menu').doc(id).set(system.toJson());
    } catch (e) {
      throw Exception("시스템 메뉴 등록 실패: $e");
    }
  }

  // 시스템 메뉴 수정 - ID를 파라미터로 받음
  Future<void> updateSystemMenu(String docId, SystemMenuModel menu) async {
    try {
      await _firestore.collection('system_menu').doc(docId).update(menu.toJson());
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
