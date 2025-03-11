import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';

class SignupCredentialsStep extends StatefulWidget {
  final TextEditingController idController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ThemeData theme;

  const SignupCredentialsStep({
    super.key,
    required this.idController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.theme,
  });

  @override
  State<SignupCredentialsStep> createState() => _SignupCredentialsStepState();
}

class _SignupCredentialsStepState extends State<SignupCredentialsStep> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '로그인에 사용할\n아이디와 비밀번호를 입력해주세요.',
          style: GoogleFonts.notoSansKr(
            fontSize: CustomTextTheme.theme.displaySmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        // 아이디 입력 필드
        TextFormField(
          controller: widget.idController,
          decoration: InputDecoration(
            labelText: '아이디',
            hintText: '아이디를 입력하세요',
            prefixIcon: const Icon(Icons.account_circle_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 비밀번호 입력 필드
        TextFormField(
          controller: widget.passwordController,
          decoration: InputDecoration(
            labelText: '비밀번호',
            hintText: '비밀번호를 입력하세요',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.theme.colorScheme.primary, width: 2),
            ),
          ),
          obscureText: !_isPasswordVisible,
        ),

        // 비밀번호 요구사항
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.check, size: 16, color: widget.theme.colorScheme.primary),
              const SizedBox(width: 4),
              const Text('영문포함', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Icon(Icons.check, size: 16, color: widget.theme.colorScheme.primary),
              const SizedBox(width: 4),
              const Text('숫자포함', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 8),
              Icon(Icons.check, size: 16, color: widget.theme.colorScheme.primary),
              const SizedBox(width: 4),
              const Text('8-20자 이내', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 비밀번호 확인 입력 필드
        TextFormField(
          controller: widget.confirmPasswordController,
          decoration: InputDecoration(
            labelText: '비밀번호 확인',
            hintText: '비밀번호를 다시 입력하세요',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: widget.theme.colorScheme.primary, width: 2),
            ),
          ),
          obscureText: !_isConfirmPasswordVisible,
        ),

        // 비밀번호 일치 여부
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Icon(Icons.check, size: 16, color: widget.theme.colorScheme.primary),
              const SizedBox(width: 4),
              const Text('비밀번호 일치', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }
}
