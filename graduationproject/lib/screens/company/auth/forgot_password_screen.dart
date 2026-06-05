// Company flow: collect email/phone and continue to OTP or reset.

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

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
  final _mobile = TextEditingController();
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
    final t = AppLocalizations.of(context);
    final email = _email.text.trim();
    final mobile = _mobile.text.trim();
    setState(() {
      _emailError = email.contains('@') ? null : t.enterValidEmail;
      _mobileError = mobile.length >= 6 ? null : t.enterMobileNumber;
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
      title: t.forgotPassword,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t.forgotPassword,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            t.forgotPasswordInstruction,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
          ),
          const SizedBox(height: 22),
          AppTextField(
            label: t.emailAddress,
            controller: _email,
            hint: t.enterYourEmail,
            keyboardType: TextInputType.emailAddress,
            validatorText: _emailError,
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t.mobileNumberLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(height: 8),
              IntlPhoneField(
                controller: _mobile,
                decoration: InputDecoration(
                  hintText: t.enterMobileNumber,
                  errorText: _mobileError,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceBright,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
                initialCountryCode: 'EG',
                flagsButtonPadding: const EdgeInsets.symmetric(horizontal: 8),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                onChanged: (phone) {
                  if (_mobileError != null) {
                    setState(() => _mobileError = null);
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: t.continueBtn,
            loading: _loading,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

