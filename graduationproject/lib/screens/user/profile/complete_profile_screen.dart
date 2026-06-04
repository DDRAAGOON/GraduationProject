import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';
import '../../../app/router/app_router.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  String _selectedRole = "Job Seeker"; // "Job Seeker" or "Tradesman"
  
  final _fullName = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _dob = TextEditingController();
  String _selectedGender = "Male";
  String? _selectedGovernorate;
  final _aboutMe = TextEditingController();

  final _facebook = TextEditingController();
  final _instagram = TextEditingController();
  final _whatsapp = TextEditingController();

  // Error variables for validation
  String? _fullNameError;
  String? _phoneError;
  String? _emailError;
  String? _dobError;
  String? _governorateError;

  // Lists for dynamic items
  final List<Map<String, String>> _educationList = [];
  final List<Map<String, String>> _experienceList = [];
  final List<String> _skillsList = [];

  // Controllers for adding items
  final _eduInstitution = TextEditingController();
  final _eduDuration = TextEditingController();
  final _eduDegree = TextEditingController();
  
  final _expTitle = TextEditingController();
  final _expDuration = TextEditingController();
  
  final _skillController = TextEditingController();

  File? _profileImage;
  File? _wallpaperImage;
  File? _criminalRecordFile;
  final List<File> _workImages = [];

  final ImagePicker _picker = ImagePicker();

  final List<String> _egyptGovernorates = [
    "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Monufia", "Minya", "Qalyubia", "New Valley", "Suez", "Aswan", "Assiut", "Beni Suef", "Port Said", "Damietta", "South Sinai", "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "North Sinai", "Sohag"
  ];

  final List<String> _tradesmanServices = [
    "Electrician", "Plumber", "Carpenter", "HVAC Technician", "Painter", "Mechanic", "Blacksmith"
  ];
  final List<String> _selectedServices = [];
  final _otherServiceController = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose(); _phone.dispose(); _email.dispose(); _dob.dispose(); _aboutMe.dispose();
    _facebook.dispose(); _instagram.dispose(); _whatsapp.dispose();
    _eduInstitution.dispose(); _eduDuration.dispose(); _eduDegree.dispose();
    _expTitle.dispose(); _expDuration.dispose(); _skillController.dispose();
    _otherServiceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String type) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (type == 'profile') _profileImage = File(image.path);
        if (type == 'wallpaper') _wallpaperImage = File(image.path);
        if (type == 'work') _workImages.add(File(image.path));
        if (type == 'criminal') _criminalRecordFile = File(image.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dob.text = "${picked.day}/${picked.month}/${picked.year}";
        _dobError = null;
      });
    }
  }

  void _addEducation() {
    if (_eduInstitution.text.isNotEmpty && _eduDegree.text.isNotEmpty) {
      setState(() {
        _educationList.add({
          'institution': _eduInstitution.text,
          'duration': _eduDuration.text,
          'degree': _eduDegree.text,
        });
        _eduInstitution.clear(); _eduDuration.clear(); _eduDegree.clear();
      });
    }
  }

  void _addExperience() {
    if (_expTitle.text.isNotEmpty) {
      setState(() {
        _experienceList.add({
          'title': _expTitle.text,
          'duration': _expDuration.text,
        });
        _expTitle.clear(); _expDuration.clear();
      });
    }
  }

  void _addSkill() {
    if (_skillController.text.isNotEmpty) {
      setState(() {
        _skillsList.add(_skillController.text);
        _skillController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        final size = MediaQuery.sizeOf(context);
        final isDark = themeMode == ThemeMode.dark || 
                      (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
        
        final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
        final textColor = isDark ? Colors.white : Colors.black;

        return Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(t, isDark),
                  const SizedBox(height: 30),
                  _buildRoleSelection(isDark),
                  const SizedBox(height: 40),

                  // Photos
                  _buildSectionTitle(t.profilePhoto, isDark),
                  _buildPhotoUploadArea(type: 'profile', file: _profileImage, isDark: isDark),
                  const SizedBox(height: 30),
                  _buildSectionTitle(t.tr(en: "Wallpaper", ar: "صورة الغلاف"), isDark),
                  _buildPhotoUploadArea(type: 'wallpaper', file: _wallpaperImage, isDark: isDark),
                  const SizedBox(height: 30),

                  // Personal Info
                  _buildSectionTitle(t.personalInfo, isDark),
                  const SizedBox(height: 16),
                  _buildLabel(t.fullName, textColor),
                  _buildTextField(_fullName, t.tr(en: 'e.g. Karim Mohamed', ar: 'مثال: كريم محمد'), isDark, errorText: _fullNameError, onChanged: (v) => setState(() => _fullNameError = null)),
                  const SizedBox(height: 16),
                  _buildLabel(t.phoneNumber, textColor),
                  _buildTextField(_phone, '01xxxxxxxxx', isDark, keyboardType: TextInputType.phone, errorText: _phoneError, onChanged: (v) => setState(() => _phoneError = null)),
                  const SizedBox(height: 16),
                  _buildLabel(t.email, textColor),
                  _buildTextField(_email, 'example@gmail.com', isDark, keyboardType: TextInputType.emailAddress, errorText: _emailError, onChanged: (v) => setState(() => _emailError = null)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(t.dob, textColor),
                            GestureDetector(
                              onTap: () => _selectDate(context),
                              child: AbsorbPointer(child: _buildTextField(_dob, 'DD/MM/YYYY', isDark, suffixIcon: Icons.calendar_today_outlined, errorText: _dobError)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel(t.gender, textColor),
                            _buildGenderDropdown(isDark, t),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel(t.tr(en: "Governorate", ar: "المحافظة"), textColor),
                  _buildGovernorateDropdown(isDark, t),

                  const SizedBox(height: 40),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 20),

                  if (_selectedRole == "Tradesman") ...[
                    // Criminal Record
                    _buildSectionTitle(t.criminalRecord, isDark),
                    const SizedBox(height: 8),
                    Text(
                      t.tr(
                        en: "The criminal record is an official document that shows a person's criminal history (Fish and Tashbih).",
                        ar: "صحيفة الحالة الجنائية هي وثيقة رسمية توضح التاريخ الجنائي للشخص (الفيش والتشبيه)"
                      ),
                      style: TextStyle(color: textColor.withOpacity(0.6), fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    _buildPhotoUploadArea(type: 'criminal', file: _criminalRecordFile, isDark: isDark),
                    const SizedBox(height: 40),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 20),
                  ],

                  // About Me
                  _buildSectionTitle(t.tr(en: "Brief About Me", ar: "نبذة عني"), isDark),
                  const SizedBox(height: 12),
                  _buildTextField(
                    _aboutMe, 
                    _selectedRole == "Tradesman" 
                      ? t.tr(en: "Tell us about your craft and experience...", ar: "تحدث عن حرفتك وخبرتك...")
                      : t.tr(en: "Write a short brief about your skills and goals...", ar: "اكتب نبذة قصيرة عن مهاراتك وأهدافك..."), 
                    isDark, 
                    maxLines: 4
                  ),

                  const SizedBox(height: 40),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 20),

                  if (_selectedRole == "Job Seeker") ...[
                    // Education
                    _buildSectionTitle(t.education, isDark),
                    const SizedBox(height: 16),
                    if (_educationList.isNotEmpty) ...[
                      ..._educationList.map((edu) => _buildAddedItem(edu['institution']!, "${edu['degree']} (${edu['duration']})", isDark, () {
                        setState(() => _educationList.remove(edu));
                      })),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(child: _buildLabel(t.tr(en: "Education institution", ar: "المؤسسة التعليمية"), textColor)),
                        const SizedBox(width: 16),
                        _buildLabel(t.tr(en: "Duration", ar: "المدة"), textColor),
                        const SizedBox(width: 40),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_eduInstitution, t.tr(en: "e.g. El Shorouk Academy", ar: "مثال: أكاديمية الشروق"), isDark)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField(_eduDuration, '2023 - 2026', isDark)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildLabel(t.tr(en: "Academic degree", ar: "الدرجة العلمية"), textColor),
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_eduDegree, t.tr(en: "e.g. Bachelor's Degree", ar: "مثال: بكالوريوس نظم معلومات"), isDark)),
                        const SizedBox(width: 16),
                        _buildActionButton(t.tr(en: "Add", ar: "إضافة"), isDark, _addEducation),
                      ],
                    ),

                    const SizedBox(height: 40),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 20),
                  ] else ...[
                    // Services (For Tradesman)
                    _buildSectionTitle(t.tr(en: "Choose Service", ar: "اختر الخدمة"), isDark),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: _tradesmanServices.map((service) {
                        bool isSelected = _selectedServices.contains(service);
                        return FilterChip(
                          label: Text(_translateService(service, t)),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedServices.add(service);
                              } else {
                                _selectedServices.remove(service);
                              }
                            });
                          },
                          selectedColor: const Color(0xFF0051DD).withOpacity(0.2),
                          checkmarkColor: const Color(0xFF0051DD),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel(t.tr(en: "Other profession", ar: "مهنة أخرى"), textColor),
                    _buildTextField(_otherServiceController, t.tr(en: "e.g. Carpenter", ar: "مثال: نجار"), isDark),
                    const SizedBox(height: 40),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 20),
                  ],

                  // Experiences
                  if (_selectedRole == "Job Seeker") ...[
                    _buildSectionTitle(t.workExperience, isDark),
                    const SizedBox(height: 16),
                    if (_experienceList.isNotEmpty) ...[
                      ..._experienceList.map((exp) => _buildAddedItem(exp['title']!, exp['duration']!, isDark, () {
                        setState(() => _experienceList.remove(exp));
                      })),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(child: _buildLabel(t.jobTitle, textColor)),
                        const SizedBox(width: 16),
                        _buildActionButton(t.tr(en: "Add", ar: "إضافة"), isDark, _addExperience),
                      ],
                    ),
                    _buildTextField(_expTitle, t.tr(en: "e.g. Accountant", ar: "مثال: محاسب"), isDark),
                    const SizedBox(height: 12),
                    _buildLabel(t.tr(en: "Duration", ar: "المدة"), textColor),
                    _buildTextField(_expDuration, '2 Years', isDark, width: size.width * 0.4),

                    const SizedBox(height: 40),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 20),
                  ],

                  // Skills
                  _buildSectionTitle(t.skills, isDark),
                  const SizedBox(height: 16),
                  if (_skillsList.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      children: _skillsList.map((skill) => Chip(
                        label: Text(skill, style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                        onDeleted: () => setState(() => _skillsList.remove(skill)),
                        backgroundColor: isDark ? Colors.white10 : Colors.black12,
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          _skillController, 
                          _selectedRole == "Tradesman" 
                            ? t.tr(en: "e.g. welding", ar: "مثال: لحام المعادن") 
                            : t.tr(en: "e.g. dart", ar: "مثال: dart"), 
                          isDark
                        )
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(t.tr(en: "Add", ar: "إضافة"), isDark, _addSkill),
                    ],
                  ),

                  const SizedBox(height: 40),
                  const Divider(color: Colors.black12),
                  const SizedBox(height: 20),

                  // Social Links
                  _buildSectionTitle(t.socialLinks, isDark),
                  const SizedBox(height: 16),
                  _buildLabel("Facebook", textColor),
                  _buildTextField(_facebook, 'URL', isDark),
                  const SizedBox(height: 12),
                  _buildLabel("Instagram", textColor),
                  _buildTextField(_instagram, 'URL', isDark),
                  const SizedBox(height: 12),
                  _buildLabel("WhatsApp", textColor),
                  _buildTextField(_whatsapp, 'Phone Number', isDark, keyboardType: TextInputType.phone),

                  if (_selectedRole == "Tradesman") ...[
                    const SizedBox(height: 40),
                    const Divider(color: Colors.black12),
                    const SizedBox(height: 20),
                    _buildSectionTitle(t.yourWork, isDark),
                    const SizedBox(height: 16),
                    _buildPhotoUploadArea(type: 'work', file: _workImages.isNotEmpty ? _workImages.first : null, isDark: isDark),
                  ],

                  const SizedBox(height: 50),
                  Align(alignment: Alignment.centerRight, child: _buildSaveButton(t)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _translateService(String service, AppLocalizations t) {
    switch (service) {
      case "Electrician": return t.tr(en: "Electrician", ar: "كهربائي");
      case "Plumber": return t.tr(en: "Plumber", ar: "فني سباكة");
      case "Carpenter": return t.tr(en: "Carpenter", ar: "نجار");
      case "HVAC Technician": return t.tr(en: "HVAC Technician", ar: "فني تكييف");
      case "Painter": return t.tr(en: "Painter", ar: "نقاش");
      case "Mechanic": return t.tr(en: "Mechanic", ar: "ميكانيكي");
      case "Blacksmith": return t.tr(en: "Blacksmith", ar: "حداد");
      default: return service;
    }
  }

  Widget _buildHeader(AppLocalizations t, bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black, height: 1.2),
        children: [
          TextSpan(text: t.tr(en: 'You Can Signin ', ar: 'يمكنك تسجيل الدخول كـ ')),
          TextSpan(text: t.tr(en: 'tradesman', ar: 'حرفي'), style: const TextStyle(color: Color(0xFF0051DD))),
          TextSpan(text: t.tr(en: ' or a ', ar: ' أو ')),
          TextSpan(text: t.tr(en: 'job seeker', ar: 'باحث عن عمل'), style: const TextStyle(color: Color(0xFFF77F32))),
          TextSpan(text: t.tr(en: ' with ', ar: ' مع ')),
          const TextSpan(text: 'Jobito', style: TextStyle(color: Color(0xFFF77F32), decoration: TextDecoration.underline, decorationColor: Color(0xFFF77F32))),
        ],
      ),
    );
  }

  Widget _buildRoleSelection(bool isDark) {
    final t = AppLocalizations.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildRoleBtn(t.tr(en: "Job Seeker", ar: "باحث عن عمل"), const Color(0xFFF77F32)),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: const Color(0xFF0D1B3E), borderRadius: BorderRadius.circular(4)),
          child: Text(t.tr(en: "OR", ar: "أو"), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12)),
        ),
        _buildRoleBtn(t.tr(en: "Tradesman", ar: "حرفي"), const Color(0xFF0051DD)),
      ],
    );
  }

  Widget _buildRoleBtn(String role, Color color) {
    String roleValue = (role == "Job Seeker" || role == "باحث عن عمل") ? "Job Seeker" : "Tradesman";
    bool isSelected = _selectedRole == roleValue;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = roleValue),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color),
        ),
        child: Text(role, style: TextStyle(color: isSelected ? Colors.white : color, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDark) {
    return Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black));
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color.withOpacity(0.8))));
  }

  Widget _buildTextField(TextEditingController controller, String hint, bool isDark, {int maxLines = 1, IconData? suffixIcon, double? width, TextInputType? keyboardType, String? errorText, Function(String)? onChanged}) {
    return Container(
      width: width,
      margin: const EdgeInsets.only(bottom: 4),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black26, fontSize: 14),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20, color: isDark ? Colors.white54 : Colors.black54) : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          errorText: errorText,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: isDark ? Colors.white24 : Colors.black12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Color(0xFF142C66), width: 1.5)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(bool isDark, AppLocalizations t) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, border: Border.all(color: isDark ? Colors.white24 : Colors.black12), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          dropdownColor: isDark ? const Color(0xFF001E3A) : Colors.white,
          items: [
            DropdownMenuItem(value: "Male", child: Text(t.tr(en: "Male", ar: "ذكر"), style: TextStyle(color: isDark ? Colors.white : Colors.black))),
            DropdownMenuItem(value: "Female", child: Text(t.tr(en: "Female", ar: "أنثى"), style: TextStyle(color: isDark ? Colors.white : Colors.black))),
          ],
          onChanged: (v) => setState(() => _selectedGender = v!),
        ),
      ),
    );
  }

  Widget _buildGovernorateDropdown(bool isDark, AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, border: Border.all(color: _governorateError != null ? Colors.redAccent : (isDark ? Colors.white24 : Colors.black12)), borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedGovernorate,
              hint: Text(t.tr(en: "Select Governorate", ar: "اختر المحافظة"), style: TextStyle(color: isDark ? Colors.white38 : Colors.black26)),
              isExpanded: true,
              dropdownColor: isDark ? const Color(0xFF001E3A) : Colors.white,
              items: _egyptGovernorates.map((gov) {
                return DropdownMenuItem(value: gov, child: Text(t.translateLocation(gov), style: TextStyle(color: isDark ? Colors.white : Colors.black)));
              }).toList(),
              onChanged: (v) => setState(() {
                _selectedGovernorate = v;
                _governorateError = null;
              }),
            ),
          ),
        ),
        if (_governorateError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 12),
            child: Text(_governorateError!, style: const TextStyle(color: Colors.redAccent, fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildPhotoUploadArea({required String type, File? file, required bool isDark}) {
    final t = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => _pickImage(type),
      child: Container(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF0051DD).withOpacity(0.3), width: 1)),
        child: file != null 
          ? ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.file(file, fit: BoxFit.cover))
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_upload_outlined, color: Color(0xFF0051DD), size: 28),
                const SizedBox(height: 8),
                RichText(text: TextSpan(style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : Colors.black54), children: [
                  TextSpan(text: t.tr(en: 'Click to ', ar: 'اضغط لـ '), style: const TextStyle(color: Color(0xFF0051DD), decoration: TextDecoration.underline)),
                  TextSpan(text: t.tr(en: 'replace', ar: 'الاستبدال'), style: const TextStyle(color: Color(0xFF0051DD), decoration: TextDecoration.underline)),
                  TextSpan(text: t.tr(en: ' or drag and drop', ar: ' أو السحب والإفلات')),
                ])),
                Text("(SVG, PNG, JPG or GIF (max. 400 x 400px))", style: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 10))
              ],
            ),
      ),
    );
  }

  Widget _buildActionButton(String text, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF0051DD).withOpacity(0.3))),
        child: Text(text, style: const TextStyle(color: Color(0xFF0051DD), fontSize: 12, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAddedItem(String title, String subtitle, bool isDark, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03), borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black54)),
          ])),
          IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: onDelete),
        ],
      ),
    );
  }

  Widget _buildSaveButton(AppLocalizations t) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _fullNameError = _fullName.text.isEmpty ? t.required : null;
          _phoneError = _phone.text.isEmpty ? t.required : null;
          _emailError = _email.text.isEmpty ? t.required : null;
          _dobError = _dob.text.isEmpty ? t.required : null;
          _governorateError = _selectedGovernorate == null ? t.required : null;
        });

        if (_fullNameError != null ||
            _phoneError != null ||
            _emailError != null ||
            _dobError != null ||
            _governorateError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(t.tr(
                en: "Please fill all basic information fields",
                ar: "يرجى ملء جميع حقول المعلومات الأساسية",
              )),
              backgroundColor: Colors.redAccent,
            ),
          );
          return;
        }

        if (_selectedRole == "Tradesman") {
          Navigator.of(context).pushReplacementNamed(AppRoutes.tradesmanWorkspace);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.userWorkspace);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF142C66),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Text(
        t.tr(en: "Save Profile", ar: "حفظ الملف الشخصي"),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
