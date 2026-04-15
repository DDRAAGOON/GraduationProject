import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../core/app_colors.dart';
import '../home/main_screen.dart';
import 'package:graduationproject/screens/user/auth/cubit/auth_cubit.dart';
import '../../../constants/app_images.dart';
import 'forgot_password_screen.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;

  String? _passwordError;
  String? _emailError;

  bool _isValidEmail(String email) {
    return email.contains('@') && email.endsWith('gmail.com');
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }

        if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        bool isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    t.userTr(
                      'auth.signInTitle',
                      fallbackEn: 'Sign in to your\naccount',
                      fallbackAr: 'تسجيل الدخول إلى\nحسابك',
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.userTr(
                          'auth.emailLabel',
                          fallbackEn: 'Email Address',
                          fallbackAr: 'البريد الإلكتروني',
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (_emailError != null)
                        Text(
                          _emailError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: t.userTr(
                        'auth.emailHint',
                        fallbackEn: 'Enter your email',
                        fallbackAr: 'أدخل بريدك الإلكتروني',
                      ),
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _emailError != null
                              ? Colors.red
                              : Colors.white24,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _emailError != null
                              ? Colors.red
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.userTr(
                          'auth.passwordLabel',
                          fallbackEn: 'Password',
                          fallbackAr: 'كلمة المرور',
                        ),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (_passwordError != null)
                        Text(
                          _passwordError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "•••••••••••",
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _passwordError != null
                              ? Colors.red
                              : Colors.white24,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: _passwordError != null
                              ? Colors.red
                              : Colors.white24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        t.userTr(
                          'auth.forgotPassword',
                          fallbackEn: 'Forgot password?',
                          fallbackAr: 'نسيت كلمة المرور؟',
                        ),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF0A2A4A),
                          Color(0xFF2F5F8F),
                          Color.fromARGB(255, 118, 159, 178),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        bottomLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = _emailController.text.trim();
                              final password = _passwordController.text.trim();

                              setState(() {
                                _emailError = null;
                                _passwordError = null;
                              });

                              bool hasError = false;

                              if (email.isEmpty) {
                                _emailError = t.userTr(
                                  'auth.errorEmailRequired',
                                  fallbackEn: 'Email is required',
                                  fallbackAr: 'البريد الإلكتروني مطلوب',
                                );
                                hasError = true;
                              } else if (!_isValidEmail(email)) {
                                _emailError = t.userTr(
                                  'auth.errorEmailInvalid',
                                  fallbackEn:
                                      'Invalid email (@gmail.com required)',
                                  fallbackAr:
                                      'بريد غير صالح (يجب أن يكون @gmail.com)',
                                );
                                hasError = true;
                              }

                              if (password.isEmpty) {
                                _passwordError = t.userTr(
                                  'auth.errorPasswordRequired',
                                  fallbackEn: 'Password is required',
                                  fallbackAr: 'كلمة المرور مطلوبة',
                                );
                                hasError = true;
                              } else if (!_isValidPassword(password)) {
                                _passwordError = t.userTr(
                                  'auth.errorPasswordMin',
                                  fallbackEn: 'At least 8 characters required',
                                  fallbackAr: 'يجب أن تكون 8 أحرف على الأقل',
                                );
                                hasError = true;
                              }

                              setState(() {});

                              if (hasError) return;

                              context.read<AuthCubit>().login(email, password);
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            bottomLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(70),
                          ),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              t.userTr(
                                'auth.continue',
                                fallbackEn: 'Continue',
                                fallbackAr: 'متابعة',
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white24)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          t.userTr(
                            'auth.orSignInWith',
                            fallbackEn: 'Or sign in with',
                            fallbackAr: 'أو سجل دخولك بواسطة',
                          ),
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.white24)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        AppImages.companyIconVector,
                        width: 24,
                        height: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error, color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.userTr(
                          'auth.noAccount',
                          fallbackEn: 'Don’t have an account, ',
                          fallbackAr: 'ليس لديك حساب، ',
                        ),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          t.userTr(
                            'auth.signUp',
                            fallbackEn: 'Sign up',
                            fallbackAr: 'إنشاء حساب',
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
