import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/features/auth/widget/signup_widget.dart';

class SignupTermsStep extends StatelessWidget {
  final bool agreeToAll;
  final bool agreeToTerms;
  final bool agreeToAge;
  final bool agreeToPersonalInfo;
  final Function(bool) onAllAgreementChanged;
  final Function(String, bool) onAgreementChanged;

  const SignupTermsStep({
    super.key,
    required this.agreeToAll,
    required this.agreeToTerms,
    required this.agreeToAge,
    required this.agreeToPersonalInfo,
    required this.onAllAgreementChanged,
    required this.onAgreementChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URL Check 서비스 이용약관에\n동의해주세요.',
          style: GoogleFonts.notoSansKr(
            fontSize: CustomTextTheme.theme.displaySmall?.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),

        // 모두 동의 체크박스
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: agreeToAll,
                onChanged: (value) => onAllAgreementChanged(value ?? false),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '모두 동의 (선택 정보 포함)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: CustomTextTheme.theme.bodyMedium?.fontSize,
              ),
            ),
          ],
        ),

        const SizedBox(height: 24),
        const Divider(height: 1),
        const SizedBox(height: 16),

        // 만 14세 이상 동의
        SignupCheckboxItem(
          value: agreeToAge,
          onChanged: (value) => onAgreementChanged('age', value ?? false),
          text: '[필수] 만 14세 이상',
          isRequired: true,
        ),

        const SizedBox(height: 16),

        // 이용약관 동의
        SignupCheckboxItem(
          value: agreeToTerms,
          onChanged: (value) => onAgreementChanged('terms', value ?? false),
          text: '[필수] 이용약관 동의',
          isRequired: true,
          showViewButton: true,
          onViewPressed: () {
            // 이용약관 보기 기능
          },
        ),

        const SizedBox(height: 16),

        // 개인정보 처리방침 동의
        SignupCheckboxItem(
          value: agreeToPersonalInfo,
          onChanged: (value) => onAgreementChanged('personal', value ?? false),
          text: '[필수] 개인정보 처리방침 동의',
          isRequired: true,
          showViewButton: true,
          onViewPressed: () {
            // 개인정보 처리방침 보기 기능
          },
        ),

        const SizedBox(height: 16),
      ],
    );
  }
}
