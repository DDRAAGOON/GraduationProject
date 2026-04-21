import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentOnboardingScreen extends StatelessWidget {
  const RecruitmentOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'Find Work Faster',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                'Discover verified companies, apply in one tap, and track every hiring stage in real time.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const Spacer(),
              AppButton(
                label: 'Continue To Sign In',
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.userWorkspace),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
