import 'package:flutter/material.dart';
import '../Tradesman_Messages/messages_List.dart';
import '../home/find_jobs.dart';
import '../home/tradesman_my_apps_screen.dart';
import '../home/tradesman_saved_jobs.dart';
import '../profile/tradesman_profile.dart';

class Navbotton extends StatefulWidget {
  const Navbotton({super.key});

  @override
  State<Navbotton> createState() => _NavbottonState();
}

class _NavbottonState extends State<Navbotton> {
  int _selectedIndex = 0;

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  final List<Widget> _pages = [
    const FindJobs(), 
    const TradesmanMyAppsScreen(), // Linked to My Apps
    const MessagesList(), 
    const TradesmanSavedJobs(),
    const TradesmanProfile(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.white,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: _isAr ? 'اكتشف' : 'Discover',
          ),
          NavigationDestination(
            icon: const Icon(Icons.fact_check),
            label: _isAr ? 'تقديماتي' : 'My Apps',
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble),
            label: _isAr ? 'الرسائل' : 'Messages',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bookmark),
            label: _isAr ? 'المحفوظة' : 'Saved',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: _isAr ? 'البروفايل' : 'Profile',
          ),
        ],
      ),
    );
  }
}
