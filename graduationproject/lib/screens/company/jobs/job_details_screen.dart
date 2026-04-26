// Full job posting details and management actions.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/models/job.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyJobDetailsScreen extends StatefulWidget {
  const CompanyJobDetailsScreen({super.key, required this.job});

  final Job job;

  @override
  State<CompanyJobDetailsScreen> createState() =>
      _CompanyJobDetailsScreenState();
}

class _CompanyJobDetailsScreenState extends State<CompanyJobDetailsScreen> {
  Job get _job => CompanyStore.instance.jobById(widget.job.id);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final job = _job;
    return AppScaffold(
      title: job.title,
      showBack: true,
      actions: [
        IconButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyApplicantsTable, arguments: job),
          icon: const Icon(Icons.groups_outlined),
        ),
        IconButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyJobAnalytics, arguments: job),
          icon: const Icon(Icons.bar_chart_outlined),
        ),
      ],
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${job.companyName} • ${job.employmentType}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              SectionTitle(
                t.descriptionSection,
                trailing: IconButton(
                  tooltip: t.edit,
                  onPressed: () => _editJob(context, job),
                  icon: const Icon(Icons.edit_outlined),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                job.description.isEmpty
                    ? t.noDescriptionYet
                    : job.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SectionTitle(t.responsibilities),
              const SizedBox(height: 10),
              _Bullets(items: job.responsibilities),
              const SizedBox(height: 16),
              SectionTitle(t.niceToHavesSection),
              const SizedBox(height: 10),
              _Bullets(items: job.niceToHaves),
              const SizedBox(height: 16),
              SectionTitle(t.qualifications),
              const SizedBox(height: 10),
              _Bullets(items: job.qualifications),
              const SizedBox(height: 16),
              SectionTitle(t.benefits),
              const SizedBox(height: 10),
              if (job.benefits.isEmpty)
                Text(t.notYet, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)))
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.benefits.map((b) => Chip(
                    label: Text(b.title),
                    avatar: Icon(Icons.check_circle_outline, size: 16, color: Theme.of(context).colorScheme.primary),
                    visualDensity: VisualDensity.compact,
                  )).toList(),
                ),
              const SizedBox(height: 16),
              SectionTitle(t.aboutThisRole),
              const SizedBox(height: 10),
              _InfoRow(label: t.salaryLabel, value: job.salaryRange),
              _InfoRow(label: t.jobTypeLabel, value: job.employmentType),
              _InfoRow(label: t.categoryLabel, value: job.category),
              const SizedBox(height: 18),
              _JobApplicantsSection(),
              const SizedBox(height: 14),
              AppButton(
                label: t.openFullTable,
                onPressed: () => Navigator.of(context).pushNamed(
                  AppRoutes.companyApplicantsTable,
                  arguments: job,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
    );
  }

  Future<void> _deleteJob(Job job) async {
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
    final deleted = CompanyStore.instance.deleteJob(job.id);
    if (!mounted) return;
    if (deleted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.jobDeleted)));
    }
  }

  Future<void> _editJob(BuildContext context, Job job) async {
    Navigator.of(context).pushNamed(
      AppRoutes.companyPostJobStep1,
      arguments: job,
    );
  }
}

class _Bullets extends StatelessWidget {
  const _Bullets({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    if (items.isEmpty) {
      return Text(
        t.noItemsYet,
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    return Column(
      children: items
          .map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.circle, size: 6),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: Text(text)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _JobApplicantsSection extends StatelessWidget {
  const _JobApplicantsSection();

  @override
  Widget build(BuildContext context) {
    final applicants = MockData.applicants();
    return Card(
      child: Column(
        children: applicants
            .take(4)
            .map(
              (a) => ListTile(
                dense: true,
                title: Text(a.fullName),
                subtitle: Text('${a.role} • ${a.stage}'),
                trailing: const Icon(Icons.chevron_right),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 420;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: isNarrow
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                SizedBox(width: 110, child: Text(label)),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
