import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../analysis/analysis_screen.dart';
import '../messages/messages_list_screen.dart';
import '../profile/profile_overview_screen.dart';
import 'technical_screen.dart';
import '../core/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const TechnicalScreen(),
    const MessagesListScreen(),
    const ProfileOverviewScreen(),
    const AnalysisScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 65.0,
        items: const <Widget>[
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.chat_rounded, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
          Icon(Icons.analytics_rounded, size: 30, color: Colors.white),
        ],
        color: const Color(0xFF49769F),
        buttonBackgroundColor: const Color(0xFF001E3A),
        backgroundColor: AppColors.background,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 400),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

