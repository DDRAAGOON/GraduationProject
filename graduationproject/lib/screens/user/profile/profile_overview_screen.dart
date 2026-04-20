import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../../../constants/app_images.dart';
import 'edit_profile_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/setting_screen.dart';
import 'user_data.dart';

class ProfileOverviewScreen extends StatefulWidget {
  const ProfileOverviewScreen({super.key});

  @override
  State<ProfileOverviewScreen> createState() => _ProfileOverviewScreenState();
}

class _ProfileOverviewScreenState extends State<ProfileOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar Icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildTopIconButton(
                      Icons.notifications_none,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                      ),
                    ),
                    const SizedBox(width: 12),
                    _buildTopIconButton(
                      Icons.settings_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingScreen()),
                      ),
                    ),
                  ],
                ),
              ),

              // Cover Image & Profile Pic
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF321A2C), Color(0xFF0F0F10)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Icon(Icons.edit_note, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -40,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF001E3A),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 45,
                        backgroundImage: AssetImage(AppImages.companyProfile1),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // User Info Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            UserProfileData.fullName,
                            style: const TextStyle(
                              color: Colors.white, 
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                            );
                            setState(() {});
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white54),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text("Edit Profile", style: TextStyle(color: Colors.white, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      UserProfileData.jobTitle,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: Colors.white54, size: 16),
                        const SizedBox(width: 4),
                        Text(UserProfileData.location, style: const TextStyle(color: Colors.white54, fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Opportunities Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.flag_outlined, color: Colors.tealAccent, size: 18),
                      SizedBox(width: 8),
                      Text("OPEN FOR OPPORTUNITIES", style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // About Me
              _buildSectionTitle("About Me"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  UserProfileData.aboutMe,
                  style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
                ),
              ),

              const SizedBox(height: 30),

              // Work Experience Section
              _buildSectionTitle("Work Experience"),
              if (UserProfileData.experiences.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text("No experience added yet", style: TextStyle(color: Colors.white38, fontSize: 12)),
                )
              else
                ...UserProfileData.experiences.map((exp) => _buildExperienceItem(
                  exp['title']!, 
                  exp['company']!, 
                  exp['duration']!
                )).toList(),

              const SizedBox(height: 30),

              // Skills
              _buildSectionTitle("Skills"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: UserProfileData.skills.map((skill) => _buildSkillTag(skill)).toList(),
                ),
              ),

              const SizedBox(height: 30),

              // Portfolio
              _buildSectionTitle("Portfolio URL"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  UserProfileData.portfolioUrl.isEmpty ? "No portfolio added" : UserProfileData.portfolioUrl,
                  style: const TextStyle(color: Colors.blueAccent, fontSize: 16),
                ),
              ),

              const SizedBox(height: 30),

              // Details Sections
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Additional Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildDetailItem(Icons.email_outlined, "Email", UserProfileData.email),
                    _buildDetailItem(Icons.phone_android_outlined, "Phone", UserProfileData.phone),
                    _buildDetailItem(Icons.calendar_today_outlined, "Birthday", UserProfileData.dob),
                    
                    const SizedBox(height: 30),
                    const Text("Social Links", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    if (UserProfileData.socialLinks.isEmpty)
                      const Text("No social links added", style: TextStyle(color: Colors.white38, fontSize: 12))
                    else
                      ...UserProfileData.socialLinks.map((link) => 
                        _buildDetailItem(Icons.link, link["platform"]!, link["url"]!)
                      ).toList(),
                  ],
                ),
              ),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopIconButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF0D2D4D),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExperienceItem(String title, String company, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.work_outline, color: Color(0xFF49769F), size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$company • $duration", style: const TextStyle(color: Colors.white54, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF49769F).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF49769F).withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white70, fontSize: 13),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: Colors.white54, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
