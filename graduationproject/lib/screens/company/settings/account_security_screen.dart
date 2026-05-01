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
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // فصل الـ Loading عن بعض
  bool _isEmailLoading = false;
  bool _isPasswordLoading = false;
  bool _isGoogleLoading = false;
  bool _isGoogleLinked = false;

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ✅ تحديث الإيميل
  Future<void> _updateEmail() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.tr(en: 'Please enter an email', ar: 'الرجاء إدخال البريد الإلكتروني'))),
      );
      return;
    }

    setState(() => _isEmailLoading = true);
    try {
      // TODO: استبدل الكود ده بالـ API Call الحقيقي
      await Future.delayed(const Duration(milliseconds: 800));
      messenger.showSnackBar(
        SnackBar(content: Text(t.saved)),
      );
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  // ✅ تحديث كلمة المرور
  Future<void> _updatePassword() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.tr(en: 'All password fields are required', ar: 'جميع حقول كلمة المرور مطلوبة'))),
      );
      return;
    }
    if (newPass.length < 6) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.tr(en: 'Password must be at least 6 characters', ar: 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'))),
      );
      return;
    }
    if (newPass != confirm) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.tr(en: 'Passwords do not match', ar: 'كلمات المرور غير متطابقة'))),
      );
      return;
    }

    setState(() => _isPasswordLoading = true);
    try {
      // TODO: استبدل الكود ده بالـ API Call الحقيقي
      await Future.delayed(const Duration(milliseconds: 800));
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      messenger.showSnackBar(
        SnackBar(content: Text(t.saved)),
      );
    } finally {
      if (mounted) setState(() => _isPasswordLoading = false);
    }
  }

  Future<void> _linkGoogleAccount() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isGoogleLoading = true);
    try {
      // TODO: ضع كود google_sign_in هنا
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() => _isGoogleLinked = true);
      messenger.showSnackBar(
        SnackBar(content: Text (t.tr(en: 'Linked successfully', ar: 'تم الربط بنجاح'))),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
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
          _sectionTitle(t.tr(en: 'Email Address', ar: 'البريد الإلكتروني')),
          const SizedBox(height: 10),
          AppTextField(
            label: '',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          Align(
            alignment: t.isAr ? Alignment.centerLeft : Alignment.centerRight,
            child: AppButton(
              label: t.tr(en: 'Update', ar: 'تحديث'),
              onPressed: _updateEmail,
              loading: _isEmailLoading,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 24),
          _sectionTitle(t.tr(en: 'Change Password', ar: 'تغيير كلمة المرور')),
          const SizedBox(height: 16),
          AppTextField(
            label: t.currentPassword,
            controller: _currentPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.newPasswordLabel,
            controller: _newPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.confirmNewPassword,
            controller: _confirmPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 24),
          AppButton(
            label: t.tr(en: 'Update Password', ar: 'تحديث كلمة المرور'),
            onPressed: _updatePassword,
            loading: _isPasswordLoading,
          ),
          const SizedBox(height: 32),
          const Divider(),
          const SizedBox(height: 24),
          _sectionTitle(t.linkGoogleAccount),
          const SizedBox(height: 8),
          Text(
            t.linkGoogleDesc,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          _buildGoogleCard(context, t),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGoogleCard(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isGoogleLinked ? Icons.link : Icons.link_off,
                color: _isGoogleLinked ? Colors.green : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                _isGoogleLinked ? t.tr(en: 'Linked successfully', ar: 'تم الربط بنجاح') : t.accountNotLinked,
                style: TextStyle(
                  color: _isGoogleLinked ? Colors.green : Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (!_isGoogleLinked) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _linkGoogleAccount,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: _isGoogleLoading 
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : SvgPicture.asset(
                    'assets/company/icon/google_g.svg',
                    width: 18,
                    height: 18,
                  ),
              label: Text(t.continueWithGoogle),
            ),
          ],
        ],
      ),
    );
  }
}