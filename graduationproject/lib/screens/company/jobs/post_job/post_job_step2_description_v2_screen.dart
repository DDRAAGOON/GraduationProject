import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/models/job.dart';
import '../../../../shared/state/company_store.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_text_field.dart';

class CompanyPostJobStep2DescriptionV2Screen extends StatefulWidget {
  const CompanyPostJobStep2DescriptionV2Screen({super.key});

  @override
  State<CompanyPostJobStep2DescriptionV2Screen> createState() =>
      _CompanyPostJobStep2DescriptionV2ScreenState();
}

class _CompanyPostJobStep2DescriptionV2ScreenState
    extends State<CompanyPostJobStep2DescriptionV2Screen> {
  final _description = TextEditingController();
  final _niceToHave = TextEditingController();
  final _perks = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _description.dispose();
    _niceToHave.dispose();
    _perks.dispose();
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
        description: _description.text.trim(),
        responsibilities: _perks.text
            .split(',')
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Post a Job',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Step 2/3', style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Details',
            controller: _description,
            hint: 'Add the description of the job...',
            maxLines: 4,
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
            label: 'Perks and Benefits',
            controller: _perks,
            hint: 'List perks and benefits (comma separated)',
            maxLines: 2,
          ),
          const SizedBox(height: 18),
          AppButton(label: 'Save', loading: _loading, onPressed: _save),
        ],
      ),
    );
  }
}
