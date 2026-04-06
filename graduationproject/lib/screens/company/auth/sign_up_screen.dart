import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';

class CompanySignUpScreen extends StatefulWidget {
  const CompanySignUpScreen({super.key});

  @override
  State<CompanySignUpScreen> createState() => _CompanySignUpScreenState();
}

class _CompanySignUpScreenState extends State<CompanySignUpScreen> {
  final _companyName = TextEditingController();
  final _email = TextEditingController();
  final _companyNumber = TextEditingController(text: '+92');
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _address = TextEditingController();
  final _taxNumber = TextEditingController();

  bool _obscure1 = true;
  bool _obscure2 = true;
  bool _agree = false;
  bool _loading = false;

  String? _companyNameError;
  String? _emailError;
  String? _companyNumberError;
  String? _passwordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _companyName.dispose();
    _email.dispose();
    _companyNumber.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _address.dispose();
    _taxNumber.dispose();
    super.dispose();
  }

  bool _validate() {
    final email = _email.text.trim();
    final pass = _password.text;
    final confirm = _confirmPassword.text;
    setState(() {
      _companyNameError = _companyName.text.trim().isNotEmpty ? null : 'Required';
      _emailError = email.contains('@') ? null : 'Enter a valid email';
      _companyNumberError = _companyNumber.text.trim().length >= 6 ? null : 'Enter company number';
      _passwordError = pass.length >= 8 ? null : 'Minimum 8 characters';
      _confirmPasswordError =
          confirm == pass ? null : 'Passwords do not match';
    });
    return _companyNameError == null &&
        _emailError == null &&
        _companyNumberError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _agree;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacementNamed(AppRoutes.companyDashboard);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: null,
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 18),
          Text(
            'Create your new\naccount',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 26),
          AppTextField(
            label: 'Company Name',
            controller: _companyName,
            hint: 'Enter company name',
            validatorText: _companyNameError,
            onChanged: (_) => _companyNameError == null
                ? null
                : setState(() => _companyNameError = null),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Company Email',
            controller: _email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
            onChanged: (_) =>
                _emailError == null ? null : setState(() => _emailError = null),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Company Number',
            controller: _companyNumber,
            hint: 'Enter company number',
            keyboardType: TextInputType.phone,
            validatorText: _companyNumberError,
            onChanged: (_) => _companyNumberError == null
                ? null
                : setState(() => _companyNumberError = null),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            controller: _password,
            hint: 'Enter your password',
            obscureText: _obscure1,
            validatorText: _passwordError,
            suffix: IconButton(
              onPressed: () => setState(() => _obscure1 = !_obscure1),
              icon: Icon(_obscure1 ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Confirm Password',
            controller: _confirmPassword,
            hint: 'Confirm your password',
            obscureText: _obscure2,
            validatorText: _confirmPasswordError,
            suffix: IconButton(
              onPressed: () => setState(() => _obscure2 = !_obscure2),
              icon: Icon(_obscure2 ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Address',
            controller: _address,
            hint: 'Enter address',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Tax number',
            controller: _taxNumber,
            hint: 'Enter tax number',
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Checkbox(
                value: _agree,
                onChanged: _loading ? null : (v) => setState(() => _agree = v ?? false),
              ),
              Expanded(
                child: Text(
                  'I Agree with Terms of Service and Privacy Policy',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (!_agree)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 8),
              child: Text(
                'Please accept terms to continue',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Continue',
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('Or sign in with'),
              ),
              Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.15))),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _loading ? null : _submit,
            icon: const Icon(Icons.g_mobiledata),
            label: const Text('Google'),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already Registered? ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Sign In'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

