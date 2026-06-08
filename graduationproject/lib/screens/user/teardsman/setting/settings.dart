import 'package:flutter/material.dart';
import 'package:graduationproject/app/router/app_router.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/screens/user/profile/setting_profile/preferences.dart';
import 'package:graduationproject/screens/user/profile/edit_profile_screen.dart';
import 'package:graduationproject/screens/user/teardsman/profile/tradesman_edit_profile_screen.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/screens/user/profile/profile_login_details_screen.dart';
import 'package:graduationproject/screens/user/profile/setting_profile/notifications.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  void _showLogoutDialog() {
    final t = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          t.tr(en: "Logout", ar: "تسجيل الخروج"),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          t.tr(
            en: "Are you sure you want to log out?",
            ar: "هل أنت متأكد أنك تريد تسجيل الخروج؟",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel, style: const TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.roleSelection, 
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(
              t.tr(en: "Logout", ar: "خروج"),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.settings,
          style: TextStyle(color: onSurfaceColor, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor, size: 20),
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
              style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            
            _buildSettingItem(
              icon: Icons.person_outline,
              title: t.tr(en: "Profile Settings", ar: "إعدادات الملف الشخصي"),
              onTap: () {
                final isTradesman =
                    RecruitmentSyncStore.instance.userRole == 'Tradesman';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => isTradesman
                        ? const TradesmanEditProfileScreen()
                        : const EditProfileScreen(),
                  ),
                );
              },
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
            _buildSettingItem(
              icon: Icons.lock_outline,
              title: t.tr(en: "Account Security", ar: "أمان الحساب"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen())),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
            _buildSettingItem(
              icon: Icons.notifications_none_outlined,
              title: t.notifications,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Notifications())),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
            _buildSettingItem(
              icon: Icons.tune_outlined,
              title: t.tr(en: "Preferences", ar: "التفضيلات"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Preferences())),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),

            const SizedBox(height: 40),
            _buildSettingItem(
              icon: Icons.logout,
              title: t.tr(en: "Logout", ar: "تسجيل الخروج"),
              titleColor: Colors.redAccent,
              showArrow: false,
              onTap: _showLogoutDialog,
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
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
    required bool isDark,
    required Color onSurfaceColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: onSurfaceColor.withValues(alpha: 0.1)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        title: Text(title, style: TextStyle(color: titleColor ?? onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.5), fontSize: 12)) : null,
        trailing: showArrow ? Icon(Icons.arrow_forward_ios, color: onSurfaceColor.withValues(alpha: 0.3), size: 14) : null,
      ),
    );
  }
}
