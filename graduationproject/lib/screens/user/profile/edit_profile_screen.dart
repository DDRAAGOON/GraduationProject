import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/user_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../shared/widgets/app_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers (Shared)
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _locationController;

  // Controllers (Specific)
  late TextEditingController _experienceController; // For Tradesman
  late List<String> _skills; // For Seeker
  late List<String> _services; // For Tradesman

  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    
    _nameController = TextEditingController(text: store.currentUserName);
    _phoneController = TextEditingController(text: store.currentUserPhone);
    _bioController = TextEditingController(text: store.currentUserAbout);
    _locationController = TextEditingController(text: store.currentUserLocation);
    
    _experienceController = TextEditingController(text: '0'); // Fallback
    _skills = List.from(store.currentUserSkills);
    _services = List.from(store.tradesmanServices);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _profileImagePath = image.path);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final isTradesman = store.userRole.toLowerCase().contains('tradesman');

    setState(() => _isLoading = true);

    try {
      String? uploadedImageUrl;
      if (_profileImagePath != null) {
        uploadedImageUrl = await UserService.instance.uploadImage(_profileImagePath!);
      }

      // 1. Prepare Common Data
      Map<String, dynamic> updateData = {
        'fullName': _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'bio': _bioController.text.trim(),
        'location': _locationController.text.trim(),
        if (uploadedImageUrl != null) 'avatar': uploadedImageUrl,
      };

      // 2. Add Role Specific Data
      if (isTradesman) {
        updateData['services'] = _services;
        updateData['experience'] = int.tryParse(_experienceController.text) ?? 0;
        // updateData['criminalRecordUrl'] = ... (Add if needed)
      } else {
        updateData['skills'] = _skills;
      }

      // 3. Call Unified API
      await UserService.instance.updateProfile(
        fullName: updateData['fullName'],
        phone: updateData['phone'],
        bio: updateData['bio'],
        location: updateData['location'],
        services: isTradesman ? _services : null,
        experience: isTradesman ? updateData['experience'] : null,
        avatar: uploadedImageUrl,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.tr(en: "Profile Updated!", ar: "تم تحديث الملف الشخصي بنجاح!")), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTradesman = store.userRole.toLowerCase().contains('tradesman');

    return Scaffold(
      appBar: AppBar(
        title: Text(t.editProfile),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Photo Section
                  _buildPhotoPicker(store),
                  const SizedBox(height: 32),

                  // Common Fields
                  _buildTextField(t.fullName, _nameController, Icons.person_outline),
                  _buildTextField(t.phoneNumber, _phoneController, Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                  _buildTextField(isAr ? 'الموقع' : 'Location', _locationController, Icons.location_on_outlined),
                  _buildTextField(t.aboutMe, _bioController, Icons.notes_outlined, maxLines: 3),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // TRADESMAN ONLY FIELDS
                  if (isTradesman) ...[
                    _buildSectionTitle(isAr ? 'الخدمات التي تقدمها' : 'Services You Provide'),
                    _buildListEditor(_services, isAr ? 'أضف خدمة (مثلاً: سباكة)' : 'Add Service'),
                    const SizedBox(height: 20),
                    _buildTextField(isAr ? 'سنوات الخبرة' : 'Years of Experience', _experienceController, Icons.work_history_outlined, keyboardType: TextInputType.number),
                  ],

                  // SEEKER ONLY FIELDS
                  if (!isTradesman) ...[
                    _buildSectionTitle(t.skills),
                    _buildListEditor(_skills, isAr ? 'أضف مهارة' : 'Add Skill'),
                  ],

                  const SizedBox(height: 40),
                  AppButton(
                    label: t.save,
                    onPressed: _saveProfile,
                    backgroundColor: const Color(0xFF142C66),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildPhotoPicker(RecruitmentSyncStore store) {
    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: _profileImagePath != null 
                ? FileImage(File(_profileImagePath!)) as ImageProvider
                : getAppImageProvider(store.profileImage),
            child: (_profileImagePath == null && store.profileImage == null) 
                ? const Icon(Icons.person, size: 60) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(color: Color(0xFFFF7A2A), shape: BoxShape.circle),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFFF7A2A), size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (val) => val!.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF213E75))),
    );
  }

  Widget _buildListEditor(List<String> list, String hint) {
    final controller = TextEditingController();
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(hintText: hint, isDense: true),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, color: Color(0xFFFF7A2A)),
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() => list.add(controller.text.trim()));
                  controller.clear();
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: list.map((item) => Chip(
            label: Text(item, style: const TextStyle(fontSize: 12)),
            onDeleted: () => setState(() => list.remove(item)),
          )).toList(),
        ),
      ],
    );
  }
}
