// Profile settings hub for the company account.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/utils/image_helper.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/services/session_manager.dart';
import '../../../shared/services/recruitment_sync_service.dart';

import '../../../app/router/app_router.dart';

class CompanyProfileSettingsOverviewScreen extends StatefulWidget {
  const CompanyProfileSettingsOverviewScreen({super.key});

  @override
  State<CompanyProfileSettingsOverviewScreen> createState() =>
      _CompanyProfileSettingsOverviewScreenState();
}

class _CompanyProfileSettingsOverviewScreenState
    extends State<CompanyProfileSettingsOverviewScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _companyName;
  late final TextEditingController _employee;
  late final TextEditingController _about;
  late String _selectedCategory;
  late List<String> _benefits;
  
  late List<String> _locations;
  late List<String> _techStack;

  DateTime? _foundedDate;
  bool _loading = false;
  bool _saveSuccess = false;
  bool _saveError = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    final store = CompanyStore.instance;
    final isAr = LocaleController.instance.locale.value.languageCode == 'ar';
    _companyName = TextEditingController(text: store.companyName);
    _employee = TextEditingController(text: store.employee);
    _about = TextEditingController(text: isAr ? store.companyAboutAr : store.companyAboutEn);
    _benefits = List.from(store.benefits);
    
    _selectedCategory = store.category;
    if (_selectedCategory != 'technical' && _selectedCategory != 'nontechnical') {
      _selectedCategory = 'technical';
    }
    _locations = List.from(store.locations);
    _techStack = List.from(store.techStack);
    // تحويل foundedDay/Month/Year المخزّنة إلى DateTime واحد
    if (store.foundedYear > 0 && store.foundedMonth > 0 && store.foundedDay > 0) {
      _foundedDate = DateTime(store.foundedYear, store.foundedMonth, store.foundedDay);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _companyName.dispose();
    _employee.dispose();
    _about.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Validate
    if (_companyName.text.trim().isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(t.tr(en: 'Company name is required', ar: 'اسم الشركة مطلوب')))
      );
      return;
    }

    setState(() {
      _loading = true;
      _saveSuccess = false;
      _saveError = false;
    });

    try {
      final store = CompanyStore.instance;
      final isAr = LocaleController.instance.locale.value.languageCode == 'ar';

      // Sync with company-specific backend endpoint: PATCH /api/companies/my/profile
      await RecruitmentSyncService.instance.updateCompanyProfile(
        name: _companyName.text.trim(),
        employee: _employee.text.trim(),
        industry: store.industry,
        website: store.website,
        aboutEn: isAr ? store.companyAboutEn : _about.text.trim(),
        aboutAr: isAr ? _about.text.trim() : store.companyAboutAr,
        locations: _locations,
        techStack: _techStack,
        foundedDay: _foundedDate?.day,
        foundedMonth: _foundedDate?.month,
        foundedYear: _foundedDate?.year,
        category: _selectedCategory,
        benefits: _benefits,
        commercialRegister: store.commercialRegister,
        nationalNumber: store.nationalNumber,
      );

      if (!mounted) return;
      setState(() => _saveSuccess = true);
      messenger.showSnackBar(
        SnackBar(
          content: Text(t.saved),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        )
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _saveError = true);
      messenger.showSnackBar(
        SnackBar(
          content: Text(t.tr(en: 'Save failed. Please try again.', ar: 'فشل الحفظ. يرجى المحاولة مرة أخرى.')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    
    return AppScaffold(
      title: t.profileSettings,
      showBack: true,
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            onTap: (index) {
              if (index == 1) {
                _tabController.index = 0; // Reset to profile tab for next time
                Navigator.of(context).pushNamed(AppRoutes.companyAccountSecurity);
              } else if (index == 2) {
                _tabController.index = 0; // Reset to profile tab for next time
                Navigator.of(context).pushNamed(AppRoutes.companyAppearanceLight);
              }
            },
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            tabs: [
              Tab(text: t.profileSettings),
              Tab(text: t.accountSecurity),
              Tab(text: t.appearanceLabel),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildProfileTab(),
                const Center(child: CircularProgressIndicator()),
                const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final t = AppLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildProfileHeader(),
        const SizedBox(height: 30),
        
        Text(t.basicInfoLabel, 
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(t.updateIdentity,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        const Divider(height: 40),

        AppTextField(
          label: t.companyName, 
          controller: _companyName,
          validatorText: _saveError && _companyName.text.isEmpty ? 'Required' : null,
        ),
        const SizedBox(height: 20),
        AppTextField(label: t.employee, controller: _employee),
        const SizedBox(height: 20),
        
        Text(t.categoryLabel, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        _buildDropdown<String>(
          value: _selectedCategory,
          items: const ['technical', 'nontechnical'],
          labelBuilder: (v) => v == 'technical' ? t.technical : t.nonTechnical,
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
        const SizedBox(height: 20),
        
        _buildChipField(t.locationInfo, _locations, () => _addTagDialog(t.locationInfo, _locations)),
        const SizedBox(height: 20),

        Text(t.dateFounded, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        _buildDatePickerField(),
        const SizedBox(height: 20),
        
        AppTextField(label: t.aboutCompany, controller: _about, maxLines: 4),
        const SizedBox(height: 20),
        _buildChipField(t.benefits, _benefits, () => _addTagDialog(t.benefits, _benefits)),
        
        const SizedBox(height: 40),
        AppButton(
          label: t.saveChange, 
          loading: _loading, 
          onPressed: _save,
          icon: _saveSuccess ? Icons.check_circle : null,
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: CompanyStore.instance,
            builder: (context, _) {
              final profileImage = CompanyStore.instance.companyProfileImage;
              final imageProvider = getAppImageProvider(profileImage);
              return Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: _saveError ? Colors.red : (_saveSuccess ? Colors.green : Colors.blue.withValues(alpha: 0.2)),
                    width: 3
                  ),
                  image: imageProvider != null ? DecorationImage(image: imageProvider, fit: BoxFit.cover) : null,
                  color: Colors.grey.shade100,
                ),
                child: imageProvider == null ? const Icon(Icons.business, size: 40, color: Colors.grey) : null,
              );
            },
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
              ),
            ),
          ),
          if (_saveError)
            const Positioned.fill(
              child: Center(child: Icon(Icons.error, color: Colors.red, size: 40)),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final t = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (pickedFile != null) {
        setState(() {
          _loading = true;
          _saveError = false;
        });

        final bytes = await pickedFile.readAsBytes();
        final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';

        // Update local store first for immediate feedback
        CompanyStore.instance.setRegistrationData(customProfileImage: base64Image);
        await SessionManager.saveCompanyPhoto(base64Image);

        // Sync photo with company profile endpoint: PATCH /api/companies/my/profile
        await RecruitmentSyncService.instance.updateCompanyProfile(
          name: CompanyStore.instance.companyName,
          photoUrl: base64Image,
        );

        if (mounted) {
          setState(() {
            _saveSuccess = true;
          });
          messenger.showSnackBar(
            SnackBar(content: Text(t.saved), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating)
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saveError = true;
          _saveSuccess = false;
        });
        messenger.showSnackBar(
          SnackBar(
            content: Text(t.tr(en: 'Image upload failed', ar: 'فشل تحميل الصورة')),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating
          )
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _addTagDialog(String title, List<String> targetList) async {
    final controller = TextEditingController();
    final newTag = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: const Text('Add')),
        ],
      ),
    );
    if (newTag != null && newTag.trim().isNotEmpty) {
      setState(() => targetList.add(newTag.trim()));
    }
  }

  Widget _buildDatePickerField() {
    final t = AppLocalizations.of(context);
    final label = _foundedDate != null
        ? '${_foundedDate!.month.toString().padLeft(2, '0')}/${_foundedDate!.day.toString().padLeft(2, '0')}/${_foundedDate!.year}'
        : (t.isAr ? 'اختر تاريخ التأسيس' : 'Select founding date');

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _foundedDate ?? DateTime(2010),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() => _foundedDate = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  color: _foundedDate != null ? null : Colors.grey.shade500,
                ),
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildChipField(String label, List<String> items, VoidCallback onAdd) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            children: [
              ...items.map((item) => Chip(
                label: Text(item),
                onDeleted: () => setState(() => items.remove(item)),
              )),
              ActionChip(label: const Text('+ Add'), onPressed: onAdd),
            ],
          ),
        ),
      ],
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
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(labelBuilder(e)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
