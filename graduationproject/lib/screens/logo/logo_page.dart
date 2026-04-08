import 'package:flutter/material.dart';
import '../../app/router/app_router.dart';
import '../../constants/app_images.dart';

/// First launch: choose Job seeker (User) or Recruiter (Company), then each flow’s onboarding.
class LogoPage extends StatelessWidget {
  const LogoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEAEEF2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: Column(
            children: [
              SizedBox(height: size.height * 0.18),
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
              _RoleButton(
                label: 'User',
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B2D4F), Color(0xFF2E4A7A)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.userOnboarding,
                ),
              ),
              SizedBox(height: size.height * 0.022),
              _RoleButton(
                label: 'Company',
                gradient: const LinearGradient(
                  colors: [Color(0xFF4A6080), Color(0xFF7A9AB8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.companyOnboardingSmartSearch,
                ),
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
    required this.gradient,
    required this.onTap,
  });

  final String label;
  final Gradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
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
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
