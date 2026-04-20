import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import '../../core/app_colors.dart';
import '../Tradesman_Messages/messages_list.dart';
import '../home/find_jobs.dart';
import '../post/post_job.dart';
import '../profile/tradesman_profile.dart';

class Navbotton extends StatefulWidget {
  const Navbotton({super.key});

  @override
  State<Navbotton> createState() => _NavbottonState();
}

class _NavbottonState extends State<Navbotton> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const FindJobs(),
    const MessagesList(),
    const TradesmanProfile(),
    const PostJob(),
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
          Icon(Icons.add, size: 30, color: Colors.white),
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




