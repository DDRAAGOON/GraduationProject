import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/state/company_store.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../widgets/company_app_bar_actions.dart';
import '../widgets/company_bottom_nav.dart';

class CompanyJobsHubScreen extends StatefulWidget {
  const CompanyJobsHubScreen({super.key});

  @override
  State<CompanyJobsHubScreen> createState() => _CompanyJobsHubScreenState();
}

class _CompanyJobsHubScreenState extends State<CompanyJobsHubScreen> {
  @override
  Widget build(BuildContext context) {
    final store = CompanyStore.instance;

    return AppScaffold(
      title: 'Job',
      showBack: false,
      leading: const CompanyProfileLeading(),
      actions: const [CompanyAppBarActions()],
      showAppBarDivider: true,
      bottomNavigationBar: const CompanyBottomNav(
        current: CompanyTab.applicants,
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ...store.jobs.map(
                  (j) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(j.title),
                      subtitle: Text('${j.companyName} • ${j.location}'),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'edit') {
                            Navigator.of(context).pushNamed(
                              AppRoutes.companyJobDetails,
                              arguments: j,
                            );
                            return;
                          }
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete job post?'),
                              content: Text(
                                'This will permanently delete "${j.title}".',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          store.deleteJob(j.id);
                        },
                        itemBuilder: (ctx) => const [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(AppRoutes.companyJobDetails, arguments: j),
                    ),
                  ),
                ),
                if (store.jobs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Text(
                      'No jobs yet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
