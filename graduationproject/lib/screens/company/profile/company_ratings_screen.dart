import 'package:flutter/material.dart';
import '../../../shared/l10n/app_localizations.dart';
import '../widgets/company_bottom_nav.dart';
import '../../../shared/widgets/app_scaffold.dart';

class CompanyRatingsScreen extends StatelessWidget {
  const CompanyRatingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final isAr = t.isAr;

    return AppScaffold(
      title: t.tr(en: 'Ratings & Reviews', ar: 'التقييمات والمراجعات'),
      showBack: false,
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: t.tr(en: 'Candidates', ar: 'تقييمات المرشحين')),
                Tab(text: t.tr(en: 'My Ratings', ar: 'تقييماتي')),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _RatingsList(
                    entries: _mockCandidateRatings,
                    emptyMessage: isAr ? 'لا توجد تقييمات من مرشحين بعد' : 'No candidate ratings yet',
                  ),
                  _RatingsList(
                    entries: _mockMyRatings,
                    emptyMessage: isAr ? 'لم تقيّم أي مرشح بعد' : 'You have not rated any candidate yet',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompanyBottomNav(current: CompanyTab.ratings),
    );
  }
}

class _RatingsList extends StatelessWidget {
  const _RatingsList({required this.entries, required this.emptyMessage});

  final List<_RatingEntry> entries;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(child: Text(emptyMessage));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        const cardColor = Color(0xFF213E75);
        return Card(
          elevation: 4,
          color: cardColor,
          shadowColor: Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          entry.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  entry.role,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.comment,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  entry.date,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RatingEntry {
  final String name;
  final double rating;
  final String role;
  final String comment;
  final String date;

  const _RatingEntry({
    required this.name,
    required this.rating,
    required this.role,
    required this.comment,
    required this.date,
  });
}

final _mockCandidateRatings = [
  const _RatingEntry(
    name: 'أحمد محمود',
    rating: 5.0,
    role: 'Flutter Developer',
    comment: 'بيئة عمل محترمة جداً وعملية المقابلة كانت سلسة.',
    date: '2024-05-20',
  ),
  const _RatingEntry(
    name: 'سارة علي',
    rating: 4.5,
    role: 'UI/UX Designer',
    comment: 'شركة منظمة وتهتم بالتفاصيل.',
    date: '2024-05-15',
  ),
];

final _mockMyRatings = [
  const _RatingEntry(
    name: 'ياسين حسن',
    rating: 4.8,
    role: 'Backend Developer',
    comment: 'مهارات تقنية عالية والتزام ممتاز بالمواعيد.',
    date: '2024-05-18',
  ),
];
