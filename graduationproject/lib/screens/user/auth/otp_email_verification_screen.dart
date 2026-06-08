import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';

class OtpEmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? password;
  final String? name;
  final bool isForgotPassword;
  const OtpEmailVerificationScreen({
    super.key, 
    required this.email, 
    this.password,
    this.name,
    this.isForgotPassword = false,
  });

  @override
  State<OtpEmailVerificationScreen> createState() => _OtpEmailVerificationScreenState();
}

class _OtpEmailVerificationScreenState extends State<OtpEmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() => _isLoading = true);
    try {
      await RecruitmentSyncService.instance.register(
        email: widget.email,
        password: widget.password ?? "12345678",
        name: widget.name ?? "User",
        role: "user",
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        startTimer();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).tr(en: "OTP resent successfully", ar: "تم إعادة إرسال الرمز بنجاح"))),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return "${minutes.toString().padLeft(2, '0')}.${seconds.toString().padLeft(2, '0')}";
  }

  String maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 4) {
      return "${name}******@$domain";
    }
    return "${name.substring(0, 4)}******@$domain";
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _showSuccessPopup(AppLocalizations t, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
              const SizedBox(height: 40),
              Image.asset(
                'assets/company/forget/1.png',
                width: 180,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text(
                t.tr(en: "Account Ready!", ar: "حسابك جاهز!"),
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0D2D4D), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                t.tr(
                  en: "Your account has been created successfully. Please log in normally now to complete your profile setup.",
                  ar: "تم إنشاء حسابك بنجاح. يرجى تسجيل الدخول بشكل عادي الآن لإكمال إعداد ملفك الشخصي."
                ),
                textAlign: TextAlign.center,
                style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),
              _buildLargeButton(
                label: t.tr(en: "Sign In Now", ar: "سجل دخولك الآن"),
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.userSignInNew,
                    (route) => false,
                    arguments: {'fromSignUp': true}, // إرسال علامة أن المستخدم سجل حساب جديد
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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
        final textColorPrimary = isDark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: textColorPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'OTP', 
              style: TextStyle(color: Color(0xFFF77F32), fontSize: 20, fontWeight: FontWeight.bold)
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 40),
                // Email Verification Header
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: t.isAr ? 'التحقق من ' : 'Email ', 
                        style: const TextStyle(color: Color(0xFFF77F32))
                      ),
                      TextSpan(
                        text: t.isAr ? 'البريد الإلكتروني' : 'verification', 
                        style: const TextStyle(color: Color(0xFF0051DD))
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.otpSubtitle, 
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15)
                ),
                Text(
                  maskEmail(widget.email),
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 50),

                // OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) => _buildOtpBox(index, isDark)),
                ),

                const SizedBox(height: 32),

                // Resend section
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.tr(en: "Didn't receive code? ", ar: "لم تستلم الرمز؟ "),
                        style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14),
                      ),
                      GestureDetector(
                        onTap: _start == 0 && !_isLoading ? _resendOtp : null,
                        child: Text(
                          t.tr(en: "Resend", ar: "إعادة إرسال"),
                          style: TextStyle(
                            color: _start == 0 && !_isLoading ? const Color(0xFF0051DD) : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Timer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time, color: isDark ? Colors.white38 : Colors.black26, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      timerText, 
                      style: TextStyle(color: isDark ? Colors.white38 : Colors.black26, fontSize: 16, fontWeight: FontWeight.w500)
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Continue Button
                _buildLargeButton(
                  label: t.continueBtn,
                  isLoading: _isLoading,
                  onPressed: () async {
                    String otp = _controllers.map((e) => e.text).join();
                    if (otp.length == 6) {
                      setState(() => _isLoading = true);
                      try {
                        await RecruitmentSyncService.instance.verifyEmailOtp(
                          email: widget.email,
                          code: otp,
                        );
                        if (!mounted) return;
                        setState(() => _isLoading = false);
                        if (widget.isForgotPassword) {
                          Navigator.pushNamed(context, AppRoutes.userResetPassword);
                        } else {
                          _showSuccessPopup(t, isDark);
                        }
                      } catch (e) {
                        if (!mounted) return;
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(t.tr(en: "Please enter 6-digit OTP", ar: "يرجى إدخال رمز التحقق المكون من 6 أرقام")))
                      );
                    }
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOtpBox(int index, bool isDark) {
    return Container(
      width: 46,
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center, // ضمان التوسيط الرأسي
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, 
            LengthLimitingTextInputFormatter(1)
          ],
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87, 
            fontSize: 24, 
            fontWeight: FontWeight.bold
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: "",
            contentPadding: EdgeInsets.zero, // إلغاء الهوامش الداخلية لظهور الرقم كاملاً
          ),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLargeButton({required String label, required VoidCallback onPressed, bool isLoading = false}) {
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
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142C66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                label,
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
