import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/router/app_router.dart';
import 'package:graduationproject/screens/user/core/custom_button.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';

class OtpEmailVerificationScreen extends StatefulWidget {
  final String email;
  final String? password; // Added password field
  const OtpEmailVerificationScreen({super.key, required this.email, this.password});

  @override
  State<OtpEmailVerificationScreen> createState() => _OtpEmailVerificationScreenState();
}

class _OtpEmailVerificationScreenState extends State<OtpEmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  Timer? _timer;
  int _start = 120; // Changed to 120 seconds (2 minutes)

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _start = 120; // Reset to 2 minutes
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
      // Re-trigger registration to send a new OTP
      await RecruitmentSyncService.instance.register(
        email: widget.email,
        password: widget.password ?? "12345678",
        name: "User",
        role: "user",
      );
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        startTimer(); // Restart the 2-minute timer
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

  void _showSuccessPopup(AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
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
                style: const TextStyle(color: Color(0xFF0D2D4D), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                t.tr(
                  en: "Your account has been created successfully. Please log in normally now to complete your profile setup.",
                  ar: "تم إنشاء حسابك بنجاح. يرجى تسجيل الدخول بشكل عادي الآن لإكمال إعداد ملفك الشخصي."
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),
              Bottom(
                label: t.tr(en: "Sign In Now", ar: "سجل دخولك الآن"),
                isLoading: false,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.userSignInNew,
                    (route) => false,
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
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(t.otpTitle, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(t.otpTitle, style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(t.otpSubtitle, style: const TextStyle(color: Colors.black54, fontSize: 14)),
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(6, (index) => _buildOtpBox(index))),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.access_time, color: Colors.black45, size: 20),
                        const SizedBox(width: 8),
                        Text(timerText, style: const TextStyle(color: Colors.black45, fontSize: 16)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _start == 0 && !_isLoading ? _resendOtp : null,
                      child: Text(
                        t.tr(en: "Resend Code", ar: "إعادة إرسال الرمز"),
                        style: TextStyle(
                          color: _start == 0 && !_isLoading ? const Color(0xFF4A6ED1) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Bottom(
                isLoading: _isLoading,
                onPressed: () async {
                  String otp = _controllers.map((e) => e.text).join();
                  if (otp.length == 6) {
                    setState(() => _isLoading = true);
                    try {
                      // Step 3: Verify the OTP with the server
                      await RecruitmentSyncService.instance.verifyEmailOtp(
                        email: widget.email,
                        code: otp,
                      );
                      if (!mounted) return;
                      setState(() => _isLoading = false);
                      _showSuccessPopup(t);
                    } catch (e) {
                      if (!mounted) return;
                      setState(() => _isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.tr(en: "Please enter full OTP", ar: "يرجى إدخال رمز التحقق كاملاً"))));
                  }
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50, height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
          style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          },
        ),
      ),
    );
  }
}
