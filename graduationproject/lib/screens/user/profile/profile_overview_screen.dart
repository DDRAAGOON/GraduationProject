import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: Theme.of(context).brightness == Brightness.dark 
                            ? [const Color(0xFF321A2C), const Color(0xFF0F0F10)]
                            : [const Color(0xFFE3EAF2), const Color(0xFFF9FBFE)],
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
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? const Color(0xFF001E3A) 
                            : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
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
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface, 
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
                            side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.5)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: Text(t.editProfile, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 11)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      UserProfileData.jobTitle,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 16),
                        const SizedBox(width: 4),
                        Text(UserProfileData.location, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14)),
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
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.teal.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flag_outlined, color: Colors.teal, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        t.tr(en: "OPEN FOR OPPORTUNITIES", ar: "متاح للفرص"),
                        style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.tealAccent : Colors.teal, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // About Me
              _buildSectionTitle(t.aboutMeSection),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  UserProfileData.aboutMe,
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14, height: 1.5),
                ),
              ),

              const SizedBox(height: 30),

              // Work Experience Section
              _buildSectionTitle(t.workExperience),
              if (UserProfileData.experiences.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    t.tr(en: "No experience added yet", ar: "لم يتم إضافة خبرة بعد"),
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
                  ),
                )
              else
                  ...UserProfileData.experiences.map((exp) => _buildExperienceItem(
                  exp['title']!, 
                  exp['company']!, 
                  exp['duration']!
                )),

              const SizedBox(height: 30),

              // Skills
              _buildSectionTitle(t.skills),
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
              _buildSectionTitle(t.portfolioUrl),
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
                    Text(t.additionalDetails, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    _buildDetailItem(Icons.email_outlined, t.email, UserProfileData.email),
                    _buildDetailItem(Icons.phone_android_outlined, t.phone, UserProfileData.phone),
                    _buildDetailItem(Icons.calendar_today_outlined, t.dob, UserProfileData.dob),
                    
                    const SizedBox(height: 30),
                    Text(t.socialMedia, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    if (UserProfileData.socialLinks.isEmpty)
                      Text(t.tr(en: "No social links added", ar: "لم يتم إضافة روابط تواصل"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12))
                    else
                      ...UserProfileData.socialLinks.map((link) => 
                        _buildDetailItem(Icons.link, link["platform"]!, link["url"]!)
                      ),
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
          color: Theme.of(context).brightness == Brightness.dark 
              ? const Color(0xFF0D2D4D) 
              : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onSurface, size: 22),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildExperienceItem(String title, String company, String duration) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.work_outline, color: Theme.of(context).colorScheme.primary, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("$company • $duration", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13)),
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
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 13),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

