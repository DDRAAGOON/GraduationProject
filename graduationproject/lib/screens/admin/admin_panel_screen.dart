import 'package:flutter/material.dart';

import '../../shared/state/recruitment_sync_store.dart';

class AdminPanelScreen extends StatelessWidget {
  const AdminPanelScreen({super.key});

  static const String adminEmail = 'admin@jobito.com';
  static const String adminPassword = 'Admin@123456';

  @override
  Widget build(BuildContext context) {
    final store = RecruitmentSyncStore.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.admin_panel_settings_outlined),
                title: const Text('Admin Account'),
                subtitle: const Text(
                  'Email: admin@jobito.com\nPassword: Admin@123456',
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                title: const Text('System Overview'),
                subtitle: Text(
                  'Jobs: ${store.jobs.length}\n'
                  'Applications: ${store.applications.length}\n'
                  'Messages: ${store.messages.length}\n'
                  'Worker Requests: ${store.serviceRequests.length}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
