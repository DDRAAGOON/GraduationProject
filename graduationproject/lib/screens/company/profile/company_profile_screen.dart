import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/models/contact_entry.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_title.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';
import 'company_edit_intro_screen.dart';

class CompanyCompanyProfileScreen extends StatefulWidget {
  const CompanyCompanyProfileScreen({super.key});

  @override
  State<CompanyCompanyProfileScreen> createState() =>
      _CompanyCompanyProfileScreenState();
}

class _CompanyCompanyProfileScreenState
    extends State<CompanyCompanyProfileScreen> {
  final _store = CompanyStore.instance;

  Future<void> _openEditIntro() async {
    await Navigator.of(context).pushNamed(
      AppRoutes.companyEditIntro,
      arguments: CompanyEditIntroArgs(
        english: _store.companyAboutEn,
        arabic: _store.companyAboutAr,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppScaffold(
      title: t.profile,
      showBack: true,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      body: AnimatedBuilder(
        animation: _store,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _CompanyStatsBar(),
              const SizedBox(height: 14),
              Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),
              SectionTitle(
                t.about,
                trailing: IconButton(
                  tooltip: t.editIntroTooltip,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: _openEditIntro,
                ),
              ),
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
              SectionTitle(t.contactSectionLabel),
              const SizedBox(height: 10),
              ..._store.contacts.asMap().entries.map(
                (entry) => _EditableLinkTile(
                  icon: Icons.link_outlined,
                  title: entry.value.name,
                  value: entry.value.value,
                  onEdit: () => _editContact(entry.key, entry.value),
                  onDelete: () => _store.removeContact(entry.key),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _addContact,
                icon: const Icon(Icons.add),
                label: Text(t.addMoreContact),
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

  Future<void> _addContact() async {
    final t = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final contact = await _showContactDialog(
      title: t.addContactTitle,
      nameController: nameController,
      valueController: valueController,
    );
    if (contact == null) return;
    _store.addContact(contact);
  }

  Future<void> _editContact(int index, ContactEntry entry) async {
    final t = AppLocalizations.of(context);
    final nameController = TextEditingController(text: entry.name);
    final valueController = TextEditingController(text: entry.value);
    final updated = await _showContactDialog(
      title: t.editContactTitle,
      nameController: nameController,
      valueController: valueController,
    );
    if (updated == null) return;
    _store.updateContact(index, updated);
  }

  Future<ContactEntry?> _showContactDialog({
    required String title,
    required TextEditingController nameController,
    required TextEditingController valueController,
  }) async {
    final t = AppLocalizations.of(context);
    return showDialog<ContactEntry>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: t.nameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: valueController,
                decoration: InputDecoration(
                  labelText: t.urlOrHandle,
                  border: const OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(
                ContactEntry(
                  name: nameController.text.trim(),
                  value: valueController.text.trim(),
                ),
              ),
              child: Text(t.save),
            ),
          ],
        );
      },
    );
  }
}

class _EditableLinkTile extends StatelessWidget {
  const _EditableLinkTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onEdit,
    required this.onDelete,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(value),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: t.edit,
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: t.delete,
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class _CompanyStatsBar extends StatelessWidget {
  const _CompanyStatsBar();

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
                  value: t.tr(en: 'July 31, 2011', ar: '٣١ يوليو ٢٠١١'),
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.location_on_outlined,
                  label: t.locationInfo,
                  value: t.tr(en: '20 countries', ar: '٢٠ دولة'),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                item(
                  icon: Icons.groups_outlined,
                  label: t.employee,
                  value: '4000+',
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.account_balance_outlined,
                  label: t.industry,
                  value: t.tr(en: 'Social & Non-Profit', ar: 'اجتماعي وحقوقي'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
