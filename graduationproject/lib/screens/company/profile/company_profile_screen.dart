// Public-style company profile with tabs and store data.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyCompanyProfileScreen extends StatefulWidget {
  const CompanyCompanyProfileScreen({super.key});

  @override
  State<CompanyCompanyProfileScreen> createState() =>
      _CompanyCompanyProfileScreenState();
}

class _CompanyCompanyProfileScreenState
    extends State<CompanyCompanyProfileScreen> {
  final _store = CompanyStore.instance;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.profile,
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _CompanyStatsBar(
                foundedDay: _store.foundedDay,
                foundedMonth: _store.foundedMonth,
                foundedYear: _store.foundedYear,
                countriesCount: _store.locations.length,
                employee: _store.employee,
                industry: _store.industry,
                category: _store.category,
              ),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withOpacity(0.2),
              ),
              const SizedBox(height: 16),
              SectionTitle(t.about),
              const SizedBox(height: 10),
              Text(
                t.isAr
                    ? (_store.companyAboutAr.trim().isNotEmpty
                        ? _store.companyAboutAr
                        : (_store.companyAboutEn.trim().isNotEmpty ? _store.companyAboutEn : t.notYet))
                    : (_store.companyAboutEn.trim().isNotEmpty ? _store.companyAboutEn : t.notYet),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: (_store.companyAboutAr.isEmpty && _store.companyAboutEn.isEmpty)
                      ? Theme.of(context).colorScheme.onSurface.withOpacity(0.4)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              SectionTitle(t.benefits),
              const SizedBox(height: 10),
              _store.benefits.isEmpty
                  ? Text(t.notYet, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)))
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _store.benefits.map((item) => Chip(
                        label: Text(item, style: const TextStyle(fontSize: 12)),
                        visualDensity: VisualDensity.compact,
                        backgroundColor: Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.3),
                      )).toList(),
                    ),
              const SizedBox(height: 16),
              if (_store.commercialRegister.isNotEmpty || _store.nationalNumber.isNotEmpty) ...[
                SectionTitle(t.tr(en: 'Registration Info', ar: 'بيانات التسجيل')),
                const SizedBox(height: 10),
                if (_store.commercialRegister.isNotEmpty)
                  _RegistrationInfoTile(
                    icon: Icons.assignment_outlined,
                    title: t.tr(en: 'Commercial Register', ar: 'السجل التجاري'),
                    value: _store.commercialRegister,
                  ),
                if (_store.nationalNumber.isNotEmpty)
                  _RegistrationInfoTile(
                    icon: Icons.badge_outlined,
                    title: t.tr(en: 'National Number', ar: 'الرقم القومي'),
                    value: _store.nationalNumber,
                  ),
                const SizedBox(height: 16),
              ],
              if (_store.contacts.isNotEmpty) ...[
                SectionTitle(t.contactSectionLabel),
                const SizedBox(height: 10),
                ..._store.contacts.asMap().entries.map(
                  (entry) => _EditableLinkTile(
                    icon: entry.value.name.toLowerCase().contains('email') 
                        ? Icons.email_outlined 
                        : Icons.link_outlined,
                    title: entry.value.name,
                    value: entry.value.value,
                  ),
                ),
              ],
            ],
          );
        },
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.profile,
      ),
    );
  }
}

class _EditableLinkTile extends StatelessWidget {
  const _EditableLinkTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  Future<void> _launch() async {
    String urlStr = value;
    if (!urlStr.contains('://') && !urlStr.startsWith('mailto:')) {
      if (urlStr.contains('@')) {
        urlStr = 'mailto:$urlStr';
      } else {
        urlStr = 'https://$urlStr';
      }
    }
    final uri = Uri.tryParse(urlStr);
    if (uri != null) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        onTap: _launch,
      ),
    );
  }
}

class _RegistrationInfoTile extends StatelessWidget {
  const _RegistrationInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

class _CompanyStatsBar extends StatelessWidget {
  const _CompanyStatsBar({
    required this.foundedDay,
    required this.foundedMonth,
    required this.foundedYear,
    required this.countriesCount,
    required this.employee,
    required this.industry,
    required this.category,
  });

  final int foundedDay;
  final int foundedMonth;
  final int foundedYear;
  final int countriesCount;
  final String employee;
  final String industry;
  final String category;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final labelColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.65);
    final iconColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.9);

    Widget item({
      required IconData icon,
      required String label,
      required String value,
    }) {
      return Expanded(
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                item(
                  icon: Icons.local_fire_department_outlined,
                  label: t.tr(en: 'Founded', ar: 'تاريخ التأسيس'),
                  value: (foundedDay == 0 || foundedMonth == 0 || foundedYear == 0)
                      ? t.notYet
                      : t.tr(
                          en: '$foundedMonth/$foundedDay/$foundedYear', 
                          ar: '$foundedYear/$foundedMonth/$foundedDay'.replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')
                        ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                item(
                  icon: Icons.groups_outlined,
                  label: t.employee,
                  value: employee.isEmpty ? t.notYet : employee,
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.category_outlined,
                  label: t.categoryLabel,
                  value: category.isEmpty ? t.notYet : (category == 'Technical' ? t.technical : t.nonTechnical),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
