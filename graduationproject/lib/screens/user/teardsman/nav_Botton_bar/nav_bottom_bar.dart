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
import '../profile/tradesman_ratings_hub_screen.dart';
import '../../../company/widgets/glowing_chatbot_fab.dart';
import '../../messages/chat_thread_screen.dart';

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
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: bgColor,
          drawer: _buildTradesmanDrawer(context, store),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            backgroundColor: bgColor,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  // Icons Row (Menu, Notifications, Post)
                  // In RTL, this Row starts from the Right.
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PostJob()),
                        ),
                        icon: Icon(
                          Icons.add_box_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        tooltip: _isAr ? 'نشر وظيفة' : 'Post Job',
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Logo on the Far Left (in Arabic RTL)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(
                      isDark ? 'assets/company/logo/لوجو جديد.png' : 'assets/company/logo/لوجو جديد لايت.png',
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: _pages[_selectedIndex],
          floatingActionButton: _selectedIndex == 1
              ? GlowingChatbotFAB(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatThreadScreen(
                          name: _isAr
                              ? 'مساعد جوبيتو الذكي'
                              : 'Jobito AI Assistant',
                          image: AppImages.jobito,
                        ),
                      ),
                    );
                  },
                )
              : null,
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
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
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
      },
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
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: getAppImageProvider(store.profileImage),
              child: store.profileImage == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: Theme.of(context).colorScheme.primary,
                    )
                  : null,
            ),
            accountName: Text(
              store.currentUserName.isNotEmpty
                  ? store.currentUserName
                  : (isAr ? 'حرفي' : 'Tradesman'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(store.currentUserEmail),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline, color: Color(0xFFFFB300)),
            title: Text(isAr ? 'التقييمات' : 'Ratings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TradesmanRatingsHubScreen(),
                ),
              );
            },
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
