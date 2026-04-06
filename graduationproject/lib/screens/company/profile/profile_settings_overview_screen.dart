import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../constants/app_images.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyProfileSettingsOverviewScreen extends StatefulWidget {
  const CompanyProfileSettingsOverviewScreen({super.key});

  @override
  State<CompanyProfileSettingsOverviewScreen> createState() =>
      _CompanyProfileSettingsOverviewScreenState();
}

class _CompanyProfileSettingsOverviewScreenState
    extends State<CompanyProfileSettingsOverviewScreen> {
  final _companyName = TextEditingController(text: 'Nomad');
  final _website = TextEditingController(text: 'https://www.nomad.com');
  final _employee = TextEditingController(text: '1 - 50');
  final _industry = TextEditingController(text: 'Technology');
  final _about = TextEditingController(
    text:
        'Nomad is part of the Information Technology Industry. We believe travelers want to experience real life...',
  );
  DateTime _founded = DateTime(2021, 7, 31);
  bool _loading = false;

  @override
  void dispose() {
    _companyName.dispose();
    _website.dispose();
    _employee.dispose();
    _industry.dispose();
    _about.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final t = AppLocalizations.of(context);
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(t.saved)));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.profileSettings,
      showBack: false,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(
            context,
          ).pushNamed(AppRoutes.companyProfileSocialLinks),
          child: Text(t.socialLinks),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            t.overviewSection,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(t.companyLogo, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.asset(
                      AppImages.companyProfileImage,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.logoHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  OutlinedButton(onPressed: () {}, child: Text(t.upload)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(label: t.companyName, controller: _companyName),
          const SizedBox(height: 16),
          AppTextField(label: t.website, controller: _website),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: AppTextField(label: t.employee, controller: _employee),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppTextField(label: t.industry, controller: _industry),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(t.dateFounded, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('${_founded.day}/${_founded.month}/${_founded.year}'),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                  initialDate: _founded,
                );
                if (picked != null && mounted) {
                  setState(() => _founded = picked);
                }
              },
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(label: t.aboutCompany, controller: _about, maxLines: 4),
          const SizedBox(height: 18),
          AppButton(label: t.saveChange, loading: _loading, onPressed: _save),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () => Navigator.of(
              context,
            ).pushNamed(AppRoutes.companyCompanyProfile),
            child: Text(t.previewProfile),
          ),
        ],
      ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.home),
    );
  }
}
