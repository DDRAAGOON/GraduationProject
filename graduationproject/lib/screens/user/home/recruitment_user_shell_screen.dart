import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../teardsman/setting/settings.dart';
import '../messages/messages_list_screen.dart';
import '../teardsman/nav_Botton_bar/nav_bottom_bar.dart';
import '../profile/user_data.dart';

class RecruitmentUserShellScreen extends StatefulWidget {
  const RecruitmentUserShellScreen({super.key});

  @override
  State<RecruitmentUserShellScreen> createState() =>
      _RecruitmentUserShellScreenState();
}

class _RecruitmentUserShellScreenState extends State<RecruitmentUserShellScreen> {
  int _tab = 0;
  bool get _isAr => Localizations.localeOf(context).languageCode == 'ar';

  @override
  void initState() {
    super.initState();
    // Start polling immediately to ensure mock jobs are loaded even if login fails
    RecruitmentSyncService.instance.startPolling();
    RecruitmentSyncService.instance.loginForDemo(companyRole: false).catchError((e) {
      debugPrint('Login failed, continuing in demo mode: $e');
    });
  }

  @override
  void dispose() {
    RecruitmentSyncService.instance.stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = <Widget>[
      const _DiscoverTab(),
      const _ApplicationsTab(),
      const MessagesListScreen(),
      const _ProfileTab(),
    ];
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              backgroundImage: UserProfileData.profileImage != null
                  ? (UserProfileData.profileImage!.startsWith('http') 
                      ? NetworkImage(UserProfileData.profileImage!) 
                      : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                  : null,
              child: UserProfileData.profileImage == null 
                  ? const Icon(Icons.person, size: 20) 
                  : null,
            ),
          ),
        ),
        title: Text(
          _tab == 0 ? (_isAr ? 'اكتشف الوظائف' : 'Discover Jobs') : 
          _tab == 1 ? (_isAr ? 'تقديماتي' : 'My Apps') :
          _tab == 2 ? (_isAr ? 'الرسائل' : 'Messages') :
          (_isAr ? 'البروفايل' : 'Profile'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF9F5F1),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Settings()),
            ),
            icon: const Icon(Icons.settings_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        selectedIndex: _tab,
        onDestinationSelected: (int value) => setState(() => _tab = value),
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
            icon: const Icon(Icons.person),
            label: _isAr ? 'البروفايل' : 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'contract':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) {
        final jobs = store.filteredJobs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobs.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 12),
                              child: Icon(Icons.search, color: Colors.grey, size: 20),
                            ),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: isAr ? 'ابحث بالاسم أو الوظيفة...' : 'Search by name or job...',
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                                  hintStyle: const TextStyle(fontSize: 14),
                                ),
                                onChanged: (value) =>
                                    store.updateFilters(searchQuery: value.trim()),
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Icon(Icons.location_on, color: Colors.grey, size: 18),
                            ),
                            Expanded(
                              flex: 2,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: store.filterLocation,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down, size: 18),
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  items: RecruitmentSyncStore.egyptGovernorates.map((gov) {
                                    return DropdownMenuItem(
                                      value: gov,
                                      child: Text(gov, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      store.updateFilters(location: value);
                                    }
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(AppRoutes.userAdvancedFilters),
                        icon: const Icon(Icons.tune, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            final RecruitmentJob job = jobs[index - 1];
            final typeColor = _getJobTypeColor(job.type);
            return Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      job.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.business, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(job.companyName, style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(job.location, style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: job.tags
                          .map((String tag) => Chip(
                                label: Text(tag),
                                backgroundColor: const Color(0xFFF9F5F1),
                                side: BorderSide.none,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: typeColor.withOpacity(0.5)),
                      ),
                      child: Text(
                        job.type,
                        style: TextStyle(
                          color: typeColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFF7A2A)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            onPressed: () => Navigator.of(context).pushNamed(
                              AppRoutes.userJobDetails,
                              arguments: job,
                            ),
                            child: Text(
                              isAr ? 'عرض التفاصيل' : 'View Details',
                              style: const TextStyle(color: Color(0xFFFF7A2A), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      label: isAr ? 'قدّم الآن' : 'Apply Now',
                      onPressed: () => Navigator.of(context).pushNamed(
                        AppRoutes.userJobApplication,
                        arguments: job,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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

    // Stats
    final totalApps = apps.length;
    final hiredApps = apps.where((a) => a.status.toLowerCase() == 'hired' || a.status == 'تم التوظيف').length;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting
            Text(
              isAr ? '${store.currentUserName} صباح الخير' : 'Good Morning, ${store.currentUserName}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF011931)),
            ),
            const SizedBox(height: 4),
            Text(
              isAr ? 'هذا ما قمت به بطلباتك حتى الآن' : 'Here is what\'s happening with your applications',
              style: const TextStyle(color: Colors.black54, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Top Row: Stats & Progress
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stat Cards
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildStatCard(
                        isAr ? 'إجمالي ما تم التقديم عليه' : 'Total Applied',
                        totalApps.toString(),
                        Icons.description_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildStatCard(
                        isAr ? 'تم اختيارك في' : 'You were hired in',
                        hiredApps.toString(),
                        Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Circular Progress Chart
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 180,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isAr ? 'حالة التقديم' : 'App Status', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Expanded(
                          child: Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: CircularProgressIndicator(
                                    value: totalApps == 0 ? 0 : hiredApps / totalApps,
                                    strokeWidth: 10,
                                    backgroundColor: const Color(0xFFEEEEEE),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('${totalApps > 0 ? (hiredApps / totalApps * 100).toInt() : 0}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Log Title
            Text(
              isAr ? 'السجل الأخير' : 'Recent Log',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF011931)),
            ),
            const SizedBox(height: 16),

            // Application List
            if (apps.isEmpty)
               Center(child: Padding(
                 padding: const EdgeInsets.all(40.0),
                 child: Text(isAr ? 'لا يوجد طلبات حالياً' : 'No applications yet.'),
               ))
            else
              ...apps.map((app) => _buildRecentAppItem(context, app, isAr)),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF011931))),
              Icon(icon, color: Colors.grey.shade400, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildRecentAppItem(BuildContext context, RecruitmentApplication app, bool isAr) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F5F1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.business, color: Color(0xFF49769F)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(app.jobTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('${app.companyName} • Full-time', style: const TextStyle(color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${app.updatedAt.day}/${app.updatedAt.month}/${app.updatedAt.year}',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  app.status,
                  style: const TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRoutes.userApplicationTimeline,
                arguments: app,
              );
            },
            icon: const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
          ),
        ],
      ),
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
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white,
                backgroundImage: UserProfileData.profileImage != null
                    ? (UserProfileData.profileImage!.startsWith('http') 
                        ? NetworkImage(UserProfileData.profileImage!) 
                        : FileImage(File(UserProfileData.profileImage!)) as ImageProvider)
                    : null,
                child: UserProfileData.profileImage == null 
                    ? const Icon(Icons.person, size: 40, color: Color(0xFF49769F)) 
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      UserProfileData.fullName.isEmpty ? "Not yet" : UserProfileData.fullName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      UserProfileData.jobTitle.isEmpty ? "Not yet" : UserProfileData.jobTitle,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              // Edit pen removed as requested
            ],
          ),
          const SizedBox(height: 24),
          
          // Switch to Tradesman Button
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(t.tr(en: "Switching to Tradesman Mode...", ar: "التبديل إلى وضع الصنايعي...")),
                  backgroundColor: const Color(0xFFFF7A2A),
                  duration: const Duration(seconds: 1),
                ),
              );
              // Navigate to Tradesman Shell
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Navbotton()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFFF7A2A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFFFF7A2A).withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.swap_horiz, color: Color(0xFFFF7A2A)),
                  const SizedBox(width: 10),
                  Text(
                    t.tr(en: "Switch to Tradesman", ar: "التبديل إلى وضع الصنايعي"),
                    style: const TextStyle(color: Color(0xFFFF7A2A), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.withOpacity(0.1)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileItem(isAr ? 'البريد الإلكتروني' : 'Email', UserProfileData.email),
                  _buildProfileItem(isAr ? 'رقم الهاتف' : 'Phone', UserProfileData.phone),
                  _buildProfileItem(isAr ? 'الموقع' : 'Location', UserProfileData.location),
                  _buildProfileItem(isAr ? 'نبذة عني' : 'About Me', UserProfileData.aboutMe),
                  _buildProfileItem(isAr ? 'المهارات' : 'Skills', UserProfileData.skills.join(', ')),
                  _buildProfileItem(isAr ? 'خبرة العمل' : 'Work Experience', UserProfileData.experiences.map((e) => "${e['title']} (${e['duration']})").join('\n')),
                  _buildProfileItem(isAr ? 'رابط ملف الأعمال' : 'Portfolio', UserProfileData.portfolioUrl),
                  _buildProfileItem(isAr ? 'السيرة الذاتية' : 'CV', UserProfileData.cvName ?? ""),
                  
                  // Gallery Section
                  if (UserProfileData.portfolioImages.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      isAr ? 'المعرض' : 'Gallery',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: UserProfileData.portfolioImages.length,
                        itemBuilder: (context, index) {
                          final path = UserProfileData.portfolioImages[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: path.startsWith('http')
                                  ? Image.network(path, width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image))
                                  : Image.file(File(path), width: 100, height: 100, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.broken_image)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  if (UserProfileData.socialLinks.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      isAr ? 'الروابط الاجتماعية' : 'Social Links',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ...UserProfileData.socialLinks.map((link) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.link, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text('${link['platform']}: '),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                String url = link['url'] ?? '';
                                if (url.isNotEmpty) {
                                  if (!url.startsWith('http')) {
                                    url = 'https://$url';
                                  }
                                  final uri = Uri.parse(url);
                                  if (await canLaunchUrl(uri)) {
                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                  }
                                }
                              },
                              child: Text(
                                link['url'] ?? '',
                                style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "Not yet" : value,
            style: const TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
