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
  late TextEditingController _socialLinkController;

  String _selectedGender = "Male";
  final ImagePicker _picker = ImagePicker();

  late List<Map<String, String>> _experiences;
  late List<Map<String, String>> _education;
  late List<String> _skills;
  late List<Map<String, String>> _socialLinks;
  late List<String> _portfolioPaths;
  String? _localBackgroundImage;
  String? _localProfileImage;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;

    _aboutMeController = TextEditingController(text: store.currentUserAbout);
    _fullNameController = TextEditingController(
      text: store.currentUserName == 'User' ? '' : store.currentUserName,
    );
    _titleController = TextEditingController(text: store.currentUserTitle);
    _phoneController = TextEditingController(text: store.currentUserPhone);
    _emailController = TextEditingController(text: store.currentUserEmail);

    // Parse DOB into Day, Month, Year
    String currentDob = UserProfileData.dob.isNotEmpty
        ? UserProfileData.dob
        : (store.birthDate.isNotEmpty ? store.birthDate : '01/01/1995');

    List<String> dobParts = [];
    if (currentDob.contains('/')) {
      dobParts = currentDob.split('/');
    } else if (currentDob.contains('-')) {
      final isoParts = currentDob.split('-');
      if (isoParts.length == 3) {
        // yyyy-mm-dd -> dd, mm, yyyy
        dobParts = [isoParts[2], isoParts[1], isoParts[0]];
      }
    }

    _dayController = TextEditingController(
      text: (dobParts.length > 0) ? dobParts[0] : '',
    );
    _monthController = TextEditingController(
      text: (dobParts.length > 1) ? dobParts[1] : '',
    );
    _yearController = TextEditingController(
      text: (dobParts.length > 2) ? dobParts[2] : '',
    );

    _locationController = TextEditingController(
      text: store.currentUserLocation,
    );
    _skillController = TextEditingController();
    _socialLinkController = TextEditingController();

    _selectedGender =
        (UserProfileData.gender == "أنثى" || UserProfileData.gender == "Female" || store.gender.toLowerCase().contains('female'))
        ? "Female"
        : "Male";

    _experiences = List<Map<String, String>>.from(store.currentUserExperience);
    _education = List<Map<String, String>>.from(store.currentUserEducation);
    _skills = List<String>.from(store.currentUserSkills);
    _socialLinks = List<Map<String, String>>.from(store.socialLinks);
    _portfolioPaths = List<String>.from(store.portfolioImages);
    _localBackgroundImage = store.backgroundImage;
    _localProfileImage = store.profileImage;
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
    _socialLinkController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _localProfileImage = image.path;
      });
    }
  }

  Future<void> _pickBackgroundImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _localBackgroundImage = image.path;
      });
    }
  }

  Future<void> _pickPortfolioImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _portfolioPaths.addAll(images.map((e) => e.path));
      });
    }
  }

  void _saveData() {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    String dob =
        "${_dayController.text}/${_monthController.text}/${_yearController.text}";
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
      portfolioImages: _portfolioPaths,
      backgroundImage: _localBackgroundImage,
      profileImage: _localProfileImage,
      birthDate: dob,
      gender: _selectedGender,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(
            color: onSurfaceColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            isAr ? Icons.arrow_back_ios_new : Icons.arrow_back_ios,
            color: onSurfaceColor,
          ),
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
                  _buildTabItem(
                    t.tr(en: "Profile Setting", ar: "إعدادات الملف"),
                    true,
                    () {},
                    isDark,
                    onSurfaceColor,
                  ),
                  const SizedBox(width: 20),
                  _buildTabItem(
                    t.tr(en: "Account Security", ar: "أمان الحساب"),
                    false,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ProfileLoginDetailsScreen(),
                        ),
                      );
                    },
                    isDark,
                    onSurfaceColor,
                  ),
                  const SizedBox(width: 20),
                  _buildTabItem(
                    t.tr(en: "Notification", ar: "الإشعارات"),
                    false,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Notifications(),
                        ),
                      );
                    },
                    isDark,
                    onSurfaceColor,
                  ),
                  const SizedBox(width: 20),
                  _buildTabItem(
                    t.tr(en: "Preferences", ar: "التفضيلات"),
                    false,
                    () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Preferences(),
                        ),
                      );
                    },
                    isDark,
                    onSurfaceColor,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 1,
            ),
            const SizedBox(height: 30),

            Text(
              t.tr(en: "Basic Information", ar: "معلومات أساسية"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              t.tr(
                en: "This is your personal information that you can update anytime.",
                ar: "هذه هي معلوماتك الشخصية التي يمكنك تحديثها في أي وقت.",
              ),
              style: TextStyle(
                color: onSurfaceColor.withValues(alpha: 0.54),
                fontSize: 13,
              ),
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            Text(
              t.tr(en: "Background Photo", ar: "صورة الخلفية"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickBackgroundImage,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark ? const Color(0xFF0D2D4D) : Colors.grey.withValues(alpha: 0.1),
                  image: _localBackgroundImage != null && getAppImageProvider(_localBackgroundImage) != null
                    ? DecorationImage(image: getAppImageProvider(_localBackgroundImage)!, fit: BoxFit.cover)
                    : null,
                ),
                alignment: Alignment.center,
                child: (_localBackgroundImage == null || getAppImageProvider(_localBackgroundImage) == null) 
                  ? Icon(Icons.add_photo_alternate_outlined, color: onSurfaceColor.withOpacity(0.5), size: 40) : null,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              t.tr(en: "Profile Photo", ar: "صورة الملف الشخصي"),
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    backgroundImage: getAppImageProvider(_localProfileImage),
                    child: (_localProfileImage == null || getAppImageProvider(_localProfileImage) == null)
                        ? Icon(
                            Icons.camera_alt,
                            color: onSurfaceColor.withValues(alpha: 0.3),
                          )
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: onSurfaceColor.withValues(alpha: 0.12),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.image_outlined,
                            color: onSurfaceColor.withValues(alpha: 0.38),
                            size: 30,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            t.tr(
                              en: "Click to replace or drag and drop",
                              ar: "انقر للاستبدال أو السحب والإفلات",
                            ),
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            _buildTextFieldWithLabel(
              context,
              _fullNameController,
              t.tr(en: "Full Name", ar: "الاسم بالكامل"),
              t.tr(en: "Enter Full Name", ar: "أدخل الاسم بالكامل"),
              onSurfaceColor,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _buildTextFieldWithLabel(
                    context,
                    _phoneController,
                    t.tr(en: "Phone Number", ar: "رقم الهاتف"),
                    t.tr(en: "Enter Phone Number", ar: "أدخل رقم الهاتف"),
                    onSurfaceColor,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildTextFieldWithLabel(
                    context,
                    _emailController,
                    t.tr(en: "Email", ar: "البريد الإلكتروني"),
                    t.tr(en: "Enter Email", ar: "أدخل البريد الإلكتروني"),
                    onSurfaceColor,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
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
                      Text(
                        t.dob,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: onSurfaceColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              context,
                              _dayController,
                              "DD",
                              onSurfaceColor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: _buildTextField(
                              context,
                              _monthController,
                              "MM",
                              onSurfaceColor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              context,
                              _yearController,
                              "YYYY",
                              onSurfaceColor,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(4),
                              ],
                            ),
                          ),
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
                      Text(
                        t.gender,
                        style: TextStyle(
                          color: onSurfaceColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                          border: Border.all(
                            color: onSurfaceColor.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            dropdownColor: isDark ? const Color(0xFF0D2D4D) : Colors.white,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(
                                value: "Male",
                                child: Text(t.male, style: TextStyle(color: onSurfaceColor)),
                              ),
                              DropdownMenuItem(
                                value: "Female",
                                child: Text(t.female, style: TextStyle(color: onSurfaceColor)),
                              ),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedGender = val);
                              }
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
            _buildTextFieldWithLabel(
              context,
              _locationController,
              t.address,
              t.tr(en: "Enter Address", ar: "أدخل العنوان"),
              onSurfaceColor,
              suffixIcon: Icons.location_on_outlined,
            ),

            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            Text(
              t.aboutMe,
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildTextField(
              context,
              _aboutMeController,
              t.tr(en: "Enter About Me", ar: "أدخل معلومات عنك"),
              onSurfaceColor,
              maxLines: 3,
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            _buildSectionHeader(t.workExperience, onSurfaceColor, () {
              _showAddItemDialog(
                title: t.tr(en: "Add Experience", ar: "إضافة خبرة"),
                fieldKeys: ["title", "company", "duration"],
                fieldLabels: [
                  t.tr(en: "Job Title", ar: "المسمى الوظيفي"),
                  t.tr(en: "Company", ar: "الشركة"),
                  t.tr(en: "Duration", ar: "المدة"),
                ],
                onSave: (data) => setState(() => _experiences.add(data)),
              );
            }),
            ..._experiences.map(
              (exp) => _buildRemovableItem(
                exp['title'] ?? "",
                exp['company'] ?? "",
                onSurfaceColor,
                () => setState(() => _experiences.remove(exp)),
              ),
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            _buildSectionHeader(t.education, onSurfaceColor, () {
              _showAddItemDialog(
                title: t.tr(en: "Add Education", ar: "إضافة تعليم"),
                fieldKeys: ["institution", "degree", "duration"],
                fieldLabels: [
                  t.tr(en: "Institution", ar: "المؤسسة التعليمية"),
                  t.tr(en: "Degree", ar: "الدرجة العلمية"),
                  t.tr(en: "Duration", ar: "المدة"),
                ],
                onSave: (data) => setState(() => _education.add(data)),
              );
            }),
            ..._education.map(
              (edu) => _buildRemovableItem(
                edu['institution'] ?? "",
                edu['degree'] ?? "",
                onSurfaceColor,
                () => setState(() => _education.remove(edu)),
              ),
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            Text(
              t.skills,
              style: TextStyle(
                color: onSurfaceColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .map(
                    (skill) => Chip(
                      label: Text(skill, style: TextStyle(fontSize: 12, color: onSurfaceColor)),
                      onDeleted: () => setState(() => _skills.remove(skill)),
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    context,
                    _skillController,
                    t.tr(en: "Add Skill", ar: "إضافة مهارة"),
                    onSurfaceColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  onPressed: () {
                    if (_skillController.text.isNotEmpty) {
                      setState(() {
                        _skills.add(_skillController.text);
                        _skillController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            _buildSectionHeader(t.socialMedia, onSurfaceColor, () {
              final url = _socialLinkController.text.trim();
              if (url.isEmpty) return;
              
              String platform = "Link";
              final low = url.toLowerCase();
              if (low.contains("facebook")) platform = isAr ? "فيسبوك" : "Facebook";
              else if (low.contains("instagram")) platform = isAr ? "إنستجرام" : "Instagram";
              else if (low.contains("whatsapp") || low.contains("wa.me")) platform = isAr ? "واتساب" : "WhatsApp";
              else if (low.contains("linkedin")) platform = "LinkedIn";
              else if (low.contains("twitter") || low.contains("x.com")) platform = "X / Twitter";
              else if (low.contains("github")) platform = "GitHub";

              setState(() {
                _socialLinks.add({'platform': platform, 'url': url});
                _socialLinkController.clear();
              });
            }),
            ..._socialLinks.map(
              (link) => _buildRemovableItem(
                link['platform'] ?? "",
                link['url'] ?? "",
                onSurfaceColor,
                () => setState(() => _socialLinks.remove(link)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    context,
                    _socialLinkController,
                    t.tr(en: "Add Link URL", ar: "إضافة رابط"),
                    onSurfaceColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
                  onPressed: () {
                    final url = _socialLinkController.text.trim();
                    if (url.isEmpty) return;
                    
                    String platform = "Link";
                    final low = url.toLowerCase();
                    if (low.contains("facebook")) platform = isAr ? "فيسبوك" : "Facebook";
                    else if (low.contains("instagram")) platform = isAr ? "إنستجرام" : "Instagram";
                    else if (low.contains("whatsapp") || low.contains("wa.me")) platform = isAr ? "واتساب" : "WhatsApp";
                    else if (low.contains("linkedin")) platform = "LinkedIn";
                    else if (low.contains("twitter") || low.contains("x.com")) platform = "X / Twitter";
                    else if (low.contains("github")) platform = "GitHub";

                    setState(() {
                      _socialLinks.add({'platform': platform, 'url': url});
                      _socialLinkController.clear();
                    });
                  },
                ),
              ],
            ),

            Divider(
              color: onSurfaceColor.withValues(alpha: 0.12),
              height: 40,
            ),

            _buildSectionHeader(t.tr(en: "Gallery", ar: "المعرض"), onSurfaceColor, _pickPortfolioImages),
            if (_portfolioPaths.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _portfolioPaths.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, i) {
                    final provider = getAppImageProvider(_portfolioPaths[i]);
                    if (provider == null) return const SizedBox.shrink();
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(image: provider, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                        ),
                        Positioned(
                          right: 0, top: 0,
                          child: GestureDetector(
                            onTap: () => setState(() => _portfolioPaths.removeAt(i)),
                            child: Container(color: Colors.black54, child: const Icon(Icons.close, color: Colors.white, size: 16)),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

            const SizedBox(height: 40),
            AppButton(
              label: t.tr(en: "Save Profile", ar: "حفظ الملف الشخصي"),
              onPressed: _saveData,
              backgroundColor: const Color(0xFF142C66),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive, VoidCallback onTap, bool isDark, Color onSurfaceColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : onSurfaceColor.withOpacity(0.5),
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              height: 2,
              width: 20,
              color: Theme.of(context).colorScheme.primary,
              margin: const EdgeInsets.only(top: 4),
            ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithLabel(
    BuildContext context,
    TextEditingController controller,
    String label,
    String hint,
    Color onSurfaceColor, {
    IconData? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: onSurfaceColor),
        ),
        const SizedBox(height: 8),
        _buildTextField(
          context,
          controller,
          hint,
          onSurfaceColor,
          suffixIcon: suffixIcon,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context,
    TextEditingController controller,
    String hint,
    Color onSurfaceColor, {
    IconData? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: onSurfaceColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: onSurfaceColor.withValues(alpha: 0.38),
        ),
        suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20, color: onSurfaceColor.withOpacity(0.5)) : null,
        filled: true,
        fillColor: isDark ? const Color(0xFF0D2D4D) : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: onSurfaceColor.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: onSurfaceColor.withValues(alpha: 0.1),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color, VoidCallback onAdd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent),
          onPressed: onAdd,
        ),
      ],
    );
  }

  Widget _buildRemovableItem(
    String title,
    String subtitle,
    Color color,
    VoidCallback onRemove,
  ) {
    return ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      subtitle: Text(subtitle, style: TextStyle(color: color.withOpacity(0.6))),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: onRemove,
      ),
    );
  }

  void _showAddItemDialog({
    required String title,
    required List<String> fieldKeys,
    required List<String> fieldLabels,
    required Function(Map<String, String>) onSave,
  }) {
    final controllers = fieldLabels
        .map((_) => TextEditingController())
        .toList();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            fieldLabels.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: controllers[index],
                decoration: InputDecoration(
                  labelText: fieldLabels[index],
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).tr(en: "Cancel", ar: "إلغاء"),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final data = <String, String>{};
              for (int i = 0; i < fieldKeys.length; i++) {
                data[fieldKeys[i]] = controllers[i].text;
              }
              onSave(data);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context).tr(en: "Save", ar: "حفظ")),
          ),
        ],
      ),
    );
  }
}
