import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/services/session_manager.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/state/theme_controller.dart';

class RecruitmentUserSettingsScreen extends StatelessWidget {
  const RecruitmentUserSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = LocaleController.instance;
    final themeController = ThemeController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);
    final onSurfaceColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurfaceColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(color: onSurfaceColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: onSurfaceColor),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController.themeMode,
            builder: (context, mode, _) => Card(
              color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Light', style: TextStyle(color: onSurfaceColor)),
                    trailing: mode == ThemeMode.light ? const Icon(Icons.check, color: Color(0xFFFF7A2A)) : null,
                    onTap: themeController.setLight,
                  ),
                  ListTile(
                    title: Text('Dark', style: TextStyle(color: onSurfaceColor)),
                    trailing: mode == ThemeMode.dark ? const Icon(Icons.check, color: Color(0xFFFF7A2A)) : null,
                    onTap: themeController.setDark,
                  ),
                  ListTile(
                    title: Text('System', style: TextStyle(color: onSurfaceColor)),
                    trailing: mode == ThemeMode.system ? const Icon(Icons.check, color: Color(0xFFFF7A2A)) : null,
                    onTap: () => themeController.themeMode.value = ThemeMode.system,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Language',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: onSurfaceColor),
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<Locale>(
            valueListenable: localeController.locale,
            builder: (context, locale, _) => Card(
              color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
              child: Column(
                children: [
                  ListTile(
                    title: Text('English', style: TextStyle(color: onSurfaceColor)),
                    trailing: locale.languageCode == 'en' ? const Icon(Icons.check, color: Color(0xFFFF7A2A)) : null,
                    onTap: () {
                      if (locale.languageCode != 'en') localeController.toggle();
                    },
                  ),
                  ListTile(
                    title: Text('العربية', style: TextStyle(color: onSurfaceColor)),
                    trailing: locale.languageCode == 'ar' ? const Icon(Icons.check, color: Color(0xFFFF7A2A)) : null,
                    onTap: () {
                      if (locale.languageCode != 'ar') localeController.toggle();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          Card(
            color: isDark ? const Color(0xFF0D2D4D) : Colors.white,
            child: ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              onTap: () async {
                await SessionManager.logoutUser();
                await RecruitmentSyncService.instance.logout();
                if (context.mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.roleSelection, (route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}