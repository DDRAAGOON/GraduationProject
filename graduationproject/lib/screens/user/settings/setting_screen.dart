import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/state/theme_controller.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/profile_login_details_screen.dart';
import '../profile/setting_profile/notifications.dart';
import '../profile/setting_profile/preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.settings,
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              t.tr(en: "Account Settings", ar: "إعدادات الحساب"),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildSettingItem(
              icon: Icons.person_outline,
              title: t.tr(en: "Profile Setting", ar: "إعدادات الملف الشخصي"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
            ),
            _buildSettingItem(
              icon: Icons.security_outlined,
              title: t.tr(en: "Account Security", ar: "أمان الحساب"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen())),
            ),
            _buildSettingItem(
              icon: Icons.notifications_none,
              title: t.tr(en: "Notification", ar: "الإشعارات"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Notifications())),
            ),
            _buildSettingItem(
              icon: Icons.tune_outlined,
              title: t.tr(en: "Preferences", ar: "التفضيلات"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Preferences())),
            ),

            const SizedBox(height: 40),
            _buildSettingItem(
              icon: Icons.logout,
              title: t.tr(en: "Logout", ar: "تسجيل الخروج"),
              titleColor: Colors.redAccent,
              showArrow: false,
              onTap: () {
                // Logout logic
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    bool showArrow = true,
  }) {
    final isAr = AppLocalizations.of(context).isAr;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF49769F).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: const Color(0xFF49769F), size: 20),
        ),
        title: Text(title, style: TextStyle(color: titleColor ?? Colors.black87, fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.black38, fontSize: 12)) : null,
        trailing: showArrow ? Icon(isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios, color: Colors.black26, size: 14) : null,
      ),
    );
  }
}
