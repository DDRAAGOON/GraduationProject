// Read-only applicant profile details for recruiters.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.applicantDetails,
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
                    label: t.scheduleInterview,
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
          SectionTitle(t.contactSection),
          const SizedBox(height: 10),
          _Info(label: t.email, value: applicant.email),
          _Info(label: t.phone, value: applicant.phone),
          _Info(label: t.locationInfo, value: applicant.location),
          const SizedBox(height: 16),
          SectionTitle(t.quickActions),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.companyApplicantDetailsResume,
                    arguments: applicant,
                  ),
                  child: Text(t.resumeLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pushNamed(
                    AppRoutes.companyApplicantHiringInterview,
                    arguments: applicant,
                  ),
                  child: Text(t.hiringProgress),
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
