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
    final mockWorks = store.getTradesmanPostedWorksPreview(isAr: isAr).map((work) {
      final status = store.tradesmanJobStatus(work.id, work.status);
      return TradesmanPostedWorkRow(
        id: work.id,
        title: work.title,
        rate: work.rate,
        status: store.translateTradesmanWorkStatus(status, isAr),
        applicantsCount: work.applicantsCount,
        postedAt: work.postedAt,
      );
    }).toList();
    final totalApplicants =
        mockWorks.fold<int>(0, (sum, row) => sum + row.applicantsCount);
    final activeCount =
        mockWorks.where((w) => w.status.contains(isAr ? 'نشط' : 'Active')).length;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  ? 'معاينة لأعمالك المنشورة وبيانات المتقدمين (بيانات تجريبية)'
                  : 'Preview of your posted works and applicants (sample data)',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.54),
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
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
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
                  _buildHeaderCell(context, isAr ? 'التقييم' : 'RATE'),
                  _buildHeaderCell(context, isAr ? 'الحالة' : 'STATUS'),
                  _buildHeaderCell(context, isAr ? 'المتقدمين' : 'APPLICANTS'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ...mockWorks.map((work) => _buildWorkRow(context, work, isAr, isDark)),
          ],
        ),
      ),
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
                builder: (context) => JobApplicantsScreen(
                  jobId: work.id,
                  jobTitle: work.title,
                ),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Color(0xFFFFB300), size: 14),
                      const SizedBox(width: 2),
                      Text(
                        work.rate,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
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
              ],
            ),
          ),
        ),
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
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
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
