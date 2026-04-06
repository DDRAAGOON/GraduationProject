import 'package:flutter/material.dart';

import '../../../shared/models/applicant.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_applicant_avatar.dart';

class CompanyApplicantHiringProgressHiredDeclinedScreen extends StatefulWidget {
  const CompanyApplicantHiringProgressHiredDeclinedScreen({super.key, required this.applicant});

  final Applicant applicant;

  @override
  State<CompanyApplicantHiringProgressHiredDeclinedScreen> createState() =>
      _CompanyApplicantHiringProgressHiredDeclinedScreenState();
}

class _CompanyApplicantHiringProgressHiredDeclinedScreenState
    extends State<CompanyApplicantHiringProgressHiredDeclinedScreen> {
  String _stage = 'Hired';
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hiring Progress',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: CompanyApplicantAvatar(seed: widget.applicant.id, radius: 24),
              title: Text(widget.applicant.fullName),
              subtitle: Text(widget.applicant.role),
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Current Stage'),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Interview', label: Text('Interview')),
              ButtonSegment(value: 'Hired', label: Text('Hired')),
              ButtonSegment(value: 'Declined', label: Text('Declined')),
            ],
            selected: {_stage},
            onSelectionChanged: (s) => setState(() => _stage = s.first),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Text(
                _stage == 'Hired'
                    ? 'Candidate has been marked as hired.'
                    : _stage == 'Declined'
                        ? 'Candidate has been declined.'
                        : 'Candidate is currently in interview stage.',
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppButton(label: 'Save', loading: _loading, onPressed: _save),
        ],
      ),
    );
  }
}

