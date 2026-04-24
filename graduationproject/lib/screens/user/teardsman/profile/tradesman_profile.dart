import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../setting/settings.dart';
import 'teardsman_data.dart';

class TradesmanProfile extends StatefulWidget {
  const TradesmanProfile({super.key});

  @override
  State<TradesmanProfile> createState() => _TradesmanProfileState();
}

class _TradesmanProfileState extends State<TradesmanProfile> {
  bool _isEditing = false;
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();
  final _serviceController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final store = RecruitmentSyncStore.instance;
    _nameController.text = store.currentUserName;
    _emailController.text = store.currentUserEmail;
    _phoneController.text = store.currentUserPhone;
    _locationController.text = store.currentUserLocation;
    _aboutController.text = store.currentUserAbout;
    _serviceController.text = store.currentUserTitle;
    _skillsController.text = store.currentUserSkills.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _serviceController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Image.asset(
          'assets/company/logo/logo.png',
          height: 150,
          fit: BoxFit.contain,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF49769F)),
          ),
          IconButton(
            onPressed: () => setState(() => _isEditing = !_isEditing),
            icon: Icon(_isEditing ? Icons.close : Icons.edit_outlined, color: const Color(0xFF49769F)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          if (!_isEditing) _loadData();
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header with Profile Image (Aligned to Left)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.white,
                        backgroundImage: store.profileImage != null && store.profileImage!.startsWith('http')
                            ? NetworkImage(store.profileImage!)
                            : null,
                        child: store.profileImage == null 
                            ? const Icon(Icons.person, size: 50, color: Color(0xFF49769F)) 
                            : null,
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_isEditing) ...[
                              Text(
                                store.currentUserName,
                                style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                store.currentUserTitle,
                                style: const TextStyle(color: Color(0xFF49769F), fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                            ] else ...[
                              _buildProfileItem(t.fullName, _nameController, enabled: true),
                              _buildProfileItem(t.tr(en: "Profession", ar: "المهنة"), _serviceController, enabled: true),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        color: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileItem(t.aboutMe, _aboutController, maxLines: 3, enabled: _isEditing),
                              _buildProfileItem(t.emailAddress, _emailController, enabled: _isEditing),
                              _buildProfileItem(t.phoneNumber, _phoneController, enabled: _isEditing),
                              _buildProfileItem(t.address, _locationController, enabled: _isEditing),
                              _buildProfileItem(t.tr(en: "Skills (comma separated)", ar: "المهارات (مفصولة بفاصلة)"), _skillsController, enabled: _isEditing),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Social Links Section
                      if (store.socialLinks.isNotEmpty) ...[
                        Text(
                          t.socialLinks,
                          style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...store.socialLinks.map((link) => Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.link, color: Color(0xFF49769F), size: 20),
                              const SizedBox(width: 12),
                              Text(
                                "${link['platform']}: ",
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Expanded(
                                child: Text(
                                  link['url'] ?? "",
                                  style: const TextStyle(color: Colors.blue, fontSize: 14, decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                        const SizedBox(height: 20),
                      ],

                      if (!_isEditing) ...[
                        _buildEducationSection(t),
                        const SizedBox(height: 20),
                      ] else ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              store.updateUserProfile(
                                fullName: _nameController.text,
                                title: _serviceController.text,
                                email: _emailController.text,
                                phone: _phoneController.text,
                                location: _locationController.text,
                                about: _aboutController.text,
                                skills: _skillsController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
                              );
                              setState(() => _isEditing = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(t.tr(en: "Profile Updated", ar: "تم تحديث الملف الشخصي"))),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF49769F),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(t.saveChange, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileItem(String label, TextEditingController controller, {int maxLines = 1, bool enabled = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        enabled: enabled,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 13, color: Colors.black45),
          border: enabled ? const OutlineInputBorder() : InputBorder.none,
          contentPadding: enabled ? const EdgeInsets.all(12) : EdgeInsets.zero,
          filled: enabled,
          fillColor: Colors.grey.withOpacity(0.05),
        ),
      ),
    );
  }

  Widget _buildEducationSection(AppLocalizations t) {
    final store = RecruitmentSyncStore.instance;
    if (store.currentUserEducation.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.education, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...store.currentUserEducation.map((edu) => Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.school, color: Color(0xFF49769F)),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(edu['institution'] ?? "", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                    Text("${edu['degree']} (${edu['duration']})", style: const TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }
}
