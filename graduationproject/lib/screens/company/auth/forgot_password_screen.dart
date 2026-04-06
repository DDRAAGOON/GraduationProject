import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';

class CompanyForgotPasswordScreen extends StatefulWidget {
  const CompanyForgotPasswordScreen({super.key});

  @override
  State<CompanyForgotPasswordScreen> createState() =>
      _CompanyForgotPasswordScreenState();
}

class _CompanyForgotPasswordScreenState
    extends State<CompanyForgotPasswordScreen> {
  final _email = TextEditingController();
  final _mobile = TextEditingController(text: '+92');
  bool _loading = false;

  String? _emailError;
  String? _mobileError;

  @override
  void dispose() {
    _email.dispose();
    _mobile.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _email.text.trim();
    final mobile = _mobile.text.trim();
    setState(() {
      _emailError = email.contains('@') ? null : 'Enter a valid email';
      _mobileError = mobile.length >= 6 ? null : 'Enter mobile number';
    });
    return _emailError == null && _mobileError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushNamed(
      AppRoutes.companyOtp,
      arguments: _email.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Forgot Password',
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your email address to receive a confirmation\ncode resetting your password.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: 'Email Address',
            controller: _email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Mobile Number',
            controller: _mobile,
            hint: 'Enter mobile number',
            keyboardType: TextInputType.phone,
            validatorText: _mobileError,
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Continue',
            loading: _loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

