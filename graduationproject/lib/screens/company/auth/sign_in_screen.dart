// Company sign-in with validation and social placeholder.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/services/session_manager.dart';
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
    final t = AppLocalizations.of(context);
    final email = _email.text.trim();
    final pass = _password.text;
    setState(() {
      _emailError = email.contains('@') ? null : t.enterValidEmail;
      _passwordError = pass.length >= 8 ? null : t.min8Chars;
    });
    return _emailError == null && _passwordError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    // In a real app, you'd fetch the company name from a database. 
    // Here we'll use a placeholder or just save the email as a name part for demo.
    await SessionManager.saveCompanySession(
      email: _email.text.trim(),
      name: _email.text.split('@').first,
    );
    
    if (!mounted) return;

    // Update store
    CompanyStore.instance.setRegistrationData(
      companyName: _email.text.split('@').first,
      email: _email.text.trim(),
    );

    setState(() => _loading = false);
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.companyDashboard, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: null,
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 18),
          Text(
            t.signInToAccount,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 32,
                ),
          ),
          const SizedBox(height: 30),
          AppTextField(
            label: t.companyEmailAddress,
            controller: _email,
            hint: t.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
            onChanged: (_) =>
                _emailError == null ? null : setState(() => _emailError = null),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.password,
            controller: _password,
            hint: t.enterYourPassword,
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
            alignment: t.isAr ? Alignment.centerLeft : Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.companyForgotPassword,
              ),
              child: Text(t.forgotPassword),
            ),
          ),
          const SizedBox(height: 10),
          AppButton(
            label: t.continueBtn,
            loading: _loading,
            onPressed: _submit,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(t.orSignInWith),
              ),
              Expanded(child: Divider(color: Colors.white.withOpacity(0.15))),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: _loading ? null : _submit,
            icon: SvgPicture.asset(
              'assets/company/icon/google_g.svg',
              width: 18,
              height: 18,
            ),
            label: const Text('Google'),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                t.dontHaveAccount,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.companySignUp),
                child: Text(t.signUpBtn),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
