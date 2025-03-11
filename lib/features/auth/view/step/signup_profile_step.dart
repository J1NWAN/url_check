import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupProfileStep extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '로그인에 사용할\n개인정보를 입력해주세요.',
          style: GoogleFonts.notoSansKr(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        // 이름 입력 필드
        TextFormField(
          controller: nameController,
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
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // 이메일 입력 필드
        TextFormField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: '이메일',
            hintText: '이메일을 입력하세요',
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
              borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
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
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('입력하신 이메일로 인증 메일이 발송됩니다.'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
