import 'package:flutter/material.dart';
import '../../app/router/app_router.dart';
import '../../constants/app_images.dart';
import '../../shared/l10n/app_localizations.dart';

/// First launch: choose Job seeker (User) or Recruiter (Company), then each flow’s onboarding.
class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.08),
              Text(
                'JOBITO',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: cs.primary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find your next role or hire top talent faster.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.84,
                    maxHeight: size.height * 0.38,
                  ),
                  child: Image.asset(
                    AppImages.jobito,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => Icon(
                      Icons.work_outline_rounded,
                      size: size.width * 0.22,
                      color: const Color(0xFF1B2D4F),
                    ),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              _RoleButton(
                label: t.userTr(
                  'role.user',
                  fallbackEn: 'User',
                  fallbackAr: 'مستخدم',
                ),
                color: cs.primary,
                onTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.userOnboardingNew),
              ),
              SizedBox(height: size.height * 0.022),
              _RoleButton(
                label: t.companyTr(
                  'role.company',
                  fallbackEn: 'Company',
                  fallbackAr: 'شركة',
                ),
                color: cs.secondary,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed(AppRoutes.companyOnboardingNew),
              ),
              SizedBox(height: size.height * 0.012),
              TextButton.icon(
                onPressed: () =>
                    Navigator.of(context).pushNamed(AppRoutes.adminPanel),
                icon: const Icon(Icons.admin_panel_settings_outlined),
                label: const Text('Admin'),
              ),
              SizedBox(height: size.height * 0.07),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleButton extends StatelessWidget {
  const _RoleButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
