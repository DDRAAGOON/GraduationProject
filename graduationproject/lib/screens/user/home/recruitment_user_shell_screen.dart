import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../teardsman/setting/settings.dart';
import '../messages/messages_list_screen.dart';
import '../messages/chat_thread_screen.dart';
import '../../../shared/utils/image_helper.dart';
import '../../../constants/app_images.dart';
import '../notifications/notifications_screen.dart';
import '../../company/help/help_center_screen.dart';
import '../teardsman/onboarding/tradesman_verification_screen.dart';
import '../../company/widgets/glowing_chatbot_fab.dart';
import '../../../shared/state/theme_controller.dart';

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

Widget _buildWhiteTag(String t) => Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        t,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );

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
            title: _tab == 5
                ? Text(
                    _isAr ? 'الملف الشخصي' : 'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  )
                : null,
            backgroundColor: backgroundColor,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            centerTitle: true,
            actions: [
              if (_tab != 5) 
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Image.asset('assets/tradesman/Group 289312.png', height: 45),
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
        indicatorColor: const Color(0xFFF77F32).withOpacity(0.1),
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
        onDestinationSelected: (int value) => setState(() => _tab = value),
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
          // Standard Header with Orange Background
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: orangeColor,
            ),
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
            accountEmail: Text(
              store.currentUserEmail,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          
          const SizedBox(height: 10),
          
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
            title: Text(isAr ? 'التبديل لوضع الصنايعي' : 'Switch to Tradesman Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TradesmanVerificationScreen()));
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
          ListTile(
            leading: const Icon(Icons.help_outline, color: Color(0xFF213E75)),
            title: Text(isAr ? 'المساعدة' : 'Help'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed(AppRoutes.companyHelpCenter);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Color(0xFF213E75)),
            title: Text(isAr ? 'عن التطبيق' : 'About App'),
            onTap: () {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: 'Jobito',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset('assets/tradesman/Group 289312.png', width: 50),
                children: [
                  Text(isAr 
                    ? 'جوبيتو هو منصتك المفضلة لإيجاد أفضل فرص العمل والمحترفين في مصر.' 
                    : 'Jobito is your go-to platform for finding the best job opportunities and professionals in Egypt.'),
                ],
              );
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
              RecruitmentSyncService.instance.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.userSignInNew, (route) => false);
            },
            child: Text(isAr ? 'تسجيل الخروج' : 'Logout', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final Function(int) onTabChange;
  const _HomeTab({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, String>> topCompanies = [
      {'en': 'Oriental Weavers', 'ar': 'النساجون الشرقيون', 'logo': 'assets/company/profile/النساجون الشرقيون.jpg'},
      {'en': 'Elsewedy Electric', 'ar': 'السويدي إليكتريك', 'logo': 'assets/company/profile/elswedy.webp'},
      {'en': 'El Araby Group', 'ar': 'مجموعة العربي', 'logo': 'assets/company/profile/EL_Araby.png'},
      {'en': 'TMG Holding', 'ar': 'مجموعة طلعت مستفى', 'logo': 'assets/company/profile/TMG.png'},
      {'en': 'Sico Egypt', 'ar': 'سيكو مصر', 'logo': 'assets/company/profile/Sico.png'},
    ];

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/tradesman/image 43.png', width: double.infinity, fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      text: TextSpan(
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
                        children: [
                          TextSpan(text: isAr ? 'جد وظيفة ' : 'Find your ', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                          TextSpan(text: isAr ? 'أحلامك ' : 'dream job ', style: const TextStyle(color: Color(0xFF0051DD))),
                          TextSpan(text: isAr ? 'اليوم' : 'today', style: const TextStyle(color: Color(0xFFFF7A2A))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr ? 'نربط المحترفين و الموهبين بافضل الفرص في مصر' : 'Connecting professionals and talents with the best opportunities in Egypt',
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  isAr ? 'نثق بهم ويثقون بنا' : 'We trust them, and they trust us',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: topCompanies.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => onTabChange(3),
                    child: Container(
                      width: 110, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9).withOpacity(isDark ? 0.1 : 0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        CircleAvatar(backgroundColor: Colors.white, radius: 25, backgroundImage: AssetImage(topCompanies[index]['logo']!)),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(isAr ? topCompanies[index]['ar']! : topCompanies[index]['en']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        )
                      ]),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader(context, isAr ? "الوظائف المتاحة اليوم" : "Jobs Available Today", () => onTabChange(1), isAr),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: store.jobs.take(2).map((j) => _buildCustomJobCard(context, j, isAr, isDark)).toList()),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(isAr ? 'استكشف حسب الفئات' : 'Explore by Categories', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              _buildCategoryTile(context, isAr ? "تقني" : "Technical", isAr ? "5 فرص" : "5 opportunities", Icons.memory, const Color(0xFFD9D9D9), isDark, isAr, () {
                store.updateFilters(category: 'Technical');
                onTabChange(1);
              }),
              _buildCategoryTile(context, isAr ? "غير تقني" : "Non-Technical", isAr ? "3 فرص" : "3 opportunities", Icons.groups, const Color(0xFFD9D9D9), isDark, isAr, () {
                store.updateFilters(category: 'Non-Technical');
                onTabChange(1);
              }),
              _buildCategoryTile(context, isAr ? "خدمات" : "Services", isAr ? "15 فرصة" : "15 opportunities", Icons.handyman, const Color(0xFFD9D9D9), isDark, isAr, () {
                store.updateFilters(category: 'Service');
                onTabChange(1);
              }),
              const SizedBox(height: 32),
              _buildSectionHeader(context, isAr ? "فرص عمل استثنائية" : "Exceptional Jobs", () => onTabChange(1), isAr),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: store.jobs
                      .where((j) => j.specialTag != null)
                      .take(2)
                      .map((j) => _buildExceptionalJobCard(context, j, isAr, isDark))
                      .toList(),
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }
    );
  }


  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onTap, bool isAr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          TextButton(onPressed: onTap, child: Text(isAr ? "عرض الكل" : "See All")),
        ],
      ),
    );
  }

  Widget _buildCustomJobCard(BuildContext context, RecruitmentJob job, bool isAr, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Logo and Navigation Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCompanyLogo(context, job.companyLogoUrl),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Row 2: Job Title
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            
            // Row 3: Company Name
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Row 4: Job Description snippet
            Text(
              job.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
            ),
            
            const SizedBox(height: 12),
            
            // Row 5: Extra Benefits snippet
            if (job.benefits.isNotEmpty) ...[
              Text(
                isAr ? "مزايا إضافية: ${job.benefits.join(' • ')}" : "Extra Benefits: ${job.benefits.join(' • ')}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
            ],
            
            // Row 6: Static Tags
            Row(
              children: [
                _buildWhiteTag(_translateValue(job.location, isAr)),
                _buildWhiteTag(_translateValue(job.type, isAr)),
                _buildWhiteTag(isAr ? "1-3 سنوات" : "1-3 exp"),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Row 7: Apply Now (Left) and Salary (Right)
            Row(
              children: [
                if (isAr) ...[
                  // Arabic: Salary on Right (Start), Apply on Left (End)
                  Text(
                    job.salaryRange,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  _buildJobitoApplyButton(context, job, isAr),
                ] else ...[
                  // English: Apply on Left (Start), Salary on Right (End)
                  _buildJobitoApplyButton(context, job, isAr),
                  const Spacer(),
                  Text(
                    job.salaryRange,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExceptionalJobCard(BuildContext context, RecruitmentJob job, bool isAr, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and Arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCompanyLogo(context, job.companyLogoUrl),
                const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            
            // Job Title
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            
            // Company Name
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Only Job Type Tag (Full-time, Part-time, Internship)
            _buildWhiteTag(_translateValue(job.type, isAr)),
          ],
        ),
      ),
    );
  }


  Widget _buildJobitoApplyButton(BuildContext context, RecruitmentJob job, bool isAr) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userJobApplication, arguments: job),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0051DD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text(
        isAr ? "قدم الآن" : "Apply Now",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }




  Widget _buildCategoryTile(BuildContext c, String t, String s, IconData i, Color col, bool isDark, bool isAr, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: isDark ? Colors.white10 : col, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Icon(isAr ? Icons.chevron_left : Icons.chevron_right),
          const Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(s, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ]),
          const SizedBox(width: 12),
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(12)), child: Icon(i, size: 28)),
        ]),
      ),
    );
  }
}

class _DiscoverTab extends StatefulWidget {
  const _DiscoverTab({super.key});

  @override
  State<_DiscoverTab> createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<_DiscoverTab> {
  late TextEditingController _searchController;
  final store = RecruitmentSyncStore.instance;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: store.searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        color: const Color(0xFF213E75),
                        borderRadius: BorderRadius.circular(24),
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
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                // Search Input Area (Right side in RTL)
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF1F1F1),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.search, color: Colors.grey, size: 18),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            onChanged: (value) => store.updateFilters(searchQuery: value.trim()),
                                            decoration: InputDecoration(
                                              hintText: isAr ? 'ابحث...' : 'Search...',
                                              border: InputBorder.none,
                                              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // Location Icon with Full Name (Left side in RTL)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: store.filterLocation,
                                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                                        style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                                        items: RecruitmentSyncStore.egyptGovernorates.map((gov) => DropdownMenuItem(
                                          value: gov,
                                          child: Text(_translateValue(gov, isAr)),
                                        )).toList(),
                                        onChanged: (value) { if (value != null) store.updateFilters(location: value); },
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFFF7A2A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                                    ),
                                  ],
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
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            children: [
                              TextSpan(text: isAr ? "جميع " : "All "),
                              TextSpan(text: isAr ? "الوظائف" : "Jobs", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                            ],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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
              return _buildFeaturedJobCardFull(context, job, isAr);
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedJobCardFull(BuildContext context, RecruitmentJob job, bool isAr) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.userJobDetails, arguments: job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF213E75),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Logo
            _buildCompanyLogo(context, job.companyLogoUrl),
            const SizedBox(height: 12),
            
            // Row 2: Job Title
            Text(
              job.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            
            // Row 3: Company Name
            const SizedBox(height: 4),
            Text(
              job.companyName,
              style: const TextStyle(
                color: Color(0xFFFF7A2A),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Preview Sections
            if (job.description.isNotEmpty)
              _buildPreviewText(isAr ? "الوصف" : "Description", job.description, isAr),
            
            if (job.qualifications.isNotEmpty)
              _buildPreviewText(isAr ? "المؤهلات" : "Qualifications", job.qualifications.join(', '), isAr),
            
            if (job.responsibilities.isNotEmpty)
              _buildPreviewText(isAr ? "المسؤوليات" : "Responsibilities", job.responsibilities.join(', '), isAr),
              
            if (job.benefits.isNotEmpty)
              _buildPreviewText(isAr ? "مزايا إضافية" : "Extra Benefits", job.benefits.join(' • '), isAr, isBenefit: true),

            const SizedBox(height: 12),
            
            // Job Type Tag
            _buildWhiteTag(_translateValue(job.type, isAr)),
            
            const SizedBox(height: 24),
            
            // Footer: Applicants (Right) and Apply Button (Left)
            Row(
              children: [
                if (isAr) ...[
                  // Arabic: Applicants on Right, Button on Left
                  Text(
                    "${RecruitmentSyncStore.instance.applications.where((a) => a.jobId == job.id).length} ${isAr ? 'متقدم' : 'applied'}",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const Spacer(),
                  _buildApplyActionBtn(context, job, isAr),
                ] else ...[
                  // English: Button on Left, Applicants on Right
                  _buildApplyActionBtn(context, job, isAr),
                  const Spacer(),
                  Text(
                    "${RecruitmentSyncStore.instance.applications.where((a) => a.jobId == job.id).length} applied",
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewText(String label, String text, bool isAr, {bool isBenefit = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        "$label: $text",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isBenefit ? const Color(0xFF4CAF50) : Colors.white70,
          fontSize: 12,
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildApplyActionBtn(BuildContext context, RecruitmentJob job, bool isAr) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userJobApplication, arguments: job),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF142C66),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      child: Text(
        isAr ? "تقديم" : "Apply",
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}


class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final apps = store.applications;
        final totalApps = apps.length;
        final hiredApps = apps.where((a) => a.status.toLowerCase().contains('hire') || a.status.toLowerCase().contains('accept')).length;
        final percentage = totalApps > 0 ? (hiredApps / totalApps * 100).toInt() : 0;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Header matching the image
              Text(
                isAr ? '${store.currentUserName} صباح الخير' : 'Good morning ${store.currentUserName}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: isAr ? TextAlign.right : TextAlign.left,
              ),
              Text(
                isAr ? 'هذا ما قمت به بطلباتك حتى الآن' : 'Here is what you have done with your applications so far',
                style: TextStyle(fontSize: 14, color: isDark ? Colors.white60 : Colors.black54),
                textAlign: isAr ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 32),

              // Stats Row from image
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Circular Progress Card (Left in image)
                  Expanded(
                    flex: 5,
                    child: Container(
                      height: 200,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            isAr ? 'حالة التقديم' : 'Application Status',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Spacer(),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: CircularProgressIndicator(
                                  value: totalApps == 0 ? 0.01 : hiredApps / totalApps,
                                  strokeWidth: 12,
                                  backgroundColor: const Color(0xFFF0F2F5),
                                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                                ),
                              ),
                              Text(
                                '$percentage%',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Two small vertical cards (Right in image)
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildSmallStatCard(
                          isAr ? 'إجمالي ما تم التقديم عليه' : 'Total Applied',
                          totalApps.toString(),
                          Icons.description_outlined,
                          isDark,
                          isAr,
                        ),
                        const SizedBox(height: 16),
                        _buildSmallStatCard(
                          isAr ? 'تم اختيارك في' : 'You were selected in',
                          hiredApps.toString(),
                          Icons.check_circle_outline,
                          isDark,
                          isAr,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Recent History Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isAr) TextButton(onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userAllApplications), child: const Text('عرض الكل', style: TextStyle(color: Color(0xFF213E75)))),
                  Text(
                    isAr ? 'السجل الأخير' : 'Recent History',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  if (!isAr) TextButton(onPressed: () => Navigator.of(context).pushNamed(AppRoutes.userAllApplications), child: const Text('See All')),
                ],
              ),
              const SizedBox(height: 16),

              // Application Items matching image style
              ...apps.take(3).map((app) => _buildImageAppItem(context, app, isAr, isDark)),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSmallStatCard(String label, String value, IconData icon, bool isDark, bool isAr) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: Colors.black87),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            textAlign: isAr ? TextAlign.right : TextAlign.left,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildImageAppItem(BuildContext context, RecruitmentApplication app, bool isAr, bool isDark) {
    final bool isHired = app.status.toLowerCase().contains('hire') || app.status.toLowerCase().contains('accept');
    final statusColor = isHired ? const Color(0xFF4CAF50) : const Color(0xFFFF9800);
    final statusText = isHired ? (isAr ? 'تم التوظيف' : 'Hired') : (isAr ? 'تم التقديم' : 'Applied');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          if (!isAr) ...[
             _buildAppIcon(isDark),
             const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  '2/5/2026', // Placeholder matching image
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            isAr ? 'دوام كامل •' : '• Full Time',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          if (isAr) ...[
             const SizedBox(width: 16),
             _buildAppIcon(isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildAppIcon(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(Icons.business_rounded, color: Color(0xFF49769F), size: 24),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return const SizedBox.shrink(); // Legacy cleanup
  }

  Widget _buildAppItem(BuildContext context, RecruitmentApplication app, bool isAr) {
    return const SizedBox.shrink(); // Legacy cleanup
  }
}


class _CompaniesTab extends StatefulWidget {
  const _CompaniesTab({super.key});
  @override
  State<_CompaniesTab> createState() => _CompaniesTabState();
}

class _CompaniesTabState extends State<_CompaniesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = 'الكل';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final store = RecruitmentSyncStore.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        // Mock data with categories for filtering
        final List<Map<String, dynamic>> companiesData = [
          {'name': 'dragon', 'jobs': 14, 'logo': Icons.business, 'cat': 'Non-Tech'},
          {'name': 'Nexora Solutions', 'jobs': 8, 'logo': Icons.account_tree_rounded, 'cat': 'Technical'},
          {'name': 'إبداع للبرمجيات', 'jobs': 5, 'logo': Icons.code, 'cat': 'Technical'},
          {'name': 'المارودي للمقاولات', 'jobs': 12, 'logo': Icons.handyman, 'cat': 'Non-Tech'},
          {'name': 'Jobito Labs', 'jobs': 20, 'logo': Icons.rocket_launch, 'cat': 'Technical'},
        ];

        final filtered = companiesData.where((c) {
          final matchesSearch = c['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
          final matchesCat = _selectedCategory == 'الكل' || c['cat'] == _selectedCategory;
          return matchesSearch && matchesCat;
        }).toList();

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blue Header Section - Now matches Discover Tab size & style
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF213E75),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        isAr ? 'تصفح الشركات' : 'Browse Companies',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isAr ? 'اكتشف أفضل الشركات وابحث عن فرصتك المثالية.' : 'Discover best companies and find your ideal opportunity.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                      const SizedBox(height: 24),
                      // Floating Search Bar - Matches Discover Tab Style
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            // Search Input Area (Right side in RTL)
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.search, color: Colors.grey, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: TextField(
                                        controller: _searchController,
                                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                                        onChanged: (v) => setState(() => _searchQuery = v),
                                        decoration: InputDecoration(
                                          hintText: isAr ? 'ابحث عن شركة...' : 'Search for company...',
                                          border: InputBorder.none,
                                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Location part (Left side in RTL)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: 'All', // Mocked for design parity
                                    icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
                                    style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500),
                                    items: ['All', 'Cairo', 'Giza'].map((gov) => DropdownMenuItem(
                                      value: gov,
                                      child: Text(_translateValue(gov, isAr)),
                                    )).toList(),
                                    onChanged: (v) {},
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF7A2A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.location_on, color: Colors.white, size: 18),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Categories Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                      child: Text(
                        isAr ? 'التصنيف' : 'Category', 
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Non-Tech' ? 'الكل' : 'Non-Tech'),
                            child: _buildCategoryBtn(isAr ? 'غير تقني' : 'Non-Tech', _selectedCategory == 'Non-Tech'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedCategory = _selectedCategory == 'Technical' ? 'الكل' : 'Technical'),
                            child: _buildCategoryBtn(isAr ? 'تقني' : 'Technical', _selectedCategory == 'Technical'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // All Companies List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(isAr ? 'جميع الشركات' : 'All Companies', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      isAr ? 'إجمالي الشركات المدرجة: ${filtered.length}' : 'Total listed companies: ${filtered.length}',
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    ...filtered.map((company) => _buildCompanyCard(context, company, isAr, isDark)),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }
    );
  }

  Widget _buildCategoryBtn(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF7A2A) : const Color(0xFF142C66),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Center(
        child: Text(
          label, 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildCompanyCard(BuildContext context, Map<String, dynamic> company, bool isAr, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF213E75),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: isAr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Row 1: "Vacant Jobs" Tag on the far right
          Row(
            mainAxisAlignment: isAr ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isAr ? 'وظائف شاغرة ${company['jobs']}' : '${company['jobs']} Vacant Jobs',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Row 2: Company Logo
          _buildCompanyIcon(company['logo']),
          const SizedBox(height: 16),
          
          // Row 3: Company Name
          Text(
            company['name'],
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          
          // Row 4: Company Info/About
          Text(
            isAr 
              ? 'شركة رائدة في مجال الحلول المتكاملة والابتكار، توفر بيئة عمل محفزة.' 
              : 'A leading company in integrated solutions and innovation, providing a motivating work environment.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 13,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          
          // Row 5: Service Type Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF7A2A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isAr ? 'خدمات عامة' : 'General Services',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(color: Colors.white24),
          
          // Row 6: View Profile Action
          Align(
            alignment: isAr ? Alignment.centerLeft : Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.userCompanyDetails, 
                arguments: {'name': company['name']}
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isAr) const Text('View Profile', style: TextStyle(color: Colors.white)),
                  Icon(
                    isAr ? Icons.arrow_back_ios : Icons.arrow_forward_ios, 
                    size: 14, 
                    color: const Color(0xFFFF7A2A)
                  ),
                  if (isAr) const Text('عرض الملف الشخصي', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFEDF2FF), borderRadius: BorderRadius.circular(15)),
      child: Icon(icon, color: const Color(0xFF49769F), size: 30),
    );
  }
}



class _ProfileTab extends StatelessWidget {
  const _ProfileTab({super.key});
  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(height: 200, width: double.infinity, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF011931), Color(0xFF49769F)]))),
                  Positioned(
                    bottom: -50, left: isAr ? null : 24, right: isAr ? 24 : null,
                    child: Container(
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4)),
                      child: CircleAvatar(radius: 50, backgroundColor: Colors.white, backgroundImage: getAppImageProvider(store.profileImage)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(store.currentUserName, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    Text(store.currentUserEmail, style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                    const SizedBox(height: 30),
                    _buildInfoCard(context, isAr ? 'عني' : 'About Me', store.currentUserAbout, Icons.info_outline, isDark),
                    const SizedBox(height: 16),
                    _buildInfoCard(context, isAr ? 'المهارات' : 'Skills', store.currentUserSkills.join(', '), Icons.psychology_outlined, isDark),
                    const SizedBox(height: 30),
                    if (store.currentUserExperience.isNotEmpty) ...[
                      Text(isAr ? 'الخبرات' : 'Experience', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ...store.currentUserExperience.map((exp) => ListTile(title: Text(exp['title']!), subtitle: Text(exp['company']!))),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }
    );
  }


  Widget _buildInfoCard(BuildContext context, String title, String content, IconData icon, bool isDark) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.black12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(content.isEmpty ? '---' : content, style: const TextStyle(fontSize: 15)),
          ])),
        ],
      ),
    );
  }
}

