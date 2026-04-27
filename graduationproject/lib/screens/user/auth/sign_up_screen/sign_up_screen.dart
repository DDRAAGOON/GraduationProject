import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../otp_email_verification_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  
  String? _emailError;
  String? _passError;
  String? _confirmError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    final t = AppLocalizations.of(context);
    setState(() {
      _emailError = _emailController.text.contains('@') ? null : t.enterValidEmail;
      _passError = _passwordController.text.length >= 8 ? null : t.min8Chars;
      _confirmError = _confirmPasswordController.text == _passwordController.text ? null : t.passwordsNoMatch;
    });

    if (_emailError == null && _passError == null && _confirmError == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpEmailVerificationScreen(email: _emailController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF011931)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.signUpBtn),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          children: [
            Text(
              t.tr(en: "Create Account", ar: "إنشاء حساب جديد"),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF011931),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.tr(en: "Fill the details to start your journey", ar: "املاً البيانات لتبدأ رحلتك معنا"),
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            
            AppTextField(
              label: t.emailAddress,
              controller: _emailController,
              hint: t.tr(en: "Enter your email", ar: "اكتب بريدك الإلكتروني"),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline,
              validatorText: _emailError,
            ),
            const SizedBox(height: 16),
            
            AppTextField(
              label: t.password,
              controller: _passwordController,
              hint: t.tr(en: "Enter your password", ar: "اكتب كلمة المرور"),
              obscureText: _obscurePassword,
              prefixIcon: Icons.lock_outline,
              validatorText: _passError,
              suffix: IconButton(
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            const SizedBox(height: 16),
            
            AppTextField(
              label: t.confirmPassword,
              controller: _confirmPasswordController,
              hint: t.tr(en: "Confirm your password", ar: "أعد كتابة كلمة المرور"),
              obscureText: _obscureConfirm,
              prefixIcon: Icons.lock_reset_outlined,
              validatorText: _confirmError,
              suffix: IconButton(
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
              ),
            ),
            
            const SizedBox(height: 32),
            AppButton(
              label: t.signUpBtn,
              onPressed: _submit,
            ),
            
            const SizedBox(height: 24),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(t.tr(en: "OR", ar: "أو"), style: const TextStyle(color: Colors.grey)),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 24),
            
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
              onPressed: () {
                // Google Sign Up logic
              },
              icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red, size: 20),
              label: Text(
                t.tr(en: "Continue with Google", ar: "المتابعة باستخدام جوجل"),
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.alreadyRegistered, style: const TextStyle(color: Colors.black54)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    t.signInBtn,
                    style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
