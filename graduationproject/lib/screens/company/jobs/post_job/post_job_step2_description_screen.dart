import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/models/job.dart';
import '../../../../shared/state/company_store.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/section_title.dart';

class CompanyPostJobStep2DescriptionScreen extends StatefulWidget {
  const CompanyPostJobStep2DescriptionScreen({super.key});

  @override
  State<CompanyPostJobStep2DescriptionScreen> createState() =>
      _CompanyPostJobStep2DescriptionScreenState();
}

class _CompanyPostJobStep2DescriptionScreenState
    extends State<CompanyPostJobStep2DescriptionScreen> {
  final _jobDescription = TextEditingController();
  final _preferred = TextEditingController();
  final _niceToHave = TextEditingController();
  final _basicInfo = TextEditingController();
  final _benefitTitle = TextEditingController();

  final List<String> _benefits = [];
  bool _loading = false;

  @override
  void dispose() {
    _jobDescription.dispose();
    _preferred.dispose();
    _niceToHave.dispose();
    _basicInfo.dispose();
    _benefitTitle.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    setState(() => _loading = false);
    final args = ModalRoute.of(context)?.settings.arguments;
    final data = args is Map<String, dynamic>
        ? args
        : const <String, dynamic>{};
    final now = DateTime.now().millisecondsSinceEpoch;
    final title = (data['title'] as String?)?.trim();
    final employmentType = (data['employmentType'] as String?)?.trim();
    final salaryRange = (data['salaryRange'] as String?)?.trim();
    CompanyStore.instance.saveJob(
      Job(
        id: 'job_$now',
        title: (title == null || title.isEmpty) ? 'Untitled role' : title,
        companyName: CompanyStore.instance.companyName,
        location: 'Remote',
        employmentType: (employmentType == null || employmentType.isEmpty)
            ? 'Full-Time'
            : employmentType,
        category: 'General',
        salaryRange: (salaryRange == null || salaryRange.isEmpty)
            ? r'$0-$0 USD'
            : salaryRange,
        description: _jobDescription.text.trim(),
        responsibilities: _preferred.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        niceToHaves: _niceToHave.text
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
      ),
    );
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.companyDashboard, (r) => false);
  }

  void _addBenefit() {
    final t = _benefitTitle.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _benefits.add(t);
      _benefitTitle.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Post a Job',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('Step 2/3 • Job Description'),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Job Descriptions',
            controller: _jobDescription,
            hint: 'Add the description of the job...',
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'What we provide (optional)',
            controller: _preferred,
            hint: 'Add preferred candidate qualifications',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Nice-To-Haves',
            controller: _niceToHave,
            hint: 'Add nice-to-have skills and qualifications',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Basic Information',
            controller: _basicInfo,
            hint: 'Basic info about role and company',
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Text(
            'Perks and Benefits',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _benefitTitle,
                  decoration: const InputDecoration(hintText: 'title'),
                  onSubmitted: (_) => _addBenefit(),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filled(
                onPressed: _addBenefit,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (_benefits.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _benefits
                  .map(
                    (b) => InputChip(
                      label: Text(b),
                      onDeleted: () => setState(() => _benefits.remove(b)),
                    ),
                  )
                  .toList(),
            ),
          const SizedBox(height: 18),
          AppButton(label: 'Save', loading: _loading, onPressed: _save),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.companyPostJobStep2v2),
            child: const Text('Open v2 of Step 2'),
          ),
        ],
      ),
    );
  }
}
