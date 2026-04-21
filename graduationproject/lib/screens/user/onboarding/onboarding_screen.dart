import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../constants/app_images.dart';
import '../auth/sign_in_screen.dart';
import '../core/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final onboardingData = [
      {
        'image': AppImages.companyOnboarding1,
        'title': t.userTr('onboarding.title1',
            fallbackEn: "Your Next Job Is Closer Than\nYou Think",
            fallbackAr: "وظيفتك القادمة أقرب مما\nتتوقع"),
        'description': t.userTr('onboarding.subtitle1',
            fallbackEn: "Thousands of job opportunities are waiting\nfor you",
            fallbackAr: "آلاف فرص العمل في انتظارك"),
      },
      {
        'image': AppImages.companyOnboarding2,
        'title': t.userTr('onboarding.title2',
            fallbackEn: "Smart Search & Better\nOpportunities",
            fallbackAr: "بحث ذكي وفرص\nأفضل"),
        'description': t.userTr('onboarding.subtitle2',
            fallbackEn: "Save time and focus on what \nmatters",
            fallbackAr: "وفر وقتك وركز على ما يهم"),
      },
      {
        'image': AppImages.companyOnboarding3,
        'title': t.userTr('onboarding.title3',
            fallbackEn: "Your Future Starts Here",
            fallbackAr: "مستقبلك يبدأ من هنا"),
        'description': t.userTr('onboarding.subtitle3',
            fallbackEn: "Thousands of job opportunities are waiting\nfor you",
            fallbackAr: "آلاف فرص العمل في انتظارك"),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: onboardingData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),
                        Image.asset(
                          onboardingData[index]['image']!,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image,
                                size: 100, color: Colors.white);
                          },
                        ),
                        const Spacer(flex: 2),
                        Text(
                          onboardingData[index]['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          onboardingData[index]['description']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => _buildIndicator(isActive: index == _currentPage),
                    ),
                  ),
                  _buildNextButton(t),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage(int count) {
    if (_currentPage < count - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  Widget _buildNextButton(AppLocalizations t) {
    return GestureDetector(
      onTap: () => _nextPage(3),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0A2A4A), // Dark
              Color(0xFF2F5F8F), // Light
              Color.fromARGB(255, 118, 159, 178),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(70),
            bottomLeft: Radius.circular(25),
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(70),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          t.next,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 6),
      width: isActive ? 32 : 12,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color(0xFF0A335E),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

