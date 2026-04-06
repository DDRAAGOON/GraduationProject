import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantDetailsProfileScreen extends StatelessWidget {
  const CompanyApplicantDetailsProfileScreen({
    super.key,
    required this.applicant,
  });

  final Applicant applicant;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Applicant Details',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  CompanyApplicantAvatar(seed: applicant.id, radius: 30),
                  const SizedBox(height: 10),
                  Text(
                    applicant.fullName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    applicant.role,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppButton(
                    label: 'Schedule Interview',
                    onPressed: () => Navigator.of(context).pushNamed(
                      AppRoutes.companyApplicantInterviewSchedule,
                      arguments: applicant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Contact'),
          const SizedBox(height: 10),
          _Info(label: 'Email', value: applicant.email),
          _Info(label: 'Phone', value: applicant.phone),
          _Info(label: 'Location', value: applicant.location),
          const SizedBox(height: 16),
          const SectionTitle('Quick actions'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.companyApplicantDetailsResume,
                    arguments: applicant,
                  ),
                  child: const Text('Resume'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.companyApplicantHiringInterview,
                    arguments: applicant,
                  ),
                  child: const Text('Hiring Progress'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isNarrow = MediaQuery.of(context).size.width < 380;
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
                SizedBox(width: 90, child: Text(label)),
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
