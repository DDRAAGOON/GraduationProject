import 'package:flutter/material.dart';
import '../../../../app/router/app_router.dart';
import '../../../../../shared/l10n/app_localizations.dart';
import '../../../../../shared/state/locale_controller.dart';
import '../../../../../shared/state/theme_controller.dart';
import '../../help/help_center_screen.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _isLanguageExpanded = false;
  bool _isThemeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final localeController = LocaleController.instance;
    final themeController = ThemeController.instance;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          t.settings,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              t.isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSurface,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              t.isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              t.preferences,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Language Section
            _buildSectionCard(
              title: t.language,
              subtitle: t.isAr ? t.arabic : t.english,
              icon: Icons.language,
              isAr: t.isAr,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(
                      () => _isLanguageExpanded = !_isLanguageExpanded,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withValues(alpha: 0.05) 
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isLanguageExpanded
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            _isLanguageExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: t.isAr
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.language,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    t.isAr ? t.arabic : t.english,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.public, color: Colors.white70),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isLanguageExpanded) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withValues(alpha: 0.03) 
                            : Colors.black.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                      ),
                      child: Column(
                        children: [
                          _buildOptionItem(
                            t.arabic,
                            Icons.language,
                            t.isAr,
                            t.isAr,
                            (_) {
                              if (!t.isAr) {
                                localeController.toggle();
                                setState(() => _isLanguageExpanded = false);
                              }
                            },
                          ),
                          const Divider(color: Colors.white10, height: 1),
                          _buildOptionItem(
                            t.english,
                            Icons.language,
                            !t.isAr,
                            t.isAr,
                            (_) {
                              if (t.isAr) {
                                localeController.toggle();
                                setState(() => _isLanguageExpanded = false);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Theme Section
            _buildSectionCard(
              title: t.appearance,
              subtitle: _getThemeName(themeController.themeMode.value, t),
              icon: Icons.palette_outlined,
              isAr: t.isAr,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(
                      () => _isThemeExpanded = !_isThemeExpanded,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark 
                            ? Colors.white.withValues(alpha: 0.05) 
                            : Colors.black.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isThemeExpanded
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).dividerColor.withValues(alpha: 0.12),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            _isThemeExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.white54,
                          ),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: t.isAr
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    t.appearance,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _getThemeName(
                                      themeController.themeMode.value,
                                      t,
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.palette, color: Colors.white70),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isThemeExpanded) ...[
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        children: [
                          _buildOptionItem(
                            t.light,
                            Icons.wb_sunny_outlined,
                            themeController.themeMode.value == ThemeMode.light,
                            t.isAr,
                            (val) {
                              themeController.setLight();
                              setState(() => _isThemeExpanded = false);
                            },
                          ),
                          const Divider(color: Colors.white10, height: 1),
                          _buildOptionItem(
                            t.dark,
                            Icons.nightlight_round_outlined,
                            themeController.themeMode.value == ThemeMode.dark,
                            t.isAr,
                            (val) {
                              themeController.setDark();
                              setState(() => _isThemeExpanded = false);
                            },
                          ),
                          const Divider(color: Colors.white10, height: 1),
                          _buildOptionItem(
                            t.systemMode,
                            Icons.settings_brightness_outlined,
                            themeController.themeMode.value == ThemeMode.system,
                            t.isAr,
                            (val) {
                              themeController.themeMode.value =
                                  ThemeMode.system;
                              setState(() => _isThemeExpanded = false);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Logout Section
            _buildLogoutButton(context, t),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HelpScreen()),
            );
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 4,
          child: const Icon(Icons.help_outline, color: Colors.white, size: 20),
        ),
      ),
      floatingActionButtonLocation: t.isAr 
          ? FloatingActionButtonLocation.endFloat 
          : FloatingActionButtonLocation.startFloat,
    );
  }

  String _getThemeName(ThemeMode mode, AppLocalizations t) {
    switch (mode) {
      case ThemeMode.light:
        return t.light;
      case ThemeMode.dark:
        return t.dark;
      case ThemeMode.system:
        return t.systemMode;
    }
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
    required bool isAr,
  }) {
    return Column(
      crossAxisAlignment:
          isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isAr) ...[
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF094174).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF49769F), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF094174).withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF49769F), size: 22),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildOptionItem(
    String label,
    IconData icon,
    bool isSelected,
    bool isAr,
    Function(String) onTap,
  ) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF49769F).withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!isAr) ...[
              Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20),
            ] else ...[
              if (isSelected)
                Icon(Icons.check, color: Theme.of(context).colorScheme.primary, size: 20),
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    icon,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                    size: 20,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AppLocalizations t) {
    return GestureDetector(
      onTap: () {
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
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, color: Colors.redAccent),
            const SizedBox(width: 10),
            Text(
              t.tr(en: "Logout", ar: "تسجيل الخروج"),
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
