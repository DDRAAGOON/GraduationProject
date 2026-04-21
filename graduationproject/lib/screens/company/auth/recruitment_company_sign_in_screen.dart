import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_text_field.dart';

class RecruitmentCompanySignInScreen extends StatefulWidget {
  const RecruitmentCompanySignInScreen({super.key});

  @override
  State<RecruitmentCompanySignInScreen> createState() =>
      _RecruitmentCompanySignInScreenState();
}

class _RecruitmentCompanySignInScreenState
    extends State<RecruitmentCompanySignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  bool _validate() {
    final mail = _email.text.trim();
    final pass = _password.text;
    setState(() {
      _emailError = mail.contains('@') ? null : 'Enter a valid email';
      _passwordError = pass.length >= 8 ? null : 'Min 8 characters';
    });
    return _emailError == null && _passwordError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.companyWorkspace,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 20),
            Text(
              'Welcome Back Company',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in with your company account to manage jobs and candidates.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Company Email Address',
              controller: _email,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validatorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Password',
              controller: _password,
              hint: 'Enter your password',
              obscureText: _obscure,
              validatorText: _passwordError,
              prefixIcon: Icons.lock_outline_rounded,
              suffix: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.companyForgotPassword),
                child: const Text('Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: 'Sign In',
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: 'Create Company Account',
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.companySignUp),
            ),
          ],
        ),
      ),
    );
  }
}
