// List and search all jobs for the signed-in company.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/state/recruitment_sync_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyJobsHubScreen extends StatefulWidget {
  const CompanyJobsHubScreen({super.key});

  @override
  State<CompanyJobsHubScreen> createState() => _CompanyJobsHubScreenState();
}

class _CompanyJobsHubScreenState extends State<CompanyJobsHubScreen> {
  final Set<String> _selectedStatuses = {'Open'};
  final Set<String> _selectedTypes = {};

  @override
  Widget build(BuildContext context) {
    final store = CompanyStore.instance;
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return AppScaffold(
      title: t.job,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final filteredJobs = store.jobs.where((j) {
            final matchesStatus = _selectedStatuses.isEmpty || _selectedStatuses.contains(j.status);
            final matchesType = _selectedTypes.isEmpty || _selectedTypes.contains(j.employmentType);
            return matchesStatus && matchesType;
          }).toList();

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: Column(
                children: [
                  _buildFilterBar(isAr),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        ...filteredJobs.map(
                          (j) => Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              title: Text(j.title),
                              subtitle: Builder(
                                builder: (context) {
                                  final count = RecruitmentSyncStore.instance.applications
                                      .where((a) => a.jobId == j.id)
                                      .length;
                                  return Text(
                                    '${j.companyName} • $count applicants',
                                  );
                                },
                              ),
                              isThreeLine: true,
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    Navigator.of(context).pushNamed(
                                      AppRoutes.companyPostJobStep1,
                                      arguments: j,
                                    );
                                    return;
                                  }
                                  if (value == 'toggle_status') {
                                    store.saveJob(j.copyWith(
                                      status: j.status == 'Open' ? 'Closed' : 'Open',
                                    ));
                                    return;
                                  }
                                  final confirmed = await showDialog<bool>(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text(t.deleteJobTitle),
                                      content: Text(t.deleteJobContent(j.title)),
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
                                  store.deleteJob(j.id);
                                },
                                itemBuilder: (ctx) => [
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text(t.edit),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'toggle_status',
                                    child: Text(j.status == 'Open' ? (isAr ? 'إغلاق الوظيفة' : 'Close Job') : (isAr ? 'فتح الوظيفة' : 'Open Job')),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(t.delete),
                                  ),
                                ],
                              ),
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(AppRoutes.companyJobDetails, arguments: j),
                            ),
                          ),
                        ),
                        if (filteredJobs.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Center(
                              child: Text(
                                t.noJobsYet,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ),
                      ],
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

  Widget _buildFilterBar(bool isAr) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _FilterChip(
            label: isAr ? 'مفتوح' : 'Open',
            isSelected: _selectedStatuses.contains('Open'),
            onChanged: (val) => _toggleFilter(_selectedStatuses, 'Open', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'مغلق' : 'Closed',
            isSelected: _selectedStatuses.contains('Closed'),
            onChanged: (val) => _toggleFilter(_selectedStatuses, 'Closed', val),
          ),
          Container(
            height: 24,
            width: 1,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 12),
          ),
          _FilterChip(
            label: isAr ? 'دوام كامل' : 'Full-Time',
            isSelected: _selectedTypes.contains('Full-Time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Full-Time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'دوام جزئي' : 'Part-Time',
            isSelected: _selectedTypes.contains('Part-Time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Part-Time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عمل حر (Freelance)' : 'Freelance',
            isSelected: _selectedTypes.contains('Freelance'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Freelance', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'تدريب (Internship)' : 'Internship',
            isSelected: _selectedTypes.contains('Internship'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Internship', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عمل لمرة واحدة' : 'One-time',
            isSelected: _selectedTypes.contains('One-time'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'One-time', val),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: isAr ? 'عن بعد (Remote)' : 'Remote',
            isSelected: _selectedTypes.contains('Remote'),
            onChanged: (val) => _toggleFilter(_selectedTypes, 'Remote', val),
          ),
        ],
      ),
    );
  }

  void _toggleFilter(Set<String> set, String value, bool? selected) {
    setState(() {
      if (selected == true) {
        set.add(value);
      } else {
        set.remove(value);
      }
    });
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onChanged,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected 
            ? Theme.of(context).colorScheme.primary 
            : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
        color: isSelected 
            ? Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3)
            : Colors.transparent,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected 
                  ? Theme.of(context).colorScheme.primary 
                  : Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: isSelected,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }
}
