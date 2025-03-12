import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_check/core/toast/custom_toast.dart';
import 'package:url_check/core/toast/enum/toast_type.dart';
import 'package:url_check/features/auth/model/user_model.dart';
import 'package:url_check/features/auth/repository/signup_repository.dart';

part 'signup_view_model.g.dart';

class SignupState {
  final TextEditingController idController;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  SignupState(
      {required this.idController,
      required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.confirmPasswordController});
}

@riverpod
class SignupViewModel extends _$SignupViewModel {
  SignupRepository signupRepository = SignupRepository();

  @override
  SignupState build() {
    return SignupState(
      idController: TextEditingController(),
      nameController: TextEditingController(),
      emailController: TextEditingController(),
      passwordController: TextEditingController(),
      confirmPasswordController: TextEditingController(),
    );
  }

  void signup(BuildContext context) async {
    if (state.idController.text.isEmpty) {
      CustomToast.show(context, '아이디를 입력해주세요', type: ToastType.error);
      return;
    }

    if (state.idController.text.length < 4) {
      CustomToast.show(context, '아이디는 4자 이상이어야 합니다', type: ToastType.error);
      return;
    }

    bool isIdExists = await signupRepository.checkId(state.idController.text);
    if (isIdExists) {
      CustomToast.show(context, '이미 존재하는 아이디입니다', type: ToastType.error);
      return;
    }

    if (state.passwordController.text.isEmpty) {
      CustomToast.show(context, '비밀번호를 입력해주세요', type: ToastType.error);
      return;
    }

    if (state.passwordController.text != state.confirmPasswordController.text) {
      CustomToast.show(context, '비밀번호가 일치하지 않습니다', type: ToastType.error);
      return;
    }

    // 비밀번호 암호화
    var bytes = utf8.encode(state.passwordController.text);
    var passwordHash = sha256.convert(bytes).toString();

    // 회원가입 로직 구현
    final user = UserModel(
      id: state.idController.text,
      name: state.nameController.text,
      password: passwordHash,
      email: state.emailController.text,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    signupRepository.signup(user);

    // 성공 시 로그인 화면으로 이동
    CustomToast.show(context, '회원가입이 완료되었습니다', type: ToastType.success);
    context.go('/login');
  }
}
