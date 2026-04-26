import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';

class CompanyAccountSecurityScreen extends StatefulWidget {
  const CompanyAccountSecurityScreen({super.key});

  @override
  State<CompanyAccountSecurityScreen> createState() => _CompanyAccountSecurityScreenState();
}

class _CompanyAccountSecurityScreenState extends State<CompanyAccountSecurityScreen> {
  final _emailController = TextEditingController();
  final _currentPassword = TextEditingController();
  final _newPassword = TextEditingController();
  final _confirmPassword = TextEditingController();
  
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _currentPassword.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _save() async {
    final t = AppLocalizations.of(context);
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(t.saved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.accountSecurity,
      showBack: true,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.tr(en: 'Email Address', ar: 'البريد الإلكتروني'),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  if (_emailController.text.isEmpty) return;
                  setState(() => _loading = true);
                  await Future.delayed(const Duration(milliseconds: 600));
                  if (!mounted) return;
                  setState(() => _loading = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.saved)),
                  );
                },
                child: Text(
                  t.tr(en: 'Update', ar: 'تحديث'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: '',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          
          Text(
            t.tr(en: 'Change Password', ar: 'تغيير كلمة المرور'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.currentPassword,
            controller: _currentPassword,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.newPasswordLabel,
            controller: _newPassword,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.confirmNewPassword,
            controller: _confirmPassword,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: t.tr(en: 'Update Password', ar: 'تحديث كلمة المرور'),
            onPressed: _save,
            loading: _loading,
          ),
          
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          
          Text(
            t.linkGoogleAccount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            t.linkGoogleDesc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.link_off, color: Theme.of(context).colorScheme.error),
                    const SizedBox(width: 12),
                    Text(
                      t.accountNotLinked,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: SvgPicture.asset(
                    'assets/company/icon/google_g.svg',
                    width: 18,
                    height: 18,
                  ),
                  label: Text(t.continueWithGoogle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
