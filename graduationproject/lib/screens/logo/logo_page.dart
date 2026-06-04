import 'package:flutter/material.dart';
import '../../app/router/app_router.dart';
import '../../shared/l10n/app_localizations.dart';
import '../../shared/state/locale_controller.dart';
import '../../shared/state/theme_controller.dart';

class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        return ValueListenableBuilder<Locale>(
          valueListenable: LocaleController.instance.locale,
          builder: (context, locale, _) {
            final t = AppLocalizations.of(context);
            final isDark = themeMode == ThemeMode.dark || 
                          (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);
            
            return Scaffold(
              backgroundColor: isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4),
              body: Stack(
                children: [
                  // Main content (Top icons and Illustration)
                  SafeArea(
                    child: Column(
                      children: [
                        // Top Icons (Mode & Language)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Directionality(
                            textDirection: TextDirection.ltr, // Keep icons on the right always
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                _CircleIconButton(
                                  icon: isDark ? Icons.nightlight_outlined : Icons.wb_sunny_outlined,
                                  onPressed: () {
                                    if (isDark) {
                                      ThemeController.instance.setLight();
                                    } else {
                                      ThemeController.instance.setDark();
                                    }
                                  },
                                ),
                                const SizedBox(width: 12),
                                _CircleIconButton(
                                  icon: Icons.public,
                                  onPressed: () => LocaleController.instance.toggle(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 1),

                        // Main Illustration
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: size.height * 0.85, 
                              ),
                              child: Image.asset(
                                'assets/tradesman/Group 289310.png',
                                width: size.width,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.auto_awesome_mosaic,
                                  size: 150,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(flex: 2), 
                      ],
                    ),
                  ),

                  // Role Buttons positioned at the bottom
                  Positioned(
                    bottom: size.height * 0.1,
                    left: 45,
                    right: 45,
                    child: Column(
                      children: [
                        _GradientRoleButton(
                          text: t.userTr('role.user', fallbackEn: 'User', fallbackAr: 'مستخدم'),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.userOnboarding),
                          colors: const [Color(0xFFF77F32), Color(0xFF3955B1), Color(0xFF0F35B0)],
                        ),
                        const SizedBox(height: 16),
                        _GradientRoleButton(
                          text: t.companyTr('role.company', fallbackEn: 'Company', fallbackAr: 'شركة'),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.companyOnboardingSmartSearch),
                          colors: const [Color(0xFF0F35B0), Color(0xFF3955B1), Color(0xFFF77F32)],
                        ),
                      ],
                    ),
                  ),
                ],
              ));
          },
        );
      },
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(21),
          child: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF0F35B0), size: 20),
        ),
      ),
    );
  }
}

class _GradientRoleButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors;

  const _GradientRoleButton({
    required this.text,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F35B0).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(27),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
