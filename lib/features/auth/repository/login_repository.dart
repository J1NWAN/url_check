import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_check/features/auth/model/user_model.dart';

class LoginRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ************* 로그인 **************
  Future<bool> login(String id, String password) async {
    final snapshot = await firestore.collection('users').doc(id).get();
    if (!snapshot.exists) {
      return false;
    }
    final user = UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
    return user.password == password;
  }
}
