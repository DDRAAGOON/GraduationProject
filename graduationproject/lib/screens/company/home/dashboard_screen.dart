// Company home: KPIs, shortcuts, and recent jobs.

import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/job.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyDashboardScreen extends StatelessWidget {
  const CompanyDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final companyStore = CompanyStore.instance;
    return ListenableBuilder(
      listenable: Listenable.merge([companyStore, RecruitmentSyncStore.instance]),
      builder: (context, _) {
        return AppScaffold(
          titleWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => Navigator.of(context).pushNamed(AppRoutes.companyProfileOverview),
                borderRadius: BorderRadius.circular(20),
                child: ClipOval(
                  child: companyStore.companyProfileImage == null
                    ? Container(
                        width: 40,
                        height: 40,
                        color: Theme.of(context).colorScheme.surfaceBright,
                        child: Icon(
                          Icons.business,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      )
                    : companyStore.companyProfileImage!.startsWith('assets/')
                        ? Image.asset(
                            companyStore.companyProfileImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            File(companyStore.companyProfileImage!),
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
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
                              arguments: jobs.isNotEmpty ? jobs.first : Job.mock(),
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
        value: RecruitmentSyncStore.instance.applications
            .where((app) => CompanyStore.instance.jobs.any((j) => j.id == app.jobId))
            .length
            .toString(),
        color: cs.primary.withOpacity(0.2),
        onTap: onTapNewCandidates,
      ),
      _MetricCard(
        title: t.messagesReceived,
        value: RecruitmentSyncStore.instance.messages.length.toString(),
        color: Colors.orange.withOpacity(0.25),
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

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase().trim()) {
      case 'full-time': return Colors.green;
      case 'part-time': return Colors.blue;
      case 'remote': return Colors.purple;
      case 'freelance': return Colors.teal;
      case 'one-time': return Colors.amber;
      case 'internship': return Colors.indigo;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final syncStore = RecruitmentSyncStore.instance;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(AppRoutes.companyJobDetails, arguments: job),
        borderRadius: BorderRadius.circular(18),
        child: Card(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.business, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      job.companyName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // Job Type Badges
                    ...job.employmentType.split(RegExp(r'[•,;]')).map((type) {
                      final tTrim = type.trim();
                      if (tTrim.isEmpty) return const SizedBox.shrink();
                      final color = _getJobTypeColor(tTrim);
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          tTrim,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      );
                    }),
                    // Category Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9F5F1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black.withOpacity(0.05)),
                      ),
                      child: Text(
                        job.category,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: syncStore,
                  builder: (context, _) {
                    final hiredCount = syncStore.applications
                        .where((a) => a.jobId == job.id && a.status.toLowerCase().contains('hire'))
                        .length;
                    final requiredCount = job.requiredCount > 0 ? job.requiredCount : 1;
                    final progress = (hiredCount / requiredCount).clamp(0.0, 1.0);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              t.hiredProgressMsg(hiredCount, requiredCount),
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: TextStyle(
                                color: progress >= 1.0 ? Colors.green : Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            color: progress >= 1.0 ? Colors.green : const Color(0xFF00D2B4),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
        color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: null,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
