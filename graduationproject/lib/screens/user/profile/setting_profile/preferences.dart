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

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: "Edit Profile", ar: "تعديل الملف الشخصي"),
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward_ios : Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
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
                  }),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Account Security", ar: "أمان الحساب"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfileLoginDetailsScreen()));
                  }),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Notification", ar: "الإشعارات"), false, () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                  }),
                  const SizedBox(width: 20),
                  _buildTabItem(t.tr(en: "Preferences", ar: "التفضيلات"), true, () {}),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 30),



            

            // App Settings
            Text(t.tr(en: "App Settings", ar: "إعدادات التطبيق"), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _buildAppSettingItem(
              icon: Icons.language,
              title: t.language,
              subtitle: isAr ? "العربية" : "English",
              onTap: () => _showLanguageDialog(context, t),
            ),
            const SizedBox(height: 15),
            _buildAppSettingItem(
              icon: Icons.palette_outlined,
              title: t.appearance,
              subtitle: ThemeController.instance.themeMode.value == ThemeMode.dark ? t.dark : t.light,
              onTap: () => _showThemeDialog(context, t),
            ),

            const SizedBox(height: 60),
            const Divider(color: Colors.black12, height: 1),
            const SizedBox(height: 30),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: Align(
                alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Preferences Saved Successfully!")),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF49769F),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text(t.tr(en: "Save Profile", ar: "حفظ الملف الشخصي"), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
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
              color: isActive ? const Color(0xFF49769F) : Colors.black38, 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal, 
              fontSize: 14,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 2,
              width: 60,
              color: const Color(0xFF49769F),
            ),
        ],
      ),
    );
  }

  Widget _buildAppSettingItem({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFF49769F).withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: const Color(0xFF49769F), size: 20),
        ),
        title: Text(title, style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.black38, fontSize: 12)),
        trailing: const Icon(Icons.keyboard_arrow_down, color: Colors.black26, size: 20),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, AppLocalizations t) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF9F5F1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.language, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: const Text("العربية"),
              trailing: t.isAr ? const Icon(Icons.check, color: Color(0xFF49769F)) : null,
              onTap: () {
                if (!t.isAr) LocaleController.instance.toggle();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: const Text("English"),
              trailing: !t.isAr ? const Icon(Icons.check, color: Color(0xFF49769F)) : null,
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
      backgroundColor: const Color(0xFFF9F5F1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(t.appearance, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ListTile(
              title: Text(t.light),
              trailing: ThemeController.instance.themeMode.value == ThemeMode.light ? const Icon(Icons.check, color: Color(0xFF49769F)) : null,
              onTap: () {
                ThemeController.instance.setLight();
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: Text(t.dark),
              trailing: ThemeController.instance.themeMode.value == ThemeMode.dark ? const Icon(Icons.check, color: Color(0xFF49769F)) : null,
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

