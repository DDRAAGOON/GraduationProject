import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/shared/widgets/app_button.dart';
import 'package:image_picker/image_picker.dart';

class TradesmanEditProfileScreen extends StatefulWidget {
  const TradesmanEditProfileScreen({super.key});

  @override
  State<TradesmanEditProfileScreen> createState() =>
      _TradesmanEditProfileScreenState();
}

class _TradesmanEditProfileScreenState
    extends State<TradesmanEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _aboutController;
  late TextEditingController _skillController;
  late TextEditingController _languageController;
  late TextEditingController _customServiceController;
  late TextEditingController _facebookController;
  late TextEditingController _instagramController;
  late TextEditingController _whatsappController;

  DateTime? _birthDate;
  String _gender = 'Male';
  String? _governorate;
  String? _district;

  late List<Map<String, String>> _experiences;
  late List<Map<String, String>> _education;
  late List<String> _skills;
  late List<String> _languages;
  late List<String> _selectedServices;
  late List<String> _portfolioPaths;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    _fullNameController = TextEditingController(text: store.currentUserName);
    _phoneController = TextEditingController(text: store.currentUserPhone);
    _emailController = TextEditingController(text: store.currentUserEmail);
    _aboutController = TextEditingController(text: store.currentUserAbout);
    _skillController = TextEditingController();
    _languageController = TextEditingController();
    _customServiceController = TextEditingController();
    _facebookController = TextEditingController();
    _instagramController = TextEditingController();
    _whatsappController = TextEditingController();

    if (store.birthDate.isNotEmpty) {
      _birthDate = DateTime.tryParse(store.birthDate);
    }
    _gender = store.gender.contains('أنثى') || store.gender == 'Female'
        ? 'Female'
        : 'Male';
    _governorate = store.governorate.isEmpty ? null : store.governorate;
    _district = store.district.isEmpty ? null : store.district;

    _experiences = List.from(store.currentUserExperience);
    _education = List.from(store.currentUserEducation);
    _skills = List.from(store.currentUserSkills);
    _languages = List.from(store.languages);
    _selectedServices = List.from(store.tradesmanServices);
    _portfolioPaths = List.from(store.portfolioImages);

    for (final link in store.socialLinks) {
      final platform = (link['platform'] ?? '').toLowerCase();
      final url = link['url'] ?? '';
      if (platform.contains('facebook') || platform.contains('فيس')) {
        _facebookController.text = url;
      } else if (platform.contains('insta') || platform.contains('انست')) {
        _instagramController.text = url;
      } else if (platform.contains('whats') || platform.contains('واتس')) {
        _whatsappController.text = url;
      }
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _aboutController.dispose();
    _skillController.dispose();
    _languageController.dispose();
    _customServiceController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _whatsappController.dispose();
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
      // تحديث محلي فوري ليظهر للمستخدم
      store.updateCurrentUser(photoUrl: image.path);

      try {
        // الرفع للسيرفر في الخلفية
        await RecruitmentSyncService.instance.updateProfile(
          photoUrl: image.path,
        );
      } catch (e) {
        debugPrint("فشل رفع الصورة للسيرفر: $e");
      }
    }
    setState(() {});
  }

  Future<void> _pickPortfolioImages() async {
    final images = await _picker.pickMultiImage();
    if (images.isEmpty) return;
    setState(() {
      _portfolioPaths.addAll(images.map((e) => e.path));
    });
  }

  Future<void> _pickBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _save() {
    final t = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.tr(en: 'Birth date is required', ar: 'تاريخ الميلاد مطلوب'),
          ),
        ),
      );
      return;
    }
    if (_governorate == null || _district == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            t.tr(
              en: 'Governorate and area are required',
              ar: 'المحافظة والمنطقة مطلوبان',
            ),
          ),
        ),
      );
      return;
    }

    final store = RecruitmentSyncStore.instance;
    final isAr = t.isAr;
    final locationParts = [
      if (_governorate != null) _governorate!,
      if (_district != null) _district!,
    ];
    final socialLinks = <Map<String, String>>[];
    if (_facebookController.text.trim().isNotEmpty) {
      socialLinks.add({
        'platform': isAr ? 'فيسبوك' : 'Facebook',
        'url': _facebookController.text.trim(),
      });
    }
    if (_instagramController.text.trim().isNotEmpty) {
      socialLinks.add({
        'platform': isAr ? 'إنستجرام' : 'Instagram',
        'url': _instagramController.text.trim(),
      });
    }
    if (_whatsappController.text.trim().isNotEmpty) {
      socialLinks.add({
        'platform': isAr ? 'واتساب' : 'WhatsApp',
        'url': _whatsappController.text.trim(),
      });
    }

    store.updateUserProfile(
      fullName: _fullNameController.text.trim(),
      title: store.currentUserTitle,
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      location: locationParts.join(' - '),
      about: _aboutController.text.trim(),
      skills: _skills,
      education: _education,
      experience: _experiences,
      socialLinks: socialLinks,
      role: 'Tradesman',
      portfolioImages: _portfolioPaths,
      birthDate: _birthDate?.toIso8601String().split('T').first ?? '',
      gender: _gender == 'Female'
          ? (isAr ? 'أنثى' : 'Female')
          : (isAr ? 'ذكر' : 'Male'),
      governorate: _governorate ?? '',
      district: _district ?? '',
      languages: _languages,
      tradesmanServices: _selectedServices,
      profileImage: store.profileImage, // نمرر الصورة الحالية لضمان عدم ضياعها
    );

    RecruitmentSyncService.instance.updateProfile(
      name: _fullNameController.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(t.tr(en: 'Saved successfully', ar: 'تم الحفظ بنجاح')),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
  }

  void _showAddDialog({
    required String title,
    required List<String> keys,
    required List<String> labels,
    required void Function(Map<String, String>) onSave,
  }) {
    final controllers = List.generate(
      labels.length,
      (_) => TextEditingController(),
    );
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(labels.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: controllers[i],
                decoration: InputDecoration(
                  labelText: labels[i],
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              final data = <String, String>{};
              for (var i = 0; i < keys.length; i++) {
                data[keys[i]] = controllers[i].text.trim();
              }
              onSave(data);
              Navigator.pop(ctx);
            },
            child: Text(AppLocalizations.of(context).tr(en: 'Save', ar: 'حفظ')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final store = RecruitmentSyncStore.instance;

    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor = isDark
            ? const Color(0xFF001E3A)
            : const Color(0xFFF8FBF4);
        final onSurfaceColor = isDark ? Colors.white : Colors.black;
        final areas = _governorate == null
            ? <String>[]
            : RecruitmentSyncStore.tradesmanGovernorateAreas[_governorate] ??
                  [];

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            title: Text(
              t.tr(en: 'Edit Profile', ar: 'تعديل الملف الشخصي'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: onSurfaceColor,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle(
                    t.tr(en: 'Personal information', ar: 'المعلومات الشخصية'),
                    onSurfaceColor,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image:
                            getAppImageProvider(store.backgroundImage) != null
                            ? DecorationImage(
                                image: getAppImageProvider(
                                  store.backgroundImage,
                                )!,
                                fit: BoxFit.cover,
                              )
                            : null,
                        gradient: store.backgroundImage == null
                            ? const LinearGradient(
                                colors: [Color(0xFF011931), Color(0xFF49769F)],
                              )
                            : null,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        t.tr(
                          en: 'Change cover photo',
                          ar: 'تغيير صورة الخلفية',
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => _pickImage(false),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: getAppImageProvider(
                          store.profileImage,
                        ),
                        child:
                            (store.profileImage == null ||
                                getAppImageProvider(store.profileImage) == null)
                            ? const Icon(Icons.camera_alt, size: 36)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _field(
                    context,
                    _fullNameController,
                    t.tr(en: 'Full name', ar: 'الاسم الكامل'),
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    context,
                    _phoneController,
                    t.tr(en: 'Phone number', ar: 'رقم الهاتف'),
                    keyboard: TextInputType.phone,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _field(
                    context,
                    _emailController,
                    t.tr(en: 'Email', ar: 'البريد الإلكتروني'),
                    keyboard: TextInputType.emailAddress,
                    required: true,
                  ),
                  const SizedBox(height: 12),
                  _label(t.dob, onSurfaceColor),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: _pickBirthDate,
                    child: InputDecorator(
                      decoration: _inputDecoration(context),
                      child: Text(
                        _birthDate == null
                            ? t.tr(en: 'Select date', ar: 'اختر التاريخ')
                            : '${_birthDate!.year}-${_birthDate!.month.toString().padLeft(2, '0')}-${_birthDate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(color: onSurfaceColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _label(t.gender, onSurfaceColor),
                  DropdownButtonFormField<String>(
                    value: _gender,
                    decoration: _inputDecoration(context),
                    dropdownColor: isDark
                        ? const Color(0xFF0D2D4D)
                        : Colors.white,
                    items: [
                      DropdownMenuItem(
                        value: 'Male',
                        child: Text(
                          t.male,
                          style: TextStyle(color: onSurfaceColor),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Female',
                        child: Text(
                          t.female,
                          style: TextStyle(color: onSurfaceColor),
                        ),
                      ),
                    ],
                    onChanged: (v) => setState(() => _gender = v ?? 'Male'),
                  ),
                  const SizedBox(height: 12),
                  _label(
                    t.tr(en: 'Governorate', ar: 'المحافظة'),
                    onSurfaceColor,
                  ),
                  DropdownButtonFormField<String>(
                    value: _governorate,
                    decoration: _inputDecoration(context),
                    dropdownColor: isDark
                        ? const Color(0xFF0D2D4D)
                        : Colors.white,
                    hint: Text(
                      t.tr(en: 'Select governorate', ar: 'اختر المحافظة'),
                      style: TextStyle(color: onSurfaceColor.withOpacity(0.5)),
                    ),
                    items: RecruitmentSyncStore.tradesmanGovernorateAreas.keys
                        .map(
                          (g) => DropdownMenuItem(
                            value: g,
                            child: Text(
                              g,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() {
                      _governorate = v;
                      _district = null;
                    }),
                  ),
                  const SizedBox(height: 12),
                  _label(t.tr(en: 'Area', ar: 'المنطقة'), onSurfaceColor),
                  DropdownButtonFormField<String>(
                    value: _district,
                    decoration: _inputDecoration(context),
                    dropdownColor: isDark
                        ? const Color(0xFF0D2D4D)
                        : Colors.white,
                    hint: Text(
                      t.tr(en: 'Select area', ar: 'اختر المنطقة'),
                      style: TextStyle(color: onSurfaceColor.withOpacity(0.5)),
                    ),
                    items: areas
                        .map(
                          (a) => DropdownMenuItem(
                            value: a,
                            child: Text(
                              a,
                              style: TextStyle(color: onSurfaceColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _district = v),
                  ),
                  const SizedBox(height: 24),
                  _sectionTitle(t.aboutMe, onSurfaceColor),
                  _hint(
                    t.tr(
                      en: 'Briefly describe your skills and experience',
                      ar: 'صف مهاراتك وخبراتك باختصار',
                    ),
                    onSurfaceColor,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _aboutController,
                    maxLines: 4,
                    style: TextStyle(color: onSurfaceColor),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? t.tr(en: 'Required', ar: 'مطلوب')
                        : null,
                    decoration: _inputDecoration(
                      context,
                      hint: t.tr(en: 'About me', ar: 'نبذة عني'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _sectionWithAdd(
                    t.tr(en: 'Experience', ar: 'الخبرات'),
                    t.tr(
                      en: 'Add your work experience briefly',
                      ar: 'أضف خبراتك العملية باختصار',
                    ),
                    onSurfaceColor,
                    () => _showAddDialog(
                      title: t.tr(en: 'Add experience', ar: 'إضافة خبرة'),
                      keys: const ['title', 'company', 'duration'],
                      labels: [
                        t.tr(en: 'Job title', ar: 'المسمى'),
                        t.tr(en: 'Company', ar: 'الشركة'),
                        t.tr(en: 'Duration', ar: 'المدة'),
                      ],
                      onSave: (d) => setState(() => _experiences.add(d)),
                    ),
                  ),
                  ..._experiences.map(
                    (e) => _removableTile(
                      e['title'] ?? '',
                      e['company'] ?? '',
                      onSurfaceColor,
                      () => setState(() => _experiences.remove(e)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionWithAdd(
                    t.skills,
                    t.tr(en: 'Add your skills', ar: 'أضف مهاراتك'),
                    onSurfaceColor,
                    () {
                      if (_skillController.text.trim().isEmpty) return;
                      setState(() {
                        _skills.add(_skillController.text.trim());
                        _skillController.clear();
                      });
                    },
                    addInline: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _skillController,
                          style: TextStyle(color: onSurfaceColor),
                          decoration: _inputDecoration(
                            context,
                            hint: t.tr(en: 'Skill', ar: 'مهارة'),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          if (_skillController.text.trim().isEmpty) return;
                          setState(() {
                            _skills.add(_skillController.text.trim());
                            _skillController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: _skills
                        .map(
                          (s) => Chip(
                            label: Text(s),
                            onDeleted: () => setState(() => _skills.remove(s)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  _sectionWithAdd(
                    t.education,
                    t.tr(en: 'Add your education', ar: 'أضف تعليمك'),
                    onSurfaceColor,
                    () => _showAddDialog(
                      title: t.tr(en: 'Add education', ar: 'إضافة تعليم'),
                      keys: const ['institution', 'degree', 'duration'],
                      labels: [
                        t.tr(en: 'Institution', ar: 'المؤسسة'),
                        t.tr(en: 'Degree', ar: 'الدرجة'),
                        t.tr(en: 'Duration', ar: 'المدة'),
                      ],
                      onSave: (d) => setState(() => _education.add(d)),
                    ),
                  ),
                  ..._education.map(
                    (e) => _removableTile(
                      e['institution'] ?? '',
                      e['degree'] ?? '',
                      onSurfaceColor,
                      () => setState(() => _education.remove(e)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _sectionWithAdd(
                    t.tr(en: 'Languages', ar: 'اللغات'),
                    t.tr(
                      en: 'Add languages you speak',
                      ar: 'أضف اللغات التي تتحدثها',
                    ),
                    onSurfaceColor,
                    () {
                      if (_languageController.text.trim().isEmpty) return;
                      setState(() {
                        _languages.add(_languageController.text.trim());
                        _languageController.clear();
                      });
                    },
                    addInline: true,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _languageController,
                          style: TextStyle(color: onSurfaceColor),
                          decoration: _inputDecoration(
                            context,
                            hint: t.tr(en: 'Language', ar: 'لغة'),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          if (_languageController.text.trim().isEmpty) return;
                          setState(() {
                            _languages.add(_languageController.text.trim());
                            _languageController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: _languages
                        .map(
                          (l) => Chip(
                            label: Text(l),
                            onDeleted: () =>
                                setState(() => _languages.remove(l)),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle(
                    t.tr(en: 'Social links', ar: 'روابط التواصل'),
                    onSurfaceColor,
                  ),
                  _field(
                    context,
                    _facebookController,
                    isAr ? 'فيسبوك' : 'Facebook',
                  ),
                  const SizedBox(height: 10),
                  _field(
                    context,
                    _instagramController,
                    isAr ? 'إنستجرام' : 'Instagram',
                  ),
                  const SizedBox(height: 10),
                  _field(
                    context,
                    _whatsappController,
                    isAr ? 'واتساب' : 'WhatsApp',
                  ),
                  const SizedBox(height: 16),
                  _sectionTitle(
                    t.tr(en: 'Services', ar: 'الخدمات'),
                    onSurfaceColor,
                  ),
                  _hint(
                    t.tr(en: 'Select your profession', ar: 'اختر مهنتك'),
                    onSurfaceColor,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: RecruitmentSyncStore.tradesmanDefaultServices.map(
                      (service) {
                        final selected = _selectedServices.contains(service);
                        return FilterChip(
                          label: Text(service),
                          selected: selected,
                          onSelected: (v) {
                            setState(() {
                              if (v) {
                                _selectedServices.add(service);
                              } else {
                                _selectedServices.remove(service);
                              }
                            });
                          },
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _customServiceController,
                          style: TextStyle(color: onSurfaceColor),
                          decoration: _inputDecoration(
                            context,
                            hint: t.tr(en: 'Other profession', ar: 'مهنة أخرى'),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          final custom = _customServiceController.text.trim();
                          if (custom.isEmpty) return;
                          setState(() {
                            _selectedServices.add(custom);
                            _customServiceController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _sectionWithAdd(
                    t.tr(en: 'Portfolio', ar: 'المعرض'),
                    t.tr(
                      en: 'Add or remove your work photos',
                      ar: 'أضف أو احذف صور أعمالك',
                    ),
                    onSurfaceColor,
                    _pickPortfolioImages,
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _portfolioPaths.asMap().entries.map((entry) {
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              File(entry.value),
                              width: 88,
                              height: 88,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -4,
                            right: -4,
                            child: GestureDetector(
                              onTap: () => setState(
                                () => _portfolioPaths.removeAt(entry.key),
                              ),
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.redAccent,
                                child: Icon(
                                  Icons.close,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    label: t.tr(en: 'Save profile', ar: 'حفظ الملف الشخصي'),
                    onPressed: _save,
                    backgroundColor: const Color(0xFF142C66),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String text, Color color) => Text(
    text,
    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
  );

  Widget _hint(String text, Color color) => Text(
    text,
    style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.45)),
  );

  Widget _label(String text, Color color) => Text(
    text,
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color),
  );

  InputDecoration _inputDecoration(BuildContext context, {String? hint}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: isDark ? const Color(0xFF0D2D4D) : Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.black12),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool required = false,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
      validator: required
          ? (v) => (v == null || v.trim().isEmpty)
                ? AppLocalizations.of(context).tr(en: 'Required', ar: 'مطلوب')
                : null
          : null,
      decoration: _inputDecoration(context, hint: label),
    );
  }

  Widget _sectionWithAdd(
    String title,
    String subtitle,
    Color color,
    VoidCallback onAdd, {
    bool addInline = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _sectionTitle(title, color)),
            if (!addInline)
              IconButton(
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.blueAccent,
                ),
                onPressed: onAdd,
              ),
          ],
        ),
        _hint(subtitle, color),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _removableTile(
    String title,
    String subtitle,
    Color color,
    VoidCallback onRemove,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: color),
      ),
      subtitle: Text(subtitle, style: TextStyle(color: color.withOpacity(0.6))),
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
        onPressed: onRemove,
      ),
    );
  }
}
