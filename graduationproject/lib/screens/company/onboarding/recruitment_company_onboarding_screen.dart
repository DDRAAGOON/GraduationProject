import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/theme_controller.dart';

class RecruitmentCompanyOnboardingScreen extends StatefulWidget {
  const RecruitmentCompanyOnboardingScreen({super.key});

  @override
  State<RecruitmentCompanyOnboardingScreen> createState() =>
      _RecruitmentCompanyOnboardingScreenState();
}

class _RecruitmentCompanyOnboardingScreenState
    extends State<RecruitmentCompanyOnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.companySignInNew);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          _CompanyOnboardingSlide(
            titleEn: 'Post Open Roles Quickly',
            titleAr: 'انشر الوظائف بسرعة',
            subtitleEn:
                'Create jobs with smart fields and reach candidates instantly.',
            subtitleAr: 'أنشئ وظائف بحقول ذكية وصل للمرشحين فوراً.',
            image: 'assets/company/Onboarding/Onboarding-1.png',
            icon: Icons.post_add_rounded,
            onNext: _nextPage,
            currentPage: _currentPage,
          ),
          _CompanyOnboardingSlide(
            titleEn: 'Manage Candidate Pipeline',
            titleAr: 'إدارة خط توظيف المرشحين',
            subtitleEn: 'Move applicants through review, shortlist, and hire.',
            subtitleAr:
                'انقل المتقدمين عبر المراجعة والقائمة المختصرة والتوظيف.',
            image: 'assets/company/Onboarding/Onboarding-2.png',
            icon: Icons.groups_2_rounded,
            onNext: _nextPage,
            currentPage: _currentPage,
          ),
          _CompanyOnboardingSlide(
            titleEn: 'Sync Updates With Candidates',
            titleAr: 'مزامنة التحديثات مع المرشحين',
            subtitleEn:
                'Every status update and message appears in candidate timeline.',
            subtitleAr: 'يظهر كل تحديث للحالة ورسالة في الجدول الزمني للمرشح.',
            image: 'assets/company/Onboarding/Onboarding-3.png',
            icon: Icons.sync_alt_rounded,
            onNext: _nextPage,
            currentPage: _currentPage,
          ),
        ],
      ),
    );
  }
}

class _CompanyOnboardingSlide extends StatelessWidget {
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String image;
  final IconData icon;
  final VoidCallback onNext;
  final int currentPage;

  const _CompanyOnboardingSlide({
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.image,
    required this.icon,
    required this.onNext,
    required this.currentPage,
  });

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
              // The diagonal background image (same as user onboarding)
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
                    // Illustration
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Center(
                        child: Image.asset(
                          image,
                          height: size.height * 0.3,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(icon, size: 100, color: Colors.white),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                    // Text Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            t.tr(en: titleEn, ar: titleAr),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFF17C21),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            t.tr(en: subtitleEn, ar: subtitleAr),
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
                    // Navigation Area
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
                              (index) => _buildIndicator(
                                isActive: index == currentPage,
                              ),
                            ),
                          ),
                          _buildNextButton(onNext, t),
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
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: const Color(0xFFF17C21).withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
    );
  }
}
