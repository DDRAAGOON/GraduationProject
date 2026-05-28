import 'package:flutter/material.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../teardsman/setting/settings.dart';
import '../messages/messages_list_screen.dart';
import '../messages/chat_thread_screen.dart';
import '../teardsman/nav_Botton_bar/nav_bottom_bar.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../constants/app_images.dart';
import '../notifications/notifications_screen.dart';
import '../../company/help/help_center_screen.dart';

// Comprehensive Translation Helper
String _translateValue(String? value, bool isAr) {
  if (value == null || value.isEmpty || !isAr) return value ?? "";
  final low = value.trim().toLowerCase();

  // Egyptian Governorates
  if (low == 'all') return 'الكل';
  if (low == 'cairo') return 'القاهرة';
  if (low == 'giza') return 'الجيزة';
  if (low == 'alexandria') return 'الإسكندرية';
  if (low == 'dakahlia') return 'الدقهلية';
  if (low == 'red sea') return 'البحر الأحمر';
  if (low == 'beheira') return 'البحيرة';
  if (low == 'fayoum') return 'الفيوم';
  if (low == 'gharbia') return 'الغربية';
  if (low == 'ismailia') return 'الإسماعيلية';
  if (low == 'monufia') return 'المنوفية';
  if (low == 'minya') return 'المنيا';
  if (low == 'qalyubia') return 'القليوبية';
  if (low == 'new valley') return 'الوادي الجديد';
  if (low == 'sharqia') return 'الشرقية';
  if (low == 'suez') return 'السويس';
  if (low == 'aswan') return 'أسوان';
  if (low == 'assiut') return 'أسيوط';
  if (low == 'beni suef') return 'بني سويف';
  if (low == 'port said') return 'بورسعيد';
  if (low == 'damietta') return 'دمياط';
  if (low == 'south sinai') return 'جنوب سيناء';
  if (low == 'kafr el sheikh') return 'كفر الشيخ';
  if (low == 'matrouh') return 'مطروح';
  if (low == 'luxor') return 'الأقصر';
  if (low == 'qena') return 'قنا';
  if (low == 'sohag') return 'سوهاج';
  if (low == 'north sinai') return 'شمال سيناء';
  if (low == 'remote') return 'عن بعد';

  // Job Types, Categories & Industries
  if (low == 'full-time' || low == 'full time') return 'دوام كامل';
  if (low == 'part-time' || low == 'part time') return 'دوام جزئي';
  if (low == 'freelance' || low == 'freelancer') return 'عمل حر';
  if (low == 'internship') return 'تدريب';
  if (low == 'one-time' || low == 'one time') return 'مرة واحدة';
  if (low == 'service' || low == 'services') return 'خدمة';
  if (low == 'technical') return 'تقني';
  if (low == 'non-technical') return 'غير تقني';
  if (low == 'general') return 'عام';

  // Job Titles
  if (low.contains('manager')) return 'مدير';
  if (low.contains('developer')) return 'مطور';
  if (low.contains('engineer')) return 'مهندس';
  if (low.contains('designer')) return 'مصمم';
  if (low.contains('accountant')) return 'محاسب';
  if (low.contains('technician')) return 'فني';
  if (low.contains('teacher')) return 'مدرس';
  if (low.contains('doctor')) return 'طبيب';
  if (low.contains('assistant')) return 'مساعد';
  if (low.contains('specialist')) return 'أخصائي';
  if (low.contains('programmer')) return 'مطور برمجيات';
  if (low == 'مبرمج') return 'مطور';

  // Status
  if (low.contains('hire')) return 'تم التوظيف';
  if (low.contains('reject') || low.contains('decline')) return 'تم الرفض';
  if (low.contains('pend')) return 'قيد الانتظار';
  if (low.contains('appli')) return 'تم التقديم';
  if (low.contains('interview')) return 'مقابلة';
  if (low.contains('review')) return 'قيد المراجعة';

  return value;
}

Widget _buildCompanyLogo(BuildContext context, String? logoUrl) {
  final provider = getAppImageProvider(logoUrl);
  return Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
      borderRadius: BorderRadius.circular(10),
    ),
    child: provider == null
        ? const Icon(Icons.business, size: 24, color: Color(0xFF49769F))
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image(image: provider, fit: BoxFit.cover),
          ),
  );
}

Color _getJobTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'full-time': return Colors.green;
    case 'part-time': return Colors.blue;
    case 'remote': return Colors.purple;
    case 'freelance':
    case 'freelancer': return Colors.teal;
    case 'one-time': return Colors.amber;
    case 'internship': return Colors.indigo;
    default: return Colors.grey;
  }
}

class RecruitmentUserShellScreen extends StatefulWidget {
  const RecruitmentUserShellScreen({super.key});

  @override
  State<RecruitmentUserShellScreen> createState() => _RecruitmentUserShellScreenState();
}

class _RecruitmentUserShellScreenState extends State<RecruitmentUserShellScreen> {
  int _tab = 0;
  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    RecruitmentSyncService.instance.startPolling();
  }

  @override
  void dispose() {
    RecruitmentSyncService.instance.stopPolling();
    super.dispose();
  }

  void _onTabChange(int index) {
    setState(() {
      _tab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      _HomeTab(onTabChange: _onTabChange),
      const _DiscoverTab(),
      const _ApplicationsTab(),
      const _CompaniesTab(),
      const MessagesListScreen(),
      const _ProfileTab(),
    ];
    final store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: _buildDrawer(context, store),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, color: Theme.of(context).colorScheme.onSurface),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
            title: _tab == 5 
              ? Text(
                  _isAr ? 'الملف الشخصي' : 'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                )
              : Image.asset(AppImages.jobito, height: 200),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen())), 
                icon: Icon(Icons.notifications_outlined, color: Theme.of(context).colorScheme.onSurface),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: pages[_tab],
          floatingActionButton: _tab == 1 
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
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                );
              }),
            ),
            child: NavigationBar(
              labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
              backgroundColor: Theme.of(context).cardColor,
              selectedIndex: _tab,
              onDestinationSelected: (int value) => setState(() => _tab = value),
              destinations: <NavigationDestination>[
                NavigationDestination(
                  icon: Icon(Icons.home_outlined, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'الرئيسية' : 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.search_outlined, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'اكتشف' : 'Discover',
                ),
                NavigationDestination(
                  icon: Icon(Icons.fact_check_outlined, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.fact_check, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'تقديماتي' : 'My Apps',
                ),
                NavigationDestination(
                  icon: Icon(Icons.business_outlined, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.business, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'الشركات' : 'Companies',
                ),
                NavigationDestination(
                  icon: Icon(Icons.chat_bubble_outline, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.chat_bubble, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'الرسائل' : 'Messages',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.onSurface),
                  selectedIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                  label: _isAr ? 'الملف الشخصي' : 'Profile',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, RecruitmentSyncStore store) {
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
                  ? Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary)
                  : null,
            ),
            accountName: Text(
              store.currentUserName.isNotEmpty ? store.currentUserName : (isAr ? 'مستخدم' : 'User'),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(store.currentUserEmail),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
            title: Text(isAr ? 'التبديل لوضع الصنايعي' : 'Switch to Tradesman Mode'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isAr ? "التبديل إلى وضع الصنايعي..." : "Switching to Tradesman Mode..."),
                  backgroundColor: const Color(0xFFFF7A2A),
                  duration: const Duration(seconds: 1),
                ),
              );
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Navbotton()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: Text(isAr ? 'الإعدادات' : 'Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(isAr ? 'المساعدة' : 'Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CompanyHelpCenterScreen()));
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
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context); // Close drawer
              _showLogoutDialog(context, isAr);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context, bool isAr) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isAr ? 'المساعدة' : 'Help'),
        content: Text(
          isAr 
            ? 'إذا كنت تواجه أي مشكلة، يرجى التواصل معنا عبر البريد الإلكتروني: support@jobito.com'
            : 'If you are facing any issues, please contact us via email: support@jobito.com',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isAr ? 'إغلاق' : 'Close'),
          ),
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
          mainAxisSize: Map<String, dynamic>.from(context as Map).isEmpty ? MainAxisSize.min : MainAxisSize.min,
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
              Navigator.pop(context); // Close dialog
              RecruitmentSyncService.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.userSignInNew, (route) => false);
            },
            child: Text(
              isAr ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final Function(int) onTabChange;
  const _HomeTab({required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final List<Map<String, String>> topCompanies = [
      {
        'en': 'Oriental Weavers',
        'ar': 'النساجون الشرقيون',
        'logo': 'assets/company/profile/النساجون الشرقيون.jpg',
      },
      {
        'en': 'Elsewedy Electric',
        'ar': 'السويدي إليكتريك',
        'logo': 'assets/company/profile/elswedy.webp',
      },
      {
        'en': 'El Araby Group',
        'ar': 'مجموعة العربي',
        'logo': 'assets/company/profile/EL_Araby.png',
      },
      {
        'en': 'TMG Holding',
        'ar': 'مجموعة طلعت مستفى',
        'logo': 'assets/company/profile/TMG.png',
      },
      {
        'en': 'Sico Egypt',
        'ar': 'سيكو مصر',
        'logo': 'assets/company/profile/Sico.png',
      },
  
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Banner with the requested image (no overlay text or search bar)
          Container(
            height: 280,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/company/Onboarding/image 42 1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // New text sections below the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: isAr ? 'جد وظيفة ' : 'Find a job ',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                      TextSpan(
                        text: isAr ? 'أحلامك ' : 'your dream ',
                        style: const TextStyle(color: Color(0xFF4A6ED1)),
                      ),
                      TextSpan(
                        text: isAr ? 'اليوم' : 'today',
                        style: const TextStyle(color: Color(0xFFFF7A2A)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isAr 
                    ? 'نربط المحترفين و الموهبين بافضل الفرص في مصر' 
                    : 'Connecting professionals and talents with the best opportunities in Egypt',
                  style: TextStyle(
                    fontSize: 15,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  isAr ? 'نثق بهم و يثقون بنا' : 'We trust them and they trust us',
                  style: TextStyle(
                    fontSize: 18, 
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: topCompanies.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        onTabChange(3); // Navigate to Companies tab
                      },
                      child: Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(topCompanies[index]['logo']!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                isAr ? topCompanies[index]['ar']! : topCompanies[index]['en']!,
                                style: TextStyle(
                                  fontSize: 10, 
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.suggestedJobs,
                      style: TextStyle(
                        fontSize: 18, 
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onTabChange(1),
                      child: Text(
                        isAr ? 'عرض الكل' : 'See All',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                (() {
                  final allJobs = store.jobs;

                  if (allJobs.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          l10n.noJobsAvailable,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: allJobs
                        .take(2)
                        .map((job) => _buildFeaturedJobCard(context, job, isAr))
                        .toList(),
                  );
                })(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isAr ? 'استكشف حسب الفئات' : 'Explore by Categories',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    TextButton(
                      onPressed: () => onTabChange(1),
                      child: Row(
                        children: [
                          Text(
                            isAr ? 'عرض كل الوظائف' : 'View all jobs',
                            style: TextStyle(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(isAr ? Icons.west : Icons.east, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.5)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      InkWell(
                        onTap: () {
                          store.updateFilters(category: 'Technical');
                          onTabChange(1);
                        },
                        child: _buildCategoryCard(
                          context,
                          isAr ? 'تقني' : 'Technical',
                          store.jobs.where((j) => j.category.toLowerCase() == 'technical').length,
                          Icons.memory,
                          const Color(0xFFF0EFFF),
                          const Color(0xFF6366F1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          store.updateFilters(category: 'Non-Technical');
                          onTabChange(1);
                        },
                        child: _buildCategoryCard(
                          context,
                          isAr ? 'غير تقني' : 'Non-Technical',
                          store.jobs.where((j) => j.category.toLowerCase() == 'non-technical').length,
                          Icons.people_outline,
                          const Color(0xFFFFF7ED),
                          const Color(0xFFF97316),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        onTap: () {
                          store.updateFilters(category: 'Service');
                          onTabChange(1);
                        },
                        child: _buildCategoryCard(
                          context,
                          isAr ? 'خدمات' : 'Services',
                          store.jobs.where((j) => j.category.toLowerCase() == 'service' || j.category.toLowerCase() == 'tradesman').length,
                          Icons.build_outlined,
                          const Color(0xFFFEF2F2),
                          const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String title, int count, IconData icon, Color boxColor, Color iconColor) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: boxColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isAr ? '$count وظيفة متاحة' : '$count jobs available',
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedJobCard(BuildContext context, RecruitmentJob job, bool isAr) {
    final store = RecruitmentSyncStore.instance;
    final String experience = job.tags.firstWhere(
      (t) => t.toLowerCase().contains('year') || t.contains('سنة'), 
      orElse: () => isAr ? '1-3 سنوات خبرة' : '1-3 years exp'
    );
    
    // Replace "مبرمج" or "Programmer" with "مطور" or "Developer" in the title display
    final String displayTitle = job.title.replaceAll('مبرمج', 'مطور').replaceAll('Programmer', 'Developer');

    return Card(
      color: Theme.of(context).cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.08)),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCompanyLogo(context, job.companyLogoUrl),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          job.companyName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (job.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    job.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                ),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _buildIconText(context, Icons.location_on_outlined, _translateValue(job.location, isAr), Theme.of(context).colorScheme.primary),
                  _buildIconText(context, Icons.work_outline, _translateValue(job.type, isAr), Theme.of(context).colorScheme.secondary),
                  _buildIconText(context, Icons.history, _translateValue(experience, isAr), Colors.orange),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.people_outline, size: 16, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    isAr 
                      ? 'عدد المتقدمين: ${store.applications.where((a) => a.jobId == job.id).length}' 
                      : 'Applicants: ${store.applications.where((a) => a.jobId == job.id).length}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (job.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.tags.take(3).where((tag) => !tag.toLowerCase().contains('year')).map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)),
                      ),
                      child: Text(
                        _translateValue(tag, isAr),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) {
        final jobs = store.filteredJobs;
        return RefreshIndicator(
          onRefresh: () => RecruitmentSyncService.instance.startPolling(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobs.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        image: const DecorationImage(
                          image: AssetImage('assets/tradesman/Screenshot 2026-05-27 032314.png'),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isAr ? "ابحث عن وظائف" : "Search for jobs",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isAr 
                                ? "اكتشف الاف الفرص الوظيفيه و ابدا مسيرتك المهنيه"
                                : "Discover thousands of job opportunities and start your career",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(100), // Full rounded ends (semi-circle)
                              border: Border.all(color: Colors.white.withOpacity(0.2)),
                            ),
                            child: Row(
                              children: [
                                const Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.search, color: Colors.grey, size: 20)),
                                Expanded(flex: 3, child: TextField(style: TextStyle(color: Theme.of(context).colorScheme.onSurface), decoration: InputDecoration(hintText: isAr ? 'ابحث بالاسم أو الوظيفة...' : 'Search by name or job...', border: InputBorder.none, contentPadding: const EdgeInsets.symmetric(horizontal: 10), hintStyle: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38))), onChanged: (value) => store.updateFilters(searchQuery: value.trim()))),
                                Container(height: 24, width: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.2)),
                                const Padding(padding: EdgeInsets.symmetric(horizontal: 8), child: Icon(Icons.location_on, color: Colors.grey, size: 18)),
                                Expanded(flex: 2, child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: store.filterLocation, isExpanded: true, icon: const Icon(Icons.keyboard_arrow_down, size: 18), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 13, fontWeight: FontWeight.w500), items: RecruitmentSyncStore.egyptGovernorates.map((gov) => DropdownMenuItem(value: gov, child: Text(_translateValue(gov, isAr), overflow: TextOverflow.ellipsis))).toList(), onChanged: (value) { if (value != null) store.updateFilters(location: value); }))),
                                const SizedBox(width: 4),
                                Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF7A2A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      // Trigger search
                                    },
                                    icon: const Icon(Icons.search, color: Colors.white, size: 20),
                                    constraints: const BoxConstraints(),
                                    padding: const EdgeInsets.all(12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 20, 
                              fontWeight: FontWeight.bold, 
                              color: Theme.of(context).colorScheme.onSurface
                            ),
                            children: [
                              TextSpan(text: isAr ? "جميع " : "All "),
                              TextSpan(
                                text: isAr ? "الوظائف" : "Jobs", 
                                style: TextStyle(color: Theme.of(context).colorScheme.primary)
                              ),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userAdvancedFilters),
                            icon: Icon(Icons.tune, color: Theme.of(context).colorScheme.primary, size: 20),
                            constraints: const BoxConstraints(),
                            padding: const EdgeInsets.all(10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }
              final job = jobs[index - 1];
              final String experience = job.tags.firstWhere(
                (t) => t.toLowerCase().contains('year') || t.contains('سنة'), 
                orElse: () => isAr ? '1-3 سنوات خبرة' : '1-3 years exp'
              );
              final String displayTitle = job.title.replaceAll('مبرمج', 'مطور').replaceAll('Programmer', 'Developer');

              return Card(
                color: Theme.of(context).cardColor, 
                elevation: 0, 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Theme.of(context).dividerColor.withValues(alpha: 0.1))), 
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            _buildCompanyLogo(context, job.companyLogoUrl),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    job.companyName,
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    displayTitle,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 17,
                                          color: Theme.of(context).colorScheme.onSurface,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _buildIconText(context, Icons.location_on_outlined, _translateValue(job.location, isAr), Theme.of(context).colorScheme.primary),
                            _buildIconText(context, Icons.work_outline, _translateValue(job.type, isAr), Theme.of(context).colorScheme.secondary),
                            _buildIconText(context, Icons.history, _translateValue(experience, isAr), Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.people_outline, size: 16, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              isAr 
                                ? 'عدد المتقدمين: ${store.applications.where((a) => a.jobId == job.id).length}' 
                                : 'Applicants: ${store.applications.where((a) => a.jobId == job.id).length}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (job.category.isNotEmpty && job.category != 'General' && job.category != 'All') ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
                            decoration: BoxDecoration(color: const Color(0xFF8B5CF6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), 
                            child: Text(_translateValue(job.category, isAr), style: const TextStyle(color: Color(0xFF8B5CF6), fontWeight: FontWeight.bold, fontSize: 11))
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (job.tags.isNotEmpty)
                          Wrap(
                            spacing: 8, 
                            runSpacing: 8, 
                            children: job.tags.take(4).where((tag) => !tag.toLowerCase().contains('year') && tag.trim().toLowerCase() != 'technical').map((String tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _translateValue(tag, isAr),
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
                                ),
                              );
                            }).toList()
                          ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                              label: isAr ? 'قدّم الآن' : 'Apply Now',
                              backgroundColor: const Color(0xFF4A6ED1),
                              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userJobApplication, arguments: job)
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildIconText(BuildContext context, IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab();
  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final apps = store.applications;
    final totalApps = apps.length;
    final hiredApps = apps.where((a) => a.status.toLowerCase().contains('hire') || a.status == 'تم التوظيف').length;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isAr ? '${store.currentUserName} صباح الخير' : 'Good Morning, ${store.currentUserName}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)),
            const SizedBox(height: 4),
            Text(isAr ? 'هذا ما قمت به بطلباتك حتى الآن' : 'Here is what\'s happening with your applications', style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 14)),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: Column(children: [_buildStatCard(context, isAr ? 'إجمالي ما تم التقديم عليه' : 'Total Applied', totalApps.toString(), Icons.description_outlined), const SizedBox(height: 12), _buildStatCard(context, isAr ? 'تم اختيارك في' : 'You were hired in', hiredApps.toString(), Icons.check_circle_outline)])),
                const SizedBox(width: 16),
                Expanded(flex: 3, child: Container(height: 180, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(isAr ? 'حالة التقديم' : 'App Status', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Expanded(child: Center(child: Stack(alignment: Alignment.center, children: [SizedBox(width: 100, height: 100, child: CircularProgressIndicator(value: totalApps == 0 ? 0 : hiredApps / totalApps, strokeWidth: 10, backgroundColor: Theme.of(context).dividerColor.withValues(alpha: 0.1), valueColor: const AlwaysStoppedAnimation<Color>(Colors.green))), Text('${totalApps > 0 ? (hiredApps / totalApps * 100).toInt() : 0}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))])))]))),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isAr ? 'السجل الأخير' : 'Recent Log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleMedium?.color)),
                if (apps.isNotEmpty)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.userApplicationTimeline,
                        arguments: apps.first,
                      );
                    },
                    child: Text(isAr ? 'عرض الكل' : 'Show all', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            if (apps.isEmpty) Center(child: Padding(padding: const EdgeInsets.all(40.0), child: Text(isAr ? 'لا يوجد طلبات حالياً' : 'No applications yet.'))) else ...apps.take(2).map((app) => _buildRecentAppItem(context, app, isAr)),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.titleLarge?.color)), Icon(icon, color: Theme.of(context).textTheme.bodySmall?.color, size: 20)]), const SizedBox(height: 8), Text(title, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color))]));
  }

  Widget _buildRecentAppItem(BuildContext context, RecruitmentApplication app, bool isAr) {
    final isHired = app.status.toLowerCase().contains('hire');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(width: 44, height: 44, decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.business, color: Color(0xFF49769F))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(app.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)), Text('${app.companyName} • ${_translateValue("Full-time", isAr)}', style: const TextStyle(color: Colors.black54, fontSize: 12))])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [Text('${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}', style: const TextStyle(fontSize: 11, color: Colors.grey)), const SizedBox(height: 4), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: (isHired ? Colors.green : Colors.orange).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Text(_translateValue(app.status, isAr), style: TextStyle(color: isHired ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)))]),
          ],
        ),
      ),
    );
  }
}

class _CompaniesTab extends StatefulWidget {
  const _CompaniesTab();
  @override
  State<_CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends State<_CompaniesTab> {
  bool _technicalChecked = false;
  bool _nonTechnicalChecked = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedLocation = "All";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _searchQuery = _searchController.text.toLowerCase()));
  }

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final Map<String, Map<String, dynamic>> companiesMap = {};
    for (final job in store.jobs) {
      final key = job.companyName.trim();
      if (key.isEmpty) continue;
      final openVacancies = (job.capacity - job.acceptedCount).clamp(0, 9999);
      if (!companiesMap.containsKey(key)) {
        companiesMap[key] = {
          'name': job.companyName,
          'industry': _translateValue(job.category.isEmpty ? 'General' : job.category, isAr),
          'description': isAr ? 'شركة توظف حالياً عبر Jobito' : 'Hiring now on Jobito',
          'logoUrl': job.companyLogoUrl,
          'vacancies': openVacancies,
          'type': job.category.toLowerCase().contains('technical') ? 'Technical' : 'Non-Technical',
          'locations': {job.location},
        };
      } else {
        companiesMap[key]!['vacancies'] = (companiesMap[key]!['vacancies'] as int) + openVacancies;
        if ((companiesMap[key]!['logoUrl'] == null || (companiesMap[key]!['logoUrl'] as String).isEmpty) && (job.companyLogoUrl != null && job.companyLogoUrl!.isNotEmpty)) {
           companiesMap[key]!['logoUrl'] = job.companyLogoUrl;
        }
        (companiesMap[key]!['locations'] as Set<String>).add(job.location);
      }
    }
    final allCompanies = companiesMap.values.toList();
    final filteredCompanies = allCompanies.where((comp) {
      final matchesSearch = comp['name'].toString().toLowerCase().contains(_searchQuery) || comp['industry'].toString().toLowerCase().contains(_searchQuery);
      final matchesLocation = _selectedLocation == 'All' || (comp['locations'] as Set<String>).contains(_selectedLocation);
      bool matchesType = true;
      if (_technicalChecked && !_nonTechnicalChecked) matchesType = comp['type'] == 'Technical';
      if (!_technicalChecked && _nonTechnicalChecked) matchesType = comp['type'] == 'Non-Technical';
      return matchesSearch && matchesLocation && matchesType;
    }).toList();
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 24), child: Column(children: [Text(isAr ? 'ابحث عن الشركات التي تحلم بها' : 'Search for companies you dream of', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Theme.of(context).textTheme.titleLarge?.color), textAlign: TextAlign.center), const SizedBox(height: 10), Text(isAr ? 'اكتشف أفضل الشركات وبيئات العمل المثالية لمستقبلك المهني' : 'Discover the best companies and ideal work environments for your professional future', style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodySmall?.color), textAlign: TextAlign.center)])),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Icon(Icons.search, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText: isAr ? 'اسم الشركة أو المجال...' : 'Company or industry...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
                ),
                const SizedBox(width: 10),
                Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
                const SizedBox(width: 4),
                Expanded(
                  flex: 2,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedLocation,
                      isExpanded: true,
                      icon: Icon(Icons.keyboard_arrow_down, size: 18, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38)),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      items: RecruitmentSyncStore.egyptGovernorates.map((gov) {
                        return DropdownMenuItem(
                          value: gov,
                          child: Text(
                            _translateValue(gov, isAr),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedLocation = value);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(isAr ? 'التصنيف' : 'Classification', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(height: 12), Row(children: [Expanded(child: _buildFilterChip(isAr ? 'تقني' : 'Technical', _technicalChecked, (v) => setState(() => _technicalChecked = v!))), const SizedBox(width: 8), Expanded(child: _buildFilterChip(isAr ? 'غير تقني' : 'Non-Technical', _nonTechnicalChecked, (v) => setState(() => _nonTechnicalChecked = v!)))]), const SizedBox(height: 30)])),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(isAr ? 'جميع الشركات' : 'All Companies', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.onSurface)), Text(isAr ? 'إجمالي الشركات المدرجة: ${filteredCompanies.length}' : 'Total listed companies: ${filteredCompanies.length}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12)), const SizedBox(height: 20), filteredCompanies.isEmpty ? const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No results found"))) : GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, mainAxisExtent: 200, mainAxisSpacing: 16), itemCount: filteredCompanies.length, itemBuilder: (context, index) => _buildCompanyCard(context, filteredCompanies[index], isAr))])),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool value, ValueChanged<bool?> onChanged) => GestureDetector(onTap: () => onChanged(!value), child: Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: value ? const Color(0xFF49769F) : Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), border: Border.all(color: value ? const Color(0xFF49769F) : Theme.of(context).dividerColor.withValues(alpha: 0.3))), alignment: Alignment.center, child: Text(label, style: TextStyle(color: value ? Colors.white : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 13, fontWeight: FontWeight.w600))));

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> comp, bool isAr) {
    final logoProvider = getAppImageProvider(comp['logoUrl']?.toString());
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Material(color: Colors.transparent, child: InkWell(onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.userCompanyDetails, arguments: comp);
      }, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFFF0F3FF), borderRadius: BorderRadius.circular(12)), child: logoProvider != null ? CircleAvatar(radius: 16, backgroundImage: logoProvider) : Icon(Icons.business, color: Theme.of(context).colorScheme.primary, size: 32)), const Spacer(), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2))), child: Text(isAr ? 'وظائف شاغرة ${comp['vacancies']}' : '${comp['vacancies']} Vacancies', style: const TextStyle(color: Color(0xFF49769F), fontSize: 11, fontWeight: FontWeight.bold)))]), const SizedBox(height: 16), Text(comp['name'] as String, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(height: 6), Text(comp['description'] as String, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13, height: 1.4), maxLines: 2, overflow: TextOverflow.ellipsis), const Spacer(), Row(children: [Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Theme.of(context).dividerColor.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20)), child: Text(comp['industry'] as String, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 11, fontWeight: FontWeight.w600))), const Spacer(), Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.primary)])])))),
    );
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;

    // Determine status based on role
    final String statusLabel = store.userRole == 'Tradesman'
        ? t.tr(en: "Tradesman", ar: "صنايعي")
        : t.tr(en: "Job Seeker", ar: "باحث عن عمل");

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final profileImageProvider = getAppImageProvider(store.profileImage);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(clipBehavior: Clip.none, children: [Container(height: 180, width: double.infinity, decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary.withValues(alpha: 0.9), Theme.of(context).colorScheme.primary.withValues(alpha: 0.6)], begin: Alignment.topLeft, end: Alignment.bottomRight))), Positioned(bottom: -50, left: isAr ? null : 24, right: isAr ? 24 : null, child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)]), child: CircleAvatar(radius: 50, backgroundColor: Theme.of(context).cardColor, backgroundImage: profileImageProvider, child: store.profileImage == null ? Icon(Icons.person, size: 55, color: Theme.of(context).colorScheme.primary) : null)))]),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(store.currentUserName.isEmpty ? t.notYet : store.currentUserName, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 26, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // الحالة (باحث عن عمل / صنايعي)
                    Text(statusLabel, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    // العنوان تحت الحالة
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), size: 16),
                        const SizedBox(width: 4),
                        Text(store.currentUserLocation.isEmpty ? t.notYet : store.currentUserLocation, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        _buildProfileItem(context, t.aboutMe, store.currentUserAbout, Icons.info_outline, showDivider: true),
                        _buildProfileItem(context, isAr ? 'البريد الإلكتروني' : 'Email', store.currentUserEmail, Icons.email_outlined, showDivider: true),
                        _buildProfileItem(context, isAr ? 'رقم الهاتف' : 'Phone', store.currentUserPhone, Icons.phone_android_outlined, showDivider: true),
                        _buildProfileItem(context, isAr ? 'الموقع' : 'Location', store.currentUserLocation, Icons.location_on_outlined, showDivider: true),
                        _buildProfileItem(context, isAr ? 'المهارات' : 'Skills', store.currentUserSkills.join(', '), Icons.psychology_outlined),
                        if (store.portfolioImages.isNotEmpty) ...[const SizedBox(height: 10), Text(isAr ? 'المعرض' : 'Gallery', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Theme.of(context).colorScheme.onSurface)), const SizedBox(height: 16), SizedBox(height: 100, child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: store.portfolioImages.length, itemBuilder: (context, index) { final path = store.portfolioImages[index]; return Container(margin: const EdgeInsets.only(right: 12), width: 100, decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: Image(image: getAppImageProvider(path) ?? const AssetImage('assets/placeholder.png'), fit: BoxFit.cover))); }))],
                      ]),
                    ),
                    const SizedBox(height: 24),
                    if (store.currentUserExperience.isNotEmpty) ...[Text(t.workExperience, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 16), ...store.currentUserExperience.map((exp) => _buildRecordItem(context, exp['title'], '${exp['company']} • ${exp['duration']}', Icons.work_outline, isAr))],
                    const SizedBox(height: 24),
                    if (store.currentUserEducation.isNotEmpty) ...[Text(t.education, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 20, fontWeight: FontWeight.w800)), const SizedBox(height: 16), ...store.currentUserEducation.map((edu) => _buildRecordItem(context, edu['degree'], '${edu['institution']} • ${edu['duration']}', Icons.school_outlined, isAr))],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRecordItem(BuildContext context, String? title, String? subtitle, IconData icon, bool isAr) => Container(margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.withValues(alpha: 0.05))), child: Row(children: [Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: Theme.of(context).colorScheme.primary)), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_translateValue(title, isAr), style: TextStyle(color: Theme.of(context).textTheme.titleMedium?.color, fontWeight: FontWeight.bold, fontSize: 16)), const SizedBox(height: 4), Text(subtitle ?? "", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54), fontSize: 13, fontWeight: FontWeight.w500))]))]));

  Widget _buildProfileItem(BuildContext context, String label, String value, IconData icon, {bool showDivider = false}) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.38), fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(value.isEmpty ? t.notYet : _translateValue(value, isAr), style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Divider(height: 1, color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          ),
      ],
    );
  }
}

Widget _buildIconText(BuildContext context, IconData icon, String text, Color color) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 16, color: color),
      const SizedBox(width: 6),
      Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
    ],
  );
}
