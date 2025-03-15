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

  // 비밀번호 요구사항 충족 여부를 저장할 변수들
  bool _hasLetter = false;
  bool _hasNumber = false;
  bool _hasValidLength = false;
  bool _passwordsMatch = false;

  @override
  void initState() {
    super.initState();
    // 비밀번호 컨트롤러에 리스너 추가
    widget.passwordController.addListener(_checkPasswordRequirements);
    widget.confirmPasswordController.addListener(_checkPasswordMatch);
  }

  @override
  void dispose() {
    // 리스너 제거
    widget.passwordController.removeListener(_checkPasswordRequirements);
    widget.confirmPasswordController.removeListener(_checkPasswordMatch);
    super.dispose();
  }

  // 비밀번호 요구사항 검사
  void _checkPasswordRequirements() {
    final password = widget.passwordController.text;

    setState(() {
      // 영문 포함 여부 검사
      _hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);

      // 숫자 포함 여부 검사
      _hasNumber = RegExp(r'[0-9]').hasMatch(password);

      // 길이 검사 (8-20자)
      _hasValidLength = password.length >= 8 && password.length <= 20;

      // 비밀번호 일치 여부 재검사
      _checkPasswordMatch();
    });
  }

  // 비밀번호 일치 여부 검사
  void _checkPasswordMatch() {
    setState(() {
      _passwordsMatch =
          widget.passwordController.text.isNotEmpty && widget.passwordController.text == widget.confirmPasswordController.text;
    });
  }

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
              // 영문 포함 요구사항
              Icon(
                widget.passwordController.text.isEmpty
                    ? Icons.check
                    : _hasLetter
                        ? Icons.check
                        : Icons.close,
                size: 16,
                color: widget.passwordController.text.isEmpty
                    ? Colors.grey
                    : _hasLetter
                        ? widget.theme.colorScheme.primary
                        : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '영문포함',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.passwordController.text.isEmpty
                      ? Colors.grey
                      : _hasLetter
                          ? widget.theme.colorScheme.primary
                          : Colors.red,
                ),
              ),
              const SizedBox(width: 8),

              // 숫자 포함 요구사항
              Icon(
                widget.passwordController.text.isEmpty
                    ? Icons.check
                    : _hasNumber
                        ? Icons.check
                        : Icons.close,
                size: 16,
                color: widget.passwordController.text.isEmpty
                    ? Colors.grey
                    : _hasNumber
                        ? widget.theme.colorScheme.primary
                        : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '숫자포함',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.passwordController.text.isEmpty
                      ? Colors.grey
                      : _hasNumber
                          ? widget.theme.colorScheme.primary
                          : Colors.red,
                ),
              ),
              const SizedBox(width: 8),

              // 길이 요구사항
              Icon(
                widget.passwordController.text.isEmpty
                    ? Icons.check
                    : _hasValidLength
                        ? Icons.check
                        : Icons.close,
                size: 16,
                color: widget.passwordController.text.isEmpty
                    ? Colors.grey
                    : _hasValidLength
                        ? widget.theme.colorScheme.primary
                        : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '8-20자 이내',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.passwordController.text.isEmpty
                      ? Colors.grey
                      : _hasValidLength
                          ? widget.theme.colorScheme.primary
                          : Colors.red,
                ),
              ),
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
              Icon(
                widget.confirmPasswordController.text.isEmpty
                    ? Icons.check
                    : _passwordsMatch
                        ? Icons.check
                        : Icons.close,
                size: 16,
                color: widget.confirmPasswordController.text.isEmpty
                    ? Colors.grey
                    : _passwordsMatch
                        ? widget.theme.colorScheme.primary
                        : Colors.red,
              ),
              const SizedBox(width: 4),
              Text(
                '비밀번호 일치',
                style: TextStyle(
                  fontSize: 12,
                  color: widget.confirmPasswordController.text.isEmpty
                      ? Colors.grey
                      : _passwordsMatch
                          ? widget.theme.colorScheme.primary
                          : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
