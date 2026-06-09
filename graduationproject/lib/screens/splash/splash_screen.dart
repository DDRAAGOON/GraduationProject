import 'package:flutter/material.dart';
import '../../app/router/app_router.dart';
import '../../core/network/secure_storage.dart';
import '../../shared/widgets/app_button.dart';

/// Splash screen shown at launch.
///
/// In [initState] we asynchronously check [SecureStorage] for a stored JWT.
/// - **Token found** → push-replace directly to [CompanyDashboardScreen].
/// - **No token** → show the normal onboarding / "Get Started" view.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _checking = true; // true while we read from SecureStorage

  @override
  void initState() {
    super.initState();
    _checkPersistedSession();
  }

  Future<void> _checkPersistedSession() async {
    try {
      final token = await SecureStorage.getToken();
      if (!mounted) return;

      if (token != null && token.isNotEmpty) {
        // A valid-looking token exists → go straight to the dashboard.
        Navigator.of(context).pushReplacementNamed(AppRoutes.companyDashboard);
        return;
      }
    } catch (_) {
      // If storage fails for any reason, fall through to the normal splash.
    }

    // No token found – show the "Get Started" UI.
    if (mounted) setState(() => _checking = false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    // While we're checking storage show a minimal loading indicator so the
    // white screen is never visible for more than a fraction of a second.
    if (_checking) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDFCF9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFDFCF9),
      body: Column(
        children: [
          Image.asset(
            'assets/company/Onboarding/image 42 1.png',
            fit: BoxFit.contain,
            width: double.infinity,
            height: size.height * 0.38,
            errorBuilder: (context, error, stackTrace) => Container(
              height: size.height * 0.38,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, size: 50),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 120,
                    left: 10,
                    child: Image.asset(
                      'assets/company/Onboarding/Vector 2355.png',
                      width: 150,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: 100,
                    right: -10,
                    child: Image.asset(
                      'assets/company/Onboarding/Rectangle 2730 (Stroke).png',
                      width: 180,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: 180,
                    left: -20,
                    child: Image.asset(
                      'assets/company/Onboarding/Rectangle 2733.png',
                      width: 240,
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            fontFamily: 'Muli',
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: 'Find '),
                            const TextSpan(
                              text: 'your ',
                              style: TextStyle(color: Color(0xFF4A80D4)),
                            ),
                            const TextSpan(
                              text: 'dream job ',
                              style: TextStyle(color: Color(0xFFF28F44)),
                            ),
                          ],
                        ),
                      ),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            color: Colors.black,
                          ),
                          children: [
                            const TextSpan(text: 'on '),
                            const TextSpan(
                              text: 'Jobito',
                              style: TextStyle(color: Color(0xFFF28F44)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
            child: AppButton(
              label: 'Get Started',
              onPressed: () {
                Navigator.of(
                  context,
                ).pushReplacementNamed(AppRoutes.roleSelection);
              },
            ),
          ),
        ],
      ),
    );
  }
}
