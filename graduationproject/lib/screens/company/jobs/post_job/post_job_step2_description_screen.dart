// Post job wizard — step 2: description and publish.

import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/l10n/app_localizations.dart';
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
    final text = _benefitTitle.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _benefits.add(text);
      _benefitTitle.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.postJob,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionTitle(t.step2Label),
          const SizedBox(height: 16),
          AppTextField(
            label: t.jobDescriptions,
            controller: _jobDescription,
            hint: t.addDescription,
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.whatWeProvide,
            controller: _preferred,
            hint: t.addPreferredQual,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.niceToHaves,
            controller: _niceToHave,
            hint: t.niceToHavesHint,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: t.basicInfo,
            controller: _basicInfo,
            hint: t.basicInfoHint,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Text(
            t.perksAndBenefits,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _benefitTitle,
                  decoration: InputDecoration(hintText: t.titleLabel),
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
          AppButton(label: t.save, loading: _loading, onPressed: _save),
        ],
      ),
    );
  }
}
