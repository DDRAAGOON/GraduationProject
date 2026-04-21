import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentUserOnboardingScreen extends StatefulWidget {
  const RecruitmentUserOnboardingScreen({super.key});

  @override
  State<RecruitmentUserOnboardingScreen> createState() =>
      _RecruitmentUserOnboardingScreenState();
}

class _RecruitmentUserOnboardingScreenState
    extends State<RecruitmentUserOnboardingScreen> {
  final PageController _controller = PageController();
  int _index = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: 'Find Jobs That Match You',
      subtitle: 'Search with filters by role, location, and salary.',
      icon: Icons.search_rounded,
    ),
    _OnboardingItem(
      title: 'Apply With Full Profile',
      subtitle: 'Send CV, portfolio, and cover letter in one flow.',
      icon: Icons.assignment_turned_in_rounded,
    ),
    _OnboardingItem(
      title: 'Track Every Hiring Stage',
      subtitle: 'Get live updates from review to interview and offer.',
      icon: Icons.timeline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _items.length,
                onPageChanged: (value) => setState(() => _index = value),
                itemBuilder: (context, i) {
                  final item = _items[i];
                  return Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor:
                              Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                          child: Icon(item.icon, size: 58),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ...List.generate(
                    _items.length,
                    (i) => Container(
                      width: 24,
                      height: 6,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: i == _index
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 180,
                    child: AppButton(
                      label: _index == _items.length - 1 ? 'Get Started' : 'Next',
                      onPressed: () {
                        if (_index == _items.length - 1) {
                          Navigator.of(context)
                              .pushReplacementNamed(AppRoutes.userSignInNew);
                          return;
                        }
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}
