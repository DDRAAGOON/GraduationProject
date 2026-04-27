import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../../auth/sign_up_screen/sign_up_seeker.dart';
import '../nav_Botton_bar/nav_bottom_bar.dart';
import '../../home/recruitment_user_shell_screen.dart';
import '../../profile/user_data.dart';
import '../setting/settings.dart';

class TradesmanProfile extends StatefulWidget {
  const TradesmanProfile({super.key});

  @override
  State<TradesmanProfile> createState() => _TradesmanProfileState();
}

class _TradesmanProfileState extends State<TradesmanProfile> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: UserProfileData.profileImage != null
                  ? (UserProfileData.profileImage!.startsWith('http') 
                      ? NetworkImage(UserProfileData.profileImage!) 
                      : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                  : null,
              child: UserProfileData.profileImage == null 
                  ? const Icon(Icons.person, size: 20) 
                  : null,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Profile", ar: "البروفايل"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF49769F)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Profile Image
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    backgroundImage: UserProfileData.profileImage != null
                        ? (UserProfileData.profileImage!.startsWith('http') 
                            ? NetworkImage(UserProfileData.profileImage!) 
                            : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                        : null,
                    child: UserProfileData.profileImage == null 
                        ? const Icon(Icons.person, size: 50, color: Color(0xFF49769F)) 
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserProfileData.fullName.isEmpty ? "Not yet" : UserProfileData.fullName,
                          style: const TextStyle(color: Colors.black87, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          UserProfileData.jobTitle.isEmpty ? "Not yet" : UserProfileData.jobTitle,
                          style: const TextStyle(color: Color(0xFF49769F), fontSize: 15, fontWeight: FontWeight.w600),
                        ),
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
                  // Switching Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t.tr(en: "Switching to Job Seeker Mode...", ar: "التبديل إلى وضع الباحث عن عمل...")),
                          backgroundColor: const Color(0xFFFF7A2A),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RecruitmentUserShellScreen()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A2A).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFFF7A2A).withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
                          const SizedBox(width: 10),
                          Text(
                            t.tr(en: "Switch to Job Seeker", ar: "التبديل إلى وضع الباحث عن عمل"),
                            style: const TextStyle(color: Color(0xFFFF7A2A), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                          _buildProfileItem(t.aboutMe, UserProfileData.aboutMe),
                          _buildProfileItem(t.emailAddress, UserProfileData.email),
                          _buildProfileItem(t.phoneNumber, UserProfileData.phone),
                          _buildProfileItem(t.address, UserProfileData.location),
                          _buildProfileItem(t.tr(en: "Skills", ar: "المهارات"), UserProfileData.skills.join(', ')),
                          _buildProfileItem(t.tr(en: "CV", ar: "السيرة الذاتية"), UserProfileData.cvName ?? ""),
                          
                          // Gallery Section
                          if (UserProfileData.portfolioImages.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Text(
                              t.tr(en: "Gallery", ar: "المعرض"),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 100,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: UserProfileData.portfolioImages.length,
                                itemBuilder: (context, index) {
                                  final path = UserProfileData.portfolioImages[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: path.startsWith('http')
                                          ? Image.network(path, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                                          : Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                      
                  const SizedBox(height: 20),
                  
                  // Social Links Section
                  if (UserProfileData.socialLinks.isNotEmpty) ...[
                    Text(
                      t.socialLinks,
                      style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...UserProfileData.socialLinks.map((link) => Container(
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
                            child: GestureDetector(
                              onTap: () async {
                                String url = link['url'] ?? '';
                                if (url.isNotEmpty) {
                                  if (!url.startsWith('http')) {
                                    url = 'https://$url';
                                  }
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                }
                              },
                              child: Text(
                                link['url'] ?? "",
                                style: const TextStyle(color: Colors.blue, fontSize: 14, decoration: TextDecoration.underline),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: 20),
                  ],

                  _buildEducationSection(t),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "Not yet" : value,
            style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationSection(AppLocalizations t) {
    if (UserProfileData.education.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.education, style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...UserProfileData.education.map((edu) => Container(
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
