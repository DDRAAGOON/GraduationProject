import 'package:flutter/material.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';

class TradesmanRatingsHubScreen extends StatelessWidget {
  const TradesmanRatingsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          title: Text(
            t.tr(en: 'Ratings', ar: 'التقييمات'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.5),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: t.tr(en: 'Client ratings', ar: 'تقييمات العملاء'),
              ),
              Tab(
                text: t.tr(en: 'My ratings', ar: 'تقييماتي للآخرين'),
              ),
            ],
          ),
        ),
        body: ListenableBuilder(
          listenable: RecruitmentSyncStore.instance,
          builder: (context, _) {
            final store = RecruitmentSyncStore.instance;
            return TabBarView(
              children: [
                _RatingsList(
                  entries: store.ratingsFromClients,
                  emptyMessage: isAr
                      ? 'لا توجد تقييمات من العملاء بعد'
                      : 'No client ratings yet',
                  isAr: isAr,
                ),
                _RatingsList(
                  entries: store.ratingsGivenByTradesman,
                  emptyMessage: isAr
                      ? 'لم تقيّم أحداً بعد'
                      : 'You have not rated anyone yet',
                  isAr: isAr,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RatingsList extends StatelessWidget {
  const _RatingsList({
    required this.entries,
    required this.emptyMessage,
    required this.isAr,
  });

  final List<TradesmanRatingEntry> entries;
  final String emptyMessage;
  final bool isAr;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (entries.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: TextStyle(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF213E75),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.personName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFB300),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if ((entry.subtitle ?? '').isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  entry.subtitle!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF7A2A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const SizedBox(height: 8),
              Text(
                entry.comment,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatDate(entry.date),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
