import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/services/user_service.dart';
import '../../../shared/services/auth_service.dart';
import '../../../shared/services/job_service.dart';
import '../../../shared/services/application_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../messages/messages_list_screen.dart';
import '../messages/chat_thread_screen.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../constants/app_images.dart';
import '../notifications/notifications_screen.dart';
import '../teardsman/onboarding/tradesman_verification_screen.dart';
import '../teardsman/setting/settings.dart';
import '../../company/widgets/glowing_chatbot_fab.dart';
import '../../../shared/state/theme_controller.dart';
import '../teardsman/nav_Botton_bar/nav_bottom_bar.dart';

// Import New Public Tabs
import 'tabs/home_tab.dart';
import 'tabs/discover_tab.dart';
import 'tabs/applications_tab.dart';
import 'tabs/companies_tab.dart';
import 'tabs/profile_tab.dart';

class RecruitmentUserShellScreen extends StatefulWidget {
  const RecruitmentUserShellScreen({super.key});

  @override
  State<RecruitmentUserShellScreen> createState() =>
      _RecruitmentUserShellScreenState();
}

class _RecruitmentUserShellScreenState
    extends State<RecruitmentUserShellScreen> {
  int _tab = 0;
  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    RecruitmentSyncService.instance.startPolling();
    UserService.instance.getCurrentUser().catchError((_) {});
    JobService.instance.getJobs().catchError((_) {});
    ApplicationService.instance.getMyApplications().catchError((_) {});
  }

  void _onTabChange(int index) {
    setState(() {
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      HomeTab(onTabChange: _onTabChange),
      const DiscoverTab(),
      const ApplicationsTab(),
      const CompaniesTab(),
      const MessagesListScreen(),
      const ProfileTab(),
    ];
    final store = RecruitmentSyncStore.instance;

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeMode,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark || 
                      (themeMode == ThemeMode.system && MediaQuery.platformBrightnessOf(context) == Brightness.dark);

        final backgroundColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: backgroundColor,
          drawer: _buildDrawer(context, store),
          appBar: AppBar(
            leadingWidth: 110,
            leading: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: isDark ? Colors.white : const Color(0xFF213E75),
                  ),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsScreen(),
                    ),
                  ),
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: isDark ? Colors.white : const Color(0xFF213E75),
                  ),
                ),
              ],
            ),
            title: null,
            backgroundColor: backgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Image.asset(
                  isDark ? 'assets/company/logo/لوجو جديد.png' : 'assets/company/logo/لوجو جديد لايت.png',
                  height: 45,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: pages[_tab],
          floatingActionButton: _tab == 1
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
          bottomNavigationBar: _buildBottomNav(isDark),
        );
      },
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: const Color(0xFFF77F32).withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.all(TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF0051DD),
        )),
      ),
      child: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        backgroundColor: isDark ? const Color(0xFF0D1B3E) : Colors.white,
        selectedIndex: _tab,
        onDestinationSelected: (int value) {
          if (value == 1) RecruitmentSyncStore.instance.clearFilters();
          setState(() => _tab = value);
        },
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.home, color: Color(0xFF0051DD)),
            label: _isAr ? 'الرئيسية' : 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.search, color: Color(0xFF0051DD)),
            label: _isAr ? 'اكتشف' : 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_outlined, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.fact_check, color: Color(0xFF0051DD)),
            label: _isAr ? 'تقديماتي' : 'My Apps',
          ),
          NavigationDestination(
            icon: Icon(Icons.business_outlined, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.business, color: Color(0xFF0051DD)),
            label: _isAr ? 'الشركات' : 'Companies',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.chat_bubble, color: Color(0xFF0051DD)),
            label: _isAr ? 'الرسائل' : 'Messages',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: isDark ? Colors.white70 : Colors.black54),
            selectedIcon: const Icon(Icons.person, color: Color(0xFF0051DD)),
            label: _isAr ? 'الملف الشخصي' : 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, RecruitmentSyncStore store) {
    final isAr = _isAr;
    final Color orangeColor = const Color(0xFFFF7A2A);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      backgroundColor: isDark ? const Color(0xFF0D1B3E) : Colors.white,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: orangeColor),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: getAppImageProvider(store.profileImage),
              child: store.profileImage == null
                  ? Icon(Icons.person, size: 40, color: orangeColor)
                  : null,
            ),
            accountName: Text(
              store.currentUserName.isNotEmpty ? store.currentUserName : (isAr ? 'مستخدم' : 'User'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(store.currentUserEmail, style: const TextStyle(color: Colors.white70)),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
            title: Text(isAr ? 'التبديل لوضع الحرفي' : 'Switch to Tradesman Mode'),
            onTap: () async {
              Navigator.pop(context); // Close Drawer
              final store = RecruitmentSyncStore.instance;
              final prefs = await SharedPreferences.getInstance();
              
              // Use email-specific key so new accounts on the same device need to verify
              final String key = 'is_tradesman_verified_${store.currentUserEmail}';
              final bool isComplete = prefs.getBool(key) ?? false;

              if (isComplete) {
                // Switch directly if already completed
                store.updateUserProfile(
                  fullName: store.currentUserName,
                  title: store.currentUserTitle,
                  role: 'Tradesman',
                );
                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Navbotton()),
                  );
                }
              } else {
                // Show warning if not completed
                if (context.mounted) {
                  _showTradesmanWarningDialog(context, isAr);
                }
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Color(0xFF213E75)),
            title: Text(isAr ? 'الإعدادات' : 'Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(isAr ? 'تسجيل الخروج' : 'Logout', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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

  void _showLogoutDialog(BuildContext context, bool isAr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? 'تسجيل الخروج' : 'Logout'),
        content: Text(isAr ? 'هل أنت متأكد من أنك تريد تسجيل الخروج؟' : 'Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(isAr ? 'إلغاء' : 'Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await AuthService.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.userSignInNew, (route) => false);
            },
            child: Text(isAr ? 'تسجيل الخروج' : 'Logout', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showTradesmanWarningDialog(BuildContext context, bool isAr) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Column(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Color(0xFFFFB300), size: 50),
            const SizedBox(height: 15),
            Text(
              isAr ? 'خطوة أخيرة للتبديل' : 'Final Step to Switch',
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isAr 
                ? 'للدخول لوضع الحرفي واستقبال الطلبات، يجب رفع الفيش الجنائي وتحديد حرفتك أولاً.'
                : 'To enter Tradesman Mode and receive requests, you must upload your fish and select your craft first.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            _buildRequirementItem(isAr ? 'صحيفة الحالة الجنائية (الفيش)' : 'Criminal Record Document', isAr),
            _buildRequirementItem(isAr ? 'اختيار الخدمة (كهربائي، سباك...)' : 'Select Service (Electrician...)', isAr),
          ],
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(isAr ? 'إلغاء' : 'Cancel', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TradesmanVerificationScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0051DD),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isAr ? 'إكمال الآن' : 'Complete Now',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: isAr ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isAr) const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
          if (!isAr) const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              textAlign: isAr ? TextAlign.right : TextAlign.left,
            ),
          ),
          if (isAr) const SizedBox(width: 8),
          if (isAr) const Icon(Icons.check_circle_outline, color: Colors.green, size: 18),
        ],
      ),
    );
  }
}
