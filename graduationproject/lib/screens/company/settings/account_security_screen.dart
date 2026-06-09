import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/contact_entry.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/services/recruitment_sync_service.dart';

class CompanyAccountSecurityScreen extends StatefulWidget {
  const CompanyAccountSecurityScreen({super.key});

  @override
  State<CompanyAccountSecurityScreen> createState() =>
      _CompanyAccountSecurityScreenState();
}

class _CompanyAccountSecurityScreenState
    extends State<CompanyAccountSecurityScreen>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Social link controllers
  final _linkedinController = TextEditingController();
  final _twitterController = TextEditingController();
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _websiteController = TextEditingController();

  late final TabController _tabController;

  bool _isEmailLoading = false;
  bool _isPasswordLoading = false;
  bool _isGoogleLoading = false;
  bool _isGoogleLinked = false;
  bool _isSocialLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadSocialLinks();
  }

  void _loadSocialLinks() {
    final contacts = CompanyStore.instance.contacts;
    for (final c in contacts) {
      final nameLower = c.name.toLowerCase();
      if (nameLower.contains('linkedin')) _linkedinController.text = c.value;
      if (nameLower.contains('twitter') || nameLower.contains('x.com')) {
        _twitterController.text = c.value;
      }
      if (nameLower.contains('facebook')) _facebookController.text = c.value;
      if (nameLower.contains('instagram')) _instagramController.text = c.value;
      if (nameLower.contains('website') || nameLower.contains('موقع')) {
        _websiteController.text = c.value;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _linkedinController.dispose();
    _twitterController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  Future<void> _updateEmail() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            t.tr(
              en: 'Please enter an email',
              ar: 'الرجاء إدخال البريد الإلكتروني',
            ),
          ),
        ),
      );
      return;
    }
    setState(() => _isEmailLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      messenger.showSnackBar(SnackBar(content: Text(t.saved)));
    } finally {
      if (mounted) setState(() => _isEmailLoading = false);
    }
  }

  Future<void> _updatePassword() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final current = _currentPasswordController.text;
    final newPass = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPass.isEmpty || confirm.isEmpty) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            t.tr(
              en: 'All password fields are required',
              ar: 'جميع حقول كلمة المرور مطلوبة',
            ),
          ),
        ),
      );
      return;
    }
    if (newPass.length < 6) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            t.tr(
              en: 'Password must be at least 6 characters',
              ar: 'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
            ),
          ),
        ),
      );
      return;
    }
    if (newPass != confirm) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            t.tr(en: 'Passwords do not match', ar: 'كلمات المرور غير متطابقة'),
          ),
        ),
      );
      return;
    }

    setState(() => _isPasswordLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      messenger.showSnackBar(SnackBar(content: Text(t.saved)));
    } finally {
      if (mounted) setState(() => _isPasswordLoading = false);
    }
  }

  Future<void> _linkGoogleAccount() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isGoogleLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() => _isGoogleLinked = true);
      messenger.showSnackBar(
        SnackBar(
          content: Text(t.tr(en: 'Linked successfully', ar: 'تم الربط بنجاح')),
        ),
      );
    } finally {
      if (mounted) setState(() => _isGoogleLoading = false);
    }
  }

  Future<void> _saveSocialLinks() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isSocialLoading = true);

    try {
      // Build social links map
      final socialLinks = <String, String>{};
      if (_linkedinController.text.trim().isNotEmpty) {
        socialLinks['linkedin'] = _linkedinController.text.trim();
      }
      if (_twitterController.text.trim().isNotEmpty) {
        socialLinks['twitter'] = _twitterController.text.trim();
      }
      if (_facebookController.text.trim().isNotEmpty) {
        socialLinks['facebook'] = _facebookController.text.trim();
      }
      if (_instagramController.text.trim().isNotEmpty) {
        socialLinks['instagram'] = _instagramController.text.trim();
      }
      if (_websiteController.text.trim().isNotEmpty) {
        socialLinks['website'] = _websiteController.text.trim();
      }

      // Update contacts in store
      final store = CompanyStore.instance;
      // Clear old social contacts
      final toRemove = store.contacts
          .asMap()
          .entries
          .where((e) {
            final n = e.value.name.toLowerCase();
            return n.contains('linkedin') ||
                n.contains('twitter') ||
                n.contains('facebook') ||
                n.contains('instagram') ||
                n.contains('website') ||
                n.contains('موقع');
          })
          .map((e) => e.key)
          .toList()
          .reversed
          .toList();
      for (final idx in toRemove) {
        store.removeContact(idx);
      }

      // Add updated ones
      if (_linkedinController.text.trim().isNotEmpty) {
        store.addContact(
          ContactEntry(
            name: 'LinkedIn',
            value: _linkedinController.text.trim(),
          ),
        );
      }
      if (_twitterController.text.trim().isNotEmpty) {
        store.addContact(
          ContactEntry(
            name: 'Twitter/X',
            value: _twitterController.text.trim(),
          ),
        );
      }
      if (_facebookController.text.trim().isNotEmpty) {
        store.addContact(
          ContactEntry(
            name: 'Facebook',
            value: _facebookController.text.trim(),
          ),
        );
      }
      if (_instagramController.text.trim().isNotEmpty) {
        store.addContact(
          ContactEntry(
            name: 'Instagram',
            value: _instagramController.text.trim(),
          ),
        );
      }
      if (_websiteController.text.trim().isNotEmpty) {
        store.addContact(
          ContactEntry(name: 'Website', value: _websiteController.text.trim()),
        );
      }

      // Sync to backend
      await RecruitmentSyncService.instance.updateCompanyProfile(
        name: store.companyName,
        socialLinks: socialLinks,
      );

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              t.tr(en: 'Social links saved ✅', ar: 'تم حفظ روابط التواصل ✅'),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              t.tr(en: 'Failed to save links', ar: 'فشل في حفظ الروابط'),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSocialLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return AppScaffold(
      title: t.accountSecurity,
      showBack: true,
      body: Column(
        children: [
          // ── Tab Bar ─────────────────────────────────────────────
          TabBar(
            controller: _tabController,
            labelColor: cs.primary,
            unselectedLabelColor: cs.onSurface.withOpacity(0.5),
            indicatorColor: cs.primary,
            tabs: [
              Tab(
                icon: const Icon(Icons.security_outlined, size: 18),
                text: t.tr(en: 'Security', ar: 'الأمان'),
              ),
              Tab(
                icon: const Icon(Icons.link_rounded, size: 18),
                text: t.tr(en: 'Social Links', ar: 'روابط التواصل'),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ── Tab 1: Security ──────────────────────────────
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _sectionTitle(
                      t.tr(en: 'Email Address', ar: 'البريد الإلكتروني'),
                    ),
                    const SizedBox(height: 10),
                    AppTextField(
                      label: '',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: t.isAr
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: AppButton(
                        label: t.tr(en: 'Update', ar: 'تحديث'),
                        onPressed: _updateEmail,
                        loading: _isEmailLoading,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),
                    _sectionTitle(
                      t.tr(en: 'Change Password', ar: 'تغيير كلمة المرور'),
                    ),
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
                      label: t.tr(
                        en: 'Update Password',
                        ar: 'تحديث كلمة المرور',
                      ),
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
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildGoogleCard(context, t),
                    const SizedBox(height: 32),
                    const Divider(),
                    const SizedBox(height: 24),
                    // Delete Account section
                    _sectionTitle(
                      t.tr(en: 'Delete Account', ar: 'حذف الحساب'),
                      color: cs.error,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.tr(
                        en: 'Once you request deletion, your account will be permanently deleted after 7 days. You can cancel during this period.',
                        ar: 'بمجرد طلب الحذف، سيتم حذف حسابك نهائياً بعد 7 أيام. يمكنك إلغاء الإجراء خلال هذه الفترة.',
                      ),
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: cs.error,
                        side: BorderSide(color: cs.error),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        t.tr(en: 'Delete My Account', ar: 'حذف حسابي'),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),

                // ── Tab 2: Social Links ──────────────────────────
                ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      t.tr(
                        en: 'Social Media Links',
                        ar: 'روابط التواصل الاجتماعي',
                      ),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      t.tr(
                        en: 'Add your company\'s social media profiles so candidates can find you.',
                        ar: 'أضف حسابات التواصل الاجتماعي لشركتك حتى يتمكن المرشحون من التواصل معك.',
                      ),
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.6),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSocialField(
                      icon: Icons.business_center_outlined,
                      iconColor: const Color(0xFF0A66C2),
                      label: 'LinkedIn',
                      hint: 'https://linkedin.com/company/...',
                      controller: _linkedinController,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      icon: Icons.close_rounded,
                      iconColor: Colors.black87,
                      label: 'X / Twitter',
                      hint: 'https://twitter.com/...',
                      controller: _twitterController,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      icon: Icons.facebook_rounded,
                      iconColor: const Color(0xFF1877F2),
                      label: 'Facebook',
                      hint: 'https://facebook.com/...',
                      controller: _facebookController,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      icon: Icons.camera_alt_outlined,
                      iconColor: const Color(0xFFE1306C),
                      label: 'Instagram',
                      hint: 'https://instagram.com/...',
                      controller: _instagramController,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      icon: Icons.language_rounded,
                      iconColor: cs.primary,
                      label: t.tr(en: 'Website', ar: 'الموقع الإلكتروني'),
                      hint: 'https://yourcompany.com',
                      controller: _websiteController,
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      label: t.tr(en: 'Save Links', ar: 'حفظ الروابط'),
                      loading: _isSocialLoading,
                      onPressed: _saveSocialLinks,
                      icon: Icons.save_outlined,
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text, {Color? color}) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildSocialField({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String hint,
    required TextEditingController controller,
  }) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.url,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(
            color: cs.onSurface.withOpacity(0.35),
            fontSize: 12,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleCard(BuildContext context, AppLocalizations t) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isGoogleLinked ? Icons.link : Icons.link_off,
                color: _isGoogleLinked
                    ? Colors.green
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Text(
                _isGoogleLinked
                    ? t.tr(en: 'Linked successfully', ar: 'تم الربط بنجاح')
                    : t.accountNotLinked,
                style: TextStyle(
                  color: _isGoogleLinked
                      ? Colors.green
                      : Theme.of(context).colorScheme.error,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: _isGoogleLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
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
