// Kanban-style pipeline of applicants by stage.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/mock/mock_data.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/models/job.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyJobApplicantsPipelineViewScreen extends StatelessWidget {
  const CompanyJobApplicantsPipelineViewScreen({super.key, required this.job});

  final Job job;

  @override
  Widget build(BuildContext context) {
    final all = MockData.applicants();
    final inReview = all
        .where((a) => a.stage.toLowerCase().contains('review'))
        .toList();
    final shortlisted = all
        .where((a) => a.stage.toLowerCase().contains('short'))
        .toList();
    final interview = all
        .where((a) => a.stage.toLowerCase().contains('interview'))
        .toList();
    final hired = all
        .where((a) => a.stage.toLowerCase().contains('hire'))
        .toList();

    return AppScaffold(
      title: job.title,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _StageColumn(title: 'In Review', applicants: inReview),
              const SizedBox(width: 12),
              _StageColumn(title: 'Shortlisted', applicants: shortlisted),
              const SizedBox(width: 12),
              _StageColumn(title: 'Interview', applicants: interview),
              const SizedBox(width: 12),
              _StageColumn(title: 'Hired', applicants: hired),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
    );
  }
}

class _StageColumn extends StatelessWidget {
  const _StageColumn({required this.title, required this.applicants});

  final String title;
  final List<Applicant> applicants;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final columnWidth = (screenWidth * 0.78).clamp(220.0, 280.0).toDouble();
    return SizedBox(
      width: columnWidth,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text('${applicants.length}'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (applicants.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No jobs',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                )
              else
                ...applicants.map(
                  (a) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      dense: true,
                      leading: CompanyApplicantAvatar(seed: a.id, radius: 18),
                      title: Text(
                        a.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        a.role,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        AppRoutes.companyApplicantDetailsProfile,
                        arguments: a,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
