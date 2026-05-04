import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import 'package:graduationproject/screens/user/profile/user_data.dart';
import 'profile_login_details_screen.dart';
import 'setting_profile/notifications.dart';
import 'setting_profile/preferences.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _aboutMeController;
  late TextEditingController _fullNameController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _dayController;
  late TextEditingController _monthController;
  late TextEditingController _yearController;
  late TextEditingController _locationController;
  late TextEditingController _skillController;
  
  String _selectedGender = "Male";
  final ImagePicker _picker = ImagePicker();

  late List<Map<String, String>> _experiences;
  late List<Map<String, String>> _education;
  late List<String> _skills;
  late List<Map<String, String>> _socialLinks;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;

    _aboutMeController = TextEditingController(text: store.currentUserAbout);
    _fullNameController = TextEditingController(text: store.currentUserName == 'User' ? '' : store.currentUserName);
    _titleController = TextEditingController(text: store.currentUserTitle);
    _phoneController = TextEditingController(text: store.currentUserPhone);
    _emailController = TextEditingController(text: store.currentUserEmail);
    
    // Parse DOB into Day, Month, Year
    String currentDob = UserProfileData.dob;
    List<String> dobParts = currentDob.split('/');
    _dayController = TextEditingController(text: dobParts.isNotEmpty ? dobParts[0] : '');
    _monthController = TextEditingController(text: dobParts.length > 1 ? dobParts[1] : '');
    _yearController = TextEditingController(text: dobParts.length > 2 ? dobParts[2] : '');

    _locationController = TextEditingController(text: store.currentUserLocation);
    _skillController = TextEditingController();
    
    _selectedGender = (UserProfileData.gender == "أنثى" || UserProfileData.gender == "Female") ? "Female" : "Male";

    _experiences = List.from(store.currentUserExperience);
    _education = List.from(store.currentUserEducation);
    _skills = List.from(store.currentUserSkills);
    _socialLinks = List.from(store.socialLinks);
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    _fullNameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _locationController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await RecruitmentSyncService.instance.updateProfile(photoUrl: image.path);
      setState(() {});
    }
  }

  void _saveData() {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    String dob = "${_dayController.text}/${_monthController.text}/${_yearController.text}";
    UserProfileData.dob = dob;

    store.updateUserProfile(
      fullName: _fullNameController.text,
      title: _titleController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      location: _locationController.text,
      about: _aboutMeController.text,
      skills: _skills,
      education: _education,
      experience: _experiences,
      socialLinks: _socialLinks,
    );

    RecruitmentSyncService.instance.updateProfile(
      name: _fullNameController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.tr(en: "Saved successfully", ar: "تم الحفظ بنجاح")),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabItem(t.tr(en: "Profile Setting", ar: "إعدادات الملف"), true, () {}),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Account Security", ar: "أمان الحساب"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()));
                  }),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Notification", ar: "الإشعارات"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                  }),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Preferences", ar: "التفضيلات"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Preferences()));
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 30),

            Text(t.tr(en: "Basic Information", ar: "معلومات أساسية"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(t.tr(en: "This is your personal information that you can update anytime.", ar: "هذه هي معلوماتك الشخصية التي يمكنك تحديثها في أي وقت."), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13)),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            Text(t.tr(en: "Profile Photo", ar: "صورة الملف الشخصي"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    backgroundImage: getAppImageProvider(store.profileImage),
                    child: store.profileImage == null 
                        ? Icon(Icons.camera_alt, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)) 
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), size: 30),
                          const SizedBox(height: 8),
                          Text(t.tr(en: "Click to replace or drag and drop", ar: "انقر للاستبدال أو السحب والإفلات"), style: const TextStyle(color: Colors.blueAccent, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            _buildTextFieldWithLabel(_fullNameController, t.tr(en: "Full Name", ar: "الاسم بالكامل"), t.tr(en: "Enter Full Name", ar: "أدخل الاسم بالكامل")),
            const SizedBox(height: 20),
            _buildTextFieldWithLabel(_titleController, t.tr(en: "Job Title", ar: "المسمى الوظيفي"), t.tr(en: "Enter Job Title", ar: "أدخل المسمى الوظيفي")),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: _buildTextFieldWithLabel(
                        _phoneController, 
                        t.tr(en: "Phone Number", ar: "رقم الهاتف"), 
                        t.tr(en: "Enter Phone Number", ar: "أدخل رقم الهاتف"),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11),
                        ],
                    )
                ),
                const SizedBox(width: 15),
                Expanded(child: _buildTextFieldWithLabel(_emailController, t.tr(en: "Email", ar: "البريد الإلكتروني"), t.tr(en: "Enter Email", ar: "أدخل البريد الإلكتروني"), keyboardType: TextInputType.emailAddress)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.dob, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildTextField(_dayController, "DD", keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)])),
                          const SizedBox(width: 5),
                          Expanded(child: _buildTextField(_monthController, "MM", keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)])),
                          const SizedBox(width: 5),
                          Expanded(flex: 2, child: _buildTextField(_yearController, "YYYY", keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)])),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(t.gender, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(value: "Male", child: Text(t.male)),
                              DropdownMenuItem(value: "Female", child: Text(t.female)),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedGender = val);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildTextFieldWithLabel(_locationController, t.address, t.tr(en: "Enter Address", ar: "أدخل العنوان"), suffixIcon: Icons.location_on_outlined),
            
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            Text(t.aboutMe, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildTextField(_aboutMeController, t.tr(en: "Enter About Me", ar: "أدخل معلومات عنك"), maxLines: 3),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            _buildSectionHeader(t.workExperience, () {
               _showAddItemDialog(
                 title: t.tr(en: "Add Experience", ar: "إضافة خبرة"), 
                 fieldKeys: ["title", "company", "duration"],
                 fieldLabels: [
                   t.tr(en: "Job Title", ar: "المسمى الوظيفي"),
                   t.tr(en: "Company", ar: "الشركة"),
                   t.tr(en: "Duration", ar: "المدة")
                 ], 
                 onSave: (data) => setState(() => _experiences.add(data))
               );
            }),
            ..._experiences.map((exp) => _buildRemovableItem(exp['title'] ?? "", exp['company'] ?? "", () => setState(() => _experiences.remove(exp)))),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            _buildSectionHeader(t.education, () {
               _showAddItemDialog(
                 title: t.tr(en: "Add Education", ar: "إضافة تعليم"), 
                 fieldKeys: ["institution", "degree", "duration"],
                 fieldLabels: [
                   t.tr(en: "Institution", ar: "المؤسسة التعليمية"),
                   t.tr(en: "Degree", ar: "الدرجة العلمية"),
                   t.tr(en: "Duration", ar: "المدة")
                 ], 
                 onSave: (data) => setState(() => _education.add(data))
               );
            }),
            ..._education.map((edu) => _buildRemovableItem(edu['institution'] ?? "", edu['degree'] ?? "", () => setState(() => _education.remove(edu)))),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            Text(t.skills, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _skills.map((skill) => Chip(
                label: Text(skill, style: const TextStyle(fontSize: 12)), 
                onDeleted: () => setState(() => _skills.remove(skill)),
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                side: BorderSide.none,
              )).toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildTextField(_skillController, t.tr(en: "Add Skill", ar: "إضافة مهارة"))),
                IconButton(icon: const Icon(Icons.add_circle, color: Colors.blueAccent), onPressed: () {
                  if (_skillController.text.isNotEmpty) { setState(() { _skills.add(_skillController.text); _skillController.clear(); }); }
                }),
              ],
            ),
            Divider(color: Theme.of(context).dividerColor.withValues(alpha: 0.12), height: 40),

            _buildSectionHeader(t.socialMedia, () {
               _showAddItemDialog(
                 title: t.tr(en: "Add Social Link", ar: "إضافة رابط تواصل"), 
                 fieldKeys: ["platform", "url"],
                 fieldLabels: [
                   t.tr(en: "Platform", ar: "المنصة"),
                   t.tr(en: "URL", ar: "الرابط")
                 ], 
                 onSave: (data) => setState(() => _socialLinks.add(data))
               );
            }),
            ..._socialLinks.map((link) => _buildRemovableItem(link['platform'] ?? "", link['url'] ?? "", () => setState(() => _socialLinks.remove(link)))),
            
            const SizedBox(height: 40),
            AppButton(
              label: t.tr(en: "Save Profile", ar: "حفظ الملف الشخصي"),
              onPressed: _saveData,
              backgroundColor: const Color(0xFF4A6ED1),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(label, style: TextStyle(color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          if (isActive) Container(height: 2, width: 20, color: Theme.of(context).colorScheme.primary, margin: const EdgeInsets.only(top: 4)),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel(TextEditingController controller, String label, String hint, {IconData? suffixIcon, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        _buildTextField(controller, hint, suffixIcon: suffixIcon, keyboardType: keyboardType, inputFormatters: inputFormatters),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {IconData? suffixIcon, int maxLines = 1, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        filled: true,
        fillColor: Theme.of(context).cardColor,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.2))),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent), onPressed: onAdd),
      ],
    );
  }

  Widget _buildRemovableItem(String title, String subtitle, VoidCallback onRemove) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: onRemove),
    );
  }

  void _showAddItemDialog({
    required String title, 
    required List<String> fieldKeys,
    required List<String> fieldLabels, 
    required Function(Map<String, String>) onSave
  }) {
    final controllers = fieldLabels.map((_) => TextEditingController()).toList();
    showDialog(context: context, builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: List.generate(fieldLabels.length, (index) => Padding(padding: const EdgeInsets.only(bottom: 10), child: TextField(controller: controllers[index], decoration: InputDecoration(labelText: fieldLabels[index], border: const OutlineInputBorder()))))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context).tr(en: "Cancel", ar: "إلغاء"))), 
          ElevatedButton(onPressed: () {
            final data = <String, String>{};
            for (int i = 0; i < fieldKeys.length; i++) {
              data[fieldKeys[i]] = controllers[i].text;
            }
            onSave(data);
            Navigator.pop(context);
          }, child: Text(AppLocalizations.of(context).tr(en: "Save", ar: "حفظ"))),
        ],
    ));
  }
}
