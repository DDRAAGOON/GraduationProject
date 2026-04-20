import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../help/help_center_screen.dart';
import '../notifications/notifications_screen.dart';
import '../settings/setting_screen.dart';
import 'edit_profile_screen.dart';
import 'setting_profile/notifications.dart' as profile_notif;

class ProfileLoginDetailsScreen extends StatefulWidget {
  const ProfileLoginDetailsScreen({super.key});

  @override
  State<ProfileLoginDetailsScreen> createState() => _ProfileLoginDetailsScreenState();
}

class _ProfileLoginDetailsScreenState extends State<ProfileLoginDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match!")),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password updated successfully!")),
      );
    }
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
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingScreen())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const profile_notif.Notifications()));
                  }),
                ],
              ),
              const SizedBox(height: 30),

              const Text("Basic Information", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Update your login information anytime.", style: TextStyle(color: Colors.white54, fontSize: 13)),
              const Divider(color: Colors.white24, height: 40),

              // Update Email Section
              const Text("Update Email", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Enter new email",
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
                    ),
                    child: const Text("Update", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(color: Colors.white24, height: 60),

              // Password Section
              const Text("Change Password", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 25),
              
              _buildPasswordField("Old Password", "Enter old password", _oldPasswordController),
              const SizedBox(height: 20),
              _buildPasswordField("New Password", "Enter new password", _newPasswordController, validate: true),
              const SizedBox(height: 20),
              _buildPasswordField("Confirm Password", "Re-type new password", _confirmPasswordController),
              
              const SizedBox(height: 40),
              // Unified Buttons Layout
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      onPressed: _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF49769F),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("Change Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HelpScreen()));
                      },
                      icon: const Icon(Icons.help_outline, color: Colors.white70, size: 18),
                      label: const Text("Help", style: TextStyle(color: Colors.white70, fontSize: 12)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white38, fontWeight: isActive ? FontWeight.bold : FontWeight.normal, fontSize: 14)),
          if (isActive) Container(margin: const EdgeInsets.only(top: 8), height: 2, width: 60, color: Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, String hint, TextEditingController controller, {bool validate = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          validator: (value) {
            if (value == null || value.isEmpty) return "$label is required";
            if (validate && value.length < 8) return "Password must be at least 8 characters";
            return null;
          },
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
      ],
    );
  }
}
