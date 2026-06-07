import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/theme_controller.dart';
import '../otp_email_verification_screen.dart';

class EmailPasswordSignUpScreen extends StatefulWidget {
  const EmailPasswordSignUpScreen({super.key});

  @override
  State<EmailPasswordSignUpScreen> createState() =>
      _EmailPasswordSignUpScreenState();
}

class _EmailPasswordSignUpScreenState extends State<EmailPasswordSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).acceptTermsMsg)),
      );
      return;
    }

    final email = _emailController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpEmailVerificationScreen(email: email),
      ),
    );
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
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: textColorPrimary),
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: [
                  // Title
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
                                  text: t.isAr ? 'أنشئ ' : 'Create ',
                                  style: const TextStyle(color: Colors.orange),
                                ),
                                TextSpan(
                                  text: t.isAr ? 'حسابك\n' : 'your new\n',
                                  style: const TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: t.isAr ? 'الجديد' : 'account',
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
                  
                  const SizedBox(height: 48),

                  // Email Address
                  _buildLabel(t.emailAddress, textColorPrimary),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hint: t.tr(en: 'Enter your email', ar: 'اكتب بريدك الإلكتروني'),
                    isDark: isDark,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v == null || v.isEmpty) return t.required;
                      if (!v.contains('@')) return t.enterValidEmail;
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password
                  _buildLabel(t.password, textColorPrimary),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    hint: '••••••••',
                    isDark: isDark,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return t.required;
                      if (v.length < 8) return t.min8Chars;
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Confirm Password
                  _buildLabel(t.tr(en: 'Confirm password', ar: 'تأكيد كلمة المرور'), textColorPrimary),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    hint: '••••••••',
                    isDark: isDark,
                    obscureText: _obscureConfirm,
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      icon: Icon(
                        _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return t.required;
                      if (v != _passwordController.text) return t.passwordsNoMatch;
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Terms Agreement
                  _buildTermsCheckbox(t, isDark),

                  const SizedBox(height: 40),

                  // Continue Button
                  _buildContinueButton(t),
                  
                  const SizedBox(height: 24),
                ],
              ),
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
            text: t.isAr ? 'أنشئ ' : 'Create ',
            style: const TextStyle(color: Color(0xFFF77F32)),
          ),
          TextSpan(
            text: t.isAr ? 'حسابك ' : 'your new\n',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          TextSpan(
            text: t.isAr ? 'الجديد' : 'account',
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
    required bool isDark,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final borderColor = isDark ? Colors.white30 : Colors.black26;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox(AppLocalizations t, bool isDark) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _agreeToTerms,
            onChanged: (v) => setState(() => _agreeToTerms = v ?? false),
            activeColor: const Color(0xFF142C66),
            side: BorderSide(color: isDark ? Colors.white54 : Colors.black26),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 13,
              ),
              children: [
                TextSpan(text: t.isAr ? 'أوافق على ' : 'I Agree with '),
                TextSpan(
                  text: t.isAr ? 'شروط الخدمة' : 'Terms of Service',
                  style: const TextStyle(color: Color(0xFF0051DD)),
                ),
                TextSpan(text: t.isAr ? ' و ' : ' and '),
                TextSpan(
                  text: t.isAr ? 'سياسة الخصوصية' : 'Privacy Policy',
                  style: const TextStyle(color: Color(0xFF0051DD)),
                ),
              ],
            ),
          ),
        ),
      ],
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
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142C66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
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
}
