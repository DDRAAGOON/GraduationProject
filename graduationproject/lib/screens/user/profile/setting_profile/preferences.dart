import 'package:flutter/material.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/state/locale_controller.dart';
import '../../../../shared/state/theme_controller.dart';
import '../edit_profile_screen.dart';
import '../profile_login_details_screen.dart';
import 'notifications.dart';

class Preferences extends StatefulWidget {
  const Preferences({super.key});

  @override
  State<Preferences> createState() => _PreferencesState();
}

class _PreferencesState extends State<Preferences> {
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
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(color: onSurfaceColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildTabItem(t.tr(en: "Profile Setting", ar: "إعدادات الملف"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                  }, isDark, onSurfaceColor),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Account Security", ar: "أمان الحساب"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()));
                  }, isDark, onSurfaceColor),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Notification", ar: "الإشعارات"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                  }, isDark, onSurfaceColor),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Preferences", ar: "التفضيلات"), true, () {}, isDark, onSurfaceColor),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Divider(color: onSurfaceColor.withValues(alpha: 0.12), height: 1),
            const SizedBox(height: 30),

            // App Settings
            Text(t.tr(en: "App Settings", ar: "إعدادات التطبيق"), style: TextStyle(color: onSurfaceColor, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _buildAppSettingItem(
              icon: Icons.language,
              title: t.language,
              subtitle: isAr ? "العربية" : "English",
              onTap: () => _showLanguageDialog(context, t),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),
            const SizedBox(height: 15),
            _buildAppSettingItem(
              icon: Icons.palette_outlined,
              title: t.appearance,
              subtitle: ThemeController.instance.themeMode.value == ThemeMode.dark ? t.dark : t.light,
              onTap: () => _showThemeDialog(context, t),
              isDark: isDark,
              onSurfaceColor: onSurfaceColor,
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, bool isActive, VoidCallback onTap, bool isDark, Color onSurfaceColor) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: isActive ? Theme.of(context).colorScheme.primary : onSurfaceColor.withValues(alpha: 0.5), 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
              fontSize: 14,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
        ],
      ),
    );
  }

  Widget _buildAppSettingItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap, required bool isDark, required Color onSurfaceColor}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: onSurfaceColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        ),
        title: Text(title, style: TextStyle(color: onSurfaceColor, fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(color: onSurfaceColor.withValues(alpha: 0.6), fontSize: 12)),
        trailing: Icon(Icons.keyboard_arrow_down, color: onSurfaceColor.withValues(alpha: 0.3), size: 20),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.language, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("العربية"),
              trailing: t.isAr ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                if (!t.isAr) LocaleController.instance.toggle();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: const Text("English"),
              trailing: !t.isAr ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                if (t.isAr) LocaleController.instance.toggle();
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.appearance, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: Text(t.light, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              trailing: ThemeController.instance.themeMode.value == ThemeMode.light ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                ThemeController.instance.setLight();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text(t.dark, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
              trailing: ThemeController.instance.themeMode.value == ThemeMode.dark ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
              onTap: () {
                ThemeController.instance.setDark();
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
