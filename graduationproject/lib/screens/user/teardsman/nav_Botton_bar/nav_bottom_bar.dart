import 'package:flutter/material.dart';
import 'package:graduationproject/screens/user/teardsman/Tradesman_Messages/messages_list.dart';
import 'package:graduationproject/screens/user/teardsman/home/find_jobs.dart';
import 'package:graduationproject/screens/user/teardsman/home/tradesman_my_apps_screen.dart';
import 'package:graduationproject/screens/user/teardsman/home/tradesman_browse_companies_screen.dart';
import 'package:graduationproject/screens/user/teardsman/profile/tradesman_profile.dart';
import 'package:graduationproject/screens/user/messages/chat_thread_screen.dart';
import 'package:graduationproject/constants/app_images.dart';

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
    const TradesmanMyAppsScreen(),
    const TradesmanBrowseCompaniesScreen(),
    const MessagesList(), 
    const TradesmanProfile(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _pages[_selectedIndex],
      floatingActionButton: _selectedIndex == 0 
        ? FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatThreadScreen(
                    name: _isAr ? 'مساعد جوبيتو الذكي' : 'Jobito AI Assistant',
                    image: AppImages.jobito,
                  ),
                ),
              );
            },
            backgroundColor: const Color(0xFF4A6ED1),
            shape: const CircleBorder(),
            child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 28),
          )
        : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Theme.of(context).cardColor,
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
            icon: const Icon(Icons.business),
            label: _isAr ? 'الشركات' : 'Companies',
          ),
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble),
            label: _isAr ? 'الرسائل' : 'Messages',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person),
            label: _isAr ? 'الملف الشخصي' : 'Profile',
          ),
        ],
      ),
    );
  }
}
