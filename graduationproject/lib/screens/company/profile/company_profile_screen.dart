import 'package:flutter/material.dart';

import '../../../shared/models/contact_entry.dart';
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
  String _about =
      'Nomad is a software platform for starting and running internet businesses. '
      'Millions of businesses rely on Stripe’s software tools to accept payments, '
      'expand globally, and manage their businesses online.\n\n'
      'Stripe has been at the forefront of expanding internet commerce. '
      'Our mission is to increase the GDP of the internet...';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Company Profile',
      showBack: true,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      body: ListView(
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
            'Company Profile',
            trailing: IconButton(
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_outlined),
              onPressed: _editAbout,
            ),
          ),
          const SizedBox(height: 10),
          Text(_about, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          SectionTitle('Contact'),
          const SizedBox(height: 10),
          AnimatedBuilder(
            animation: _store,
            builder: (context, _) => Column(
              children: [
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
                  label: const Text('Add more'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.companyProfile,
      ),
    );
  }

  Future<void> _editAbout() async {
    final controller = TextEditingController(text: _about);
    final saved = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) {
        final viewInsets = MediaQuery.of(ctx).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + viewInsets),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Edit Company Profile',
                style: Theme.of(
                  ctx,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 8,
                decoration: const InputDecoration(
                  labelText: 'About',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
    if (saved == null) return;
    setState(() => _about = saved);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Updated')));
    }
  }

  Future<void> _addContact() async {
    final nameController = TextEditingController();
    final valueController = TextEditingController();
    final contact = await _showContactDialog(
      title: 'Add contact',
      nameController: nameController,
      valueController: valueController,
    );
    if (contact == null) return;
    _store.addContact(contact);
  }

  Future<void> _editContact(int index, ContactEntry entry) async {
    final nameController = TextEditingController(text: entry.name);
    final valueController = TextEditingController(text: entry.value);
    final updated = await _showContactDialog(
      title: 'Edit contact',
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
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: valueController,
                decoration: const InputDecoration(
                  labelText: 'URL or handle',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(
                ContactEntry(
                  name: nameController.text.trim(),
                  value: valueController.text.trim(),
                ),
              ),
              child: const Text('Save'),
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
              tooltip: 'Edit',
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              tooltip: 'Delete',
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
                  label: 'Founded',
                  value: 'July 31, 2011',
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: '20 countries',
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                item(
                  icon: Icons.groups_outlined,
                  label: 'Employees',
                  value: '4000+',
                ),
                const SizedBox(width: 14),
                item(
                  icon: Icons.account_balance_outlined,
                  label: 'Industry',
                  value: 'Social & Non-Profit',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
