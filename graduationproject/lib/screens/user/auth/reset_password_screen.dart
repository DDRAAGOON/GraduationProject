import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';
import '../../../app/router/app_router.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  String? _newPassError;
  String? _confirmPassError;

  bool _isPasswordValid(String pass) {
    // التحقق من الطول فقط (8 على الأقل) كما طلب المستخدم
    return pass.length >= 8;
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        final isDark =
            themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        final backgroundColor = isDark
            ? const Color(0xFF001E3A)
            : const Color(0xFFF8FBF4);
        final textColorPrimary = isDark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: isDark ? Colors.white70 : Colors.black54,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              t.resetPassword,
              style: const TextStyle(
                color: Color(0xFFF77F32),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              children: [
                const SizedBox(height: 20),
                // Main Heading
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      fontFamily: 'Inter',
                    ),
                    children: [
                      TextSpan(
                        text: t.isAr ? 'إعادة تعيين ' : 'Reset ',
                        style: const TextStyle(color: Color(0xFFF77F32)),
                      ),
                      TextSpan(
                        text: t.isAr ? 'كلمة المرور' : 'Password',
                        style: const TextStyle(color: Color(0xFF0051DD)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.resetPasswordSub,
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 48),

                // New Password Field
                _buildLabel(t.newPassword, textColorPrimary),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _newPasswordController,
                  hint: '••••••••',
                  isDark: isDark,
                  obscureText: _obscureNew,
                  errorText: _newPassError,
                  suffixIcon: IconButton(
                    onPressed: () => setState(() => _obscureNew = !_obscureNew),
                    icon: Icon(
                      _obscureNew
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.tr(
                    en: "Must be at least 8 characters",
                    ar: "يجب أن تكون 8 أحرف على الأقل",
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm Password Field
                _buildLabel(t.confirmPassword, textColorPrimary),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _confirmPasswordController,
                  hint: '••••••••',
                  isDark: isDark,
                  obscureText: _obscureConfirm,
                  errorText: _confirmPassError,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.mustMatch,
                  style: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 60),

                // Verify Account Button
                _buildLargeButton(
                  label: t.isAr ? "إعادة تعيين" : t.verifyAccount,
                  onPressed: () {
                    final newPass = _newPasswordController.text;
                    final confirmPass = _confirmPasswordController.text;

                    setState(() {
                      _newPassError = null;
                      _confirmPassError = null;
                    });

                    bool hasError = false;

                    if (!_isPasswordValid(newPass)) {
                      _newPassError = t.isAr
                          ? "كلمة المرور قصيرة جداً"
                          : "Password too short";
                      hasError = true;
                    }

                    if (newPass != confirmPass) {
                      _confirmPassError = t.passwordsNoMatch;
                      hasError = true;
                    }

                    if (hasError) return;

                    _showSuccessBottomSheet(context, t, isDark);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessBottomSheet(
    BuildContext context,
    AppLocalizations t,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 40),
              // Illustration (Check circle with decorations)
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0D2D4D).withOpacity(0.1),
                        width: 10,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Color(0xFF0D2D4D),
                    size: 80,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                t.passwordChanged,
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0D2D4D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                t.passwordChangedMsg,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              _buildLargeButton(
                label: t.verifyAccount,
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.userSignInNew,
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
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
    String? errorText,
  }) {
    final borderColor = isDark ? Colors.white30 : Colors.black26;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        suffixIcon: suffixIcon,
        errorText: errorText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white : const Color(0xFF142C66),
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLargeButton({
    required String label,
    required VoidCallback onPressed,
  }) {
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
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142C66),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: Text(
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
