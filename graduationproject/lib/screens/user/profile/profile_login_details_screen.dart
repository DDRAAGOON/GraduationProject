import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../help/help_center_screen.dart';
import 'edit_profile_screen.dart';
import 'setting_profile/notifications.dart';

class ProfileLoginDetailsScreen extends StatefulWidget {
  const ProfileLoginDetailsScreen({super.key});

  @override
  State<ProfileLoginDetailsScreen> createState() => _ProfileLoginDetailsScreenState();
}

class _ProfileLoginDetailsScreenState extends State<ProfileLoginDetailsScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
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
                _buildTabItem("Login Details", true, () {}),
                _buildTabItem("Notifications", false, () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Basic Information
            const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("This is login information that you can update anytime.", style: TextStyle(color: Colors.white54, fontSize: 13)),
            const Divider(color: Colors.white24, height: 40),

            Row(
              children: [
                const Text("jakegyll@email.com", style: TextStyle(color: Colors.white, fontSize: 15)),
                const SizedBox(width: 8),
                const Icon(Icons.check_circle, color: Colors.teal, size: 18),
              ],
            ),
            const Text("Your email address is verified.", style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 20),
            const Text("Update Email", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter your new email",
                      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.05),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.white24)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.white24)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49769F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: const Text("Update Email", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Divider(color: Colors.white24, height: 60),
            
            _buildPasswordField("Old Password", "Enter your old password", _oldPasswordController),
            const SizedBox(height: 24),
            _buildPasswordField("New Password", "Enter your new password", _newPasswordController),
            
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49769F),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text("Change Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                  },
                  icon: const Icon(Icons.help_outline, color: Colors.white70, size: 20),
                  label: const Text("Help Center", style: TextStyle(color: Colors.white70)),
                ),
              ],
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
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
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

  Widget _buildPasswordField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white24)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.white24)),
          ),
        ),
        const SizedBox(height: 8),
        const Text("Minimum 8 characters", style: TextStyle(color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}
