import 'package:flutter/material.dart';

import '../../../../app/router/app_router.dart';
import '../../../../shared/l10n/app_localizations.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../../shared/widgets/app_text_field.dart';

class CompanyPostJobStep1InformationV2Screen extends StatefulWidget {
  const CompanyPostJobStep1InformationV2Screen({super.key});

  @override
  State<CompanyPostJobStep1InformationV2Screen> createState() =>
      _CompanyPostJobStep1InformationV2ScreenState();
}

class _CompanyPostJobStep1InformationV2ScreenState
    extends State<CompanyPostJobStep1InformationV2Screen> {
  final _jobTitle = TextEditingController();
  bool _fullTime = true;
  bool _remote = false;
  bool _contract = false;
  bool _partTime = false;
  bool _intern = false;
  RangeValues _salary = const RangeValues(5000, 22000);
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
      () => _titleError = _jobTitle.text.trim().isEmpty ? t.required : null,
    );
    return _titleError == null;
  }

  Future<void> _next() async {
    if (!_validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _loading = false);
    String employmentType = 'Full-Time';
    if (_remote) employmentType = 'Remote';
    if (_contract) employmentType = 'Contract';
    if (_partTime) employmentType = 'Part-Time';
    if (_intern) employmentType = 'Internship';

    Navigator.of(context).pushNamed(
      AppRoutes.companyPostJobStep2v2,
      arguments: {
        'title': _jobTitle.text.trim(),
        'employmentType': employmentType,
        'salaryRange':
            '\$${_salary.start.toStringAsFixed(0)}-\$${_salary.end.toStringAsFixed(0)} USD',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.postJob,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(t.step1Short, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 14),
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
          const SizedBox(height: 8),
          _CheckRow(
            label: 'Full-Time',
            value: _fullTime,
            onChanged: (v) => setState(() => _fullTime = v),
          ),
          _CheckRow(
            label: 'Remote',
            value: _remote,
            onChanged: (v) => setState(() => _remote = v),
          ),
          _CheckRow(
            label: 'Contract',
            value: _contract,
            onChanged: (v) => setState(() => _contract = v),
          ),
          _CheckRow(
            label: 'Part-Time',
            value: _partTime,
            onChanged: (v) => setState(() => _partTime = v),
          ),
          _CheckRow(
            label: 'Internship',
            value: _intern,
            onChanged: (v) => setState(() => _intern = v),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 18),
          AppButton(label: t.nextStep, loading: _loading, onPressed: _next),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
