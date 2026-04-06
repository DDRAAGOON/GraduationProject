import 'package:flutter/material.dart';

import '../../../shared/models/contact_entry.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyProfileSettingsSocialLinksScreen extends StatefulWidget {
  const CompanyProfileSettingsSocialLinksScreen({super.key});

  @override
  State<CompanyProfileSettingsSocialLinksScreen> createState() =>
      _CompanyProfileSettingsSocialLinksScreenState();
}

class _CompanyProfileSettingsSocialLinksScreenState
    extends State<CompanyProfileSettingsSocialLinksScreen> {
  bool _loading = false;

  Future<void> _save() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved')));
  }

  Future<void> _addMore() async {
    final name = TextEditingController();
    final value = TextEditingController();
    final created = await _showContactDialog(
      title: 'Add social/contact link',
      nameController: name,
      valueController: value,
    );
    if (created == null) return;
    CompanyStore.instance.addContact(created);
  }

  Future<void> _edit(int index, ContactEntry entry) async {
    final name = TextEditingController(text: entry.name);
    final value = TextEditingController(text: entry.value);
    final updated = await _showContactDialog(
      title: 'Edit social/contact link',
      nameController: name,
      valueController: value,
    );
    if (updated == null) return;
    CompanyStore.instance.updateContact(index, updated);
  }

  Future<ContactEntry?> _showContactDialog({
    required String title,
    required TextEditingController nameController,
    required TextEditingController valueController,
  }) {
    return showDialog<ContactEntry>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'URL / handle'),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile Settings',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Social Links',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          Text(
            'Add elsewhere links to your company profile. You can add only username without full https links.',
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          AnimatedBuilder(
            animation: CompanyStore.instance,
            builder: (context, _) => Column(
              children: [
                ...CompanyStore.instance.contacts.asMap().entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Card(
                      child: ListTile(
                        title: Text(entry.value.name),
                        subtitle: Text(entry.value.value),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => _edit(entry.key, entry.value),
                              icon: const Icon(Icons.edit_outlined),
                            ),
                            IconButton(
                              onPressed: () => CompanyStore.instance
                                  .removeContact(entry.key),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _addMore,
                    icon: const Icon(Icons.add),
                    label: const Text('Add more'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          AppButton(label: 'Save Change', loading: _loading, onPressed: _save),
          const SizedBox(height: 6),
          TextButton(onPressed: () {}, child: const Text('Help Center')),
        ],
      ),
    );
  }
}
