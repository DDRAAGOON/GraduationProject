import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:graduationproject/screens/user/core/custom_button.dart';
import '../../../../constants/app_images.dart';
import '../otp_email_verification_screen.dart';
import '../sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeToTerms = false;

  String? _emailError;
  String? _phoneError;
  String? _usernameError;
  String? _passwordError;

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
    return email.contains('@') && email.endsWith('gmail.com');
  }

  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  bool _isValidPhone(String phone) {
    return phone.length >= 10;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF011931),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Create your new\naccount",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              
              // Email Address Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Email Address",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_emailError != null)
                    Text(
                      _emailError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: "Enter your email",
                hasError: _emailError != null,
              ),
              
              const SizedBox(height: 24),
              
              // Mobile Number Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mobile Number",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_phoneError != null)
                    Text(
                      _phoneError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
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
                          backgroundColor: const Color(0xFF011931),
                          textStyle: const TextStyle(color: Colors.white),
                          searchTextStyle: const TextStyle(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    },
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _phoneError != null ? Colors.red : Colors.white24,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedCountry.flagEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "+${_selectedCountry.phoneCode}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      controller: _phoneController,
                      hintText: "Enter Mobile Number",
                      keyboardType: TextInputType.phone,
                      hasError: _phoneError != null,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // User Name Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "User Name",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_usernameError != null)
                    Text(
                      _usernameError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _usernameController,
                hintText: "Enter Username",
                hasError: _usernameError != null,
              ),
              
              const SizedBox(height: 24),
              
              // Password Header with Error
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Password",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (_passwordError != null)
                    Text(
                      _passwordError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: "•••••••••",
                obscureText: _obscurePassword,
                hasError: _passwordError != null,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Terms and Conditions
              Row(
                children: [
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white24),
                    child: Checkbox(
                      value: _agreeToTerms,
                      activeColor: Colors.blue,
                      onChanged: (value) => setState(() => _agreeToTerms = value!),
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: "I Agree with ",
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        children: [
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(color: Colors.blue[300]),
                          ),
                          const TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(color: Colors.blue[300]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Continue Button
              Bottom(
                isLoading: false,
                onPressed: () {
                  final email = _emailController.text.trim();
                  final phone = _phoneController.text.trim();
                  final username = _usernameController.text.trim();
                  final password = _passwordController.text.trim();

                  setState(() {
                    _emailError = null;
                    _phoneError = null;
                    _usernameError = null;
                    _passwordError = null;
                  });

                  bool hasError = false;

                  if (email.isEmpty) {
                    _emailError = "Email is required";
                    hasError = true;
                  } else if (!_isValidEmail(email)) {
                    _emailError = "Must contain @ and gmail.com";
                    hasError = true;
                  }

                  if (phone.isEmpty) {
                    _phoneError = "Phone is required";
                    hasError = true;
                  } else if (!_isValidPhone(phone)) {
                    _phoneError = "Invalid phone number";
                    hasError = true;
                  }

                  if (username.isEmpty) {
                    _usernameError = "Username is required";
                    hasError = true;
                  }

                  if (password.isEmpty) {
                    _passwordError = "Password is required";
                    hasError = true;
                  } else if (!_isValidPassword(password)) {
                    _passwordError = "At least 8 characters required";
                    hasError = true;
                  }

                  if (!_agreeToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please agree to terms")),
                    );
                    hasError = true;
                  }

                  setState(() {});

                  if (hasError) return;

                  // Proceed to OTP Screen after validation
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OtpEmailVerificationScreen(email: email),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Divider
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white24)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Or sign in with",
                      style: TextStyle(color: Colors.white38, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.white24)),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Google Login
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child:  Image.asset(
                      AppImages.companyIconVector,
                      width: 24,
                      height: 24,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error, color: Colors.red),
                    )
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Already Registered
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already Registered? ",
                    style: TextStyle(color: Colors.white70),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    bool hasError = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: hasError ? Colors.red : Colors.white24),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: hasError ? Colors.red : Colors.white24),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: hasError ? Colors.red : Colors.blue),
        ),
      ),
    );
  }
}
