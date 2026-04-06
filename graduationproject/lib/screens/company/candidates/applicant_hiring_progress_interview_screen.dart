import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/models/applicant.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantHiringProgressInterviewScreen extends StatelessWidget {
  const CompanyApplicantHiringProgressInterviewScreen({
    super.key,
    required this.applicant,
  });

  final Applicant applicant;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hiring Progress',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CompanyApplicantAvatar(seed: applicant.id, radius: 24),
              title: Text(applicant.fullName),
              subtitle: Text(
                '${applicant.role} • ⭐ ${applicant.rating.toStringAsFixed(1)}',
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Current Stage'),
          const SizedBox(height: 10),
          _StagePill(label: 'Interview', selected: true),
          const SizedBox(height: 12),
          _InfoRow(label: 'Interview Date', value: '10 - 13 July 2021'),
          _InfoRow(
            label: 'Interview Location',
            value: 'Silver Crysta Room, Nomad Office',
          ),
          _InfoRow(label: 'Assigned to', value: 'Maria Kelly'),
          const SizedBox(height: 16),
          AppButton(
            label: 'Move To Next Step',
            onPressed: () => Navigator.of(context).pushNamed(
              AppRoutes.companyApplicantHiringHiredDeclined,
              arguments: applicant,
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Notes'),
          const SizedBox(height: 10),
          ...[
            _NoteCard(
              author: 'Maria Kelly',
              time: '10 July, 2021 • 11:30 AM',
              text:
                  'Please, do an interview stage immediately. The design division needs more new employee now immediately.',
            ),
            _NoteCard(
              author: 'Maria Kelly',
              time: '10 July, 2021 • 10:30 AM',
              text: 'Please, do an interview stage immediately.',
            ),
          ],
        ],
      ),
    );
  }
}

class _StagePill extends StatelessWidget {
  const _StagePill({required this.label, required this.selected});
  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)
            : Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(label),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
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
                SizedBox(width: 140, child: Text(label)),
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

class _NoteCard extends StatelessWidget {
  const _NoteCard({
    required this.author,
    required this.time,
    required this.text,
  });
  final String author;
  final String time;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    author,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Flexible(
                  child: Text(
                    time,
                    maxLines: 2,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(text),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(onPressed: () {}, child: const Text('Reply')),
            ),
          ],
        ),
      ),
    );
  }
}
