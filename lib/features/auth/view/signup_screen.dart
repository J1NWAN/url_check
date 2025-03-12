import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_check/core/theme/custom_text_theme.dart';
import 'package:url_check/core/toast/custom_toast.dart';
import 'package:url_check/core/toast/enum/toast_type.dart';
import 'package:url_check/features/auth/view/step/signup_terms_step.dart';
import 'package:url_check/features/auth/view/step/signup_profile_step.dart';
import 'package:url_check/features/auth/view/step/signup_credentials_step.dart';
import 'package:url_check/features/auth/viewmodel/signup_view_model.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  // 현재 단계를 추적하는 변수
  int _currentStep = 0;

  // 폼 키와 컨트롤러
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // 약관 동의 여부
  bool _agreeToAll = false;
  bool _agreeToTerms = false;
  bool _agreeToAge = false;
  bool _agreeToPersonalInfo = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // 다음 단계로 이동
  void _nextStep() {
    if (_currentStep == 0 && (!_agreeToTerms || !_agreeToAge || !_agreeToPersonalInfo)) {
      CustomToast.show(context, '필수 약관에 모두 동의해주세요', type: ToastType.error);
      return;
    }

    if (_currentStep == 1) {
      if (_nameController.text.isEmpty) {
        CustomToast.show(context, '이름을 입력해주세요', type: ToastType.error);
        return;
      }
      if (_emailController.text.isEmpty) {
        CustomToast.show(context, '이메일을 입력해주세요', type: ToastType.error);
        return;
      }
    }

    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeSignup();
    }
  }

  // 이전 단계로 이동
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    } else {
      context.go('/login');
    }
  }

  // 회원가입 완료
  void _completeSignup() {
    ref.read(signupViewModelProvider).idController.text = _idController.text;
    ref.read(signupViewModelProvider).nameController.text = _nameController.text;
    ref.read(signupViewModelProvider).emailController.text = _emailController.text;
    ref.read(signupViewModelProvider).passwordController.text = _passwordController.text;
    ref.read(signupViewModelProvider).confirmPasswordController.text = _confirmPasswordController.text;
    ref.read(signupViewModelProvider.notifier).signup(context);
  }

  // 모든 동의 상태 업데이트
  void _updateAllAgreement(bool value) {
    setState(() {
      _agreeToAll = value;
      _agreeToTerms = value;
      _agreeToAge = value;
      _agreeToPersonalInfo = value;
    });
  }

  // 개별 동의 상태 업데이트
  void _updateAgreement(String type, bool value) {
    setState(() {
      switch (type) {
        case 'terms':
          _agreeToTerms = value;
          break;
        case 'age':
          _agreeToAge = value;
          break;
        case 'personal':
          _agreeToPersonalInfo = value;
          break;
      }

      // 모든 약관 동의 상태 업데이트
      _agreeToAll = _agreeToTerms && _agreeToAge && _agreeToPersonalInfo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 진행 상태 표시
              LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: Colors.grey[300],
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),

              // 단계별 화면
              Expanded(
                child: SingleChildScrollView(
                  child: _buildCurrentStep(theme),
                ),
              ),

              // 다음 버튼
              ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _currentStep == 0 ? '동의하고 가입하기' : (_currentStep == 2 ? '완료' : '다음'),
                  style: GoogleFonts.notoSansKr(
                    fontSize: CustomTextTheme.theme.bodyMedium?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 현재 단계에 맞는 화면 반환
  Widget _buildCurrentStep(ThemeData theme) {
    switch (_currentStep) {
      case 0:
        return SignupTermsStep(
          agreeToAll: _agreeToAll,
          agreeToTerms: _agreeToTerms,
          agreeToAge: _agreeToAge,
          agreeToPersonalInfo: _agreeToPersonalInfo,
          onAllAgreementChanged: _updateAllAgreement,
          onAgreementChanged: _updateAgreement,
        );
      case 1:
        return SignupProfileStep(
          nameController: _nameController,
          emailController: _emailController,
          theme: theme,
        );
      case 2:
        return SignupCredentialsStep(
          idController: _idController,
          passwordController: _passwordController,
          confirmPasswordController: _confirmPasswordController,
          theme: theme,
        );
      default:
        return Container();
    }
  }
}
