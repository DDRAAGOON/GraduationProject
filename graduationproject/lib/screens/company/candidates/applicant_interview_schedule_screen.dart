// Schedule or edit interview slots for a candidate.

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

class _ScheduleTile extends StatefulWidget {
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
  State<_ScheduleTile> createState() => _ScheduleTileState();
}

class _ScheduleTileState extends State<_ScheduleTile> {
  String? _feedback;

  Future<void> _addFeedbackDialog(AppLocalizations t) async {
    final controller = TextEditingController(text: _feedback);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.addFeedback),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: t.tr(en: 'Enter your feedback', ar: 'أدخل تعليقك'),
              border: const OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) => (v == null || v.trim().isEmpty) ? '*' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(t.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, controller.text.trim());
              }
            },
            child: Text(t.save),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _feedback = result);
    }
  }

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
                Expanded(child: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.w700))),
                Text(widget.time, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 6),
            Text(widget.stage, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            Text(
              widget.place,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            if (_feedback != null) ...[
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          t.tr(en: 'Feedback', ar: 'التعليقات'),
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                        InkWell(
                          onTap: () => _addFeedbackDialog(t),
                          child: Text(
                            t.tr(en: 'Edit', ar: 'تعديل'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(_feedback!, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 10),
              Align(
                alignment: t.isAr ? Alignment.centerRight : Alignment.centerLeft,
                child: OutlinedButton(
                  onPressed: () => _addFeedbackDialog(t),
                  child: Text(t.addFeedback),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
