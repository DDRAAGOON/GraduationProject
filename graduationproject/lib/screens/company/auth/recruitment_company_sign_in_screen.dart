import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/services/session_manager.dart';
import '../../../shared/state/company_store.dart';
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
    final t = AppLocalizations.of(context);
    final mail = _email.text.trim();
    final pass = _password.text;
    setState(() {
      _emailError = mail.contains('@') ? null : t.enterValidEmail;
      _passwordError = pass.isNotEmpty ? null : t.enterYourPassword;
    });
    return _emailError == null && _passwordError == null;
  }

  Future<void> _submit() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    try {
      final user = await RecruitmentSyncService.instance.login(
        email: _email.text.trim(),
        password: _password.text,
        expectedRole: 'company',
      );

      final name = user['name']?.toString() ?? 'Company User';

      await SessionManager.saveCompanySession(
        email: _email.text.trim(),
        name: name,
      );

      CompanyStore.instance.setRegistrationData(
        companyName: name,
        email: _email.text.trim(),
      );

      // Pull all jobs/data from server before navigating to workspace
      await RecruitmentSyncService.instance.startPolling();

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.companyWorkspace,
        (route) => false,
      );
    } catch (_) {
      if (!mounted) return;
      final t = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.invalidCredentials)),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const SizedBox(height: 5),
            Transform.translate(
              offset: const Offset(-70, -10),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/tradesman/تسجيل دخول جديد.png',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  Transform.translate(
                    offset: const Offset(-15, -20),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: t.isAr ? 'تسجيل ' : 'Sign ',
                            style: const TextStyle(color: Colors.orange),
                          ),
                          TextSpan(
                            text: t.isAr ? 'الدخول إلى\n' : 'in to\n',
                            style: const TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: t.isAr ? 'حسابك' : 'your Account',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: t.companyEmailAddress,
              controller: _email,
              hint: t.enterYourEmail,
              keyboardType: TextInputType.emailAddress,
              validatorText: _emailError,
              prefixIcon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: t.password,
              controller: _password,
              hint: t.enterYourPassword,
              obscureText: _obscure,
              validatorText: _passwordError,
              prefixIcon: Icons.lock_outline_rounded,
              suffix: IconButton(
                onPressed: () => setState(() => _obscure = !_obscure),
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            Align(
              alignment: t.isAr ? Alignment.centerLeft : Alignment.centerRight,
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.companyForgotPassword),
                child: Text(t.forgotPassword),
              ),
            ),
            const SizedBox(height: 8),
            AppButton(
              label: t.signInBtn,
              loading: _loading,
              onPressed: _submit,
            ),
            const SizedBox(height: 10),
            AppButton(
              label: t.createCompanyAccount,
              variant: AppButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.companySignUp),
            ),
          ],
        ),
      ),
    );
  }
}
