import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
        color: Theme.of(context).colorScheme.primary,
        buttonBackgroundColor: Theme.of(context).brightness == Brightness.dark 
            ? const Color(0xFF001E3A) 
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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




