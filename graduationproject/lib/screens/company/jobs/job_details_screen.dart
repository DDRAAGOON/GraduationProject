// Full job posting details and management actions.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/models/job.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_bottom_nav.dart';

enum _JobViewTab { table, pipeline }

class CompanyJobDetailsScreen extends StatefulWidget {
  const CompanyJobDetailsScreen({super.key, required this.job});

  final Job job;

  @override
  State<CompanyJobDetailsScreen> createState() =>
      _CompanyJobDetailsScreenState();
}

class _CompanyJobDetailsScreenState extends State<CompanyJobDetailsScreen> {
  _JobViewTab _tab = _JobViewTab.table;

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
          tooltip: t.edit,
          onPressed: () => _editJob(context, job),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          tooltip: t.deleteJobTooltip,
          onPressed: () => _deleteJob(job),
          icon: const Icon(Icons.delete_outline),
        ),
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
                '${job.companyName} • ${job.location} • ${job.employmentType}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.7),
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
              SectionTitle(t.aboutThisRole),
              const SizedBox(height: 10),
              _InfoRow(label: t.salaryLabel, value: job.salaryRange),
              _InfoRow(label: t.jobTypeLabel, value: job.employmentType),
              _InfoRow(label: t.categoryLabel, value: job.category),
              const SizedBox(height: 18),
              SegmentedButton<_JobViewTab>(
                segments: [
                  ButtonSegment(value: _JobViewTab.table, label: Text(t.tableView)),
                  ButtonSegment(
                    value: _JobViewTab.pipeline,
                    label: Text(t.pipelineView),
                  ),
                ],
                selected: {_tab},
                onSelectionChanged: (s) => setState(() => _tab = s.first),
              ),
              const SizedBox(height: 12),
              _JobApplicantsSection(tab: _tab),
              const SizedBox(height: 14),
              AppButton(
                label: _tab == _JobViewTab.table
                    ? t.openFullTable
                    : t.openFullPipeline,
                onPressed: () => Navigator.of(context).pushNamed(
                  _tab == _JobViewTab.table
                      ? AppRoutes.companyApplicantsTable
                      : AppRoutes.companyApplicantsPipeline,
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
    final t = AppLocalizations.of(context);
    final title = TextEditingController(text: job.title);
    final location = TextEditingController(text: job.location);
    final employmentType = TextEditingController(text: job.employmentType);
    final category = TextEditingController(text: job.category);
    final salaryRange = TextEditingController(text: job.salaryRange);
    final description = TextEditingController(text: job.description);

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final bottomInset = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(t.editJobTitle, style: Theme.of(ctx).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(
                  controller: title,
                  decoration: InputDecoration(labelText: t.titleLabel),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: location,
                  decoration: InputDecoration(labelText: t.locationLabel),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: employmentType,
                  decoration: InputDecoration(labelText: t.employmentTypeLabel),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: category,
                  decoration: InputDecoration(labelText: t.categoryLabel),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: salaryRange,
                  decoration: InputDecoration(labelText: t.salaryRangeLabel),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: description,
                  maxLines: 4,
                  decoration: InputDecoration(labelText: t.descriptionSection),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text(t.save),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (saved != true) return;
    CompanyStore.instance.saveJob(
      job.copyWith(
        title: title.text.trim(),
        location: location.text.trim(),
        employmentType: employmentType.text.trim(),
        category: category.text.trim(),
        salaryRange: salaryRange.text.trim(),
        description: description.text.trim(),
      ),
    );
    if (mounted) setState(() {});
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
  const _JobApplicantsSection({required this.tab});

  final _JobViewTab tab;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final applicants = MockData.applicants();
    if (tab == _JobViewTab.table) {
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

    final stages = <String, List<Applicant>>{
      t.inReview: applicants
          .where((a) => a.stage.toLowerCase().contains('review'))
          .toList(),
      t.shortlisted: applicants
          .where((a) => a.stage.toLowerCase().contains('short'))
          .toList(),
      t.interview: applicants
          .where((a) => a.stage.toLowerCase().contains('interview'))
          .toList(),
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: stages.entries
            .map(
              (entry) => Container(
                width: 180,
                margin: const EdgeInsets.only(right: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 6),
                        ...entry.value
                            .take(3)
                            .map(
                              (a) => Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  a.fullName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
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
                    ).colorScheme.onSurface.withValues(alpha: 0.8),
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
                      ).colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
