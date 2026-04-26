// Profile settings hub for the company account.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/services/session_manager.dart';

class CompanyProfileSettingsOverviewScreen extends StatefulWidget {
  const CompanyProfileSettingsOverviewScreen({super.key});

  @override
  State<CompanyProfileSettingsOverviewScreen> createState() =>
      _CompanyProfileSettingsOverviewScreenState();
}

class _CompanyProfileSettingsOverviewScreenState
    extends State<CompanyProfileSettingsOverviewScreen> {
  late final TextEditingController _companyName;
  late final TextEditingController _website;
  late final TextEditingController _employee;
  late final TextEditingController _industry;
  late final TextEditingController _about;
  
  late List<String> _locations;
  late List<String> _techStack;

  late int _selectedDay;
  late int _selectedMonth;
  late int _selectedYear;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final store = CompanyStore.instance;
    final isAr = LocaleController.instance.locale.value.languageCode == 'ar';
    _companyName = TextEditingController(text: store.companyName);
    _website = TextEditingController(text: store.website);
    _employee = TextEditingController(text: store.employee);
    _industry = TextEditingController(text: store.industry);
    _about = TextEditingController(text: isAr ? store.companyAboutAr : store.companyAboutEn);
    _locations = List.from(store.locations);
    _techStack = List.from(store.techStack);
    _selectedDay = store.foundedDay;
    _selectedMonth = store.foundedMonth;
    _selectedYear = store.foundedYear;
  }

  @override
  void dispose() {
    _companyName.dispose();
    _website.dispose();
    _employee.dispose();
    _industry.dispose();
    _about.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    
    final store = CompanyStore.instance;
    final isAr = LocaleController.instance.locale.value.languageCode == 'ar';
    
    CompanyStore.instance.updateProfile(
      name: _companyName.text,
      website: _website.text,
      employee: _employee.text,
      industry: _industry.text,
      aboutEn: isAr ? store.companyAboutEn : _about.text,
      aboutAr: isAr ? _about.text : store.companyAboutAr,
      locations: _locations,
      techStack: _techStack,
      foundedDay: _selectedDay,
      foundedMonth: _selectedMonth,
      foundedYear: _selectedYear,
      commercialRegister: store.commercialRegister,
      nationalNumber: store.nationalNumber,
      benefits: store.benefits,
      category: store.category,
    );

    // Persist company name change
    final data = await SessionManager.getCompanyData();
    await SessionManager.saveCompanySession(
      email: data['email'] ?? '',
      name: _companyName.text,
      photoPath: store.companyProfileImage,
    );

    if (!mounted) return;

    setState(() => _loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.saved)));
  }

  Future<void> _addTagDialog(String title, List<String> targetList) async {
    final t = AppLocalizations.of(context);
    final controller = TextEditingController();
    final newTag = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: t.tr(en: 'Enter value', ar: 'أدخل القيمة'),
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
          onSubmitted: (val) => Navigator.of(ctx).pop(val),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text),
            child: Text(t.save),
          ),
        ],
      ),
    );
    if (newTag != null && newTag.trim().isNotEmpty) {
      setState(() => targetList.add(newTag.trim()));
    }
  }

  Widget _buildChipField(String label, List<String> items, VoidCallback onAdd) {
    final t = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 56),
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ...items.map(
                (item) => Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  onDeleted: () {
                    setState(() => items.remove(item));
                  },
                  visualDensity: VisualDensity.compact,
                  deleteIcon: const Icon(Icons.close, size: 16),
                ),
              ),
              ActionChip(
                label: Text(t.tr(en: '+ Add', ar: '+ إضافة'), style: const TextStyle(fontSize: 12)),
                onPressed: onAdd,
                visualDensity: VisualDensity.compact,
                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                side: BorderSide.none,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    // Month abbreviations
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return AppScaffold(
      title: t.profileSettings,
      showBack: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyProfileSocialLinks),
          child: Text(t.socialLinks),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.overviewSection,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(t.companyLogo, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: CompanyStore.instance,
                    builder: (context, _) {
                      final profileImage = CompanyStore.instance.companyProfileImage;
                      return ClipOval(
                        child: profileImage == null
                            ? Container(
                                width: 44,
                                height: 44,
                                color: Theme.of(context).colorScheme.surfaceBright,
                                child: Icon(
                                  Icons.business,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 24,
                                ),
                              )
                            : profileImage.startsWith('assets/')
                                ? Image.asset(
                                    profileImage,
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(profileImage),
                                    width: 44,
                                    height: 44,
                                    fit: BoxFit.cover,
                                  ),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.logoHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final picker = ImagePicker();
                      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        CompanyStore.instance.setRegistrationData(customProfileImage: pickedFile.path);
                        
                        // Persist photo change
                        final data = await SessionManager.getCompanyData();
                        await SessionManager.saveCompanySession(
                          email: data['email'] ?? '',
                          name: data['name'] ?? '',
                          photoPath: pickedFile.path,
                        );
                      }
                    }, 
                    child: Text(t.upload),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(label: t.companyName, controller: _companyName),
          const SizedBox(height: 16),
          AppTextField(label: t.website, controller: _website),
          const SizedBox(height: 16),
          
          _buildChipField(t.locationInfo, _locations, () => _addTagDialog(t.locationInfo, _locations)),
          const SizedBox(height: 16),
          
          AppTextField(label: t.employee, controller: _employee),
          const SizedBox(height: 16),
          AppTextField(label: t.industry, controller: _industry),
          const SizedBox(height: 16),

          Text(t.dateFounded, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildDropdown<int>(
                  value: _selectedDay,
                  items: _selectedDay == 0 
                      ? [0, ...List.generate(31, (i) => i + 1)] 
                      : List.generate(31, (i) => i + 1),
                  labelBuilder: (v) => v == 0 ? (t.isAr ? 'اليوم' : 'Day') : t.tr(
                    en: v.toString(), 
                    ar: v.toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')
                  ),
                  onChanged: (v) => setState(() => _selectedDay = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildDropdown<int>(
                  value: _selectedMonth,
                  items: _selectedMonth == 0 
                      ? [0, ...List.generate(12, (i) => i + 1)] 
                      : List.generate(12, (i) => i + 1),
                  labelBuilder: (v) {
                    if (v == 0) return t.isAr ? 'الشهر' : 'Month';
                    return t.isAr ? [
                      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
                      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
                    ][v - 1] : months[v - 1];
                  },
                  onChanged: (v) => setState(() => _selectedMonth = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: _buildDropdown<int>(
                  value: _selectedYear,
                  items: _selectedYear == 0 
                      ? [0, ...List.generate(50, (i) => 2024 - i)] 
                      : List.generate(50, (i) => 2024 - i),
                  labelBuilder: (v) => v == 0 ? (t.isAr ? 'السنة' : 'Year') : t.tr(
                    en: v.toString(), 
                    ar: v.toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')
                  ),
                  onChanged: (v) => setState(() => _selectedYear = v!),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),

          const SizedBox(height: 16),
          AppTextField(label: t.aboutCompany, controller: _about, maxLines: 4),
          const SizedBox(height: 18),
          AppButton(label: t.saveChange, loading: _loading, onPressed: _save),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.companyCompanyProfile),
            child: Text(t.previewProfile),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T value,
    required List<T> items,
    required String Function(T) labelBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((e) {
            return DropdownMenuItem<T>(
              value: e,
              child: Text(labelBuilder(e)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
