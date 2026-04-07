// List and search all jobs for the signed-in company.

import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/l10n/app_localizations.dart';
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
    final t = AppLocalizations.of(context);

    return AppScaffold(
      title: t.job,
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
                              title: Text(t.deleteJobTitle),
                              content: Text(t.deleteJobContent(j.title)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: Text(t.cancel),
                                ),
                                FilledButton(
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: Text(t.delete),
                                ),
                              ],
                            ),
                          );
                          if (confirmed != true) return;
                          store.deleteJob(j.id);
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(t.edit),
                          ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(t.delete),
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
                      t.noJobsYet,
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
