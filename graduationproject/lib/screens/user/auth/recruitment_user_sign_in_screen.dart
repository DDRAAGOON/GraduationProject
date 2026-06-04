import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/services/session_manager.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import 'sign_up_screen/email_password_sign_up_screen.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';

class RecruitmentUserSignInScreen extends StatefulWidget {
  const RecruitmentUserSignInScreen({super.key});

  @override
  State<RecruitmentUserSignInScreen> createState() =>
      _RecruitmentUserSignInScreenState();
}

class _RecruitmentUserSignInScreenState
    extends State<RecruitmentUserSignInScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String? _emailError;
  String? _passError;

  final GoogleSignIn _googleSignInInstance = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    setState(() {
      _emailError = _email.text.contains('@') ? null : t.enterValidEmail;
      _passError = _password.text.isNotEmpty ? null : t.min8Chars;
    });

    if (_emailError != null || _passError != null) return;
    setState(() => _loading = true);

    // Bypass login for UI testing
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _loading = false);

    // التحقق هل المستخدم قادم من عملية إنشاء حساب جديد أم لا
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final bool isNewUser = args?['fromSignUp'] ?? false;

    if (isNewUser) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.userCompleteProfile, (route) => false);
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.userWorkspace, (route) => false);
    }
    return;

    try {
      final user = await RecruitmentSyncService.instance.login(
        email: _email.text.trim(),
        password: _password.text,
        expectedRole: 'user',
      );

      final name = user['name']?.toString() ?? 'User';

      await SessionManager.saveUserSession(
        email: _email.text.trim(),
        name: name,
      );

      if (!mounted) return;
      setState(() => _loading = false);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.userCompleteProfile, (route) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      String msg = t.isAr
          ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
          : 'Invalid email or password.';

      if (e is DioException) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout) {
          msg = t.isAr
              ? 'فشل الاتصال بالخادم، تحقق من الإنترنت'
              : 'Connection timeout. Check your internet.';
        } else if (e.response?.statusCode == 401 ||
            e.response?.statusCode == 403) {
          msg = t.isAr
              ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
              : 'Invalid email or password.';
        } else {
          msg = t.isAr
              ? 'حدث خطأ في الاتصال بالخادم'
              : 'Server connection error.';
        }
      } else {
        msg =
            e.toString().contains('حساب مخصص') ||
                e.toString().contains('company accounts')
            ? e.toString().replaceAll('Exception: ', '')
            : msg;
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignInInstance
          .signIn();
      if (googleUser == null) {
        setState(() => _loading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get Google ID Token');
      }

      await RecruitmentSyncService.instance.googleLogin(idToken);

      final name = googleUser.displayName ?? googleUser.email.split('@').first;

      await SessionManager.saveUserSession(email: googleUser.email, name: name);

      if (!mounted) return;

      setState(() => _loading = false);
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.userCompleteProfile, (route) => false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark || 
                      (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        
        final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
        final textColorPrimary = isDark ? Colors.white : const Color(0xFF000000);

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              children: [
                const SizedBox(height: 20),
                // Title
                _buildTitle(t, isDark),
                
                const SizedBox(height: 60),

                // Email Field
                _buildLabel(t.emailAddress, textColorPrimary),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _email,
                  hint: t.tr(en: 'Enter your email', ar: 'اكتب بريدك الإلكتروني'),
                  prefixIcon: Icons.mail_outline,
                  isDark: isDark,
                  errorText: _emailError,
                ),

                const SizedBox(height: 24),

                // Password Field
                _buildLabel(t.password, textColorPrimary),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _password,
                  hint: t.tr(en: 'Enter your password', ar: 'اكتب كلمة المرور'),
                  prefixIcon: Icons.lock_outline,
                  isDark: isDark,
                  obscureText: _obscure,
                  errorText: _passError,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userForgotPassword),
                    child: Text(
                      t.forgotPassword,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Continue Button
                _buildContinueButton(t),

                const SizedBox(height: 32),

                // Divider
                _buildDivider(t, textColorPrimary),

                const SizedBox(height: 32),

                // Google Button
                _buildGoogleButton(t),

                const SizedBox(height: 24),

                // Sign up footer
                _buildFooter(t, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitle(AppLocalizations t, bool isDark) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.bold,
          height: 1.2,
          fontFamily: 'Inter',
        ),
        children: [
          TextSpan(
            text: t.isAr ? 'تسجيل الدخول ' : 'Sign ',
            style: const TextStyle(color: Color(0xFFF77F32)),
          ),
          TextSpan(
            text: t.isAr ? 'إلى ' : 'in to ',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          TextSpan(
            text: t.isAr ? 'حسابك' : 'your\nAccount',
            style: const TextStyle(color: Color(0xFF0051DD)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color.withOpacity(0.8),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData prefixIcon,
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    String? errorText,
  }) {
    final borderColor = isDark ? Colors.white30 : Colors.black26;
    final iconColor = isDark ? Colors.white70 : Colors.black54;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: iconColor, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: isDark ? Colors.white : const Color(0xFF142C66), width: 1.5),
        ),
        errorText: errorText,
      ),
    );
  }

  Widget _buildContinueButton(AppLocalizations t) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF142C66).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _loading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142C66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: _loading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                t.continueBtn,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildDivider(AppLocalizations t, Color textColor) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black26)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            t.tr(en: "Or sign in with", ar: "أو سجل دخولك عبر"),
            style: TextStyle(
              color: textColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black26)),
      ],
    );
  }

  Widget _buildGoogleButton(AppLocalizations t) {
    return Container(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _loading ? null : _handleGoogleSignIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_loading)
              const CircularProgressIndicator(color: Colors.white)
            else ...[
              const Text(
                'Continue with ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(text: 'G', style: TextStyle(color: Color(0xFF4285F4))),
                    TextSpan(text: 'o', style: TextStyle(color: Color(0xFFEA4335))),
                    TextSpan(text: 'o', style: TextStyle(color: Color(0xFFFBBC05))),
                    TextSpan(text: 'g', style: TextStyle(color: Color(0xFF4285F4))),
                    TextSpan(text: 'l', style: TextStyle(color: Color(0xFF34A853))),
                    TextSpan(text: 'e', style: TextStyle(color: Color(0xFFEA4335))),
                  ],
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(AppLocalizations t, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          t.tr(en: "Don't have an account, ", ar: "ليس لديك حساب؟ "),
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EmailPasswordSignUpScreen(),
              ),
            );
          },
          child: Text(
            t.signUpBtn,
            style: const TextStyle(
              color: Color(0xFFF77F32),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
