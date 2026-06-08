import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';

class CompanyOnboardingSmartSearchScreen extends StatelessWidget {
  const CompanyOnboardingSmartSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final size = MediaQuery.sizeOf(context);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        final isDark =
            themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system &&
                MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        return Scaffold(
          backgroundColor: isDark
              ? const Color(0xFF001E3A)
              : const Color(0xFFF8FBF4),
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/tradesman/Rectangle 4127.png',
                  width: size.width,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, _, _) => Container(
                    height: size.height * 0.5,
                    color: const Color(0xFFF17C21),
                  ),
                ),
              ),

              SafeArea(
                child: Column(
                  children: [
                    const Spacer(flex: 40),
                    Center(
                      child: Image.asset(
                        'assets/company/Onboarding/Onboarding-1.png',
                        height: size.height * 0.3,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.post_add_rounded,
                              size: 100,
                              color: Colors.white,
                            ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            t.tr(
                              en: 'Post Open Roles Quickly',
                              ar: 'انشر الوظائف بسرعة',
                            ),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFF17C21),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.tr(
                              en: 'Create jobs with smart fields and reach candidates instantly.',
                              ar: 'أنشئ وظائف بحقول ذكية وصل للمرشحين فوراً.',
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 3),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: List.generate(
                              3,
                              (index) => _buildIndicator(isActive: index == 0),
                            ),
                          ),
                          _buildNextButton(() {
                            Navigator.of(context).pushNamed(
                              AppRoutes.companyOnboardingNextJobCloser,
                            );
                          }, t),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextButton(VoidCallback onPressed, AppLocalizations t) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF142C66),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 5,
      ),
      child: Text(
        t.tr(en: 'Next', ar: 'التالي'),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      width: isActive ? 28 : 12,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF17C21) : Colors.white70,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
