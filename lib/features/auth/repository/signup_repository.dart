import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_check/features/auth/model/user_model.dart';

class SignupRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ************* 회원가입 **************
  Future<void> signup(UserModel user) async {
    await firestore.collection('users').doc(user.id).set(user.toJson());
  }
}
