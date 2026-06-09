import 'package:flutter/material.dart';
import 'package:graduationproject/data/api/api_client.dart';
import 'package:graduationproject/shared/l10n/app_localizations.dart';
import 'package:graduationproject/shared/services/rating_service.dart';
import 'package:graduationproject/shared/state/recruitment_sync_store.dart';
import 'package:graduationproject/shared/utils/rating_utils.dart';

class TradesmanRatingsHubScreen extends StatefulWidget {
  final bool isTradesmanMode;
  const TradesmanRatingsHubScreen({super.key, this.isTradesmanMode = true});

  @override
  State<TradesmanRatingsHubScreen> createState() =>
      _TradesmanRatingsHubScreenState();
}

class _TradesmanRatingsHubScreenState extends State<TradesmanRatingsHubScreen> {
  List<TradesmanRatingEntry> _received = [];
  List<TradesmanRatingEntry> _given = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  Future<void> _loadRatings() async {
    setState(() => _isLoading = true);
    final userId =
        RecruitmentSyncStore.instance.currentUserId.isNotEmpty
            ? RecruitmentSyncStore.instance.currentUserId
            : await ApiClient.getUserId() ?? '';

    if (userId.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    final receivedRaw = await RatingService.instance.getUserRatings(userId);
    final givenRaw = await RatingService.instance.getUserGivenRatings(userId);
    
    if (!mounted) return;

    setState(() {
      // Filter received ratings based on mode
      _received = receivedRaw.where((r) {
        final type = r['raterType']?.toString().toLowerCase() ?? '';
        return widget.isTradesmanMode ? type.contains('tradesman') : !type.contains('tradesman');
      }).map(_toEntry).toList();

      _given = givenRaw.map((r) => _toEntry(r, isGiven: true)).toList();
      _isLoading = false;
    });
  }

  TradesmanRatingEntry _toEntry(
    Map<String, dynamic> rating, {
    bool isGiven = false,
  }) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    
    String subtitle = "";
    if (isGiven) {
      subtitle = isAr ? 'تقييمي له' : 'My rating';
    } else {
      subtitle = widget.isTradesmanMode 
          ? (isAr ? 'عميل' : 'Client')
          : (isAr ? 'شركة' : 'Company');
    }

    return TradesmanRatingEntry(
      personName: isGiven
          ? RatingUtils.targetName(rating)
          : RatingUtils.authorName(rating),
      rating: RatingUtils.value(rating),
      comment: RatingUtils.comment(rating),
      date: RatingUtils.date(rating) ?? DateTime.now(),
      subtitle: subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF001E3A) : const Color(0xFFF8FBF4);

    final receivedTitle = widget.isTradesmanMode 
        ? (isAr ? 'تقييمات العملاء' : 'Client ratings')
        : (isAr ? 'تقييمات الشركات' : 'Company ratings');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          backgroundColor: bgColor,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            t.tr(en: 'Ratings & Reviews', ar: 'التقييمات والآراء'),
            style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black, fontSize: 18),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(text: receivedTitle),
              Tab(text: isAr ? 'تقييماتي للآخرين' : 'My ratings'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadRatings,
                child: TabBarView(
                  children: [
                    _RatingsList(
                      entries: _received,
                      emptyMessage: isAr
                          ? 'لا توجد تقييمات مستلمة بعد'
                          : 'No received ratings yet',
                      isAr: isAr,
                    ),
                    _RatingsList(
                      entries: _given,
                      emptyMessage: isAr
                          ? 'لم تقيّم أحداً بعد'
                          : 'You have not rated anyone yet',
                      isAr: isAr,
                    ),
                  ],
                ),
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
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Center(
              child: Text(
                emptyMessage,
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      itemCount: entries.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
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
