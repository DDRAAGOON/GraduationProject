import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../teardsman/nav_Botton_bar/nav_bottom_bar.dart';
import '../../teardsman/profile/teardsman_data.dart';
//import '../teardsman/profile/teardsman_data.dart';
import 'sign_up_seeker.dart';

class SignUpTradesman extends StatefulWidget {
  const SignUpTradesman({super.key});

  @override
  State<SignUpTradesman> createState() => _SignUpTradesmanState();
}

class _SignUpTradesmanState extends State<SignUpTradesman> {
  final _formKey = GlobalKey<FormState>();
  final String _selectedRole = "Tradesman";

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  
  // Education Controllers
  final TextEditingController _eduInstitutionController = TextEditingController();
  final TextEditingController _eduDegreeController = TextEditingController();
  final TextEditingController _eduDurationController = TextEditingController();

  // Social Controllers
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _facebookController = TextEditingController();

  final List<String> _genderOptions = ["Male", "Female"];
  String? _selectedGender;
  
  // DOB Dropdowns
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;
  final List<String> _days = List.generate(31, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _months = List.generate(12, (i) => (i + 1).toString().padLeft(2, '0'));
  final List<String> _years = List.generate(70, (i) => (DateTime.now().year - 18 - i).toString());

  // Services
  final List<String> _trades = ["Ù†Ø¬Ø§Ø±", "ÙÙ†ÙŠ Ø³Ø¨Ø§ÙƒØ©", "Ù†Ù‚Ø§Ø´", "Ù…ÙŠÙƒØ§Ù†ÙŠÙƒÙŠ", "ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠ", "Ø­Ø¯Ø§Ø¯", "Ù…Ù†Ø¸Ù Ù…Ù†Ø§Ø²Ù„", "Other"];
  String? _selectedTrade;

  List<Map<String, String>> _educationList = [];
  List<String> _skillsList = [];
  
  // Criminal Record and Work Images state
  bool _criminalRecordUploaded = false;
  List<String> _workImages = [];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _aboutMeController.dispose();
    _serviceController.dispose();
    _skillsController.dispose();
    _eduInstitutionController.dispose();
    _eduDegreeController.dispose();
    _eduDurationController.dispose();
    _instagramController.dispose();
    _facebookController.dispose();
    super.dispose();
  }

  void _addEducation() {
    if (_eduInstitutionController.text.isNotEmpty && _eduDegreeController.text.isNotEmpty) {
      setState(() {
        _educationList.add({
          "institution": _eduInstitutionController.text.trim(),
          "degree": _eduDegreeController.text.trim(),
          "duration": _eduDurationController.text.trim(),
        });
        _eduInstitutionController.clear();
        _eduDegreeController.clear();
        _eduDurationController.clear();
      });
    }
  }

  void _addSkill() {
    String skill = _skillsController.text.trim();
    if (skill.isNotEmpty && !_skillsList.contains(skill)) {
      setState(() {
        _skillsList.add(skill);
        _skillsController.clear();
      });
    }
  }

  void _saveTradesmanProfile() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDay == null || _selectedMonth == null || _selectedYear == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select your full Date of Birth")));
        return;
      }
      if (_selectedGender == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select gender")));
        return;
      }
      if (!_criminalRecordUploaded) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Criminal Record is required")));
        return;
      }

      // Saving data to TradesmanProfileData
      TradesmanProfileData.fullName = _fullNameController.text;
      TradesmanProfileData.email = _emailController.text;
      TradesmanProfileData.phone = "+20 ${_phoneController.text}";
      TradesmanProfileData.gender = _selectedGender!;
      TradesmanProfileData.dob = "$_selectedYear-$_selectedMonth-$_selectedDay";
      TradesmanProfileData.address = _addressController.text;
      TradesmanProfileData.aboutMe = _aboutMeController.text;
      TradesmanProfileData.service = _serviceController.text;
      TradesmanProfileData.skills = List.from(_skillsList);
      TradesmanProfileData.education = List.from(_educationList);
      TradesmanProfileData.workImages = List.from(_workImages);
      TradesmanProfileData.socialLinks = {
        "instagram": _instagramController.text,
        "facebook": _facebookController.text,
      };
      TradesmanProfileData.criminalRecordUploaded = _criminalRecordUploaded;

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tradesman Profile saved successfully!")));
      
      // Navigate to Home (MainScreen which contains find jobs)
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Navbotton()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, title: const Text("Registration", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                RichText(
                  text: const TextSpan(
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: "You Can "),
                      TextSpan(text: "SignUp ", style: TextStyle(color: Color(0xFF49769F))),
                      TextSpan(text: "Tradesman or a job seeker with "),
                      TextSpan(text: "Jobito", style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Container(width: 80, height: 3, color: Colors.orange, margin: const EdgeInsets.only(left: 230)),
                const SizedBox(height: 25),

                // Role Selection
                Row(
                  children: [
                    Expanded(child: _buildRoleOption("Job Seeker")),
                    Container(width: 30, height: 1, color: Colors.white24),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("or", style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                    Container(width: 30, height: 1, color: Colors.white24),
                    Expanded(child: _buildRoleOption("Tradesman")),
                  ],
                ),
                const SizedBox(height: 35),

                // Profile Photo Section
                _buildSectionHeader("Profile Photo", "This image will be shown publicly as your profile picture."),
                const SizedBox(height: 15),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white12,
                      child: Icon(Icons.person, size: 45, color: Colors.white.withValues(alpha: 0.5)),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: _buildUploadBox("Click to replace or drag and drop\nSVG, PNG, JPG or GIF (max. 800 x 800px)", () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Photo Selected")));
                    })),
                  ],
                ),
                const SizedBox(height: 30),

                // Personal Details
                const Text("Personal Information", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                _buildTextField(_fullNameController, "Full Name", Icons.person_outline, isRequired: true),
                const SizedBox(height: 20),
                _buildTextField(_emailController, "Email", Icons.email_outlined, isRequired: true),
                const SizedBox(height: 20),
                _buildTextField(_phoneController, "Phone Number", Icons.phone_android_outlined, 
                  keyboardType: TextInputType.phone, 
                  isRequired: true, 
                  prefixText: "+20 ",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)]),
                const SizedBox(height: 20),
                
                // Gender Dropdown
                _buildDropdownField(
                  label: "Gender",
                  icon: Icons.person_search_outlined,
                  value: _selectedGender,
                  items: _genderOptions,
                  onChanged: (v) => setState(() => _selectedGender = v),
                  isRequired: true,
                ),
                
                const SizedBox(height: 20),
                
                // Date of Birth Dropdowns
                const Text("Date of Birth", style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildSimpleDropdown("Day", _days, _selectedDay, (v) => setState(() => _selectedDay = v))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildSimpleDropdown("Month", _months, _selectedMonth, (v) => setState(() => _selectedMonth = v))),
                    const SizedBox(width: 10),
                    Expanded(child: _buildSimpleDropdown("Year", _years, _selectedYear, (v) => setState(() => _selectedYear = v))),
                  ],
                ),
                
                const SizedBox(height: 20),
                _buildTextField(_addressController, "Address", Icons.location_on_outlined, isRequired: true),
                const SizedBox(height: 30),

                // Criminal Record Check (Required)
                _buildSectionHeader("Criminal Record Check *", "An official document that shows a person's criminal history."),
                const SizedBox(height: 15),
                _buildUploadBox(
                  _criminalRecordUploaded ? "Criminal Record Uploaded âœ“" : "Click to upload Criminal Record\nSVG, PNG, JPG or GIF (max. 400 x 400px)", 
                  () {
                    setState(() {
                      _criminalRecordUploaded = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Criminal Record Uploaded Successfully")));
                  }
                ),
                const SizedBox(height: 30),

                // About Me
                const Text("About Me", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 15),
                _buildTextField(_aboutMeController, "About Me", Icons.info_outline, maxLines: 4),
                const SizedBox(height: 30),

                // Service (Required choice or text)
                const Text("Service *", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const Text("Select or enter the profession you provide", style: TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 15),
                _buildDropdownField(
                  label: "Select Service",
                  icon: Icons.work_outline,
                  value: _selectedTrade,
                  items: _trades,
                  onChanged: (v) => setState(() {
                    _selectedTrade = v;
                    if (v != "Other") _serviceController.text = v!;
                    else _serviceController.clear();
                  }),
                  isRequired: true,
                ),
                if (_selectedTrade == "Other") ...[
                  const SizedBox(height: 15),
                  _buildTextField(_serviceController, "Enter Profession", Icons.edit_note_outlined, isRequired: true),
                ],
                const SizedBox(height: 30),

                // Education
                const Text("Education", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const Text("Add your academic qualifications", style: TextStyle(color: Colors.white38, fontSize: 12)),
                const SizedBox(height: 20),
                _buildTextField(_eduInstitutionController, "Education Institution", Icons.school_outlined),
                const SizedBox(height: 15),
                _buildTextField(_eduDegreeController, "Academic Degree", Icons.workspace_premium_outlined),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_eduDurationController, "Duration", Icons.timer_outlined)),
                    const SizedBox(width: 10),
                    IconButton(onPressed: _addEducation, icon: const Icon(Icons.add_circle, color: Color(0xFF49769F), size: 35)),
                  ],
                ),
                ..._educationList.asMap().entries.map((entry) => Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.03), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
                  child: Row(
                    children: [
                      const Icon(Icons.school, color: Color(0xFF49769F), size: 20),
                      const SizedBox(width: 12),
                      Expanded(child: Text("${entry.value['institution']} - ${entry.value['degree']} (${entry.value['duration']})", style: const TextStyle(color: Colors.white70, fontSize: 12))),
                      IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => setState(() => _educationList.removeAt(entry.key))),
                    ],
                  ),
                )),
                const SizedBox(height: 30),

                // Skills
                const Text("Skills", style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _skillsController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type and press Add", hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                    prefixIcon: const Icon(Icons.star_outline, color: Color(0xFF49769F), size: 20),
                    suffixIcon: IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF49769F)), onPressed: _addSkill),
                    filled: true, fillColor: Colors.white.withValues(alpha: 0.05), contentPadding: const EdgeInsets.all(16),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF49769F))),
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(spacing: 8, runSpacing: 8, children: _skillsList.map((s) => Chip(label: Text(s, style: const TextStyle(color: Colors.white, fontSize: 11)), backgroundColor: const Color(0xFF49769F).withValues(alpha: 0.2), onDeleted: () => setState(() => _skillsList.remove(s)), deleteIcon: const Icon(Icons.close, size: 14, color: Colors.white70), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))).toList()),
                const SizedBox(height: 30),

                // Social Links
                const Text("Social Links", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(child: _buildTextField(_instagramController, "Instagram", Icons.camera_alt_outlined)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildTextField(_facebookController, "Facebook", Icons.facebook_outlined)),
                  ],
                ),
                const SizedBox(height: 30),

                // Your Work
                _buildSectionHeader("Your Work", "Upload images of your previous work"),
                const SizedBox(height: 15),
                _buildUploadBox(
                  "Click to add work images\nSVG, PNG, JPG or GIF (max. 800 x 800px)", 
                  () {
                    setState(() {
                      _workImages.add("Work Image ${_workImages.length + 1}");
                    });
                  }
                ),
                if (_workImages.isNotEmpty) ...[
                  const SizedBox(height: 15),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _workImages.length,
                      itemBuilder: (context, index) => Container(
                        width: 80,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Stack(
                          children: [
                            const Center(child: Icon(Icons.image, color: Colors.white38)),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => setState(() => _workImages.removeAt(index)),
                                child: const Icon(Icons.cancel, color: Colors.red, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 40),

                // Save Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveTradesmanProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF49769F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text("Save Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ],
    );
  }

  Widget _buildUploadBox(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12, style: BorderStyle.solid),
        ),
        child: Center(
          child: Column(
            children: [
              const Icon(Icons.cloud_upload_outlined, color: Color(0xFF49769F), size: 30),
              const SizedBox(height: 8),
              Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white38, fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleOption(String role) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        if (role == "Job Seeker") Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF49769F) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: isSelected ? const Color(0xFF49769F) : Colors.white12, width: 1.5),
        ),
        alignment: Alignment.center,
        child: Text(
          role,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData? icon, {String? hint, String? prefixText, int maxLines = 1, TextInputType keyboardType = TextInputType.text, bool isRequired = false, VoidCallback? onIconTap, IconData? suffixIcon, VoidCallback? onSuffixTap, List<TextInputFormatter>? inputFormatters, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller, maxLines: maxLines, keyboardType: keyboardType, inputFormatters: inputFormatters, style: const TextStyle(color: Colors.white, fontSize: 14),
      validator: isRequired ? (validator ?? (value) => (value == null || value.isEmpty) ? "$label is required" : null) : null,
      decoration: InputDecoration(
        prefixText: prefixText, prefixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        hintText: hint, hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        prefixIcon: icon != null ? InkWell(onTap: onIconTap, child: Icon(icon, color: const Color(0xFF49769F), size: 20)) : null,
        suffixIcon: suffixIcon != null ? IconButton(icon: Icon(suffixIcon, color: Colors.white54), onPressed: onSuffixTap) : null,
        filled: true, fillColor: Colors.white.withValues(alpha: 0.05), contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF49769F))),
      ),
    );
  }

  Widget _buildDropdownField({required String label, required IconData icon, required String? value, required List<String> items, required ValueChanged<String?> onChanged, bool isRequired = false}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(color: Colors.white)))).toList(),
      onChanged: onChanged,
      dropdownColor: const Color(0xFF0D2D4D),
      style: const TextStyle(color: Colors.white),
      validator: isRequired ? (v) => v == null ? "$label is required" : null : null,
      decoration: InputDecoration(
        labelText: label, labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF49769F), size: 20),
        filled: true, fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
      ),
    );
  }

  Widget _buildSimpleDropdown(String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(color: Colors.white24, fontSize: 12)),
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF0D2D4D),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.white, fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}


