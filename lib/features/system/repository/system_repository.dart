import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_check/features/system/model/system_model.dart';

class SystemRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 시스템 목록 스트림
  Stream<List<SystemModel>> getSystemsStream() {
    return _firestore
        .collection('system_info')
        .orderBy('system_name_ko')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => SystemModel.fromJson({'id': doc.id, ...doc.data()})).toList());
  }
}
