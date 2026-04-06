import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';
import '../../../shared/models/job.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyStore = CompanyStore.instance;
    return AppScaffold(
      titleWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: Image.asset(
              AppImages.companyProfileImage,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            companyStore.companyName,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
        ],
      ),
      showBack: false,
      centerTitle: false,
      showAppBarDivider: true,
      body: AnimatedBuilder(
        animation: companyStore,
        builder: (context, _) {
          final jobs = companyStore.jobs;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _StatsGrid(
                    onTapNewCandidates: () => Navigator.of(context).pushNamed(
                      AppRoutes.companyApplicantsTable,
                      arguments: jobs.isNotEmpty ? jobs.first : Job.mock(),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const SectionTitle('Job Updates'),
                  const SizedBox(height: 10),
                  ...jobs.map((j) => _JobUpdateCard(job: j)),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.home),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.onTapNewCandidates});

  final VoidCallback onTapNewCandidates;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: [
        _MetricCard(
          title: 'New candidates\nto review',
          value: '76',
          color: cs.primary.withValues(alpha: 0.2),
          onTap: onTapNewCandidates,
        ),
        _MetricCard(
          title: 'Schedule\nfor today',
          value: '3',
          color: Colors.teal.withValues(alpha: 0.25),
          onTap: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyApplicantInterviewSchedule),
        ),
        _MetricCard(
          title: 'Messages\nreceived',
          value: '24',
          color: Colors.orange.withValues(alpha: 0.25),
          onTap: () => Navigator.of(
            context,
          ).pushReplacementNamed(AppRoutes.companyMessagesList),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String value;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.labelLarge),
                    const Spacer(),
                    Text(
                      value,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.trending_up, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobUpdateCard extends StatelessWidget {
  const _JobUpdateCard({required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(
          context,
        ).pushNamed(AppRoutes.companyJobDetails, arguments: job),
        borderRadius: BorderRadius.circular(18),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Edit',
                      onPressed: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.companyJobDetails, arguments: job),
                      icon: const Icon(Icons.edit_outlined, size: 20),
                    ),
                    IconButton(
                      tooltip: 'Delete',
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${job.companyName} • ${job.location} • ${job.employmentType}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _Chip(job.category),
                    const SizedBox(width: 8),
                    _Chip(job.employmentType),
                    const Spacer(),
                    if (job.appliedCount != null && job.capacity != null)
                      Text(
                        '${job.appliedCount} applied of ${job.capacity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete job post?'),
        content: Text('This will permanently delete "${job.title}".'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    CompanyStore.instance.deleteJob(job.id);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job deleted')));
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}
