// Public-style company profile with tabs and store data.

import 'package:flutter/material.dart';

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
              ),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),
              SectionTitle(t.about),
              const SizedBox(height: 10),
              Text(
                t.isAr
                    ? (_store.companyAboutAr.trim().isNotEmpty
                        ? _store.companyAboutAr
                        : _store.companyAboutEn) // Fallback to English if Arabic is not provided
                    : _store.companyAboutEn,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SectionTitle(t.locationInfo),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _store.locations.map((item) => Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
              const SizedBox(height: 16),
              SectionTitle(t.tr(en: 'Tech Stack', ar: 'التقنيات المستخدمة')),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _store.techStack.map((item) => Chip(
                  label: Text(item, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
              const SizedBox(height: 16),
              SectionTitle(t.contactSectionLabel),
              const SizedBox(height: 10),
              ..._store.contacts.asMap().entries.map(
                (entry) => _EditableLinkTile(
                  icon: Icons.link_outlined,
                  title: entry.value.name,
                  value: entry.value.value,
                ),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        onTap: () {},
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
  });

  final int foundedDay;
  final int foundedMonth;
  final int foundedYear;
  final int countriesCount;
  final String employee;
  final String industry;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final cs = Theme.of(context).colorScheme;
    final labelColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.65);
    final iconColor = Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.9);

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
                color: cs.primary.withValues(alpha: 0.10),
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
                  value: t.tr(
                    en: '$foundedMonth/$foundedDay/$foundedYear', 
                    ar: '$foundedYear/$foundedMonth/$foundedDay'.replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')
                  ),
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.location_on_outlined,
                  label: t.locationInfo,
                  value: t.tr(
                    en: '$countriesCount countries', 
                    ar: '${countriesCount.toString().replaceAll('0', '٠').replaceAll('1', '١').replaceAll('2', '٢').replaceAll('3', '٣').replaceAll('4', '٤').replaceAll('5', '٥').replaceAll('6', '٦').replaceAll('7', '٧').replaceAll('8', '٨').replaceAll('9', '٩')} دولة'
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
                  value: employee,
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.account_balance_outlined,
                  label: t.industry,
                  value: industry,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
