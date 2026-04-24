import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/state/theme_controller.dart';
import '../help/help_center_screen.dart';

class RecruitmentUserSettingsScreen extends StatelessWidget {
  const RecruitmentUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final localeController = LocaleController.instance;
    final themeController = ThemeController.instance;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        title: Text(t.settings),
        backgroundColor: const Color(0xFFF9F5F1),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.appearance, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController.themeMode,
            builder: (context, mode, _) => Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(t.light),
                    trailing: mode == ThemeMode.light
                        ? const Icon(Icons.check)
                        : null,
                    onTap: themeController.setLight,
                  ),
                  ListTile(
                    title: Text(t.dark),
                    trailing:
                        mode == ThemeMode.dark ? const Icon(Icons.check) : null,
                    onTap: themeController.setDark,
                  ),
                  ListTile(
                    title: Text(t.systemMode),
                    trailing: mode == ThemeMode.system
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () =>
                        themeController.themeMode.value = ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(t.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ValueListenableBuilder<Locale>(
            valueListenable: localeController.locale,
            builder: (context, locale, _) => Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text(t.english),
                    trailing: locale.languageCode == 'en'
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      if (locale.languageCode != 'en') localeController.toggle();
                    },
                  ),
                  ListTile(
                    title: Text(t.arabic),
                    trailing: locale.languageCode == 'ar'
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () {
                      if (locale.languageCode != 'ar') localeController.toggle();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Text(t.helpCenter),
                  leading: const Icon(Icons.help_outline),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const HelpScreen()),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(
                    t.tr(en: "Logout", ar: "تسجيل الخروج"),
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  onTap: () => _showLogoutDialog(context, t),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AppLocalizations t) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.tr(en: "Logout", ar: "تسجيل الخروج")),
        content: Text(t.tr(
          en: "Are you sure you want to log out of your account?",
          ar: "هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟",
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.roleSelection,
                (route) => false,
              );
            },
            child: Text(
              t.tr(en: "Logout", ar: "خروج"),
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
