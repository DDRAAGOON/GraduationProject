import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import '../post/job_applicants_screen.dart';

class TradesmanMyAppsScreen extends StatelessWidget {
  const TradesmanMyAppsScreen({super.key});

  String _formatDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final store = RecruitmentSyncStore.instance;

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final mockWorks = store
            .getTradesmanPostedWorksPreview(isAr: isAr)
            .where((work) => !store.isJobDeleted(work.id))
            .map((work) {
              final status = store.tradesmanJobStatus(work.id, work.status);
              return TradesmanPostedWorkRow(
                id: work.id,
                title: work.title,
                rate: work.rate,
                status: store.translateTradesmanWorkStatus(status, isAr),
                applicantsCount: work.applicantsCount,
                postedAt: work.postedAt,
              );
            })
            .toList();

        // Also add real jobs posted by this tradesman
        final realJobs = store.jobs
            .where(
              (j) =>
                  j.companyName == store.currentUserName &&
                  !store.isJobDeleted(j.id),
            )
            .map((j) {
              return TradesmanPostedWorkRow(
                id: j.id,
                title: j.title,
                rate: "5.0",
                status: isAr ? "نشط" : "Active",
                applicantsCount: store.applications
                    .where((a) => a.jobId == j.id)
                    .length,
                postedAt: j.publishedAt,
              );
            })
            .toList();

        final allWorks = [...realJobs, ...mockWorks];

        final totalApplicants = allWorks.fold<int>(
          0,
          (sum, row) => sum + row.applicantsCount,
        );
        final activeCount = allWorks
            .where((w) => w.status.contains(isAr ? 'نشط' : 'Active'))
            .length;

        final bgColor = isDark
            ? const Color(0xFF001E3A)
            : const Color(0xFFF8FBF4);

        return Scaffold(
          backgroundColor: bgColor,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  t.tr(en: 'My posted works', ar: 'قائمة الأعمال'),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  isAr
                      ? 'معاينة لأعمالك المنشورة وبيانات المتقدمين'
                      : 'Preview of your posted works and applicants',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.54),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    _buildSimpleStat(
                      context,
                      isAr ? 'الأعمال النشطة' : 'Active works',
                      '$activeCount',
                      Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    _buildSimpleStat(
                      context,
                      isAr ? 'المتقدمين' : 'Applicants',
                      '$totalApplicants',
                      Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.03),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      _buildHeaderCell(
                        context,
                        isAr ? 'العمل' : 'WORK',
                        flex: 2,
                        align: TextAlign.start,
                      ),
                      _buildHeaderCell(context, isAr ? 'الحالة' : 'STATUS'),
                      _buildHeaderCell(context, isAr ? 'المتقدمين' : 'APPS'),
                      _buildHeaderCell(context, isAr ? 'حذف' : 'DELETE'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ...allWorks.map(
                  (work) => _buildWorkRow(context, work, isAr, isDark),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkRow(
    BuildContext context,
    TradesmanPostedWorkRow work,
    bool isAr,
    bool isDark,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    JobApplicantsScreen(jobId: work.id, jobTitle: work.title),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.1),
              ),
              boxShadow: isDark
                  ? []
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        work.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${isAr ? 'نشر' : 'Posted'}: ${_formatDate(work.postedAt)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    work.status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${work.applicantsCount}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 20,
                  ),
                  onPressed: () => _showDeleteDialog(context, work, isAr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    TradesmanPostedWorkRow work,
    bool isAr,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAr ? 'حذف العمل' : 'Delete Work'),
        content: Text(
          isAr
              ? 'هل أنت متأكد من حذف هذا العمل؟'
              : 'Are you sure you want to delete this work?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isAr ? 'إلغاء' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              RecruitmentSyncStore.instance.removeJob(work.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isAr ? 'تم الحذف بنجاح' : 'Deleted successfully',
                  ),
                ),
              );
            },
            child: Text(
              isAr ? 'حذف' : 'Delete',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label, {
    int flex = 1,
    TextAlign align = TextAlign.center,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        textAlign: align,
      ),
    );
  }
}
