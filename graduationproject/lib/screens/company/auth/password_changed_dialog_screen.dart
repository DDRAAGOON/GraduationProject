import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyPasswordChangedDialogScreen extends StatelessWidget {
  const CompanyPasswordChangedDialogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBack: false,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    ),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 44,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Password Changed',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Password changed successfully, you can login again\nwith a new password',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                  ),
                  const SizedBox(height: 18),
                  AppButton(
                    label: 'Back to Sign in',
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                      AppRoutes.companySignIn,
                      (r) => false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

