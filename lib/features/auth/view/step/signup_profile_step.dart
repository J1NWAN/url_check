import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';

class SignupProfileStep extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final ThemeData theme;

  const SignupProfileStep({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.theme,
  });

  @override
  State<SignupProfileStep> createState() => _SignupProfileStepState();
}

class _SignupProfileStepState extends State<SignupProfileStep> {
  String? _emailErrorText;

  // 이메일 유효성 검사 정규식
  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    // 이메일 컨트롤러에 리스너 추가
    widget.emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    // 리스너 제거
    widget.emailController.removeListener(_validateEmail);
    super.dispose();
  }

  // 이메일 유효성 검사 함수
  void _validateEmail() {
    final email = widget.emailController.text;
    setState(() {
      if (email.isEmpty) {
        _emailErrorText = null;
      } else if (!_emailRegExp.hasMatch(email)) {
        _emailErrorText = '이메일 형식이 올바르지 않습니다.';
      } else {
        _emailErrorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '회원님의\n정보를 입력해주세요.',
          style: GoogleFonts.notoSansKr(
            fontSize: CustomTextTheme.theme.displaySmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        // 이름 입력 필드
        TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            labelText: '이름',
            hintText: '이름을 입력하세요',
            prefixIcon: const Icon(Icons.person_outline),
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

        // 이메일 입력 필드
        TextFormField(
          controller: widget.emailController,
          decoration: InputDecoration(
            labelText: '이메일',
            hintText: '이메일을 입력하세요',
            errorText: _emailErrorText,
            prefixIcon: const Icon(Icons.email_outlined),
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
          keyboardType: TextInputType.emailAddress,
          onChanged: (_) => _validateEmail(),
          onFieldSubmitted: (_) => _validateEmail(),
        ),
        const SizedBox(height: 16),

        // 이메일 인증 안내
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: widget.theme.colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '입력하신 이메일로 인증 메일이 발송됩니다.',
                  style: GoogleFonts.notoSansKr(
                    fontSize: CustomTextTheme.theme.bodyMedium?.fontSize,
                    color: widget.theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
