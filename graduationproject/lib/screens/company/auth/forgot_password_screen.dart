import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.tr(en: 'Forgot Password', ar: 'نسيت كلمة المرور'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t.tr(en: 'Forgot Password?', ar: 'نسيت كلمة المرور؟'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            t.tr(
              en: 'Enter your email address to receive a confirmation\ncode resetting your password.',
              ar: 'أدخل بريدك الإلكتروني لاستلام رمز التأكيد\nلإعادة تعيين كلمة المرور.',
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: t.tr(en: 'Email Address', ar: 'البريد الإلكتروني'),
            controller: _email,
            hint: t.tr(en: 'Enter your email', ar: 'أدخل بريدك الإلكتروني'),
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.tr(en: 'Mobile Number', ar: 'رقم الهاتف'),
            controller: _mobile,
            hint: t.tr(en: 'Enter mobile number', ar: 'أدخل رقم الهاتف'),
            keyboardType: TextInputType.phone,
            validatorText: _mobileError,
          ),
          const SizedBox(height: 20),
          AppButton(
            label: t.tr(en: 'Continue', ar: 'متابعة'),
            loading: _loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

