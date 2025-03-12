import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/snackbar/custom_snackbar.dart';
import 'package:url_check/core/snackbar/enum/snackbar_type.dart';
import 'package:url_check/features/auth/repository/login_repository.dart';

part 'login_view_model.g.dart';

class LoginState {
  final TextEditingController idController;
  final TextEditingController passwordController;

  LoginState({required this.idController, required this.passwordController});
}

@riverpod
class LoginViewModel extends _$LoginViewModel {
  LoginRepository loginRepository = LoginRepository();

  @override
  LoginState build() {
    return LoginState(
      idController: TextEditingController(),
      passwordController: TextEditingController(),
    );
  }

  void login(BuildContext context) async {
    if (state.passwordController.text.isNotEmpty) {
      // 비밀번호 암호화
      var bytes = utf8.encode(state.passwordController.text);
      var passwordHash = sha256.convert(bytes).toString();
      state.passwordController.text = passwordHash;
    }

    final isLogin = await loginRepository.login(state.idController.text, state.passwordController.text);
    if (isLogin) {
      context.go('/home');
    } else {
      CustomSnackBar.show(
        context,
        title: '로그인 실패',
        message: '아이디 또는 비밀번호를 확인해주세요',
        type: SnackBarType.error,
      );
    }
  }
}
