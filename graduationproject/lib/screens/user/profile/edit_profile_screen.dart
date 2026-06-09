import 'dart:io';
import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _fullNameController;
  late TextEditingController _titleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;
  late TextEditingController _skillController;
  late TextEditingController _languageController;
  late TextEditingController _customServiceController;
  late TextEditingController _socialLinkController;
  late TextEditingController _socialUrlController;
  late TextEditingController _expTitleController;
  late TextEditingController _expCompanyController;
  late TextEditingController _eduInstController;
  late TextEditingController _eduDegreeController;

  DateTime? _birthDate;
  String _gender = 'Male';
  String? _governorate;

  late List<Map<String, String>> _experiences;
  late List<Map<String, String>> _education;
  late List<String> _skills;
  late List<String> _languages;
  late List<String> _selectedServices;
  late List<String> _portfolioPaths;
  late List<Map<String, String>> _socialLinks;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    _fullNameController = TextEditingController(text: store.currentUserName);
    _titleController = TextEditingController(text: store.currentUserTitle);
    _phoneController = TextEditingController(text: store.currentUserPhone);
    _emailController = TextEditingController(text: store.currentUserEmail);
    _aboutController = TextEditingController(text: store.currentUserAbout);
    _skillController = TextEditingController();
    _languageController = TextEditingController();
    _customServiceController = TextEditingController();
    _socialLinkController = TextEditingController();
    _socialUrlController = TextEditingController();
    _expTitleController = TextEditingController();
    _expCompanyController = TextEditingController();
    _eduInstController = TextEditingController();
    _eduDegreeController = TextEditingController();

    if (store.birthDate.isNotEmpty) {
      _birthDate = DateTime.tryParse(store.birthDate);
    }
    _gender = store.gender.contains('أنثى') || store.gender == 'Female' ? 'Female' : 'Male';
    _governorate = (store.governorate.isEmpty || store.governorate == 'All') ? null : store.governorate;

    _experiences = List<Map<String, String>>.from(store.currentUserExperience);
    _education = List<Map<String, String>>.from(store.currentUserEducation);
    _skills = List<String>.from(store.currentUserSkills);
    _languages = List<String>.from(store.languages);
    _selectedServices = List<String>.from(store.tradesmanServices);
    _portfolioPaths = List<String>.from(store.portfolioImages);
    _socialLinks = List<Map<String, String>>.from(store.socialLinks);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _titleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _skillController.dispose();
    _languageController.dispose();
    _customServiceController.dispose();
    _socialLinkController.dispose();
    _socialUrlController.dispose();
    _expTitleController.dispose();
    _expCompanyController.dispose();
    _eduInstController.dispose();
    _eduDegreeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBackground) async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final store = RecruitmentSyncStore.instance;
    if (isBackground) {
      store.updateUserProfile(
        fullName: store.currentUserName,
        title: store.currentUserTitle,
        backgroundImage: image.path,
      );
    } else {
      store.updateCurrentUser(photoUrl: image.path);
      try { await RecruitmentSyncService.instance.updateProfile(photoUrl: image.path); } catch (_) {}
    }
    setState(() {});
  }

  Future<void> _pickPortfolioImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isNotEmpty) setState(() => _portfolioPaths.addAll(images.map((e) => e.path)));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final store = RecruitmentSyncStore.instance;
    final t = AppLocalizations.of(context);
    
    store.updateUserProfile(
      fullName: _fullNameController.text.trim(),
      title: _titleController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: _governorate ?? store.currentUserLocation,
      about: _aboutController.text.trim(),
      skills: _skills,
      education: _education,
      experience: _experiences,
      socialLinks: _socialLinks,
      portfolioImages: _portfolioPaths,
      birthDate: _birthDate?.toIso8601String().split('T').first ?? '',
      gender: _gender == 'Female' ? (t.isAr ? 'أنثى' : 'Female') : (t.isAr ? 'ذكر' : 'Male'),
      governorate: _governorate ?? '',
      languages: _languages,
      tradesmanServices: _selectedServices,
      role: store.userRole,
    );

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.isAr ? 'تم الحفظ بنجاح' : 'Saved successfully'), backgroundColor: Colors.green));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final store = RecruitmentSyncStore.instance;
    final bool isTradesman = store.userRole.toLowerCase().contains('tradesman');
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.editProfile, style: TextStyle(fontWeight: FontWeight.bold, color: onSurfaceColor)),
        backgroundColor: Colors.transparent, elevation: 0,
        leading: IconButton(icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: onSurfaceColor), onPressed: () => Navigator.pop(context)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Personal Info Section
              _sectionTitle(t.personalInfo, onSurfaceColor),
              const SizedBox(height: 12),
              _buildImagePickers(store, t),
              const SizedBox(height: 20),
              _field(_fullNameController, t.fullName, required: true),
              const SizedBox(height: 12),
              _field(_titleController, t.tr(en: 'Job Title', ar: 'المسمى الوظيفي')),
              const SizedBox(height: 12),
              _field(_phoneController, t.phoneNumber, keyboard: TextInputType.phone, required: true),
              const SizedBox(height: 12),
              _field(_emailController, t.emailAddress, keyboard: TextInputType.emailAddress, required: true),
              const SizedBox(height: 12),
              _buildBirthAndGender(t),
              const SizedBox(height: 12),
              _buildGovernorateDropdown(t),
              const SizedBox(height: 24),

              // 2. Universal Sections
              _sectionTitle(isAr ? 'الخبرات' : 'Experience', onSurfaceColor),
              _buildDualInput(_expTitleController, _expCompanyController, 
                t.tr(en: 'Title', ar: 'المسمى'), t.tr(en: 'Company', ar: 'الشركة'), 
                () {
                  if (_expTitleController.text.isNotEmpty) {
                    setState(() => _experiences.add({'title': _expTitleController.text.trim(), 'company': _expCompanyController.text.trim()}));
                    _expTitleController.clear(); _expCompanyController.clear();
                  }
                }),
              ..._experiences.map((e) => _removableTile(e['title'] ?? '', e['company'] ?? '', () => setState(() => _experiences.remove(e)))),
              
              const SizedBox(height: 16),
              _sectionTitle(t.education, onSurfaceColor),
              _buildDualInput(_eduInstController, _eduDegreeController, 
                t.tr(en: 'Institution', ar: 'المؤسسة'), t.tr(en: 'Degree', ar: 'الدرجة'), 
                () {
                  if (_eduInstController.text.isNotEmpty) {
                    setState(() => _education.add({'institution': _eduInstController.text.trim(), 'degree': _eduDegreeController.text.trim()}));
                    _eduInstController.clear(); _eduDegreeController.clear();
                  }
                }),
              ..._education.map((e) => _removableTile(e['institution'] ?? '', e['degree'] ?? '', () => setState(() => _education.remove(e)))),

              const SizedBox(height: 16),
              _sectionTitle(t.skills, onSurfaceColor),
              _buildListInput(_skillController, t.tr(en: 'Add Skill', ar: 'أضف مهارة'), _skills),
              _buildChips(_skills),

              const SizedBox(height: 16),
              _sectionTitle(isAr ? 'اللغات' : 'Languages', onSurfaceColor),
              _buildListInput(_languageController, t.tr(en: 'Add Language', ar: 'أضف لغة'), _languages),
              _buildChips(_languages),

              const SizedBox(height: 16),
              _sectionTitle(t.socialLinks, onSurfaceColor),
              _buildDualInput(_socialLinkController, _socialUrlController, 
                t.tr(en: 'Platform', ar: 'المنصة'), 'URL', 
                () {
                  if (_socialLinkController.text.isNotEmpty && _socialUrlController.text.isNotEmpty) {
                    setState(() => _socialLinks.add({'platform': _socialLinkController.text.trim(), 'url': _socialUrlController.text.trim()}));
                    _socialLinkController.clear(); _socialUrlController.clear();
                  }
                }),
              ..._socialLinks.map((s) => _removableTile(s['platform'] ?? '', s['url'] ?? '', () => setState(() => _socialLinks.remove(s)))),

              // 3. 🛠️ TRADESMAN ONLY SERVICES
              if (isTradesman) ...[
                const SizedBox(height: 24),
                _sectionTitle(isAr ? 'الخدمات المهنية' : 'Professional Services', onSurfaceColor),
                _buildServicesGrid(store),
              ],

              const SizedBox(height: 24),
              _sectionTitle(isAr ? 'معرض الأعمال' : 'Portfolio', onSurfaceColor),
              _buildPortfolioGallery(t),

              const SizedBox(height: 40),
              AppButton(label: t.save, onPressed: _save, backgroundColor: const Color(0xFF142C66)),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildImagePickers(RecruitmentSyncStore store, AppLocalizations t) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(true),
          child: Container(
            height: 100, width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: getAppImageProvider(store.backgroundImage) != null ? DecorationImage(image: getAppImageProvider(store.backgroundImage)!, fit: BoxFit.cover) : null,
              gradient: store.backgroundImage == null ? const LinearGradient(colors: [Color(0xFF011931), Color(0xFF49769F)]) : null,
            ),
            alignment: Alignment.center,
            child: Text(t.tr(en: 'Change Cover', ar: 'تغيير الغلاف'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () => _pickImage(false),
          child: CircleAvatar(
            radius: 40,
            backgroundImage: getAppImageProvider(store.profileImage),
            child: (store.profileImage == null) ? const Icon(Icons.camera_alt) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildBirthAndGender(AppLocalizations t) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _birthDate ?? DateTime(2000),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (date != null) setState(() => _birthDate = date);
            },
            child: InputDecorator(
              decoration: InputDecoration(labelText: t.dob, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true),
              child: Text(_birthDate == null ? t.tr(en: 'Select Date', ar: 'اختر التاريخ') : _birthDate!.toIso8601String().split('T').first),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _gender,
            decoration: InputDecoration(labelText: t.gender, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true),
            items: [
              DropdownMenuItem(value: 'Male', child: Text(t.male)),
              DropdownMenuItem(value: 'Female', child: Text(t.female)),
            ],
            onChanged: (v) => setState(() => _gender = v!),
          ),
        ),
      ],
    );
  }

  Widget _buildGovernorateDropdown(AppLocalizations t) {
    final govList = RecruitmentSyncStore.egyptGovernorates.where((g) => g != 'All').toList();
    
    // Safety check to prevent red screen if _governorate is not in the list
    String? selectedGov;
    if (_governorate != null && govList.contains(_governorate)) {
      selectedGov = _governorate;
    }

    return DropdownButtonFormField<String>(
      value: selectedGov,
      hint: Text(t.tr(en: 'Select Governorate', ar: 'اختر المحافظة')),
      decoration: InputDecoration(
        labelText: t.tr(en: 'Governorate', ar: 'المحافظة'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        isDense: true,
      ),
      items: govList.map((g) => DropdownMenuItem(
        value: g,
        child: Text(t.translateLocation(g)),
      )).toList(),
      onChanged: (v) => setState(() => _governorate = v),
    );
  }

  Widget _buildServicesGrid(RecruitmentSyncStore store) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8, runSpacing: 8,
          children: RecruitmentSyncStore.tradesmanDefaultServices.map((service) {
            final selected = _selectedServices.contains(service);
            return FilterChip(
              label: Text(service, style: const TextStyle(fontSize: 12)),
              selected: selected,
              onSelected: (v) => setState(() => v ? _selectedServices.add(service) : _selectedServices.remove(service)),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customServiceController,
                decoration: InputDecoration(
                  hintText: t.tr(en: 'Other profession', ar: 'مهنة أخرى'),
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Colors.blueAccent),
              onPressed: () {
                if (_customServiceController.text.isNotEmpty) {
                  setState(() => _selectedServices.add(_customServiceController.text.trim()));
                  _customServiceController.clear();
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPortfolioGallery(AppLocalizations t) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(onPressed: _pickPortfolioImages, icon: const Icon(Icons.add_a_photo_outlined, color: Colors.blueAccent)),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _portfolioPaths.asMap().entries.map((entry) {
            final provider = getAppImageProvider(entry.value);
            return Stack(
              children: [
                if (provider != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image(image: provider, width: 70, height: 70, fit: BoxFit.cover),
                  )
                else
                  Container(width: 70, height: 70, color: Colors.grey, child: const Icon(Icons.broken_image)),
                Positioned(top: 0, right: 0, child: GestureDetector(onTap: () => setState(() => _portfolioPaths.removeAt(entry.key)), child: const CircleAvatar(radius: 10, backgroundColor: Colors.red, child: Icon(Icons.close, size: 12, color: Colors.white)))),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildListInput(TextEditingController controller, String hint, List<String> list) {
    return Row(
      children: [
        Expanded(child: TextField(controller: controller, decoration: InputDecoration(hintText: hint, isDense: true))),
        IconButton(icon: const Icon(Icons.add_circle, color: Colors.blueAccent), onPressed: () {
          if (controller.text.isNotEmpty) {
            setState(() => list.add(controller.text.trim()));
            controller.clear();
          }
        }),
      ],
    );
  }

  Widget _buildDualInput(TextEditingController c1, TextEditingController c2, String h1, String h2, VoidCallback onAdd) {
    return Row(
      children: [
        Expanded(child: TextField(controller: c1, decoration: InputDecoration(hintText: h1, isDense: true))),
        const SizedBox(width: 8),
        Expanded(child: TextField(controller: c2, decoration: InputDecoration(hintText: h2, isDense: true))),
        IconButton(icon: const Icon(Icons.add_circle, color: Colors.blueAccent), onPressed: onAdd),
      ],
    );
  }

  Widget _buildChips(List<String> items) {
    return Wrap(
      spacing: 8,
      children: items.map((item) => Chip(
        label: Text(item, style: const TextStyle(fontSize: 12)),
        onDeleted: () => setState(() => items.remove(item)),
        deleteIcon: const Icon(Icons.close, size: 14),
      )).toList(),
    );
  }

  Widget _sectionTitle(String text, Color color) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
  );

  Widget _field(TextEditingController controller, String label, {bool required = false, TextInputType? keyboard}) {
    return TextFormField(
      controller: controller, keyboardType: keyboard,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), isDense: true),
      validator: required ? (v) => (v == null || v.isEmpty) ? 'Required' : null : null,
    );
  }

  Widget _sectionWithAdd(String title, VoidCallback onAdd) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      IconButton(icon: const Icon(Icons.add_circle_outline, color: Colors.blueAccent), onPressed: onAdd),
    ]);
  }

  Widget _removableTile(String title, String subtitle, VoidCallback onRemove) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: onRemove),
      contentPadding: EdgeInsets.zero,
    );
  }
}
