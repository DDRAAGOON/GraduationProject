import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/locale_controller.dart';
import '../../../shared/state/theme_controller.dart';
import '../core/app_colors.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _isLanguageExpanded = false;
  bool _isThemeExpanded = false;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final localeController = LocaleController.instance;
    final themeController = ThemeController.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          t.settings,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              t.isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios,
              color: Colors.white,
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
              style: const TextStyle(
                color: Colors.white70,
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
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isLanguageExpanded
                              ? const Color(0xFF49769F)
                              : Colors.white12,
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
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    t.isAr ? t.arabic : t.english,
                                    style: const TextStyle(
                                      color: Colors.white,
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
                        color: Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white10),
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
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isThemeExpanded
                              ? const Color(0xFF49769F)
                              : Colors.white12,
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
                                    style: const TextStyle(
                                      color: Colors.white38,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    _getThemeName(
                                      themeController.themeMode.value,
                                      t,
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
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
          ],
        ),
      ),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(color: Colors.white38, fontSize: 12),
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
                    color: isSelected ? const Color(0xFF49769F) : Colors.white38,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF49769F) : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFF49769F), size: 20),
            ] else ...[
              if (isSelected)
                const Icon(Icons.check, color: Color(0xFF49769F), size: 20),
              Row(
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF49769F) : Colors.white70,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    icon,
                    color: isSelected ? const Color(0xFF49769F) : Colors.white38,
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
}
