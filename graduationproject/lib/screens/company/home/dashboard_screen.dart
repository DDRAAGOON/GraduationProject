// Company home: KPIs, shortcuts, and recent jobs.

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
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
    return AnimatedBuilder(
      animation: companyStore,
      builder: (context, _) {
        return AppScaffold(
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: companyStore.companyProfileImage.startsWith('assets/')
                    ? Image.asset(
                        companyStore.companyProfileImage,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(companyStore.companyProfileImage),
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  companyStore.companyName,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          showBack: false,
          centerTitle: false,
          showAppBarDivider: true,
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final jobs = companyStore.jobs;
                  final t = AppLocalizations.of(context);
                  return ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth < 400 ? 12 : 16,
                      vertical: 16,
                    ),
                    children: [
                      _StatsGrid(
                        availableWidth: constraints.maxWidth,
                        onTapNewCandidates: () =>
                            Navigator.of(context).pushNamed(
                              AppRoutes.companyApplicantsTable,
                              arguments:
                              jobs.isNotEmpty ? jobs.first : Job.mock(),
                            ),
                      ),
                      const SizedBox(height: 18),
                      SectionTitle(t.jobUpdates),
                      const SizedBox(height: 10),
                      ...jobs.map((j) => _JobUpdateCard(job: j)),
                      if (jobs.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            t.noJobsYet,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.home),
        );
      },
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({
    required this.onTapNewCandidates,
    required this.availableWidth,
  });

  final VoidCallback onTapNewCandidates;
  final double availableWidth;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context);

    final int crossAxisCount = availableWidth < 360
        ? 1
        : availableWidth >= 700
        ? 3
        : 2;

    final double aspectRatio = availableWidth < 360
        ? 2.8
        : availableWidth >= 700
        ? 1.9
        : 1.5;

    final cards = [
      _MetricCard(
        title: t.newCandidates,
        value: t.tr(en: '76', ar: '٧٦'),
        color: cs.primary.withValues(alpha: 0.2),
        onTap: onTapNewCandidates,
      ),
      _MetricCard(
        title: t.messagesReceived,
        value: t.tr(en: '24', ar: '٢٤'),
        color: Colors.orange.withValues(alpha: 0.25),
        onTap: () => Navigator.of(context)
            .pushReplacementNamed(AppRoutes.companyMessagesList),
      ),
    ];

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: aspectRatio,
      children: cards,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.labelLarge,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        value,
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
    final t = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(AppRoutes.companyJobDetails, arguments: job),
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    IconButton(
                      tooltip: t.edit,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AppRoutes.companyJobDetails, arguments: job),
                      icon: const Icon(Icons.edit_outlined, size: 20),
                    ),
                    IconButton(
                      tooltip: t.delete,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () => _confirmDelete(context),
                      icon: const Icon(Icons.delete_outline, size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${job.companyName} • ${job.location} • ${job.employmentType}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _Chip(job.category),
                    _Chip(job.employmentType),
                    if (job.appliedCount != null && job.capacity != null)
                      Text(
                        '${job.appliedCount} ${t.appliedOf} ${job.capacity}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
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
    final t = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.deleteJobTitle),
        content: Text(t.deleteJobContent(job.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(t.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    CompanyStore.instance.deleteJob(job.id);
    if (context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(t.jobDeleted)));
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
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
