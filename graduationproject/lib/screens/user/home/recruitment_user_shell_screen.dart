import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

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
    RecruitmentSyncService.instance
        .loginForDemo(companyRole: false)
        .then((_) => RecruitmentSyncService.instance.startPolling());
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
      const _MessagesTab(),
      const _SavedJobsTab(),
      const _ProfileTab(),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: InkWell(
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.userEditProfile),
            borderRadius: BorderRadius.circular(20),
            child: const CircleAvatar(
              backgroundImage: AssetImage(AppImages.companyProfile1),
            ),
          ),
        ),
        title: _isAr 
            ? Text('مساحة المستخدم') 
            : Image.asset(
                'assets/company/logo/logo.png',
                height: 150,
                fit: BoxFit.contain,
              ),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
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
            label: _isAr ? 'الرسائل' : 'Inbox',
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
      builder: (BuildContext context, _) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: store.filteredJobs.length + 1,
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
                                hintText: isAr ? 'بحث...' : 'Search...',
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
          final RecruitmentJob job = store.filteredJobs[index - 1];
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.business, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(job.companyName),
                      const SizedBox(width: 8),
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(job.location),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.userJobDetails,
                            arguments: job,
                          ),
                          child: const Text('View Details'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () => store.toggleSaveJob(job.id),
                        icon: Icon(
                          store.savedJobIds.contains(job.id)
                              ? Icons.bookmark
                              : Icons.bookmark_outline,
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
      ),
    );
  }
}

class _ApplicationsTab extends StatelessWidget {
  const _ApplicationsTab();

  @override
  Widget build(BuildContext context) {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) {
        if (store.applications.isEmpty) {
          return const Center(child: Text('No applications yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: store.applications.length,
          itemBuilder: (BuildContext context, int index) {
            final RecruitmentApplication app = store.applications[index];
            return Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(app.jobTitle),
                subtitle: Text('${app.companyName}\nStatus: ${app.status}'),
                isThreeLine: true,
                trailing: Text(
                  '${app.updatedAt.hour}:${app.updatedAt.minute.toString().padLeft(2, '0')}',
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.userApplicationTimeline,
                  arguments: app,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MessagesTab extends StatelessWidget {
  const _MessagesTab();

  @override
  Widget build(BuildContext context) {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) => ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(16),
        itemCount: store.messages.length,
        itemBuilder: (BuildContext context, int index) {
          final RecruitmentMessage message = store.messages[index];
          return Align(
            alignment: message.fromCompany
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.fromCompany
                    ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.15)
                    : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(message.text),
            ),
          );
        },
      ),
    );
  }
}

class _SavedJobsTab extends StatelessWidget {
  const _SavedJobsTab();

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        if (store.savedJobs.isEmpty) {
          return const Center(child: Text('No saved jobs.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: store.savedJobs.length,
          itemBuilder: (context, index) {
            final job = store.savedJobs[index];
            return Card(
              color: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: ListTile(
                title: Text(job.title),
                subtitle: Text('${job.companyName} • ${job.location}'),
                trailing: IconButton(
                  onPressed: () => store.toggleSaveJob(job.id),
                  icon: const Icon(Icons.delete_outline),
                ),
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.userJobDetails,
                  arguments: job,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _ProfileTab extends StatefulWidget {
  const _ProfileTab();

  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  final _aboutController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final store = RecruitmentSyncStore.instance;
    _nameController.text = store.currentUserName;
    _emailController.text = store.currentUserEmail;
    _phoneController.text = store.currentUserPhone;
    _locationController.text = store.currentUserLocation;
    _aboutController.text = store.currentUserAbout;
    _skillsController.text = store.currentUserSkills.join(', ');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _aboutController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        // Sync controllers if data changes in store
        _loadData();
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isAr ? 'الملف الشخصي' : 'Profile',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.userSettingsNew),
                    icon: const Icon(Icons.settings_outlined),
                    label: Text(isAr ? 'الإعدادات' : 'Settings'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
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
                      _buildProfileItem(isAr ? 'الاسم بالكامل' : 'Full Name', _nameController),
                      _buildProfileItem(isAr ? 'البريد الإلكتروني' : 'Email', _emailController),
                      _buildProfileItem(isAr ? 'رقم الهاتف' : 'Phone', _phoneController),
                      _buildProfileItem(isAr ? 'الموقع' : 'Location', _locationController),
                      _buildProfileItem(isAr ? 'نبذة عني' : 'About Me', _aboutController, maxLines: 3),
                      _buildProfileItem(isAr ? 'المهارات' : 'Skills', _skillsController),
                      
                      if (store.socialLinks.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        Text(
                          isAr ? 'الروابط الاجتماعية' : 'Social Links',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        ...store.socialLinks.map((link) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.link, size: 18, color: Colors.blue),
                              const SizedBox(width: 8),
                              Text('${link['platform']}: '),
                              Expanded(
                                child: Text(
                                  link['url'] ?? '',
                                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],

                      const SizedBox(height: 20),
                      AppButton(
                        label: isAr ? 'حفظ التغييرات' : 'Save Profile',
                        onPressed: () {
                          store.updateUserProfile(
                            fullName: _nameController.text,
                            title: store.currentUserTitle,
                            email: _emailController.text,
                            phone: _phoneController.text,
                            location: _locationController.text,
                            about: _aboutController.text,
                            skills: _skillsController.text.split(',').map((e) => e.trim()).toList(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(isAr ? 'تم تحديث الملف الشخصي' : 'Profile updated')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileItem(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
