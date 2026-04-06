import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';

class CompanySignInScreen extends StatefulWidget {
  const CompanySignInScreen({super.key});

  @override
  State<CompanySignInScreen> createState() => _CompanySignInScreenState();
}

class _CompanySignInScreenState extends State<CompanySignInScreen> {
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
    final email = _email.text.trim();
    final pass = _password.text;
    setState(() {
      _emailError = email.contains('@') ? null : 'Enter a valid email';
      _passwordError = pass.length >= 8 ? null : 'Minimum 8 characters';
    });
    return _emailError == null && _passwordError == null;
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
            'Sign in to your\naccount',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 30),
          AppTextField(
            label: 'Company Email Address',
            controller: _email,
            hint: 'Enter your email',
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
            onChanged: (_) => _emailError == null ? null : setState(() => _emailError = null),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Password',
            controller: _password,
            hint: 'Enter your password',
            obscureText: _obscure,
            validatorText: _passwordError,
            onChanged: (_) =>
                _passwordError == null ? null : setState(() => _passwordError = null),
            suffix: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.companyForgotPassword,
              ),
              child: const Text('Forgot password?'),
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
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.companySignUp),
                child: const Text('Sign up'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

