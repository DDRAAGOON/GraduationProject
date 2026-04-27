import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../../shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';
import '../../profile/user_data.dart';
import '../setting/settings.dart';
import '../../home/recruitment_user_shell_screen.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Edge-to-edge Top Cover Section
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF011931), Color(0xFF49769F)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // App Bar Icons
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 40), // Placeholder
                        Text(
                          t.tr(en: "Profile", ar: "البروفايل"),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        IconButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Settings()),
                          ),
                          icon: const Icon(Icons.settings_outlined, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
                // Profile Avatar Centered
                Positioned(
                  bottom: -60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))],
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: UserProfileData.profileImage != null
                            ? (UserProfileData.profileImage!.startsWith('http') 
                                ? NetworkImage(UserProfileData.profileImage!) 
                                : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                            : null,
                        child: UserProfileData.profileImage == null 
                            ? const Icon(Icons.person, size: 70, color: Color(0xFF49769F)) 
                            : null,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 75),

            // User Primary Info
            Text(
              UserProfileData.fullName.isEmpty ? "No Name" : UserProfileData.fullName,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF011931), fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              UserProfileData.jobTitle.isEmpty ? "Service Provider" : UserProfileData.jobTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF49769F), fontSize: 16, fontWeight: FontWeight.w700),
            ),
            
            const SizedBox(height: 35),

            // Main Content Area with reduced side padding for "Full Width" look
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Mode Switch Button
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(t.tr(en: "Switching Mode...", ar: "جاري التبديل...")),
                          backgroundColor: const Color(0xFFFF7A2A),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const RecruitmentUserShellScreen()),
                      );
                    },
                    icon: const Icon(Icons.swap_horiz, color: Colors.white),
                    label: Text(t.tr(en: "Switch to Job Seeker", ar: "التبديل إلى وضع الباحث عن عمل")),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF7A2A),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 5,
                      shadowColor: const Color(0xFFFF7A2A).withOpacity(0.4),
                    ),
                  ),
                  
                  const SizedBox(height: 30),

                  // About Me Card
                  _buildFullWidthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(t.aboutMe, Icons.info_outline),
                        const SizedBox(height: 12),
                        Text(
                          UserProfileData.aboutMe.isEmpty ? "No info provided yet." : UserProfileData.aboutMe,
                          style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Contact Details Card
                  _buildFullWidthCard(
                    child: Column(
                      children: [
                        _buildInfoRow(t.emailAddress, UserProfileData.email, Icons.email_outlined),
                        const Divider(height: 32),
                        _buildInfoRow(t.phoneNumber, UserProfileData.phone, Icons.phone_android_outlined),
                        const Divider(height: 32),
                        _buildInfoRow(t.address, UserProfileData.location, Icons.location_on_outlined),
                        const Divider(height: 32),
                        _buildInfoRow(t.tr(en: "Skills", ar: "المهارات"), UserProfileData.skills.join(', '), Icons.psychology_outlined),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Gallery Section
                  if (UserProfileData.portfolioImages.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.tr(en: "Portfolio Gallery", ar: "معرض الأعمال"), Icons.image_outlined),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: UserProfileData.portfolioImages.length,
                              itemBuilder: (context, index) {
                                final path = UserProfileData.portfolioImages[index];
                                return Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  width: 110,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.grey.shade100),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: path.startsWith('http')
                                        ? Image.network(path, fit: BoxFit.cover)
                                        : Image.file(File(path), fit: BoxFit.cover),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Social Links
                  if (UserProfileData.socialLinks.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.socialLinks, Icons.link),
                          const SizedBox(height: 16),
                          ...UserProfileData.socialLinks.map((link) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () async {
                                String url = link['url'] ?? '';
                                if (url.isNotEmpty) {
                                  if (!url.startsWith('http')) url = 'https://$url';
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(10)),
                                    child: const Icon(Icons.link_rounded, color: Color(0xFF49769F), size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Text("${link['platform']}: ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                  Expanded(child: Text(link['url'] ?? "", style: const TextStyle(color: Color(0xFF49769F), decoration: TextDecoration.underline), overflow: TextOverflow.ellipsis)),
                                ],
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Education Section
                  if (UserProfileData.education.isNotEmpty) ...[
                    _buildFullWidthCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(t.education, Icons.school_outlined),
                          const SizedBox(height: 16),
                          ...UserProfileData.education.map((edu) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(Icons.school, color: Color(0xFF49769F), size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(edu['institution'] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF011931))),
                                      Text("${edu['degree']} • ${edu['duration']}", style: const TextStyle(color: Colors.black45, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                  
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF49769F), size: 22),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Color(0xFF011931))),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: const Color(0xFF49769F), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.black38, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                value.isEmpty ? "Not provided" : value,
                style: const TextStyle(color: Color(0xFF011931), fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
