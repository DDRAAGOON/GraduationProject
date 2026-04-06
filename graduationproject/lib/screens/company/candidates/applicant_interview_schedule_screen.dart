import 'package:flutter/material.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantInterviewScheduleScreen extends StatelessWidget {
  const CompanyApplicantInterviewScheduleScreen({super.key, required this.applicant});

  final Applicant applicant;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.interviewSchedule,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CompanyApplicantAvatar(seed: applicant.id, radius: 24),
              title: Text(applicant.fullName),
              subtitle: Text(applicant.role),
              trailing: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
                tooltip: t.addScheduleInterview,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionTitle(t.interviewList),
          const SizedBox(height: 10),
          ...[
            _ScheduleTile(
              name: 'Kathryn Murphy',
              time: '10:00 AM - 11:30 AM',
              place: 'Silver Crysta Room, Nomad',
              stage: 'Written Test 2',
            ),
            _ScheduleTile(
              name: 'Jenny Wilson',
              time: '10:00 AM - 11:00 AM',
              place: 'Silver Crysta Room, Nomad',
              stage: 'Written Test 2',
            ),
            _ScheduleTile(
              name: 'Thad Edgins',
              time: '10:00 AM - 11:00 AM',
              place: 'Silver Crysta Room, Nomad',
              stage: 'Skill Test',
            ),
          ],
        ],
      ),
    );
  }
}

class _ScheduleTile extends StatelessWidget {
  const _ScheduleTile({
    required this.name,
    required this.time,
    required this.place,
    required this.stage,
  });

  final String name;
  final String time;
  final String place;
  final String stage;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w700))),
                Text(time, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 6),
            Text(stage, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Text(
              place,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: t.isAr ? Alignment.centerRight : Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: () {},
                child: Text(t.addFeedback),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
