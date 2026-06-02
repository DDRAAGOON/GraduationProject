import '../../../../app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'sign_up_screen.dart';
import 'sign_up_tradesman.dart';

class UserRoleSelectionScreen extends StatelessWidget {
  const UserRoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person_pin_circle_outlined, size: 80, color: Color(0xFF4A6ED1)),
              const SizedBox(height: 30),
              Text(
                t.tr(en: "Welcome to Jobito!", ar: "أهلاً بك في جوبيتو!"),
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                t.tr(
                  en: "To give you the best experience, please tell us how you want to use the app.",
                  ar: "لتقديم أفضل تجربة لك، أخبرنا كيف تود استخدام التطبيق."
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
              ),
              const SizedBox(height: 50),
              _buildRoleCard(
                context,
                title: t.tr(en: "I'm looking for a Job", ar: "أنا أبحث عن وظيفة"),
                subtitle: t.tr(en: "Find professional opportunities and track applications.", ar: "ابحث عن فرص مهنية وتتبع طلبات التوظيف."),
                icon: Icons.search_rounded,
                color: const Color(0xFF4A6ED1),
                onTap: () => Navigator.pushNamed(context, AppRoutes.userSignUpSeeker),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context,
                title: t.tr(en: "I'm a Tradesman", ar: "أنا صنايعي / محترف"),
                subtitle: t.tr(en: "Showcase your skills and find service requests.", ar: "اعرض مهاراتك واحصل على طلبات الخدمات."),
                icon: Icons.handyman_rounded,
                color: const Color(0xFFFF7A2A),
                onTap: () => Navigator.pushNamed(context, AppRoutes.userSignUpTradesman),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, {required String title, required String subtitle, required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
