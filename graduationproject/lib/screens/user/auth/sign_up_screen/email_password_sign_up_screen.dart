import 'package:flutter/material.dart';
import 'package:graduationproject/app/router/app_router.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../otp_email_verification_screen.dart';
import '../../core/custom_button.dart';

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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email is required';
    }
    if (!text.toLowerCase().endsWith('@gmail.com')) {
      return 'Email must end with @gmail.com';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Password is required';
    }
    if (text.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Please confirm your password';
    }
    if (text != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    try {
      // Step 1: Create the account on the server. 
      // This will trigger the server to send the OTP email.
      await RecruitmentSyncService.instance.register(
        email: email,
        password: password,
        name: "User", // Temporary name for new accounts
        role: "user",
      );

      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // Step 2: Go to OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpEmailVerificationScreen(email: email, password: password),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      
      // If user already exists, maybe just go to OTP or inform them
      String error = e.toString().toLowerCase();
      if (error.contains("already exists") || error.contains("موجود مسبقا")) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account already exists. Please sign in.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    }
  }

  InputDecoration _buildFieldDecoration(BuildContext context, String label) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: colorScheme.onSurface.withValues(alpha: 0.65),
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colorScheme.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FC),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(
          t.tr(en: 'Create account', ar: 'إنشاء الحساب'),
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.tr(
                    en: 'Create your account to continue',
                    ar: 'أنشئ حسابك للمتابعة',
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.tr(
                    en: 'Use your Gmail account and set a secure password',
                    ar: 'استخدم بريد Gmail الخاص بك واضبط كلمة مرور آمنة',
                  ),
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildFieldDecoration(
                    context,
                    t.tr(en: 'Email', ar: 'البريد الإلكتروني'),
                  ),
                  validator: _validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildFieldDecoration(
                    context,
                    t.tr(en: 'Password', ar: 'كلمة المرور'),
                  ),
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _buildFieldDecoration(
                    context,
                    t.tr(en: 'Confirm password', ar: 'تأكيد كلمة المرور'),
                  ),
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 24),
                Bottom(isLoading: _isLoading, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
