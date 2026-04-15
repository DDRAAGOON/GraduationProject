import 'package:flutter/material.dart';
import '../auth/sign_in_screen.dart';
import 'onboarding_future_starts_screen.dart';
import 'onboarding_next_job_closer_screen.dart';
import 'onboarding_smart_search_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
        children: [
          Screen1(onNext: _nextPage, currentPage: _currentPage),
          Screen2(onNext: _nextPage, currentPage: _currentPage),
          Screen3(onNext: _nextPage, currentPage: _currentPage),
        ],
      ),
    );
  }
}
