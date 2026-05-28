import 'package:flutter/material.dart';
import 'package:graduationproject/screens/user/teardsman/Tradesman_Messages/messages_list.dart';
import 'package:graduationproject/screens/user/teardsman/home/find_jobs.dart';
import 'package:graduationproject/screens/user/teardsman/home/tradesman_my_apps_screen.dart';
import 'package:graduationproject/screens/user/teardsman/home/tradesman_browse_companies_screen.dart';
import 'package:graduationproject/screens/user/teardsman/profile/tradesman_profile.dart';
import 'package:graduationproject/constants/app_images.dart';
import 'package:graduationproject/screens/user/home/recruitment_user_shell_screen.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/image_helper.dart';
import 'package:graduationproject/screens/user/notifications/notifications_screen.dart';
import 'package:graduationproject/screens/company/help/help_center_screen.dart';
import 'package:graduationproject/app/router/app_router.dart';
import 'package:graduationproject/shared/services/recruitment_sync_service.dart';
import '../setting/settings.dart';
import '../home/tradesman_home_screen.dart';
import '../post/post_job.dart';

class Navbotton extends StatefulWidget {
  const Navbotton({super.key});

  @override
  State<Navbotton> createState() => _NavbottonState();
}

class _NavbottonState extends State<Navbotton> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  late final List<Widget> _pages = [
    TradesmanHomeScreen(
      onTabChange: (index) => setState(() => _selectedIndex = index),
    ),
    const FindJobs(),
    const TradesmanMyAppsScreen(),
    const TradesmanBrowseCompaniesScreen(),
    const MessagesList(),
    const TradesmanProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Theme.of(context).colorScheme.onSurface,
            size: 28,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        title: _selectedIndex == 5
            ? Text(
                _isAr ? 'الملف الشخصي' : 'Profile',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              )
            : Image.asset(AppImages.jobito, height: 180),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostJob()),
            ),
            icon: Icon(
              Icons.add_box_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),
            tooltip: _isAr ? 'نشر وظيفة' : 'Post Job',
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationsScreen(),
              ),
            ),
            icon: Icon(
              Icons.notifications_outlined,
              color: Theme.of(context).colorScheme.onSurface,
              size: 26,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: _buildTradesmanDrawer(context, store),
      body: _pages[_selectedIndex],
      floatingActionButton:
          null, // Removed Chatbot icon from all pages for Tradesman
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            );
          }),
        ),
        child: NavigationBar(
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
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: _isAr ? 'الرئيسية' : 'Home',
            ),
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
      ),
    );
  }

  Widget _buildTradesmanDrawer(
    BuildContext context,
    RecruitmentSyncStore store,
  ) {
    final isAr = _isAr;
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF011931)),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: getAppImageProvider(store.profileImage),
              child: store.profileImage == null
                  ? const Icon(Icons.person, size: 40, color: Color(0xFF011931))
                  : null,
            ),
            accountName: Text(
              store.currentUserName.isNotEmpty
                  ? store.currentUserName
                  : (isAr ? 'صنايعي' : 'Tradesman'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(store.currentUserEmail),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
            title: Text(
              isAr ? 'التبديل لوضع الباحث عن عمل' : 'Switch to Job Seeker Mode',
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const RecruitmentUserShellScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(isAr ? 'الإعدادات' : 'Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(isAr ? 'مركز المساعدة' : 'Help Center'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const CompanyHelpCenterScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(isAr ? 'عن التطبيق' : 'About'),
            onTap: () {
              Navigator.pop(context);
              _showAboutDialog(context, isAr);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              isAr ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context, isAr);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isAr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? 'عن جوبيتو' : 'About Jobito'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppImages.jobito, height: 60),
            const SizedBox(height: 16),
            Text(
              isAr
                  ? 'جوبيتو هو منصتك المثالية للبحث عن وظائف وتوظيف المحترفين في مصر.'
                  : 'Jobito is your ideal platform for job searching and professional recruitment in Egypt.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text('Version 1.0.0'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAr ? 'رائع' : 'Cool'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isAr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isAr
              ? 'هل أنت متأكد من أنك تريد تسجيل الخروج؟'
              : 'Are you sure you want to log out?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              RecruitmentSyncService.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.userSignInNew,
                (route) => false,
              );
            },
            child: Text(
              isAr ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
