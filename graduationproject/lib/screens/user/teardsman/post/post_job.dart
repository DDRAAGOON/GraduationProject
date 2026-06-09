import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import '../../../../shared/services/recruitment_sync_service.dart';
import 'job_applicants_screen.dart';

class PostJob extends StatefulWidget {
  const PostJob({super.key});

  @override
  State<PostJob> createState() => _PostJobState();
}

class _PostJobState extends State<PostJob> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController(
    text: "1",
  );

  final List<String> _days = [
    "Saturday",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];
  final Set<String> _selectedDays = {};
  final List<String> _skills = [];
  final List<String> _governorates = [
    'القاهرة',
    'الجيزة',
    'الإسكندرية',
    'الدقهلية',
    'البحر الأحمر',
    'البحيرة',
    'الفيوم',
    'الغربية',
    'الإسماعيلية',
    'المنوفية',
    'المنيا',
    'القليوبية',
    'الوادي الجديد',
    'الشرقية',
    'السويس',
    'أسوان',
    'أسيوط',
    'بني سويف',
    'بورسعيد',
    'دمياط',
    'جنوب سيناء',
    'كفر الشيخ',
    'مطروح',
    'الأقصر',
    'قنا',
    'سوهاج',
    'شمال سيناء',
  ];
  String? _selectedGovernorate;

  bool _isWorkTimeExpanded = false;

  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _skillController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images.map((image) => File(image.path)));
      });
    }
  }

  Future<void> _validateAndPost(AppLocalizations t) async {
    if (_formKey.currentState!.validate()) {
      if (_skills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.tr(
                en: "Please add at least one required skill",
                ar: "يرجى إضافة مهارة واحدة على الأقل",
              ),
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      final store = RecruitmentSyncStore.instance;
      final selectedLocation =
          _selectedGovernorate ?? store.currentUserLocation;
      final int capacity = int.tryParse(_capacityController.text) ?? 1;

      try {
        final String jobId = await RecruitmentSyncService.instance.postJob(
          title: _titleController.text,
          companyName: store.currentUserName,
          location: selectedLocation,
          salaryRange:
              "Negotiable", // Default to Negotiable since price is removed
          type: 'one-time',
          category: 'Service',
          tags: _skills,
          description: _descriptionController.text,
          responsibilities: [],
          qualifications: [],
          niceToHaves: [],
          benefits: [],
          requiredCount: capacity,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              t.tr(en: "Work posted successfully!", ar: "تم نشر العمل بنجاح!"),
            ),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to applicants screen with the real ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobApplicantsScreen(
              jobId: jobId,
              jobTitle: _titleController.text,
              initialDesc: _descriptionController.text,
              initialBudget: "Negotiable",
              initialDays: _selectedDays.toList(),
            ),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(t.isAr ? 'فشل نشر العمل' : 'Failed to post work'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t.tr(en: "Publish work", ar: "نشر العمل"),
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Basic Information Header
              _buildSectionHeader(
                t.tr(en: "Basic Information", ar: "المعلومات الأساسية"),
                t.tr(
                  en: "This information will be displayed publicly",
                  ar: "هذه المعلومات ستظهر للعامة",
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Work Title
              _buildSideTitleSection(
                isVertical: true,
                title: t.tr(en: "Work title", ar: "عنوان العمل"),
                subtitle: t.tr(
                  en: "Write a short, clear title for the task",
                  ar: "اكتب عنوانًا قصيرًا وواضحًا للمهمة المطلوبة",
                ),
                child: _buildTextField(
                  controller: _titleController,
                  hint: "مثال: نجار ماهر",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t.tr(
                        en: "Work title is required",
                        ar: "عنوان العمل مطلوب",
                      );
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Description
              _buildSideTitleSection(
                isVertical: true,
                title: t.tr(en: "Work description", ar: "وصف العمل"),
                subtitle: t.tr(
                  en: "Explain tasks and requirements in detail",
                  ar: "اشرح المهام والمتطلبات بالتفصيل",
                ),
                child: _buildTextField(
                  controller: _descriptionController,
                  hint: "اكتب تفاصيل العمل و المتطلبات",
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t.tr(
                        en: "Work description is required",
                        ar: "وصف العمل مطلوب",
                      );
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Number of Services (Capacity)
              _buildSideTitleSection(
                isVertical: true,
                title: t.tr(en: "Number of services", ar: "عدد الخدمات"),
                subtitle: t.tr(
                  en: "How many clients can you accept for this work?",
                  ar: "كم عدد العملاء الذين يمكنك قبولهم لهذا العمل؟",
                ),
                child: _buildTextField(
                  controller: _capacityController,
                  hint: "1",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return t.tr(en: "Required", ar: "مطلوب");
                    }
                    if (int.tryParse(value) == null || int.parse(value) <= 0) {
                      return t.tr(en: "Invalid number", ar: "رقم غير صالح");
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Required Skills
              _buildSideTitleSection(
                isVertical: true,
                title: t.tr(en: "Required skills", ar: "المهارات المطلوبة"),
                subtitle: t.tr(
                  en: "Add the skills needed for this work",
                  ar: "أضف المهارات اللازمة لهذا العمل",
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _skillController,
                            hint: "مثال: نجارة",
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: () {
                            final skill = _skillController.text.trim();
                            if (skill.isEmpty) return;
                            setState(() {
                              if (!_skills.contains(skill)) {
                                _skills.add(skill);
                              }
                              _skillController.clear();
                            });
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: Text(t.tr(en: "Add", ar: "إضافة")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF142C66),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _skills.map((skill) {
                        return Chip(
                          label: Text(skill),
                          deleteIcon: const Icon(Icons.close, size: 16),
                          onDeleted: () =>
                              setState(() => _skills.remove(skill)),
                          backgroundColor: colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                          labelStyle: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Location
              _buildSideTitleSection(
                isVertical: true,
                title: t.tr(en: "Location", ar: "الموقع"),
                subtitle: t.tr(
                  en: "Choose the governorate",
                  ar: "اختر المحافظة",
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGovernorate,
                  decoration: InputDecoration(
                    hintText: t.tr(
                      en: "Select governorate",
                      ar: "اختر المحافظة",
                    ),
                    hintStyle: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: 0.26,
                      ),
                      fontSize: 13,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: theme.cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: theme.dividerColor.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: _governorates.map((governorate) {
                    return DropdownMenuItem<String>(
                      value: governorate,
                      child: Text(
                        governorate,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 13,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) =>
                      setState(() => _selectedGovernorate = value),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return t.tr(
                        en: "Location is required",
                        ar: "الموقع مطلوب",
                      );
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Work Time
              _buildSideTitleSection(
                title: t.tr(en: "Work time", ar: "وقت العمل"),
                subtitle: t.tr(en: "Available days", ar: "الأيام المتاحة"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => setState(
                        () => _isWorkTimeExpanded = !_isWorkTimeExpanded,
                      ),
                      child: _buildSmallDropdown(
                        _selectedDays.isEmpty
                            ? t.tr(en: "Select", ar: "اختر")
                            : (_selectedDays.length == 7
                                  ? t.tr(en: "All days", ar: "كل الأيام")
                                  : "${_selectedDays.length} ${t.tr(en: "Days", ar: "أيام")}"),
                      ),
                    ),
                    if (_isWorkTimeExpanded) ...[
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.2),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            _buildDayItem(
                              t.tr(en: "All Days", ar: "كل الأيام"),
                              isSpecial: true,
                            ),
                            Divider(
                              color: theme.dividerColor.withValues(alpha: 0.12),
                              height: 1,
                            ),
                            ..._days.map((day) => _buildDayItem(day)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Divider(
                color: theme.dividerColor.withValues(alpha: 0.12),
                height: 40,
              ),

              // Images
              _buildSideTitleSection(
                title: t.tr(en: "Work Images", ar: "صور العمل"),
                subtitle: t.tr(en: "Showcase your work", ar: "اعرض عملك"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cloud_upload_outlined,
                              color: colorScheme.primary,
                              size: 30,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              t.tr(
                                en: "Upload work images",
                                ar: "ارفع صور لعملك",
                              ),
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_selectedImages.isNotEmpty) ...[
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: FileImage(_selectedImages[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 2,
                                  right: 12,
                                  child: GestureDetector(
                                    onTap: () => setState(
                                      () => _selectedImages.removeAt(index),
                                    ),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Bottom Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _validateAndPost(t),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142C66),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    t.tr(en: "Publish work", ar: "نشر العمل"),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSideTitleSection({
    required String title,
    required String subtitle,
    required Widget child,
    bool isVertical = false,
  }) {
    final theme = Theme.of(context);
    if (isVertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                fontSize: 11,
              ),
            ),
          ],
          const SizedBox(height: 12),
          child,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(flex: 5, child: child),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.26),
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.all(12),
        filled: true,
        fillColor: theme.cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSmallDropdown(String hint) {
    final theme = Theme.of(context);
    return Container(
      width: 150,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              hint,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.54),
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            _isWorkTimeExpanded
                ? Icons.keyboard_arrow_up
                : Icons.keyboard_arrow_down,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(String day, {bool isSpecial = false}) {
    final theme = Theme.of(context);
    bool isSelected = isSpecial
        ? _selectedDays.length == 7
        : _selectedDays.contains(day);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSpecial) {
            if (_selectedDays.length == 7) {
              _selectedDays.clear();
            } else {
              _selectedDays.addAll(_days);
            }
          } else {
            if (isSelected) {
              _selectedDays.remove(day);
            } else {
              _selectedDays.add(day);
            }
          }
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withValues(alpha: 0.05),
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.26),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              day,
              style: TextStyle(
                color: isSelected
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.54),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
