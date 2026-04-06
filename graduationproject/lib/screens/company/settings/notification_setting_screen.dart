import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyNotificationSettingScreen extends StatelessWidget {
  const CompanyNotificationSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Setting',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(AppRoutes.companyAppearanceDark),
              child: const Text('Appearance'),
            ),
            const SizedBox(height: 14),
            Text(
              'This screen is intentionally minimal in the design.\nUse it as an entry to notification preferences.',
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

