import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class RecruitmentUserSignInScreen extends StatefulWidget {
  const RecruitmentUserSignInScreen({super.key});

  @override
  State<RecruitmentUserSignInScreen> createState() =>
      _RecruitmentUserSignInScreenState();
}

class _RecruitmentUserSignInScreenState extends State<RecruitmentUserSignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  String? _emailError;
  String? _passError;

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() {
      _emailError = _email.text.contains('@')
          ? null
          : (_isAr ? 'اكتب ايميل صحيح' : 'Enter valid email');
      _passError = _password.text.length >= 8
          ? null
          : (_isAr ? 'كلمة المرور 8 حروف على الأقل' : 'Min 8 characters');
    });
    if (_emailError != null || _passError != null) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.userWorkspace,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isAr ? 'تسجيل دخول المستخدم' : 'User Sign In')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _isAr ? 'أهلا بيك' : 'Welcome back',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: _isAr ? 'البريد الإلكتروني' : 'Email',
            controller: _email,
            hint: _isAr ? 'اكتب ايميلك' : 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
            prefixIcon: Icons.mail_outline,
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: _isAr ? 'كلمة المرور' : 'Password',
            controller: _password,
            hint: _isAr ? 'اكتب كلمة المرور' : 'Enter your password',
            obscureText: _obscure,
            validatorText: _passError,
            prefixIcon: Icons.lock_outline,
            suffix: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          const SizedBox(height: 18),
          AppButton(
            label: _isAr ? 'دخول' : 'Sign In',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
