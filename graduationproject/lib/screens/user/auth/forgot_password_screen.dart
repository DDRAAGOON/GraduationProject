import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/state/theme_controller.dart';
import 'otp_email_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _emailError;
  String? _phoneError;
  bool _isLoading = false;

  Country _selectedCountry = Country(
    phoneCode: "20",
    countryCode: "EG",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "Egypt",
    example: "Egypt",
    displayName: "Egypt",
    displayNameNoCountryCode: "Egypt",
    e164Key: "",
  );

  bool _isValidEmail(String email) {
    return email.contains('@') && email.contains('.');
  }

  bool _isValidPhone(String phone) {
    return phone.length >= 10 && phone.length <= 11;
  }

  Future<void> _handleContinue() async {
    final t = AppLocalizations.of(context);
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();

    setState(() {
      _emailError = null;
      _phoneError = null;
    });

    bool hasError = false;

    if (email.isEmpty) {
      _emailError = t.enterYourEmail;
      hasError = true;
    } else if (!_isValidEmail(email)) {
      _emailError = t.isAr ? "بريد إلكتروني غير صالح" : "Invalid email address";
      hasError = true;
    }

    if (phone.isEmpty) {
      _phoneError = t.enterMobileNumber;
      hasError = true;
    } else if (!_isValidPhone(phone)) {
      _phoneError = t.isAr ? "رقم الهاتف غير صحيح" : "Invalid phone number";
      hasError = true;
    }

    if (hasError) return;

    setState(() => _isLoading = true);

    try {
      // Step 1: Request OTP from Server
      await AuthService.instance.forgotPassword(email);

      if (!mounted) return;
      setState(() => _isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpEmailVerificationScreen(
            email: email,
            isForgotPassword: true,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
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
              icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white70 : Colors.black54, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              t.isAr ? 'نسيت كلمة المرور' : "Forgot Password",
              style: const TextStyle(
                color: Color(0xFFF77F32), 
                fontSize: 20, 
                fontWeight: FontWeight.bold
              ),
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              children: [
                const SizedBox(height: 20),
                // Main Heading
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                    children: [
                      TextSpan(
                        text: t.isAr ? 'نسيت ' : 'Forgot ', 
                        style: const TextStyle(color: Color(0xFFF77F32))
                      ),
                      TextSpan(
                        text: t.isAr ? 'كلمة المرور؟' : 'Password?', 
                        style: const TextStyle(color: Color(0xFF0051DD))
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.tr(
                    en: "Enter your email address to receive a confirmation code resetting your password.",
                    ar: "أدخل بريدك الإلكتروني لتلقي رمز تأكيد لإعادة تعيين كلمة المرور الخاصة بك."
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54,
                    fontSize: 15,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 48),

                // Email Field
                _buildLabel(t.emailAddress, textColorPrimary),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hint: t.tr(en: "Enter your email", ar: "أدخل بريدك الإلكتروني"),
                  isDark: isDark,
                  errorText: _emailError,
                ),

                const SizedBox(height: 24),

                // Mobile Number Field
                _buildLabel(t.phoneNumber, textColorPrimary),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            setState(() {
                              _selectedCountry = country;
                            });
                          },
                          countryListTheme: CountryListThemeData(
                            backgroundColor: backgroundColor,
                            textStyle: TextStyle(color: textColorPrimary),
                            searchTextStyle: TextStyle(color: textColorPrimary),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      },
                      child: Container(
                        height: 56,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: isDark ? Colors.white24 : Colors.black12),
                        ),
                        child: Row(
                          children: [
                            Text(_selectedCountry.flagEmoji, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                            Text(
                              "+${_selectedCountry.phoneCode}",
                              style: TextStyle(color: textColorPrimary, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _phoneController,
                        hint: t.tr(en: "Enter Mobile Number", ar: "أدخل رقم الهاتف"),
                        isDark: isDark,
                        keyboardType: TextInputType.phone,
                        errorText: _phoneError,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Continue Button
                _buildLargeButton(
                  label: t.tr(en: "Continue", ar: "متابعة"),
                  isLoading: _isLoading,
                  onPressed: _handleContinue,
                ),
              ],
            ),
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
        color: color.withValues(alpha: 0.8),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    String? errorText,
  }) {
    final borderColor = isDark ? Colors.white30 : Colors.black26;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
        filled: true,
        fillColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
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

  Widget _buildLargeButton({required String label, required VoidCallback onPressed, bool isLoading = false}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF142C66).withValues(alpha: 0.3),
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
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
