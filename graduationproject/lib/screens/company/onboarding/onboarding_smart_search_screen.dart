// Onboarding: smart search positioning before app shell.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyOnboardingSmartSearchScreen extends StatelessWidget {
  const CompanyOnboardingSmartSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      showBack: true,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Spacer(),
            Image.asset(
              AppImages.companyOnboarding1,
              height: 260,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 22),
            Text(
              t.companyTr(
                'onboarding.title1',
                fallbackEn: 'Your Next Job Is Closer Than\nYou Think',
                fallbackAr: 'وظيفتك القادمة أقرب مما\nتتوقع',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              t.companyTr(
                'onboarding.subtitle1',
                fallbackEn:
                    'Thousands of job opportunities are waiting\nfor you',
                fallbackAr: 'آلاف فرص العمل في انتظارك',
              ),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 16,
              ),
            ),
            const Spacer(),
            AppButton(
              label: t.companyTr(
                'next',
                fallbackEn: 'Next',
                fallbackAr: 'التالي',
              ),
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(AppRoutes.companyOnboardingNextJobCloser),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
