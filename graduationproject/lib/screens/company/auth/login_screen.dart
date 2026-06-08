// Company Login Screen – JWT-based authentication entry point.
//
// Merges the premium UI from the new login_screen with the full API logic
// (RecruitmentSyncService, SessionManager, CompanyStore, Google Sign-In)
// from the original sign_in_screen.
//
// On successful login the JWT is stored via [SecureStorage], the local
// [CompanyStore] is seeded, and the user is pushed to [CompanyDashboardScreen]
// (stack is fully cleared so Back cannot return here).

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app/router/app_router.dart';
import '../../../core/network/api_error_handler.dart';
import '../../../core/network/secure_storage.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/services/session_manager.dart';
import '../../../shared/state/company_store.dart';

class CompanyLoginScreen extends StatefulWidget {
  const CompanyLoginScreen({super.key});

  @override
  State<CompanyLoginScreen> createState() => _CompanyLoginScreenState();
}

class _CompanyLoginScreenState extends State<CompanyLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Submit (Email + Password)
  // ---------------------------------------------------------------------------

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    try {
      // Use the app-wide sync service which handles token storage internally.
      final userData = await RecruitmentSyncService.instance.loginLegacy(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        expectedRole: 'company',
      );

      final userName =
          userData['name']?.toString() ?? _emailController.text.split('@').first;

      // Persist the session locally.
      await SessionManager.saveCompanySession(
        email: _emailController.text.trim(),
        name: userName,
      );

      if (!mounted) return;

      // Seed the in-memory store so the dashboard renders immediately.
      CompanyStore.instance.setRegistrationData(
        companyName: userName,
        email: _emailController.text.trim(),
      );

      // Also ensure the token returned by loginLegacy is in SecureStorage
      // (RecruitmentSyncService already does this, but being explicit here).
      final token = userData['token']?.toString() ??
          userData['accessToken']?.toString() ??
          userData['access_token']?.toString();
      if (token != null && token.isNotEmpty) {
        await SecureStorage.saveToken(token);
      }

      await RecruitmentSyncService.instance.startPolling();

      if (!mounted) return;
      _navigateToDashboard();
    } catch (e) {
      if (!mounted) return;
      _showError(_mapError(e));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Google Sign-In
  // ---------------------------------------------------------------------------

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the picker.
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) throw Exception('Failed to get Google ID Token');

      final userData =
          await RecruitmentSyncService.instance.googleLogin(idToken);

      final companyName =
          userData['name']?.toString() ??
          googleUser.displayName ??
          googleUser.email.split('@').first;
      final userEmail = userData['data']?['email']?.toString() ??
          userData['email']?.toString() ??
          googleUser.email;

      await SessionManager.saveCompanySession(
        email: userEmail,
        name: companyName,
      );

      if (!mounted) return;

      CompanyStore.instance.setRegistrationData(
        companyName: companyName,
        email: userEmail,
      );

      _navigateToDashboard();
    } catch (e) {
      if (!mounted) return;
      final t = AppLocalizations.of(context);
      _showError('${t.googleSignInFailed}: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  void _navigateToDashboard() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.companyDashboard,
      (route) => false,
    );
  }

  String _mapError(Object e) {
    if (e is AppException) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      return e.localizedMessage(isAr);
    }
    
    final t = AppLocalizations.of(context);
    final msg = e.toString().replaceAll('Exception: ', '');
    // Keep role-specific messages.
    if (msg.contains('حساب شركة') || msg.contains('company account')) {
      return msg;
    }
    return t.invalidCredentials;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF001428) : const Color(0xFFF6F8FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Header ────────────────────────────────────────────────
                  _buildHeader(isDark, cs, isAr),
                  const SizedBox(height: 40),

                  // ── Email ─────────────────────────────────────────────────
                  _buildLabel(t.emailAddress, isDark),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87),
                    decoration: _inputDecoration(
                      hint: t.enterYourEmail,
                      icon: Icons.email_outlined,
                      isDark: isDark,
                      cs: cs,
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return t.required;
                      if (!v.contains('@') || !v.contains('.')) {
                        return t.enterValidEmail;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ── Password ──────────────────────────────────────────────
                  _buildLabel(t.password, isDark),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87),
                    decoration: _inputDecoration(
                      hint: '••••••••',
                      icon: Icons.lock_outline,
                      isDark: isDark,
                      cs: cs,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: cs.onSurface.withValues(alpha: 0.55),
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return t.required;
                      if (v.length < 8) return t.min8Chars;
                      return null;
                    },
                  ),

                  // ── Forgot Password ───────────────────────────────────────
                  Align(
                    alignment: isAr
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.companyForgotPassword),
                      child: Text(
                        t.forgotPassword,
                        style: TextStyle(
                          color: cs.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Sign In Button ────────────────────────────────────────
                  _buildPrimaryButton(cs),
                  const SizedBox(height: 24),

                  // ── Divider ───────────────────────────────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                            color: cs.onSurface.withValues(alpha: 0.15)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Text(
                          t.orSignInWith,
                          style: TextStyle(
                              color: cs.onSurface.withValues(alpha: 0.45),
                              fontSize: 13),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                            color: cs.onSurface.withValues(alpha: 0.15)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Google Button ─────────────────────────────────────────
                  OutlinedButton.icon(
                    onPressed: _isLoading ? null : _handleGoogleSignIn,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                          color: cs.outline.withValues(alpha: 0.4)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    icon: SvgPicture.asset(
                      'assets/company/icon/google_g.svg',
                      width: 20,
                      height: 20,
                      placeholderBuilder: (_) =>
                          const Icon(Icons.login, size: 20),
                    ),
                    label: const Text(
                      'Continue with Google',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Sign-up link ──────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.dontHaveAccount,
                        style: TextStyle(
                            color: cs.onSurface.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => Navigator.of(context)
                            .pushNamed(AppRoutes.companySignUp),
                        child: Text(
                          t.signUpBtn,
                          style: TextStyle(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: cs.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Widget helpers
  // ---------------------------------------------------------------------------

  Widget _buildHeader(bool isDark, ColorScheme cs, bool isAr) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [cs.primary, cs.primary.withValues(alpha: 0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: cs.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child:
              const Icon(Icons.work_rounded, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          isAr ? 'مرحباً بعودتك 👋' : 'Welcome back 👋',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1A1D23),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          isAr
              ? 'سجّل دخولك لإدارة وظائفك وطلبات التوظيف.'
              : 'Sign in to manage your jobs and applications.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white60 : Colors.black45,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLabel(String text, bool isDark) => Text(
        text,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white70 : const Color(0xFF2C2C2C),
        ),
      );

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool isDark,
    required ColorScheme cs,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: cs.onSurface.withValues(alpha: 0.38)),
      prefixIcon:
          Icon(icon, color: cs.primary.withValues(alpha: 0.7), size: 20),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.outline.withValues(alpha: 0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: cs.error, width: 1.8),
      ),
    );
  }

  Widget _buildPrimaryButton(ColorScheme cs) {
    return SizedBox(
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: _isLoading
              ? null
              : LinearGradient(
                  colors: [cs.primary, cs.primary.withValues(alpha: 0.75)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: _isLoading ? cs.primary.withValues(alpha: 0.5) : null,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: _isLoading
              ? []
              : [
                  BoxShadow(
                    color: cs.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  Localizations.localeOf(context).languageCode == 'ar'
                      ? 'تسجيل الدخول'
                      : 'Sign In',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
