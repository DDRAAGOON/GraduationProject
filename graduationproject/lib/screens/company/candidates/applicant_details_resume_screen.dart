// Resume / document view for an applicant.

import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantDetailsResumeScreen extends StatelessWidget {
  const CompanyApplicantDetailsResumeScreen({super.key, required this.applicant});

  final Applicant applicant;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.resumeLabel,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CompanyApplicantAvatar(seed: applicant.id, radius: 28),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          applicant.fullName,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(applicant.role),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf_outlined),
              title: const Text('my_cv.pdf'),
              subtitle: Text('498 kB • ${t.lastUsed}'),
              trailing: const Icon(Icons.check_circle_outline),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
