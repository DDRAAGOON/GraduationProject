import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';
import '../notifications/notifications_screen.dart';
import '../settings/setting_screen.dart';
import 'profile_login_details_screen.dart';
import 'setting_profile/notifications.dart' as profile_notif;
import 'user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _selectedGender = "Male";
  String _accountType = "Job Seeker"; // المتغير الخاص بنوع الحساب

  late TextEditingController _aboutMeController;
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dobController;
  late TextEditingController _portfolioController;
  final TextEditingController _skillInputController = TextEditingController();

  // Experience Controllers
  final TextEditingController _expJobTitleController = TextEditingController();
  final TextEditingController _expCompanyController = TextEditingController();
  final TextEditingController _expDurationController = TextEditingController();

  List<String> _currentSkills = [];
  List<Map<String, String>> _currentExperiences = [];

  @override
  void initState() {
    super.initState();
    _aboutMeController = TextEditingController(text: UserProfileData.aboutMe);
    _fullNameController = TextEditingController(text: UserProfileData.fullName);
    _phoneController = TextEditingController(text: UserProfileData.phone);
    _emailController = TextEditingController(text: UserProfileData.email);
    _dobController = TextEditingController(text: UserProfileData.dob);
    _portfolioController = TextEditingController(text: UserProfileData.portfolioUrl);
    _selectedGender = UserProfileData.gender.isEmpty ? "Male" : UserProfileData.gender;
    _currentSkills = List.from(UserProfileData.skills);
    _currentExperiences = List.from(UserProfileData.experiences);
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _portfolioController.dispose();
    _skillInputController.dispose();
    _expJobTitleController.dispose();
    _expCompanyController.dispose();
    _expDurationController.dispose();
    super.dispose();
  }

  void _addSkill() {
    String skill = _skillInputController.text.trim();
    if (skill.isNotEmpty && !_currentSkills.contains(skill)) {
      setState(() {
        _currentSkills.add(skill);
        _skillInputController.clear();
      });
    }
  }

  void _removeSkill(String skill) {
    setState(() {
      _currentSkills.remove(skill);
    });
  }

  void _addExperience() {
    if (_expJobTitleController.text.isNotEmpty && _expCompanyController.text.isNotEmpty) {
      setState(() {
        _currentExperiences.add({
          "title": _expJobTitleController.text.trim(),
          "company": _expCompanyController.text.trim(),
          "duration": _expDurationController.text.trim(),
        });
        _expJobTitleController.clear();
        _expCompanyController.clear();
        _expDurationController.clear();
      });
    }
  }

  void _saveData() {
    setState(() {
      UserProfileData.aboutMe = _aboutMeController.text;
      UserProfileData.fullName = _fullNameController.text;
      UserProfileData.phone = _phoneController.text;
      UserProfileData.email = _emailController.text;
      UserProfileData.dob = _dobController.text;
      UserProfileData.portfolioUrl = _portfolioController.text;
      UserProfileData.gender = _selectedGender;
      UserProfileData.skills = List.from(_currentSkills);
      UserProfileData.experiences = List.from(_currentExperiences);
      // هنا يمكن إضافة حفظ نوع الحساب في UserProfileData إذا رغبت مستقبلاً
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
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabItem("My Profile", true, () {}),
                  _buildTabItem("Login Details", false, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()));
                  }),
                  _buildTabItem("Notifications", false, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const profile_notif.Notifications()));
                  }),
                ],
              ),
              const SizedBox(height: 30),
              const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(color: Colors.white24, height: 40),

              // Profile Photo Section
              const Text("Profile Photo", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  const CircleAvatar(radius: 40, backgroundImage: AssetImage(AppImages.companyProfile1)),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF49769F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        child: const Text("Change Photo", style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      const SizedBox(height: 4),
                      const Text("JPG, PNG, max 2MB", style: TextStyle(color: Colors.white38, fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              _buildTextField(_aboutMeController, "About Me", maxLines: 3),
              const SizedBox(height: 20),
              _buildTextFieldWithLabel(_fullNameController, "Full Name", "Enter Full Name"),
              const SizedBox(height: 20),
              _buildTextFieldWithLabel(_phoneController, "Phone Number", "Enter Phone Number"),
              const SizedBox(height: 20),
              _buildTextFieldWithLabel(_emailController, "Email", "Enter Email"),
              const SizedBox(height: 20),
              _buildTextFieldWithLabel(_dobController, "Date of Birth", "YYYY-MM-DD", suffixIcon: Icons.calendar_today_outlined),
              const SizedBox(height: 20),
              _buildDropdownField("Gender", ["Male", "Female"]),
              const Divider(color: Colors.white24, height: 40),

              // Experience Section
              const Text("Experience", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              _buildTextFieldWithLabel(_expJobTitleController, "Job Title", ""),
              const SizedBox(height: 15),
              _buildTextFieldWithLabel(_expCompanyController, "Company", ""),
              const SizedBox(height: 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: _buildTextFieldWithLabel(_expDurationController, "Duration", "")),
                  const SizedBox(width: 10),
                  IconButton(onPressed: _addExperience, icon: const Icon(Icons.add_circle, color: Color(0xFF49769F), size: 35)),
                ],
              ),
              const SizedBox(height: 15),
              ..._currentExperiences.asMap().entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
                child: Row(
                  children: [
                    const Icon(Icons.work_history, color: Color(0xFF49769F), size: 20),
                    const SizedBox(width: 12),
                    Expanded(child: Text("${entry.value['title']} at ${entry.value['company']} (${entry.value['duration']})", style: const TextStyle(color: Colors.white70, fontSize: 12))),
                    IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => setState(() => _currentExperiences.removeAt(entry.key))),
                  ],
                ),
              )).toList(),
              const Divider(color: Colors.white24, height: 40),

              // Skills Section
              const Text("Skills", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(child: TextField(controller: _skillInputController, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: "Add a new skill", hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
                  const SizedBox(width: 10),
                  IconButton(onPressed: _addSkill, icon: const Icon(Icons.add_circle, color: Color(0xFF49769F), size: 30)),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(spacing: 10, runSpacing: 10, children: _currentSkills.map((skill) => _buildSkillTag(skill)).toList()),
              const Divider(color: Colors.white24, height: 40),

              const Text("Portfolio URL", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildTextField(_portfolioController, "Link to your portfolio URL"),
              const Divider(color: Colors.white24, height: 40),

              // Account Type Section (As requested)
              const Text("Account Type", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("You can update your account type", style: TextStyle(color: Colors.white54, fontSize: 13)),
              const SizedBox(height: 20),
              _buildRadioOption("Job Seeker", "Looking for a job"),
              _buildRadioOption("Workers", "Hiring, sourcing candidates, or posting a jobs"),
              
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveData,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF49769F), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                  child: const Text("Save Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Column(children: [Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 14)), if (isActive) Container(margin: const EdgeInsets.only(top: 8), height: 2, width: 60, color: Colors.blueAccent)]));
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(controller: controller, maxLines: maxLines, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24), filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)), contentPadding: const EdgeInsets.all(16)));
  }

  Widget _buildTextFieldWithLabel(TextEditingController controller, String label, String hint, {IconData? suffixIcon}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(height: 8), TextField(controller: controller, style: const TextStyle(color: Colors.white, fontSize: 14), decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(color: Colors.white24, fontSize: 12), suffixIcon: suffixIcon != null ? Icon(suffixIcon, color: Colors.white54, size: 18) : null, filled: true, fillColor: Colors.white.withOpacity(0.05), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)))]);
  }

  Widget _buildDropdownField(String label, List<String> items) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(height: 8), Container(padding: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), border: Border.all(color: Colors.white12), borderRadius: BorderRadius.circular(12)), child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedGender, dropdownColor: const Color(0xFF0D2D4D), isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white54), items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value, style: const TextStyle(color: Colors.white)))).toList(), onChanged: (String? newValue) { if (newValue != null) setState(() => _selectedGender = newValue); })))]);
  }

  Widget _buildSkillTag(String skill) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), decoration: BoxDecoration(color: const Color(0xFF49769F).withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF49769F).withOpacity(0.3))), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(skill, style: const TextStyle(color: Colors.white70, fontSize: 13)), const SizedBox(width: 8), GestureDetector(onTap: () => _removeSkill(skill), child: const Icon(Icons.close, color: Colors.white54, size: 16))]));
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
