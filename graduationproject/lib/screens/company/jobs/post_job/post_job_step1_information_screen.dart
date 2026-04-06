import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/section_title.dart';

class CompanyPostJobStep1InformationScreen extends StatefulWidget {
  const CompanyPostJobStep1InformationScreen({super.key});

  @override
  State<CompanyPostJobStep1InformationScreen> createState() =>
      _CompanyPostJobStep1InformationScreenState();
}

class _CompanyPostJobStep1InformationScreenState
    extends State<CompanyPostJobStep1InformationScreen> {
  final _jobTitle = TextEditingController();
  final Set<String> _types = {'Full-Time'};
  RangeValues _salary = const RangeValues(5000, 22000);
  final List<String> _skills = [
    'Graphic Design',
    'Communication',
    'Illustrator',
  ];
  bool _loading = false;
  String? _titleError;

  @override
  void dispose() {
    _jobTitle.dispose();
    super.dispose();
  }

  bool _validate() {
    final t = AppLocalizations.of(context);
    setState(
      () => _titleError = _jobTitle.text.trim().length >= 3
          ? null
          : t.at3Chars,
    );
    return _titleError == null;
  }

  Future<void> _next() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushNamed(
      AppRoutes.companyPostJobStep2,
      arguments: {
        'title': _jobTitle.text.trim(),
        'employmentType': _types.isNotEmpty ? _types.first : 'Full-Time',
        'salaryRange':
            '\$${_salary.start.toStringAsFixed(0)}-\$${_salary.end.toStringAsFixed(0)} USD',
      },
    );
  }

  void _toggle(String type) {
    setState(() {
      if (_types.contains(type)) {
        _types.remove(type);
      } else {
        _types.add(type);
      }
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
          SectionTitle(t.step1Label),
          const SizedBox(height: 16),
          AppTextField(
            label: t.jobTitle,
            controller: _jobTitle,
            hint: t.jobTitleHint,
            validatorText: _titleError,
          ),
          const SizedBox(height: 16),
          Text(
            t.typeOfEmployment,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _TypeChip(
                label: 'Full-Time',
                selected: _types.contains('Full-Time'),
                onTap: () => _toggle('Full-Time'),
              ),
              _TypeChip(
                label: 'Remote',
                selected: _types.contains('Remote'),
                onTap: () => _toggle('Remote'),
              ),
              _TypeChip(
                label: 'Contract',
                selected: _types.contains('Contract'),
                onTap: () => _toggle('Contract'),
              ),
              _TypeChip(
                label: 'Part-Time',
                selected: _types.contains('Part-Time'),
                onTap: () => _toggle('Part-Time'),
              ),
              _TypeChip(
                label: 'Internship',
                selected: _types.contains('Internship'),
                onTap: () => _toggle('Internship'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.salary, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            '\$${_salary.start.toStringAsFixed(0)} - \$${_salary.end.toStringAsFixed(0)}',
          ),
          RangeSlider(
            values: _salary,
            min: 0,
            max: 50000,
            divisions: 100,
            onChanged: (v) => setState(() => _salary = v),
          ),
          const SizedBox(height: 12),
          Text(
            t.requiredSkills,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            children: _skills
                .map(
                  (s) => InputChip(
                    label: Text(s),
                    onDeleted: () => setState(() => _skills.remove(s)),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 16),
          AppButton(label: t.nextStep, loading: _loading, onPressed: _next),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.companyPostJobStep1v2),
            child: Text(t.openV2Step1),
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : Colors.white.withValues(alpha: 0.12);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: selected ? 0.25 : 1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(label),
      ),
    );
  }
}
