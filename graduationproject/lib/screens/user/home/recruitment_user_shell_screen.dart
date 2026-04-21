import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
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
      appBar: AppBar(title: Text(_isAr ? 'مساحة المستخدم' : 'User Workspace')),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
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
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText:
                            isAr ? 'ابحث عن وظيفة أو شركة' : 'Search jobs or companies',
                      ),
                      onChanged: (value) =>
                          store.updateFilters(searchQuery: value.trim()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => Navigator.of(context)
                        .pushNamed(AppRoutes.userAdvancedFilters),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            );
          }
          final RecruitmentJob job = store.filteredJobs[index - 1];
          return Card(
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
                  Text('${job.companyName} • ${job.location}'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: job.tags
                        .map((String tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Text(job.salaryRange),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
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
                  const SizedBox(height: 8),
                  if (store.userRole == 'Job Seeker')
                    _WorkerRequestQuickCard(isAr: isAr),
                  if (store.userRole == 'Job Seeker') const SizedBox(height: 8),
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
  final _titleController = TextEditingController();
  final _locationController = TextEditingController(text: 'Cairo, Egypt');
  final _bioController = TextEditingController(
    text:
        'Flutter developer focused on scalable architecture and pixel-perfect UI.',
  );
  final _skillsController = TextEditingController(
    text: 'Flutter, Dart, REST API, Firebase',
  );
  final _portfolioController = TextEditingController(
    text: 'https://portfolio.example.com',
  );
  String _selectedRole = 'Job Seeker';

  @override
  void initState() {
    super.initState();
    final store = RecruitmentSyncStore.instance;
    _nameController.text = store.currentUserName;
    _titleController.text = store.currentUserTitle;
    _selectedRole = store.userRole;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _skillsController.dispose();
    _portfolioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Profile',
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
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: isAr ? 'المسمى الوظيفي' : 'Professional title',
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedRole,
                      decoration: InputDecoration(
                        labelText: isAr ? 'نوع الحساب' : 'Account type',
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Worker',
                          child: Text('Worker'),
                        ),
                        DropdownMenuItem(
                          value: 'Job Seeker',
                          child: Text('Job Seeker'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedRole = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _locationController,
                      decoration:
                          InputDecoration(labelText: isAr ? 'الموقع' : 'Location'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _bioController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: 'About',
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _skillsController,
                      decoration:
                          const InputDecoration(labelText: 'Skills (comma separated)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _portfolioController,
                      decoration: const InputDecoration(labelText: 'Portfolio URL'),
                    ),
                    const SizedBox(height: 14),
                    AppButton(
                      label: 'Save Profile',
                      onPressed: () {
                        store.updateUserProfile(
                          fullName: _nameController.text,
                          title: _titleController.text,
                          role: _selectedRole,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isAr ? 'تم تحديث البروفايل' : 'Profile updated',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.verified_user_outlined),
                title: const Text('Profile Completion'),
                subtitle: const Text('78% completed - add CV and certifications'),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerRequestQuickCard extends StatefulWidget {
  const _WorkerRequestQuickCard({required this.isAr});

  final bool isAr;

  @override
  State<_WorkerRequestQuickCard> createState() => _WorkerRequestQuickCardState();
}

class _WorkerRequestQuickCardState extends State<_WorkerRequestQuickCard> {
  final _title = TextEditingController();
  final _desc = TextEditingController();
  final _budget = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _budget.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isAr ? 'محتاج Worker؟' : 'Need a Worker?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _title,
              decoration: InputDecoration(
                labelText: widget.isAr ? 'عنوان الطلب' : 'Request title',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _desc,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: widget.isAr ? 'تفاصيل' : 'Description',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _budget,
              decoration: InputDecoration(
                labelText: widget.isAr ? 'الميزانية' : 'Budget',
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  if (_title.text.trim().isEmpty || _desc.text.trim().isEmpty) {
                    return;
                  }
                  store.postServiceRequest(
                    title: _title.text.trim(),
                    description: _desc.text.trim(),
                    budget: _budget.text.trim().isEmpty
                        ? 'Negotiable'
                        : _budget.text.trim(),
                  );
                  _title.clear();
                  _desc.clear();
                  _budget.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.isAr
                          ? 'تم نشر طلب الـWorker'
                          : 'Worker request posted'),
                    ),
                  );
                },
                child: Text(widget.isAr ? 'نشر الطلب' : 'Post Request'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
