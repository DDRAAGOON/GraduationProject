import 'package:flutter/material.dart';
import '../../../constants/app_images.dart';
import '../home/technical_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  String? _newPasswordError;
  String? _confirmPasswordError;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSuccessBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 40),
              // Shield Check Image from Assets
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withValues(alpha: 0.05),
                    ),
                  ),
                  Image.asset(
                    AppImages.companyForgotPassword,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                "Password Changed",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF011931),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Password changed successfully, you can login again\nwith a new password",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              // Using a similar button style as the screen
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
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const TechnicalScreen()),
                      (route) => false,
                    );
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
                  child: const Text(
                    "Verify Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
        title: const Text(
          "Reset Password",
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Reset Password",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Your new password must be different from the\npreviously used password",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 40),
              // New Password Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "New Password",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_newPasswordError != null)
                    Text(
                      _newPasswordError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureNewPassword = !_obscureNewPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _newPasswordError != null
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _newPasswordError != null
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color:
                          _newPasswordError != null ? Colors.red : Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Must be at least 8 character",
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 24),
              // Confirm Password Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Confirm Password",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_confirmPasswordError != null)
                    Text(
                      _confirmPasswordError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢â€¢",
                  hintStyle: const TextStyle(color: Colors.white38),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: _confirmPasswordError != null
                          ? Colors.red
                          : Colors.blue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Both password must match",
                style: TextStyle(color: Colors.white60, fontSize: 12),
              ),
              const SizedBox(height: 60),
              _buildVerifyButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return Container(
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
        onPressed: () {
          final newPassword = _newPasswordController.text.trim();
          final confirmPassword = _confirmPasswordController.text.trim();

          setState(() {
            _newPasswordError = null;
            _confirmPasswordError = null;
          });

          bool hasError = false;

          if (newPassword.isEmpty) {
            _newPasswordError = "Password is required";
            hasError = true;
          } else if (newPassword.length < 8) {
            _newPasswordError = "At least 8 characters required";
            hasError = true;
          }

          if (confirmPassword.isEmpty) {
            _confirmPasswordError = "Please confirm your password";
            hasError = true;
          } else if (confirmPassword != newPassword) {
            _confirmPasswordError = "Passwords do not match";
            hasError = true;
          }

          setState(() {});

          if (hasError) return;

          // Show Success Bottom Sheet
          _showSuccessBottomSheet();
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
        child: const Text(
          "Verify Account",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}


