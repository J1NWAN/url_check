import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/features/system/model/system_model.dart';

part 'system_repository.g.dart';

@Riverpod(keepAlive: true)
SystemRepository systemRepository(SystemRepositoryRef ref) {
  return SystemRepository(FirebaseFirestore.instance);
}

class SystemRepository {
  final FirebaseFirestore _firestore;

  SystemRepository(this._firestore);

  // 시스템 목록 조회
  Stream<List<SystemModel>> fetchSystems() {
    try {
      return _firestore
          .collection('system')
          .orderBy('system_name_en')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => SystemModel.fromJson({'id': doc.id, ...doc.data()})).toList());
    } catch (e) {
      throw Exception("시스템 목록 조회 실패: $e");
    }
  }

  // 시스템 등록
  Future<void> createSystem(SystemModel system) async {
    try {
      system = system.copyWith(createdAt: Timestamp.now().toDate());
      await _firestore.collection('system').doc(system.id).set(system.toJson());
    } catch (e) {
      throw Exception("시스템 등록 실패: $e");
    }
  }

  // 시스템 수정
  Future<void> updateSystem(SystemModel system) async {
    try {
      system = system.copyWith(updatedAt: Timestamp.now().toDate());
      await _firestore.collection('system').doc(system.id).update(system.toJson());
    } catch (e) {
      throw Exception("시스템 수정 실패: $e");
    }
  }

  // 시스템 삭제
  Future<void> deleteSystem(String id) async {
    try {
      await _firestore.collection('system').doc(id).delete();
    } catch (e) {
      throw Exception("시스템 삭제 실패: $e");
    }
  }
}
