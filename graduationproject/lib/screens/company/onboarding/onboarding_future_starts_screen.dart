import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyOnboardingFutureStartsScreen extends StatelessWidget {
  const CompanyOnboardingFutureStartsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBack: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              AppImages.companyOnboarding3,
              height: 260,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 22),
            Text(
              'Your Future Starts Here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                fontSize: 24,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              'Take the next step toward your\ndream job All in one app',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Get Started',
              onPressed: () => Navigator.of(context).pushReplacementNamed(
                AppRoutes.companySignIn,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

