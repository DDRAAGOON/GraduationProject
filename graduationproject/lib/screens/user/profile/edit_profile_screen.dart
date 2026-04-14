import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';
import 'profile_login_details_screen.dart';
import 'setting_profile/notifications.dart';
import 'user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _accountType = "Job Seeker";
  String _selectedGender = "Male";

  late TextEditingController _aboutMeController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _portfolioController;

  @override
  void initState() {
    super.initState();

    _aboutMeController = TextEditingController(text: "");
    _fullNameController = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _dobController = TextEditingController(text: "");
    _portfolioController = TextEditingController(text: "");
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  void _saveData() {
    setState(() {
      UserProfileData.aboutMe = _aboutMeController.text;
      UserProfileData.fullName = _fullNameController.text;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem("My Profile", true, () {}),
                _buildTabItem("Login Details", false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()),
                  );
                }),
                _buildTabItem("Notifications", false, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Notifications()),
                  );
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Basic Information
            const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("This is your personal information that you can update anytime.", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const Divider(color: Colors.white24, height: 40),

            Row(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(AppImages.companyProfile1),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white24, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: const [
                        Icon(Icons.image_outlined, color: Colors.white54, size: 30),
                        SizedBox(height: 8),
                        Text("Click to replace or drag and drop", style: TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        Text("SVG, PNG, JPG or GIF (max. 400 x 400px)", style: TextStyle(color: Colors.white38, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 40),

            // About Me
            const Text("About Me", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(_aboutMeController, "Enter About Me", maxLines: 3),
            const Divider(color: Colors.white24, height: 40),

            // Personal Details
            const Text("Personal Details", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextFieldWithLabel(_fullNameController, "Full Name", "Enter Full Name")),
                const SizedBox(width: 15),
                Expanded(child: _buildTextFieldWithLabel(_phoneController, "Phone Number", "Enter Phone Number")),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _buildTextFieldWithLabel(_emailController, "Email", "Enter Email")),
                const SizedBox(width: 15),
                Expanded(child: _buildTextFieldWithLabel(_dobController, "Date of Birth", "Enter Date of Birth", suffixIcon: Icons.calendar_today_outlined)),
              ],
            ),
            const SizedBox(height: 20),
            _buildDropdownField("Gender", ["Male", "Female"]),
            const Divider(color: Colors.white24, height: 40),

            // Skills
            const Text("Skills", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildSkillTag("Facebook Ads"),
                _buildSkillTag("Content Planning"),
                _buildSkillTag("Analytics"),
                _buildSkillTag("Community Manager"),
              ],
            ),
            const Divider(color: Colors.white24, height: 40),

            // Account Type
            const Text("Account Type", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("You can update your account type", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 20),
            _buildRadioOption("Job Seeker", "Looking for a job"),
            _buildRadioOption("Workers", "Hiring, sourcing candidates, or posting a jobs"),
            
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF49769F),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Save Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 14),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: Colors.blueAccent,
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white24)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white24)),
      ),
    );
  }

  Widget _buildTextFieldWithLabel(TextEditingController controller, String label, String hint, {IconData? suffixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.white54, size: 18) : null,
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.white24)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: Colors.white24)),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            children: const [TextSpan(text: " *", style: TextStyle(color: Colors.red))],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 120,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButton<String>(
            value: _selectedGender,
            dropdownColor: AppColors.background,
            underline: Container(),
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54),
            items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)))).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedGender = newValue;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkillTag(String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(skill, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(width: 8),
          const Icon(Icons.close, color: Colors.white54, size: 14),
        ],
      ),
    );
  }

  Widget _buildRadioOption(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<String>(
            value: title,
            groupValue: _accountType,
            activeColor: const Color(0xFF49769F),
            onChanged: (value) => setState(() => _accountType = value!),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
