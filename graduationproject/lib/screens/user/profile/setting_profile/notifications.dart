import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../edit_profile_screen.dart';
import '../profile_login_details_screen.dart'; // تصحيح الاستيراد للملف الصحيح

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool _applicationsEnabled = true;
  bool _jobsEnabled = false;
  bool _recommendationsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabItem("My Profile", false, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                }),
                _buildTabItem("Login Details", false, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()));
                }),
                _buildTabItem("Notifications", true, () {}),
              ],
            ),
            const SizedBox(height: 30),

            const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("This is notifications preferences that you can update anytime.", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const Divider(color: Colors.white24, height: 40),

            const Text("Notifications", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Customize your preferred notification settings", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const SizedBox(height: 30),

            _buildNotificationOption(
              "Applications",
              "These are notifications for jobs that you have applied to",
              _applicationsEnabled,
              (val) => setState(() => _applicationsEnabled = val!),
            ),
            _buildNotificationOption(
              "Jobs",
              "These are notifications for job openings that suit your profile",
              _jobsEnabled,
              (val) => setState(() => _jobsEnabled = val!),
            ),
            _buildNotificationOption(
              "Recommendations",
              "These are notifications for personalized recommendations from our recruiters",
              _recommendationsEnabled,
              (val) => setState(() => _recommendationsEnabled = val!),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 14),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: Colors.blueAccent,
            ),
        ],
      ),
    );
  }

  Widget _buildNotificationOption(String title, String subtitle, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF49769F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(color: Colors.white38, width: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
