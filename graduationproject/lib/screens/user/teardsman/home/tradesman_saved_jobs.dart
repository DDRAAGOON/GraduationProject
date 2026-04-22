import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import '../../../../../shared/state/recruitment_sync_store.dart';

class TradesmanSavedJobs extends StatelessWidget {
  const TradesmanSavedJobs({super.key});

  Color _getJobTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'full-time':
        return Colors.green;
      case 'part-time':
        return Colors.blue;
      case 'contract':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final store = RecruitmentSyncStore.instance;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5F1),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          t.tr(en: 'Saved Jobs', ar: 'الوظائف المحفوظة'),
          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final savedJobs = store.savedJobs.where((j) => j.category == 'Tradesman').toList();

          if (savedJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 80, color: Colors.grey.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    t.tr(en: 'No saved jobs yet', ar: 'لا توجد وظائف محفوظة'),
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              final job = savedJobs[index];
              return _buildJobCard(context, job, t);
            },
          );
        },
      ),
    );
  }

  Widget _buildJobCard(BuildContext context, RecruitmentJob job, AppLocalizations t) {
    final store = RecruitmentSyncStore.instance;
    final typeColor = _getJobTypeColor(job.type);

    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(job.logoIcon ?? Icons.work_outline, color: Colors.black54, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    job.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () => store.toggleSaveJob(job.id),
                  icon: const Icon(Icons.bookmark, color: Color(0xFF49769F), size: 28),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.business, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.companyName, style: const TextStyle(color: Colors.black54)),
                const SizedBox(width: 12),
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(job.location, style: const TextStyle(color: Colors.black54)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: typeColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    job.type,
                    style: TextStyle(
                      color: typeColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                ...job.tags.map((String tag) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F5F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                )).toList(),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {},
                child: Text(
                  t.tr(en: 'View Details', ar: 'عرض التفاصيل'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
