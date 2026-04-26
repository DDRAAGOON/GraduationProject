import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/services/recruitment_sync_service.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_button.dart';

class RecruitmentCompanyShellScreen extends StatefulWidget {
  const RecruitmentCompanyShellScreen({super.key});

  @override
  State<RecruitmentCompanyShellScreen> createState() =>
      _RecruitmentCompanyShellScreenState();
}

class _RecruitmentCompanyShellScreenState
    extends State<RecruitmentCompanyShellScreen> {
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    RecruitmentSyncService.instance
        .loginForDemo(companyRole: true)
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
      const _CompanyDashboardTab(),
      const _CompanyAnalyticsTab(),
      const _PipelineTab(),
      const _BroadcastTab(),
      const _CompanyMoreTab(),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Company Workspace')),
      body: pages[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (int value) => setState(() => _tab = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Analytics'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Pipeline'),
          NavigationDestination(icon: Icon(Icons.send), label: 'Broadcast'),
          NavigationDestination(icon: Icon(Icons.apps), label: 'More'),
        ],
      ),
    );
  }
}

class _CompanyDashboardTab extends StatelessWidget {
  const _CompanyDashboardTab();

  @override
  Widget build(BuildContext context) {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          Text(
            'Company Control Center',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Quick Stats',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text('Active jobs: ${store.jobs.length}'),
                  Text('Applications: ${store.applications.length}'),
                  Text('Messages: ${store.messages.length}'),
                  Text('Worker requests: ${store.serviceRequests.length}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (store.serviceRequests.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Worker Requests',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    ...store.serviceRequests.take(2).map(
                      (r) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(r.title),
                        subtitle: Text('${r.requestedBy} • ${r.budget}'),
                        trailing: const Icon(Icons.chevron_right),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Post New Job',
            icon: Icons.add,
            onPressed: () async {
              Navigator.of(context).pushNamed(AppRoutes.companyPostJobComposer);
            },
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Edit Company Profile',
            variant: AppButtonVariant.secondary,
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.companyProfileEditor),
          ),
        ],
      ),
    );
  }
}

class _CompanyMoreTab extends StatelessWidget {
  const _CompanyMoreTab();

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('All Posted Jobs', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...store.jobs.map(
            (job) => Card(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      title: Text(job.title),
                      subtitle: Text('${job.location} • ${job.salaryRange}'),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              AppRoutes.companyPostJobComposer,
                            ),
                            child: const Text('Edit Template'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Job shared: ${job.title}')),
                              );
                            },
                            child: const Text('Share'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompanyAnalyticsTab extends StatelessWidget {
  const _CompanyAnalyticsTab();

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    int countBy(String status) => store.applications.where((a) => a.status == status).length;
    final total = store.applications.isEmpty ? 1 : store.applications.length;

    Widget metric(String label, int value, Color color) {
      final ratio = value / total;
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text('$value', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: ratio.clamp(0, 1),
                color: color,
                backgroundColor: color.withOpacity(0.2),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Hiring Analytics',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 10),
        metric('Applied', countBy('Applied'), Theme.of(context).colorScheme.secondary),
        metric('In Review', countBy('In Review'), Theme.of(context).colorScheme.primary),
        metric('Shortlisted', countBy('Shortlisted'), Colors.teal),
        metric('Final Review', countBy('Final Review'), Colors.amber),
        metric('Hired', countBy('Hired'), Colors.green),
      ],
    );
  }
}

class _PipelineTab extends StatelessWidget {
  const _PipelineTab();

  @override
  Widget build(BuildContext context) {
    final RecruitmentSyncStore store = RecruitmentSyncStore.instance;
    return AnimatedBuilder(
      animation: store,
      builder: (BuildContext context, _) {
        if (store.applications.isEmpty) {
          return const Center(child: Text('No candidates yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: store.applications.length,
          itemBuilder: (BuildContext context, int index) {
            final RecruitmentApplication app = store.applications[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      app.userName,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    Text('${app.jobTitle} • ${app.status}'),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: () => RecruitmentSyncService.instance
                              .updateStatus(
                            applicationId: app.id,
                            status: 'Shortlisted',
                          ),
                          child: const Text('Shortlist'),
                        ),
                        OutlinedButton(
                          onPressed: () => RecruitmentSyncService.instance
                              .updateStatus(
                            applicationId: app.id,
                            status: 'Final Review',
                          ),
                          child: const Text('Final Review'),
                        ),
                        OutlinedButton(
                          onPressed: () => RecruitmentSyncService.instance
                              .updateStatus(
                            applicationId: app.id,
                            status: 'Hired',
                          ),
                          child: const Text('Hire'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          AppRoutes.companyCandidateDetails,
                          arguments: app,
                        ),
                        child: const Text('Open Candidate Profile'),
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

class _BroadcastTab extends StatefulWidget {
  const _BroadcastTab();

  @override
  State<_BroadcastTab> createState() => _BroadcastTabState();
}

class _BroadcastTabState extends State<_BroadcastTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Broadcast message to candidates',
            ),
          ),
          const SizedBox(height: 12),
          AppButton(
            label: 'Send',
            onPressed: () async {
              final String text = _controller.text.trim();
              if (text.isEmpty) {
                return;
              }
              await RecruitmentSyncService.instance.sendBroadcast(text);
              if (!context.mounted) {
                return;
              }
              _controller.clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Message delivered to users.')),
              );
            },
          ),
        ],
      ),
    );
  }
}
