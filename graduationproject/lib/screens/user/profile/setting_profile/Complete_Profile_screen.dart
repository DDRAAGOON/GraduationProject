import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';
import '../../core/app_colors.dart';
import '../../home/main_screen.dart';
import '../user_data.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();

  List<String> _skillsList = []; 
  List<Map<String, String>> _socialLinksList = [];

  String? _selectedJob;
  String _selectedPlatform = "LinkedIn";

  final List<String> _jobOptions = [
    "Student (طالب)", "Software Engineer", "Product Designer", "UI/UX Designer",
    "Marketing Specialist", "Project Manager", "HR Manager", "Sales Representative",
    "Flutter Developer", "Frontend Developer", "Backend Developer", "AI Developer",
    "Data Analyst", "Accountant", "Bodyguard", "Craftsman", "Other"
  ];

  final List<String> _platforms = ["LinkedIn", "GitHub", "Twitter", "Instagram", "Facebook", "Other"];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _aboutMeController.dispose();
    _skillsController.dispose();
    _portfolioController.dispose();
    _socialController.dispose();
    super.dispose();
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

  void _removeSkill(String skill) {
    setState(() => _skillsList.remove(skill));
  }

  void _addSocialLink() {
    String link = _socialController.text.trim();
    if (link.isNotEmpty) {
      setState(() {
        _socialLinksList.add({"platform": _selectedPlatform, "url": link});
        _socialController.clear();
      });
    }
  }

  void _removeSocialLink(int index) {
    setState(() => _socialLinksList.removeAt(index));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(DateTime.now().year - 20),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF49769F),
              onPrimary: Colors.white,
              surface: Color(0xFF0D2D4D),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // حفظ كافة البيانات في الملف الموحد
      UserProfileData.fullName = "${_firstNameController.text} ${_lastNameController.text}";
      UserProfileData.email = _emailController.text;
      UserProfileData.phone = "+20 ${_phoneController.text}";
      UserProfileData.aboutMe = _aboutMeController.text;
      UserProfileData.dob = _dobController.text;
      UserProfileData.location = _addressController.text;
      UserProfileData.jobTitle = _selectedJob ?? "Job Seeker";
      UserProfileData.portfolioUrl = _portfolioController.text;
      
      // حفظ القوائم (المهارات والروابط)
      UserProfileData.skills = List.from(_skillsList);
      UserProfileData.socialLinks = List.from(_socialLinksList);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile saved successfully!")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Complete Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Personal Information", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                
                Row(
                  children: [
                    Expanded(child: _buildTextField(_firstNameController, "First Name", Icons.person_outline, isRequired: true)),
                    const SizedBox(width: 15),
                    Expanded(child: _buildTextField(_lastNameController, "Last Name", Icons.person_outline, isRequired: true)),
                  ],
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  _emailController, "Email", Icons.email_outlined, isRequired: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!value.endsWith("@gmail.com")) return "Must be a valid @gmail.com";
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  _phoneController, "Phone Number", Icons.phone_android_outlined, 
                  keyboardType: TextInputType.phone, isRequired: true, prefixText: "+20 ",
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Phone is required";
                    if (value.length < 10) return "Phone must be 10 digits";
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  value: _selectedJob,
                  dropdownColor: const Color(0xFF0D2D4D),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) => value == null ? "Please select your job or status" : null,
                  decoration: InputDecoration(
                    labelText: "Current Job / Status",
                    labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
                    prefixIcon: const Icon(Icons.work_outline, color: Color(0xFF49769F), size: 20),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                  ),
                  items: _jobOptions.map((String job) => DropdownMenuItem(value: job, child: Text(job))).toList(),
                  onChanged: (val) => setState(() => _selectedJob = val),
                ),
                const SizedBox(height: 20),

                _buildTextField(
                  _dobController, "Date of Birth", Icons.calendar_today_outlined, 
                  hint: "YYYY-MM-DD", isRequired: true, onIconTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) return "DOB is required";
                    DateTime? date = DateTime.tryParse(value);
                    if (date == null) return "Invalid format (YYYY-MM-DD)";
                    DateTime today = DateTime.now();
                    int age = today.year - date.year;
                    if (today.month < date.month || (today.month == date.month && today.day < date.day)) age--;
                    if (age < 20) return "You must be 20 or older";
                    return null;
                  }
                ),
                const SizedBox(height: 20),

                _buildTextField(_addressController, "Address", Icons.location_on_outlined, isRequired: true),
                const SizedBox(height: 30),

                const Text("Professional Details", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),

                _buildTextField(_aboutMeController, "About Me", Icons.info_outline, maxLines: 3, isRequired: false),
                const SizedBox(height: 20),

                const Text("Skills", style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _skillsController,
                  style: const TextStyle(color: Colors.white),
                  onFieldSubmitted: (_) => _addSkill(),
                  decoration: InputDecoration(
                    hintText: "Type a skill and press Add",
                    hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                    prefixIcon: const Icon(Icons.star_outline, color: Color(0xFF49769F), size: 20),
                    suffixIcon: IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF49769F)), onPressed: _addSkill),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skillsList.map((skill) => Chip(
                    label: Text(skill, style: const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: const Color(0xFF49769F).withOpacity(0.2),
                    deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white70),
                    onDeleted: () => _removeSkill(skill),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFF49769F))),
                  )).toList(),
                ),
                const SizedBox(height: 20),

                // Portfolio Section (Link Only)
                const Text("Portfolio", style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                _buildTextField(_portfolioController, "Portfolio Link (URL)", Icons.link_outlined, isRequired: false),
                const SizedBox(height: 20),

                const Text("Social Media Links", style: TextStyle(color: Colors.white54, fontSize: 14)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.white12)),
                        child: DropdownButton<String>(
                          value: _selectedPlatform,
                          dropdownColor: const Color(0xFF0D2D4D),
                          underline: const SizedBox(),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          items: _platforms.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _selectedPlatform = val!),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: _socialController,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        decoration: InputDecoration(
                          hintText: "Paste link here",
                          hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.05),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
                        ),
                      ),
                    ),
                    IconButton(onPressed: _addSocialLink, icon: const Icon(Icons.add_circle, color: Color(0xFF49769F), size: 30)),
                  ],
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _socialLinksList.length,
                  itemBuilder: (context, index) {
                    final item = _socialLinksList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
                      child: Row(
                        children: [
                          const Icon(Icons.link, color: Color(0xFF49769F), size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "${item["platform"]}: ",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  TextSpan(
                                    text: item["url"]!,
                                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => _removeSocialLink(index)),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF49769F), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
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

  Widget _buildTextField(
    TextEditingController controller, String label, IconData icon, {
    String? hint, String? prefixText, int maxLines = 1, TextInputType keyboardType = TextInputType.text,
    bool isRequired = false, VoidCallback? onIconTap, List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: const TextStyle(color: Colors.white),
      validator: isRequired ? (validator ?? (value) => (value == null || value.isEmpty) ? "$label is required" : null) : null,
      decoration: InputDecoration(
        prefixText: prefixText,
        prefixStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54, fontSize: 14),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 12),
        prefixIcon: InkWell(onTap: onIconTap, child: Icon(icon, color: const Color(0xFF49769F), size: 20)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.white12)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Color(0xFF49769F))),
      ),
    );
  }
}
