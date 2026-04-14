import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/screens/user/core/custom_button.dart';
import '../core/app_colors.dart';
import '../profile/setting_profile/Complete_Profile_screen.dart'; // Import complete profile screen

class OtpEmailVerificationScreen extends StatefulWidget {
  final String email;
  const OtpEmailVerificationScreen({super.key, required this.email});

  @override
  State<OtpEmailVerificationScreen> createState() => _OtpEmailVerificationScreenState();
}

class _OtpEmailVerificationScreenState extends State<OtpEmailVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  
  Timer? _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
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

  void _showSuccessPopup() {
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
              const Text(
                "Account Created",
                style: TextStyle(color: Color(0xFF0D2D4D), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                "Your account has been created successfully,\nnow you can continue to the app.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to Complete Profile Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const CompleteProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49769F),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Continue", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
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
    return Scaffold(
      backgroundColor: const Color(0xFF011931),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("OTP", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text("Email verification", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Enter the verification code we send you on your email.", style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 50),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: List.generate(4, (index) => _buildOtpBox(index))),
              const SizedBox(height: 40),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, color: Colors.white60, size: 20),
                    const SizedBox(width: 8),
                    Text(timerText, style: const TextStyle(color: Colors.white60, fontSize: 16)),
                  ],
                ),
              ),
              const Spacer(),
              Bottom(
                isLoading: false,
                onPressed: () {
                  String otp = _controllers.map((e) => e.text).join();
                  if (otp.length == 4) {
                    _showSuccessPopup();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter full OTP")));
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
      width: 75, height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 1.5),
      ),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none),
          onChanged: (value) {
            if (value.isNotEmpty && index < 3) FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          },
        ),
      ),
    );
  }
}
